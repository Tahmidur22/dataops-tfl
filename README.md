# TFL data-ops

This project delivers a full DataOps solution that ingests data from the TFL API and builds out a robust Azure data platform using automated infrastructure. It deploys keys services to support scalable data processing. End-to-end pipelines and data workloads are deployed through CI/CD framework, supporting three fully separated enviornments. 
____________


# Backend - Initial setup 

1. Create Service Principal
2. Create TFState 

```hcl
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
```
3. Assign Owner/Contributor Role assignments (TFState RG > Access Control (IAM) > Role Assignments)
