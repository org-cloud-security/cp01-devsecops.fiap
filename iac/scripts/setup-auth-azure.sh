#!/bin/bash
set -euo pipefail

REPO="org-cloud-security/cp01-devsecops.fiap"
STORAGE_ACCOUNT="stdevsecopstfstate"
STORAGE_RESOURCE_GROUP="rg-devsecops-tfstate"

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)
STORAGE_ID=$(az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$STORAGE_RESOURCE_GROUP" --query id -o tsv)

# Usage: create_sp <app-name> <github-subject> <role>
create_sp() {
  local client_id principal_id

  client_id=$(az ad app create --display-name "$1" --query appId -o tsv)
  principal_id=$(az ad sp create --id "$client_id" --query id -o tsv)

  az ad app federated-credential create --id "$client_id" --parameters '{
    "name": "github",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$REPO"':'"$2"'",
    "audiences": ["api://AzureADTokenExchange"]
  }' > /dev/null

  az role assignment create \
    --assignee-object-id "$principal_id" \
    --assignee-principal-type ServicePrincipal \
    --role "$3" \
    --scope "/subscriptions/$SUBSCRIPTION_ID" > /dev/null

  az role assignment create \
    --assignee-object-id "$principal_id" \
    --assignee-principal-type ServicePrincipal \
    --role "Storage Blob Data Contributor" \
    --scope "$STORAGE_ID" > /dev/null

  echo "$client_id"
}

PLAN_CLIENT_ID=$(create_sp "sp-devsecops-plan" "pull_request" "Reader")
APPLY_CLIENT_ID=$(create_sp "sp-devsecops-apply" "ref:refs/heads/main" "Contributor")

echo "AZURE_CLIENT_ID_PLAN=$PLAN_CLIENT_ID"
echo "AZURE_CLIENT_ID_APPLY=$APPLY_CLIENT_ID"
echo "AZURE_TENANT_ID=$TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
