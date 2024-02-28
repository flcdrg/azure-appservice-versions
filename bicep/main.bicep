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
      windowsFxVersion: 'NODE:${version}LTS'
      appSettings: [
        // {
        //   name: 'WEBSITE_NODE_DEFAULT_VERSION'
        //   value: '~${version}'
        // }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'True'
        }
        {
          name: 'WEBSITE_HTTPLOGGING_RETENTION_DAYS'
          value: '3'
        }
      ]
    }
  }
}]

// Linux app services
resource linuxAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-linux-versions-australiaeast'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource linuxWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in nodeVersions: {
  name: 'app-linux-node${version}-versions-australiaeast'
  location: location
  properties: {
    serverFarmId: linuxAppServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|${version}-lts'
      http20Enabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'True'
        }
        {
          name: 'WEBSITE_HTTPLOGGING_RETENTION_DAYS'
          value: '3'
        }
      ]
    }
  }
}]
