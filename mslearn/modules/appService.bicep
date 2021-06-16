param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServicePlanName = 'toy-product-launch-plan'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2_v3': 'F1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3': 'Free'
var dbAccountName = 'toy-dabase-launch'

//We can also create objects
param resourceTags object = {
  EnvironmentName: 'DEV'
  CostCenter: 'Accounting'
  Team: 'Data Science'
}

//We can also create arrays
@description('We need to restrict the locations to South Central, Central, and West')
param acceptableLocations array = [
  {
    locationName: 'southcentralus'
  }
  {
    locationName: 'centralus'
  }
  {
    locationName: 'westus'
  }
]

//restrict parameter length and value
@minLength(5)
@maxLength(24)
param storageAccountName string


resource account 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: dbAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'standard'
    locations: acceptableLocations
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: appServicePlanName
  location: location
  sku:{
    name:appServicePlanSkuName
    tier:appServicePlanTierName
  }
  tags: resourceTags
}

resource appServiceApp 'Microsoft.Web/sites@2021-01-01' = {
  name: appServiceAppName
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
  tags: resourceTags
}


output appServiceAppHostName string = appServiceApp.properties.defaultHostName
