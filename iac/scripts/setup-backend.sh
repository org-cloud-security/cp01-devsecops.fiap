#!/bin/bash
set -euo pipefail

RESOURCE_GROUP="rg-devsecops-tfstate"
STORAGE_ACCOUNT="stdevsecopstfstate"
CONTAINER="tfstate"
LOCATION="brazilsouth"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS

az storage container-rm create \
  --name "$CONTAINER" \
  --storage-account "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP"
