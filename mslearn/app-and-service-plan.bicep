resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: 'toy-product-launch-plan'
  location: 'southcentralus'
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  tags: {
    'department' : 'finance'
    'budget' : 'christmas'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-01-01' = {
  name: 'toy-product-launch-1'
  location: 'southcentralus'
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly:true
  }
}
