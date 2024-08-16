
#!/bin/bash
# Variables
RESOURCE_GROUP="your_resource_group"
LOCATION="your_location"
KEY_VAULT_NAME="your_key_vault_name"
SECRET_NAME="your_secret_name"
SECRET_VALUE="your_secret_value"

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a key vault
az keyvault create --name $KEY_VAULT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

# Store a secret in the key vault
az keyvault secret set --vault-name $KEY_VAULT_NAME --name $SECRET_NAME --value $SECRET_VALUE
