
#!/bin/bash
# Variables
KEY_VAULT_NAME="your_key_vault_name"
USER_PRINCIPAL_NAME="your_user@yourdomain.onmicrosoft.com"

# Get the user object ID
USER_OBJECT_ID=$(az ad user show --id $USER_PRINCIPAL_NAME --query objectId --output tsv)

# Set access policies for the key vault
az keyvault set-policy --name $KEY_VAULT_NAME --object-id $USER_OBJECT_ID --secret-permissions get list set delete --key-permissions get list create delete
