@description('Private Endpoint name')
param privateEndpointName string

@description('Private DNS Zone resource ID')
param privateDnsZoneId string

resource existingPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' existing = {
  name: privateEndpointName
}

resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  parent: existingPrivateEndpoint
  name: 'default'

  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'postgresql-dns-config'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

output dnsZoneGroupId string = dnsZoneGroup.id
