@description('Globally unique PostgreSQL server name')
param serverName string

param location string

@description('PostgreSQL administrator username')
param administratorLogin string

@secure()
@description('PostgreSQL administrator password')
param administratorPassword string

resource postgres 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: serverName
  location: location

  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }

  properties: {
    version: '16'

    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword

    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }

    storage: {
      storageSizeGB: 32
      autoGrow: 'Disabled'
    }

    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }

    highAvailability: {
      mode: 'Disabled'
    }

    network: {
      publicNetworkAccess: 'Disabled'
    }
  }
}

output serverId string = postgres.id
output serverName string = postgres.name
output serverFqdn string = postgres.properties.fullyQualifiedDomainName
