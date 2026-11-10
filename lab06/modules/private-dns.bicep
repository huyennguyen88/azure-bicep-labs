@description('Name of Private DNS Zone')
param zoneName string = 'privatelink.postgres.database.azure.com'

@description('Name of the VNet link')
param vnetLinkName string

@description('Resource ID of the VNet')
param vnetId string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: zoneName
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZone
  name: vnetLinkName
  location: 'global'

  properties: {
    registrationEnabled: false

    virtualNetwork: {
      id: vnetId
    }
  }
}

output privateDnsZoneId string = privateDnsZone.id
output privateDnsZoneName string = privateDnsZone.name
output vnetLinkId string = vnetLink.id
