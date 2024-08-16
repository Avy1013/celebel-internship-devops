
# Variables
$ResourceGroupName = "your_resource_group"
$Location = "your_location"
$VMName = "your_vm_name"
$VNetName = "your_vnet_name"
$SubnetName = "your_subnet_name"
$VMImage = "UbuntuLTS"

# Create a resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create a virtual network
$VNet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VNetName -AddressPrefix 10.0.0.0/16
$SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 10.0.0.0/24 -VirtualNetwork $VNet
$VNet | Set-AzVirtualNetwork

# Create a virtual machine
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize "Standard_DS1_v2"
$Credential = Get-Credential -Message "Enter the username and password for the virtual machine"
$VM = New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VirtualNetworkName $VNetName -SubnetName $SubnetName -ImageName $VMImage -Credential $Credential
