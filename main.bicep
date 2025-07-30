param project string
param environment string
param location string = resourceGroup().location

var locationShortCodes = {
  uksouth: 'uks'
  ukwest: 'ukw'
  northeurope: 'ne'
}
var locationShort = locationShortCodes[location]
var logicAppName = 'logic-${project}-${environment}-${locationShort}-001'

module logicApp 'br/public:avm/res/logic/workflow:0.5.2' = {
  name: 'logicAppDeployment'
  params: {
    name: logicAppName
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    workflowTriggers: {
      Recurrence: {
        recurrence: {
          frequency: 'Minute'
          interval: 5
        }
        type: 'Recurrence'
      }
    }
  }
}

module apiConnection1 'br/public:avm/res/web/connection:0.4.2' = {
  name: 'apiConnectionDeployment1'
  params: {
    displayName: 'azurerm'
    name: 'azurerm-${project}-${environment}-${locationShort}-001'
    api: {
      name: 'azurerm'
      displayName: 'Azure Resource Manager'
      description: 'Azure Resource Manager exposes the APIs to manage all of your Azure resources.'
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/uksouth/managedApis/arm'
      type: 'Microsoft.Web/locations/managedApis'
    }
    location: location
  }
}

module apiConnection2 'br/public:avm/res/web/connection:0.4.2' = {
  name: 'apiConnectionDeployment2'
  params: {
    displayName: 'azurevm'
    name: 'azurevm-${project}-${environment}-${locationShort}-001'
    api: {
      name: 'azurevm'
      displayName: 'Azure VM'
      description: 'Azure VM connector allows you to manage virtual machines.'
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/uksouth/managedApis/azurevm'
      type: 'Microsoft.Web/locations/managedApis'
    }
    location: location
  }
}
