param location string = 'japaneast'

@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'
param vnetAddressPrefix string = '10.30.0.0/16'
param subnetAddressPrefix string = '10.30.1.0/24'
param enableSshDenyRule bool = false
param enableAuditNsg bool = false

@description('Name of the application subnet')
@minLength(3)
@maxLength(30)
param subnetName string = 'snet-app'

@description('CIDR for the Private Endpoint subnet')
param peSubnetAddressPrefix string

@description('PostgreSQL administrator username')
param pgAdminUsername string = 'pgadminlab'

@secure()
@description('PostgreSQL administrator password')
param pgAdminPassword string

var vnetName = 'vnet-${environment}'
var nsgName = 'nsg-${environment}'
var postgresServerName = 'pg-bicep-${environment}-${uniqueString(resourceGroup().id, environment)}'
var postgresPrivateEndpointName = 'pe-postgres-${environment}'

module nsgModule './modules/nsg.bicep' = {
  name: 'deploy-nsg-${environment}'
  params: {
    nsgName: nsgName
    location: location
    enableSshDenyRule: enableSshDenyRule
  }
}

module auditNsgModule './modules/nsg.bicep' = if (enableAuditNsg) {
  name: 'deploy-audit-nsg-${environment}'
  params: {
    nsgName: 'nsg-audit-${environment}'
    location: location
    enableSshDenyRule: false
  }
}

module vnetModule './modules/vnet.bicep' = {
  name: 'deploy-vnet-${environment}'
  params: {
    vnetName: vnetName
    location: location
    addressPrefix: vnetAddressPrefix
  }
}

module subnetModule './modules/subnet.bicep' = {
  name: 'deploy-subnet-${environment}'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    nsgId: nsgModule.outputs.nsgId
  }
  dependsOn: [
    vnetModule
  ]
}

module peSubnetModule './modules/private-endpoint-subnet.bicep' = {
  name: 'deploy-pe-subnet-${environment}'
  params: {
    vnetName: vnetName
    subnetName: 'snet-pe'
    addressPrefix: peSubnetAddressPrefix
  }

  dependsOn: [
    vnetModule
  ]
}

module postgresModule './modules/postgresql.bicep' = {
  name: 'deploy-postgresql-${environment}'
  params: {
    serverName: postgresServerName
    location: location
    administratorLogin: pgAdminUsername
    administratorPassword: pgAdminPassword
  }
}

module postgresPrivateEndpointModule './modules/private-endpoint.bicep' = {
  name: 'deploy-postgres-pe-${environment}'
  params: {
    endpointName: postgresPrivateEndpointName
    location: location
    subnetId: peSubnetModule.outputs.subnetId
    postgresServerId: postgresModule.outputs.serverId
  }
}

module postgresDnsModule './modules/private-dns.bicep' = {
  name: 'deploy-postgres-dns-${environment}'

  params: {
    zoneName: 'privatelink.postgres.database.azure.com'
    vnetLinkName: 'link-${environment}'
    vnetId: vnetModule.outputs.vnetId
  }
}

module postgresDnsZoneGroupModule './modules/private-dns-zone-group.bicep' = {
  name: 'deploy-postgres-dns-group-${environment}'

  params: {
    privateEndpointName: postgresPrivateEndpointName
    privateDnsZoneId: postgresDnsModule.outputs.privateDnsZoneId
  }

  dependsOn: [
    postgresPrivateEndpointModule
  ]
}

output vnetId string = vnetModule.outputs.vnetId
output subnetId string = subnetModule.outputs.subnetId
output nsgId string = nsgModule.outputs.nsgId
output peSubnetId string = peSubnetModule.outputs.subnetId
output deployedEnvironment string = environment
output postgresServerId string = postgresModule.outputs.serverId
output postgresServerName string = postgresModule.outputs.serverName
output postgresFqdn string = postgresModule.outputs.serverFqdn
output postgresPrivateEndpointId string = postgresPrivateEndpointModule.outputs.privateEndpointId
output postgresDnsZoneId string = postgresDnsModule.outputs.privateDnsZoneId
output postgresDnsZoneName string = postgresDnsModule.outputs.privateDnsZoneName
output postgresVnetLinkId string = postgresDnsModule.outputs.vnetLinkId
output postgresDnsZoneGroupId string = postgresDnsZoneGroupModule.outputs.dnsZoneGroupId
