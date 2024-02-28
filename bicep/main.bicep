@description('Location for all resources.')
param location string = resourceGroup().location

var windowsHostingPlanName = 'plan-windows-versions-australiaeast'

var nodeVersions = [ '16', '18', '20' ]

// https://learn.microsoft.com/azure/templates/microsoft.web/serverfarms?WT.mc_id=DOP-MVP-5001655
resource windowsAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: windowsHostingPlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'app'
}

// app service that uses plan
resource windowsWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in nodeVersions: {
  name: 'app-windows-node${version}-versions-australiaeast'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: windowsAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~${version}'
        }
      ]
    }
  }
}]

// config for app service
resource windowsWebAppConfig 'Microsoft.Web/sites/config@2022-09-01' = [for (version, i) in nodeVersions: {
  parent: windowsWebApp[i]
  name: 'web'
  properties: {
    windowsFxVersion: 'NODE:${version}LTS'
  }
}]


// Linux app services
resource linuxAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-linux-versions-australiaeast'
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource linuxWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in nodeVersions: {
  name: 'app-linux-node${version}-versions-australiaeast'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: linuxAppServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE:${version}-lts'
    }
  }
}]
