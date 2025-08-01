param project string
param environment string
param location string = resourceGroup().location
var locationShort = locationShortCodes[location]
var locationShortCodes = {
  uksouth: 'uks'
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logic-${project}-${environment}-${locationShort}-001'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: json(loadTextContent('config/workflow.json'))
    parameters: {
      '$connections': {
        value: {
          'azurerm-${project}-${environment}-${locationShort}-001': {
            connectionId: apiConnection1.id
            connectionName: apiConnection1.name
            id: apiConnection1.properties.api.id
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
          }
          'azurevm-${project}-${environment}-${locationShort}-001': {
            connectionId: apiConnection2.id
            connectionName: apiConnection2.name
            id: apiConnection2.properties.api.id
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
          }
        }
      }
    }
  }
}

resource apiConnection1 'Microsoft.Web/connections@2016-06-01' = {
  name:  'azurerm-${project}-${environment}-${locationShort}-001'
  kind:  'V1'
  location: location
  properties: {
    displayName: 'azurerm'
    api: {
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/arm'
    }
    parameterValueType: 'Alternative'
  }
}

resource apiConnection2 'Microsoft.Web/connections@2016-06-01' = {
  name:  'azurevm-${project}-${environment}-${locationShort}-001'
  kind:  'V1'
  location: location
  properties: {
    displayName: 'azurevm'
    api: {
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/azurevm'
    }
    parameterValueType: 'Alternative'
  }
}
