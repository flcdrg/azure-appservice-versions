@description('Location for all resources.')
param location string = resourceGroup().location

var windowsHostingPlanName = 'plan-windows-versions-australiaeast'

// https://learn.microsoft.com/azure/templates/microsoft.web/serverfarms?WT.mc_id=DOP-MVP-5001655
resource windowsAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: windowsHostingPlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'app'
}

// app service that uses plan and node 16
resource windowsWebApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'app-win-node16-versions-australiaeast'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: windowsAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
      ]
    }
  }
}
