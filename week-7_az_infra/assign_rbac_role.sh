
#!/bin/bash
# Assign the 'Reader' role to the test user
az role assignment create --assignee testuser@yourdomain.onmicrosoft.com --role "Reader" --scope /subscriptions/$(az account show --query id --output tsv)
