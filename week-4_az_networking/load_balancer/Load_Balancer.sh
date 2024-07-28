#!/bin/bash

# Set variables
RESOURCE_GROUP="lb-demo-rg"
LOCATION="eastus"
VNET_NAME="lb-vnet"
SUBNET_FRONTEND="frontend-subnet"
SUBNET_BACKEND="backend-subnet"
SUBNET_DB="db-subnet"
PUBLIC_IP_NAME="lb-public-ip"
EXTERNAL_LB_NAME="external-lb"
INTERNAL_LB_NAME="internal-lb"
NSG_NAME="lb-nsg"

# Function to create resource and wait for it
create_resource() {
    local max_attempts=5
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        if eval "$1"; then
            echo "Successfully created: $2"
            return 0
        else
            echo "Attempt $attempt failed. Retrying in 30 seconds..."
            sleep 30
            attempt=$((attempt + 1))
        fi
    done
    echo "Failed to create resource after $max_attempts attempts: $2"
    return 1
}

# Create resource group
create_resource "az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --output table" "Resource Group"

# Create VNet and subnets
create_resource "az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET_FRONTEND \
    --subnet-prefix 10.0.1.0/24 \
    --output table" "VNet and Frontend Subnet"

create_resource "az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_BACKEND \
    --address-prefix 10.0.2.0/24 \
    --output table" "Backend Subnet"

create_resource "az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_DB \
    --address-prefix 10.0.3.0/24 \
    --output table" "DB Subnet"

# Create NSG
create_resource "az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME \
    --output table" "NSG"

# Allow HTTP traffic
create_resource "az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-HTTP \
    --priority 100 \
    --destination-port-ranges 80 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --output table" "NSG Rule"

# Create public IP for external load balancer
create_resource "az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name $PUBLIC_IP_NAME \
    --sku Standard \
    --output table" "Public IP"

# Create external load balancer
create_resource "az network lb create \
    --resource-group $RESOURCE_GROUP \
    --name $EXTERNAL_LB_NAME \
    --sku Standard \
    --public-ip-address $PUBLIC_IP_NAME \
    --frontend-ip-name frontendip \
    --backend-pool-name backendpool \
    --output table" "External Load Balancer"

# Create health probe
create_resource "az network lb probe create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $EXTERNAL_LB_NAME \
    --name healthprobe \
    --protocol tcp \
    --port 80 \
    --output table" "Health Probe"

# Create LB rule
create_resource "az network lb rule create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $EXTERNAL_LB_NAME \
    --name HTTPRule \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name frontendip \
    --backend-pool-name backendpool \
    --probe-name healthprobe \
    --output table" "LB Rule"

# Function to create VM and add to backend pool
create_vm_and_add_to_pool() {
    local vm_name=$1
    local subnet_name=$2
    local lb_name=$3

    create_resource "az vm create \
        --resource-group $RESOURCE_GROUP \
        --name $vm_name \
        --image Ubuntu2204 \
        --admin-username azureuser \
        --generate-ssh-keys \
        --vnet-name $VNET_NAME \
        --subnet $subnet_name \
        --nsg $NSG_NAME \
        --public-ip-address \"\" \
        --size Standard_B1ls \
        --output table" "VM $vm_name"

    create_resource "az network nic ip-config address-pool add \
        --resource-group $RESOURCE_GROUP \
        --nic-name ${vm_name}VMNic \
        --ip-config-name ipconfig${vm_name} \
        --lb-name $lb_name \
        --address-pool backendpool \
        --output table" "Adding $vm_name to backend pool"
}

# Create VMs for external LB backend pool
for i in {1..2}
do
    create_vm_and_add_to_pool "backendVM$i" $SUBNET_BACKEND $EXTERNAL_LB_NAME
done

# Create internal load balancer
create_resource "az network lb create \
    --resource-group $RESOURCE_GROUP \
    --name $INTERNAL_LB_NAME \
    --sku Standard \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_BACKEND \
    --frontend-ip-name frontendip \
    --backend-pool-name backendpool \
    --output table" "Internal Load Balancer"

# Create health probe for internal LB
create_resource "az network lb probe create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $INTERNAL_LB_NAME \
    --name healthprobe \
    --protocol tcp \
    --port 80 \
    --output table" "Internal LB Health Probe"

# Create LB rule for internal LB
create_resource "az network lb rule create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $INTERNAL_LB_NAME \
    --name HTTPRule \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name frontendip \
    --backend-pool-name backendpool \
    --probe-name healthprobe \
    --output table" "Internal LB Rule"

# Create VMs for internal LB backend pool
for i in {1..2}
do
    create_vm_and_add_to_pool "dbVM$i" $SUBNET_DB $INTERNAL_LB_NAME
done

echo "Infrastructure setup complete!"

# Output the public IP of the external load balancer
PUBLIC_IP=$(az network public-ip show \
    --resource-group $RESOURCE_GROUP \
    --name $PUBLIC_IP_NAME \
    --query ipAddress \
    --output tsv)
echo "External Load Balancer Public IP: $PUBLIC_IP"

# Additional setup for demonstration
# Install Nginx on frontend VMs
# for i in {1..2}
# do
#     az vm run-command invoke \
#         --resource-group $RESOURCE_GROUP \
#         --name "backendVM$i" \
#         --command-id RunShellScript \
#         --scripts "sudo apt-get update && sudo apt-get install -y nginx" \
#         --output table
# done

# # Install Python HTTP server on backend VMs
# for i in {1..2}
# do
#     az vm run-command invoke \
#         --resource-group $RESOURCE_GROUP \
#         --name "dbVM$i" \
#         --command-id RunShellScript \
#         --scripts "echo '<html><body><h1>Backend Server $i</h1></body></html>' > index.html && nohup python3 -m http.server 80 &" \
#         --output table
# done

echo "Setup complete. You can now access the load balancer at http://$PUBLIC_IP"
