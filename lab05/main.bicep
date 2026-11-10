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

var vnetName = 'vnet-${environment}'
var nsgName = 'nsg-${environment}'

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

output vnetId string = vnetModule.outputs.vnetId
output subnetId string = subnetModule.outputs.subnetId
output nsgId string = nsgModule.outputs.nsgId
output deployedEnvironment string = environment
