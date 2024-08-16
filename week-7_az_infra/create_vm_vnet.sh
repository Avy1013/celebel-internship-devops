
#!/bin/bash
# Variables
RESOURCE_GROUP="your_resource_group"
LOCATION="your_location"
VNET_NAME="your_vnet_name"
SUBNET_NAME="your_subnet_name"
VM_NAME="your_vm_name"
VM_IMAGE="UbuntuLTS"

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a virtual network
az network vnet create --resource-group $RESOURCE_GROUP --name $VNET_NAME --address-prefix 10.0.0.0/16 --subnet-name $SUBNET_NAME --subnet-prefix 10.0.0.0/24

# Create a virtual machine
az vm create --resource-group $RESOURCE_GROUP --name $VM_NAME --image $VM_IMAGE --vnet-name $VNET_NAME --subnet $SUBNET_NAME --admin-username azureuser --generate-ssh-keys
