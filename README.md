# bicep-learning
Playing with learning Bicep.

## This repo
This repo is a sketchpad as I learn how to use Bicep.

## Handy references 

* [Template Reference](https://docs.microsoft.com/en-us/azure/templates/) - includes Bicep code for every Azure resource.

* [Bicep Reference](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/) - Syntax and how-to guides

## Securing parameters
The general rule is to always used Managed Identities. If Managed Identities aren't available for the resource, then use Service Principle.

`@secure()` allows you to secure a parameter.


