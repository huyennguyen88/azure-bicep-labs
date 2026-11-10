param vnetName string
param location string
param addressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
