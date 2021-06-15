//use this to set a parameter
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
//use this to set a variable
var appServicePlanName = 'toy-product-launch-plan'
//use this to assign location from resource group
param location string = resourceGroup().location
//use this to create meaningful unique names
//the uniqueString function uses the resource group id as a seed string
//the will allow us to use this unique string regularly (it is not a random string generator)
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
//this parameter lets us make a decision. Is it prod or nonprod?
//allowed means that one of these choices must be made
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
//I could now set the variables here
//the question mark is a ternary operator, which means it's basically a true of false statement
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2_v3' : 'F1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3' : 'Free'



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku:{
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-01-01' = {
  name: appServiceAppName
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
