# tfl-data-ops


# Backend - Initial setup 

TFState Resource Group
az group create -n sttfldatatfstate-rg -l eastus

TFState Storage Account
az storage account create \
  -n sttfldatatfstate \
  -g sttfldatatfstate-rg \
  -l eastus \
  --sku Standard_LRS

TFState Storage Container
az storage container create \
  --name sttfldatatfstate-container \
  --account-name sttfldatatfstate