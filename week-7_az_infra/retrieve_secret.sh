
#!/bin/bash
# Variables
KEY_VAULT_NAME="your_key_vault_name"
SECRET_NAME="your_secret_name"

# Retrieve the secret from the key vault
az keyvault secret show --vault-name $KEY_VAULT_NAME --name $SECRET_NAME --query value --output tsv
