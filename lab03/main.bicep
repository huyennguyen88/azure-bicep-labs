param location string = 'japaneast'

@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

var vnetName = 'vnet-${environment}'
var nsgName = 'nsg-${environment}'

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-app'

  properties: {
    addressPrefix: '10.30.1.0/24'
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

output vnetId string = vnet.id
output subnetId string = subnet.id
output nsgId string = nsg.id
output deployedEnvironment string = environment
