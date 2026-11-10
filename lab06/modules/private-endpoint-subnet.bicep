param vnetName string
param subnetName string = 'snet-pe'
param addressPrefix string

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: existingVnet
  name: subnetName

  properties: {
    addressPrefix: addressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
  }
}

output subnetId string = peSubnet.id
