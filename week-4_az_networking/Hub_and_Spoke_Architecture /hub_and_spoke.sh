resourcegroup="celebal-internship-vaibhav_group"
location="northeurope"
vnetAddressPrefix="10.0.0.0/16"
subnetAddressPrefix="10.0.0.0/24"

# VNet names and address prefixes
managementVnet="ManagementVNet"
productionVnet="ProductionVNet"
testingVnet="TestingVNet"
developingVnet="DevelopingVNet"

# Virtual machine variables
ssh_key_path="/Users/avy/Downloads/azure/new_keys_folder.pub"
vmImage="Canonical:UbuntuServer:18.04-LTS:latest"
vmSize="Standard_B1s"


az network vnet create \
  --resource-group $resourcegroup \
  --name managementVnet \
  --address-prefix $vnetAddressPrefix \
  --subnet-name default \
  --subnet-prefix $subnetAddressPrefix \
  --location $location \
  --output table

az network vnet show \
  --resource-group $resourcegroup \
  --name managementVnet \
  --output table

  az network vnet create \
  --resource-group $resourcegroup \
  --name ProductionVNet \
  --address-prefix 10.1.0.0/16 \
  --subnet-name default \
  --subnet-prefix 10.1.0.0/24 \
  --location $location \
  --output table

az network vnet show \
  --resource-group $resourcegroup \
  --name ProductionVNet \
  --output table

  az network vnet create \
  --resource-group $resourcegroup \
  --name TestingVNet \
  --address-prefix 10.2.0.0/16 \
  --subnet-name default \
  --subnet-prefix 10.2.0.0/24 \
  --location $location \
  --output table

az network vnet show \
  --resource-group $resourcegroup \
  --name TestingVNet \
  --output table

  az network vnet create \
  --resource-group $resourcegroup \
  --name DevelopingVNet \
  --address-prefix 10.3.0.0/16  \
  --subnet-name default \
  --subnet-prefix 10.3.0.0/24 \
  --location $location \
  --output table

az network vnet show \
  --resource-group $resourcegroup \
  --name DevelopingVNet \
  --output table

  # Create VM in Management VNet
az vm create \
  --resource-group $resourcegroup \
  --name ManagementVM \
  --location $location \
  --vnet-name $managementVnet \
  --subnet default \
  --image $vmImage \
  --ssh-key-values $ssh_key_path \
  --size $vmSize \
  --public-ip-sku Standard \
  --output table

# Create VM in Production VNet
az vm create \
  --resource-group $resourcegroup \
  --name ProductionVM \
  --location $location \
  --vnet-name $productionVnet \
  --subnet default \
  --image $vmImage \
  --ssh-key-values $ssh_key_path \
  --size $vmSize \
  --public-ip-address "" \
  --output table

# Create VM in Testing VNet
az vm create \
  --resource-group $resourcegroup \
  --name TestingVM \
  --location $location \
  --vnet-name $testingVnet \
  --subnet default \
  --image $vmImage \
  --ssh-key-values $ssh_key_path \
  --size $vmSize \
  --public-ip-address "" \
  --output table

# Create VM in Developing VNet
az vm create \
  --resource-group $resourcegroup \
  --name DevelopingVM \
  --location $location \
  --vnet-name $developingVnet \
  --subnet default \
  --image $vmImage \
  --ssh-key-values $ssh_key_path \
  --size $vmSize \
  --public-ip-address "" \
  --output table

# Creating vpc peering
create_bidirectional_peering() {
  local hubVnet=$1
  local spokeVnet=$2
  local peeringHubToSpoke="${hubVnet}To${spokeVnet##*-}"
  local peeringSpokeToHub="${spokeVnet##*-}To${hubVnet}"

  az network vnet peering create \
    --resource-group $resourcegroup \
    --name $peeringHubToSpoke \
    --vnet-name $hubVnet \
    --remote-vnet $spokeVnet \
    --allow-vnet-access \
    --allow-forwarded-traffic \
    --output table

  az network vnet peering create \
    --resource-group $resourcegroup \
    --name $peeringSpokeToHub \
    --vnet-name $spokeVnet \
    --remote-vnet $hubVnet \
    --allow-vnet-access \
    --allow-forwarded-traffic \
    --output table
}

# Create peerings
create_bidirectional_peering $managementVnet $productionVnet
create_bidirectional_peering $managementVnet $testingVnet
create_bidirectional_peering $managementVnet $developingVnet

# Enable IP forwarding for the Management VM's NIC
managementVmNic=$(az vm show -g $resourcegroup -n ManagementVM --query 'networkProfile.networkInterfaces[0].id' -o tsv)
az network nic update --name ${managementVmNic##*/} --resource-group $resourcegroup --ip-forwarding true
