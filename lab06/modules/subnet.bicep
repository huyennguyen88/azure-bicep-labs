param vnetName string
param subnetName string
param subnetAddressPrefix string
param nsgId string

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: existingVnet
  name: subnetName

  properties: {
    addressPrefix: subnetAddressPrefix
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

output subnetId string = subnet.id
