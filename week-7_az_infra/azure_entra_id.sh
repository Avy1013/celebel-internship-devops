
#!/bin/bash
# Create a new Azure Entra ID (Azure AD) tenant (this requires admin privileges)
# az ad tenant create --display-name <display-name> --domain-name <domain-name>

# List existing Entra IDs
az ad tenant list

# Create a test user
az ad user create --display-name "Test User" --password "Password123!" --user-principal-name testuser@yourdomain.onmicrosoft.com

# Create a test group
az ad group create --display-name "Test Group" --mail-nickname "testgroup"

# Add the test user to the test group
az ad group member add --group "Test Group" --member-id $(az ad user show --id testuser@yourdomain.onmicrosoft.com --query objectId --output tsv)
