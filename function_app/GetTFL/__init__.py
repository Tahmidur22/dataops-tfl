import os
import requests
import pandas as pd
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
import datetime
import logging

def main(time: func.TimerRequest) -> None:
    now = datetime.datetime.utcnow()
    timestamp = now.strftime("%Y%m%dT%H%M%S")
    logging.info(f"Function triggered at {timestamp} - Starting TfL crowding data ingestion.")

    # Load station codes from CSV file
    try:
        current_dir = os.path.dirname(os.path.abspath(__file__))
        csv_path = os.path.join(current_dir, "naptan.csv")
        df_stations = pd.read_csv(csv_path, header=None, names=["code", "station_name"])
        station_codes = df_stations["code"].tolist()
        logging.info(f"Loaded {len(station_codes)} station codes from naptan.csv.")
    except Exception as e:
        logging.exception(f"Failed to load naptan.csv: {e}")
        return

    base_url = "https://api.tfl.gov.uk/crowding"
    all_records = []

    for code in station_codes:
        url = f"{base_url}/{code}/Live"
        try:
            res = requests.get(url)
            if res.status_code != 200:
                logging.warning(f"Failed to fetch {code}: {res.status_code}")
                continue

            data = res.json()
            if data:
                flat = pd.json_normalize(data)
                flat["station_code"] = code
                flat["timestamp_utc"] = now
                all_records.append(flat)
                logging.info(f"Retrieved crowding data for {code}")

        except Exception as e:
            logging.error(f"Error retrieving data for {code}: {e}")
            continue

    if not all_records:
        logging.warning("No data retrieved from TfL API.")
        return

    df = pd.concat(all_records, ignore_index=True)

    # Save to temporary CSV
    tmp_path = "/tmp/tfl_crowding_all.csv"
    df.to_csv(tmp_path, index=False)
    logging.info(f"Saved data for {len(station_codes)} stations to CSV.")

    # Upload to Azure Blob
    storage_account_url = os.getenv("STORAGE_ACCOUNT_URL")
    container_name = os.getenv("CONTAINER_NAME")

    if not storage_account_url or not container_name:
        logging.error("Missing STORAGE_ACCOUNT_URL or CONTAINER_NAME environment variable.")
        return

    blob_name = f"raw/tfl_crowding/year-{now.year}/month-{now.month:02d}/day-{now.day:02d}/tfl_crowding_{timestamp}.csv"

    try:
        credential = DefaultAzureCredential()
        blob_service_client = BlobServiceClient(account_url=storage_account_url, credential=credential)
        container_client = blob_service_client.get_container_client(container_name)

        with open(tmp_path, "rb") as data_file:
            container_client.upload_blob(name=blob_name, data=data_file, overwrite=False)

        logging.info(f"SUCCESS: Uploaded combined TfL crowding data to {container_name}/{blob_name}")

    except Exception as e:
        logging.exception(f"Error uploading to Azure Blob: {e}")
        return

    logging.info("Azure Function completed successfully.")