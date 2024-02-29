@description('Location for all resources.')
param location string = resourceGroup().location

var windowsHostingPlanName = 'plan-windows-versions-australiaeast'

var nodeVersions = [ '16', '18', '20' ]

var dotnetVersions = [ '6', '7', '8' ]

// https://learn.microsoft.com/azure/templates/microsoft.web/serverfarms?WT.mc_id=DOP-MVP-5001655
resource windowsAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: windowsHostingPlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'app'
}

// https://learn.microsoft.com/en-au/azure/templates/microsoft.web/sites?pivots=deployment-language-bicep&WT.mc_id=DOP-MVP-5001655
// app service that uses plan
resource windowsWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in nodeVersions: {
  name: 'app-windows-node${version}-versions-australiaeast'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: windowsAppServicePlan.id
    siteConfig: {
      windowsFxVersion: 'NODE:${version}LTS'
      http20Enabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        // Windows requires this, whereas Linux does not
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~${version}'
        }
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

resource linuxDotNetWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in dotnetVersions: {
  name: 'app-linux-dotnet${version}-versions-australiaeast'
  location: location
  properties: {
    serverFarmId: linuxAppServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|${version}.0'
      http20Enabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'

      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'True'
        }
        {
          name: 'SCM_BUILD_ARGS'
          value: '-c Release -f net${version}.0'
        }
        {
          name: 'WEBSITE_HTTPLOGGING_RETENTION_DAYS'
          value: '3'
        }
      ]
    }
  }
}]

resource windowsDotNetWebApp 'Microsoft.Web/sites@2022-09-01' = [for version in dotnetVersions: {
  name: 'app-windows-dotnet${version}-versions-australiaeast'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: windowsAppServicePlan.id
    siteConfig: {
      windowsFxVersion: 'dotnet:${version}'
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
