
#!/bin/bash

# Create Storage Account
az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS

# Create Container
az storage container create --name mycontainer --account-name mystorageaccount

# Upload Blob
az storage blob upload --container-name mycontainer --name myblob --file /path/to/file --account-name mystorageaccount

# Generate SAS
az storage account generate-sas --permissions rwl --account-name mystorageaccount --services b --resource-types co --expiry 2024-08-30T00:00Z

# Create a File Share
az storage share create --name myshare --account-name mystorageaccount
