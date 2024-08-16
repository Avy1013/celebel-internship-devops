#!/bin/bash

# Variables
RESOURCE_GROUP="your_resource_group"
VAULT_NAME="your_backup_vault"
VM_NAME="your_vm_name"
POLICY_NAME="daily_backup_policy"
ALERT_RULE_NAME="cpu_alert_rule"
ACTION_GROUP_NAME="cpu_alert_action_group"
EMAIL_ADDRESS="your_email@example.com"
LOCATION="your_location"

# Create Recovery Services Vault
az backup vault create --resource-group $RESOURCE_GROUP --name $VAULT_NAME --location $LOCATION

# Set backup properties
az backup vault backup-properties set --name $VAULT_NAME --resource-group $RESOURCE_GROUP --backup-storage-redundancy LocallyRedundant

# Create a backup policy
az backup policy create --resource-group $RESOURCE_GROUP --vault-name $VAULT_NAME --name $POLICY_NAME --policy '{
    "name": "'"$POLICY_NAME"'",
    "properties": {
        "schedulePolicy": {
            "scheduleRunFrequency": "Daily",
            "scheduleRunTimes": ["2022-01-01T03:00:00Z"]
        },
        "retentionPolicy": {
            "retentionPolicyType": "LongTermRetentionPolicy",
            "dailySchedule": {
                "retentionDuration": {
                    "count": 30,
                    "durationType": "Days"
                },
                "retentionTimes": ["2022-01-01T03:00:00Z"]
            }
        }
    }
}'

# Associate the backup policy with the VM
az backup protection enable-for-vm --resource-group $RESOURCE_GROUP --vault-name $VAULT_NAME --vm $VM_NAME --policy-name $POLICY_NAME

# Create an action group for the alert
az monitor action-group create --resource-group $RESOURCE_GROUP --name $ACTION_GROUP_NAME --short-name ag --action email $EMAIL_ADDRESS

# Create an alert rule for VM CPU percentage
az monitor metrics alert create --resource-group $RESOURCE_GROUP --name $ALERT_RULE_NAME --scopes "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Compute/virtualMachines/$VM_NAME" --condition "avg Percentage CPU > 80" --window-size 5m --evaluation-frequency 1m --action-groups $(az monitor action-group show --resource-group $RESOURCE_GROUP --name $ACTION_GROUP_NAME --query id -o tsv)

echo "Backup policy, schedule, and alert rule have been successfully created."
