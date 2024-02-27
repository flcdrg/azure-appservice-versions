# Get current Azure App Service application versions

Display application version in Azure App Services

## Infrastructure

Note: You will need to adjust the names if you are trying to provision your own resources.

Create a new resource group in Azure

```bash
az group create --location australiaeast --resource-group rg-versions-australiaeast
```

Create a service principal that has contributor access to the resource group

```bash
az ad sp create-for-rbac --name sp-versions-australiaeast --role Contributor --scopes /subscriptions/<yoursubscription>/resourceGroups/rg-versions-australiaeast --sdk-auth
```
