
#!/bin/bash
# Create a custom role definition JSON file
cat <<EOF > customRole.json
{
    "Name": "Custom Reader Role",
    "IsCustom": true,
    "Description": "Can read resources",
    "Actions": [
        "Microsoft.Resources/subscriptions/resourceGroups/read",
        "Microsoft.Resources/subscriptions/read",
        "Microsoft.Compute/virtualMachines/read"
    ],
    "NotActions": [],
    "AssignableScopes": [
        "/subscriptions/$(az account show --query id --output tsv)"
    ]
}
EOF

# Create the custom role
az role definition create --role-definition customRole.json

# Assign the custom role to the test user
az role assignment create --assignee testuser@yourdomain.onmicrosoft.com --role "Custom Reader Role" --scope /subscriptions/$(az account show --query id --output tsv)
