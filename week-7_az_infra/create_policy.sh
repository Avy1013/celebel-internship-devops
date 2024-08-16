
#!/bin/bash
# Variables
POLICY_NAME="AuditVMSizes"
POLICY_DISPLAY_NAME="Audit VM sizes"
POLICY_DESC="Audit the sizes of virtual machines"
POLICY_RULE='{
    "if": {
        "allOf": [
            {
                "field": "type",
                "equals": "Microsoft.Compute/virtualMachines"
            },
            {
                "field": "Microsoft.Compute/virtualMachines/sku.name",
                "notIn": ["Standard_DS1_v2", "Standard_B1s"]
            }
        ]
    },
    "then": {
        "effect": "audit"
    }
}'

# Create the policy definition
az policy definition create --name $POLICY_NAME --display-name "$POLICY_DISPLAY_NAME" --description "$POLICY_DESC" --rules "$POLICY_RULE" --mode All

# Assign the policy to the subscription
az policy assignment create --policy $POLICY_NAME --name $POLICY_NAME --scope /subscriptions/$(az account show --query id --output tsv)
