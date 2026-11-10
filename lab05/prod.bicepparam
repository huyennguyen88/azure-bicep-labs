using './main.bicep'

param location = 'japaneast'
param environment = 'prod'

param vnetAddressPrefix = '10.40.0.0/16'
param subnetAddressPrefix = '10.40.1.0/24'
param enableSshDenyRule = true
param enableAuditNsg = true
