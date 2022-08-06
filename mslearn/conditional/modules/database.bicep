@description('The Azure regioon into which the resources should be deployed')
param location string

@secure()
@description('The administrator login username for the SQL server')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server')
param sqlServerAdministratorLoginPassword string

@description('The name and tier of the SQL database SKU')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

@description('The name of the environment. This must be Development or Production')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The name of the audit storage account sku')
param auditStorageAccountSkuName string = 'Standard_LRS'

var sqlServerName = 'teddy${location}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'
var aduitingEnabled = environmentName == 'Production'
//this take function and the 24 is the make sure that the name of the storage doesn't go over the max character name size
var auditStorageAccountName = '${take('bearaudit${location}${uniqueString(resourceGroup().id)}', 24)}'


resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = if (aduitingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2020-11-01-preview' = if (aduitingEnabled) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}
