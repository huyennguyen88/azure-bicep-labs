param nsgName string
param location string

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
}

output nsgId string = nsg.id
