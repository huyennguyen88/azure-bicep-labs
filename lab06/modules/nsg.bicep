param nsgName string
param location string
param enableSshDenyRule bool = false

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
}

resource sshDenyRule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-05-01' = if (enableSshDenyRule) {
  parent: nsg
  name: 'Deny-SSH-Internet'

  properties: {
    priority: 100
    direction: 'Inbound'
    access: 'Deny'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

output nsgId string = nsg.id
