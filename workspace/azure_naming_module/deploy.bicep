/*
************************************************
 █████╗ ███████╗██╗   ██╗██████╗ ███████╗    ███╗   ██╗ █████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗     ███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗
██╔══██╗╚══███╔╝██║   ██║██╔══██╗██╔════╝    ████╗  ██║██╔══██╗████╗ ████║██║████╗  ██║██╔════╝     ████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔════╝
███████║  ███╔╝ ██║   ██║██████╔╝█████╗      ██╔██╗ ██║███████║██╔████╔██║██║██╔██╗ ██║██║  ███╗    ██╔████╔██║██║   ██║██║  ██║██║   ██║██║     █████╗  
██╔══██║ ███╔╝  ██║   ██║██╔══██╗██╔══╝      ██║╚██╗██║██╔══██║██║╚██╔╝██║██║██║╚██╗██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██╔══╝  
██║  ██║███████╗╚██████╔╝██║  ██║███████╗    ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗███████╗
╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
                                                                                                                                                         
This module is created with the intent to make naming modules somewhat flexible and safe.
Banner made with: https://manytools.org/hacker-tools/ascii-banner/ [ANSI Shadow]
************************************************
*/

@description('The type of resource registered with the Azure Naming Module.')
@allowed([
  'resource-group'
  'azure-tag'
  'private-endpoints'
  'virtual-networks'
  'network-security-groups'
  'bastion'
  'network-interface'
  'public-ip-address'
  'virtual-machines'
  'key-vault'
  'azure-synapse'
  'azure-synapse-private-link-hub'
  'azure-ad-group'
  'azure-managed-identity'
  'databricks'
  'hdinsights'
  'azure-data-factory'
  'azure-machine-learning'
  'azure-stream-analytics'
  'azure-analysis-services'
  'event-hubs'
  'azure-data-explorer'
  'azure-data-share'
  'azure-time-series-insights'
  'microsoft-graph-data-connect'
  'microsoft-purview'
  'azure-storage-account'
  'azure-cosmos-db'
  'azure-sql'
  'azure-sql-db'
  'azure-mysql'
  'azure-mariadb'
  'azure-postgresql'
  'dedicated-sql-pools'
  'power-platform'
  'iot-hub'
  'iot-central'
  'azure-digital-twins'
])
param resourceType string

@description('Deployment Region - regions are limited to US and Gov locations. Regions are used to determine short code.')
@allowed([
  'eastus'
  'eastus2'
  'southcentralus'
  'westus'
  'westus2'
  'centralus'
  'northcentralus'
  'usdodcentralus'
  'usdodeast'
  'usgovarizona'
  'usgovtexas'
  'usgovvirginia'
])
param region string

@description('Environment options are dev and prod.')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('Workload or application name. Min character 3, Max character 12')
@minLength(3)
@maxLength(12)
param application string

@description('Business unit represents the project, department, or team responsible for the resource. Min 2, Max 6 characters')
@minLength(2)
@maxLength(6)
param businessUnit string

@description('The instance is used to give the resource uniqueness. When more than one resource is used, the instance manages multiples. Defaults to 01. Min 2, Max 4')
@minLength(2)
@maxLength(4)
param instance string = '01'

var resourcesElement = 'resources'
var sharedRegionCodes = json(loadTextContent('.ref/azure-regions.json'))
var sharedResourceTypes = json(loadTextContent('.ref/azure-resource-types.json'))
var resourceObject = sharedResourceTypes[resourcesElement][resourceType]

var useDashes = resourceObject['naming-rules'] ? 'This is with dashes' : 'This has no dashes'
