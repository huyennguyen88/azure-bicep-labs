param location string = 'japaneast'

@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'
param vnetAddressPrefix string = '10.30.0.0/16'

var vnetName = 'vnet-${environment}'
var nsgName = 'nsg-${environment}'

module nsgModule './modules/nsg.bicep' = {
  name: 'deploy-nsg-${environment}'
  params: {
    nsgName: nsgName
    location: location
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
    subnetName: 'snet-app'
    subnetAddressPrefix: '10.30.1.0/24'
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
