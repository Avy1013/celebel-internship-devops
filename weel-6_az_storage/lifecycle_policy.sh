
#!/bin/bash

# Apply Lifecycle Management Policy
az storage account management-policy create --account-name mystorageaccount --policy @policy.json
