# Get current Azure App Service application versions

Display runtime versions in Azure App Services.

For example, when you specify Node 18 LTS, what exact version is Azure provisioning? Surprisingly, it probably isn't the latest LTS version in that major release.

This project creates Azure App Services with different runtime versions on Windows and Linux and then generates a report as to what actual node version is being used.

## Infrastructure

Note: You will need to adjust the names if you are trying to provision your resources.

Create a new resource group in Azure

```bash
az group create --location australiaeast --resource-group rg-versions-australiaeast
```

Create a service principal that has contributor access to the resource group

```bash
az ad sp create-for-rbac --name sp-versions-australiaeast --role Contributor --scopes /subscriptions/<yoursubscription>/resourceGroups/rg-versions-australiaeast --sdk-auth
```
