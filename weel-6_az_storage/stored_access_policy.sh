
#!/bin/bash

# Create Stored Access Policy
az storage container policy create --account-name mystorageaccount --container-name mycontainer --name mypolicy --permissions r --expiry 2024-08-30T00:00Z

# Generate SAS using the stored access policy
az storage blob generate-sas --account-name mystorageaccount --container-name mycontainer --name myblob --policy-name mypolicy
