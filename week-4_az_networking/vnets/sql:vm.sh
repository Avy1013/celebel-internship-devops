
# Variables
resourcegroup="celebal-internship-vaibhav_group"
location="northeurope"
vnetName="myvnet"
vmname="linux-vm"
windows_vmname="windows-vm"
username="azure"
ssh_key_path="/Users/avy/Downloads/azure/new_keys_folder.pub"
admin_password="password.1000!!"
subnet1Name="Subnet1"
subnet2Name="Subnet2"
vnetAddressPrefix="10.0.0.0/16"
subnet1AddressPrefix="10.0.0.0/24"
subnet2AddressPrefix="10.0.1.0/24"
sqlServerName="my-sql-server-$(date +%s)"
sqlDbName="mydatabase"
sqlAdminUser="sqladmin"
sqlAdminPassword="password.1000!!"
sqlSku="GP_S_Gen5_1"
sqlEdition="GeneralPurpose"
sqlFamily="Gen5"
sqlCapacity="1"

# Create a virtual network with the first subnet
az network vnet create \
  --name $vnetName \
  --resource-group $resourcegroup \
  --location $location \
  --address-prefixes $vnetAddressPrefix \
  --subnet-name $subnet1Name \
  --subnet-prefixes $subnet1AddressPrefix \
  --output table 

# Add the second subnet
az network vnet subnet create \
  --resource-group $resourcegroup \
  --vnet-name $vnetName \
  --name $subnet2Name \
  --address-prefixes $subnet2AddressPrefix

# Add the service endpoint for Microsoft.Sql to Subnet2
az network vnet subnet update \
  --name $subnet2Name \
  --vnet-name $vnetName \
  --resource-group $resourcegroup \
  --service-endpoints Microsoft.Sql \
  --output table

# Create a Linux VM in Subnet1
az vm create \
  --resource-group $resourcegroup \
  --name $vmname \
  --location $location \
  --image Canonical:UbuntuServer:18.04-LTS:latest \
  --size Standard_B1s \
  --public-ip-sku Standard \
  --admin-username $username \
  --ssh-key-values @$ssh_key_path \
  --subnet $subnet1Name \
  --vnet-name $vnetName \
  --output table

# Create a Windows VM in Subnet2
az vm create \
  --resource-group $resourcegroup \
  --name $windows_vmname \
  --location $location \
  --image Win2022AzureEditionCore \
  --size Standard_B1s \
  --admin-username $username \
  --admin-password $admin_password \
  --subnet $subnet1Name \
  --vnet-name $vnetName \
  --output table

# Create an Azure SQL Server
az sql server create \
  --name $sqlServerName \
  --resource-group $resourcegroup \
  --location $location \
  --admin-user $sqlAdminUser \
  --admin-password $sqlAdminPassword \
  --output table

# Configure a Virtual Network Rule for the SQL Server
az sql server vnet-rule create \
  --resource-group $resourcegroup \
  --server $sqlServerName \
  --name MyVnetRule \
  --vnet-name $vnetName \
  --subnet $subnet2Name \
  --output table

# Create an Azure SQL Database with edition, family, and capacity
az sql db create \
  --resource-group $resourcegroup \
  --server $sqlServerName \
  --name $sqlDbName \
  --service-objective $sqlSku \
  --compute-model Serverless \
  --max-size 2GB \
  --zone-redundant false \
  --edition $sqlEdition \
  --family $sqlFamily \
  --capacity $sqlCapacity \
  --output table
