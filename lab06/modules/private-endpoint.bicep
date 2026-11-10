@description('Private Endpoint resource name')
param endpointName string

param location string

@description('Resource ID of the target subnet')
param subnetId string

@description('Resource ID of PostgreSQL Flexible Server')
param postgresServerId string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: endpointName
  location: location

  properties: {
    subnet: {
      id: subnetId
    }

    privateLinkServiceConnections: [
      {
        name: 'postgresql-connection'

        properties: {
          privateLinkServiceId: postgresServerId
          groupIds: [
            'sites'
          ]
          requestMessage: 'Private connection to PostgreSQL'
        }
      }
    ]
  }
}

output privateEndpointId string = privateEndpoint.id
