@description('Location for all resources.')
param location string = resourceGroup().location


// App Service Plan names
var windowsNodePlanName = 'plan-windows-node-versions-australiaeast'
var windowsDotNetPlanName = 'plan-windows-dotnet-versions-australiaeast'
var linuxNodePlanName = 'plan-linux-node-versions-australiaeast'
var linuxDotNetPlanName = 'plan-linux-dotnet-versions-australiaeast'

var nodeVersions = ['20', '22']

var dotnetVersions = ['8', '9']


// Windows Node App Service Plan
resource windowsNodeAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: windowsNodePlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'app'
}

// Windows .NET App Service Plan
resource windowsDotNetAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: windowsDotNetPlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'app'
}

// Linux Node App Service Plan
resource linuxNodeAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: linuxNodePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

// Linux .NET App Service Plan
resource linuxDotNetAppServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: linuxDotNetPlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}


// Windows Node Web Apps
resource windowsNodeWebApp 'Microsoft.Web/sites@2022-09-01' = [
  for version in nodeVersions: {
    name: 'app-windows-node${version}-versions-australiaeast'
    location: location
    kind: 'app'
    properties: {
      serverFarmId: windowsNodeAppServicePlan.id
      siteConfig: {
        windowsFxVersion: 'NODE:${version}LTS'
        http20Enabled: true
        ftpsState: 'Disabled'
        minTlsVersion: '1.2'
        appSettings: [
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
  }
]


// Linux Node Web Apps
resource linuxNodeWebApp 'Microsoft.Web/sites@2022-09-01' = [
  for version in nodeVersions: {
    name: 'app-linux-node${version}-versions-australiaeast'
    location: location
    properties: {
      serverFarmId: linuxNodeAppServicePlan.id
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
  }
]


// Linux .NET Web Apps
resource linuxDotNetWebApp 'Microsoft.Web/sites@2022-09-01' = [
  for version in dotnetVersions: {
    name: 'app-linux-dotnet${version}-versions-australiaeast'
    location: location
    properties: {
      serverFarmId: linuxDotNetAppServicePlan.id
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
            name: 'WEBSITE_HTTPLOGGING_RETENTION_DAYS'
            value: '3'
          }
        ]
      }
    }
  }
]


// Windows .NET Web Apps
resource windowsDotNetWebApp 'Microsoft.Web/sites@2022-09-01' = [
  for version in dotnetVersions: {
    name: 'app-windows-dotnet${version}-versions-australiaeast'
    location: location
    kind: 'app'
    properties: {
      serverFarmId: windowsDotNetAppServicePlan.id
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
  }
]
