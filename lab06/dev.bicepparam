using './main.bicep'

param location = 'japaneast'
param environment = 'dev'

param vnetAddressPrefix = '10.30.0.0/16'
param subnetAddressPrefix = '10.30.1.0/24'
param enableSshDenyRule = false
param enableAuditNsg = false
param peSubnetAddressPrefix = '10.30.2.0/24'
param pgAdminUsername = 'pgadmindev'
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD', '')
