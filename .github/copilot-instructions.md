# Copilot Instructions for azure-appservice-versions

## Project Overview
This repository automates the discovery and reporting of actual runtime versions used by Azure App Services for Node.js and .NET, across both Windows and Linux plans. It provisions App Service Plans and Web Apps for each runtime/platform combination, deploys minimal sample apps, and queries them to determine the real runtime version provisioned by Azure.

## Architecture & Key Components
- **Sample Apps** for each runtime/platform combination are located under `apps/`
  - `apps/dotnetApp/`: Minimal ASP.NET app returning the .NET runtime version at `/`.
  - `apps/nodeApp/`: Express app returning the Node.js version at `/`.
- **Automation & Reporting**:
  - `.github/workflows/appservices.yml`: Main workflow. Deploys infra, publishes apps, queries each app, and generates a sortable HTML report of actual versions.
  - JSON files are used as workflow artifacts to pass version info between jobs.
  - The HTML report is published to GitHub Pages and is fully sortable (ARIA-compliant, see W3C example).

## Developer Workflows
- **App Deployment**: Each app is deployed via `az webapp up` in the workflow, using the correct plan and runtime for each matrix entry.
- **Version Reporting**: Each app is queried at its root URL. The response is saved as a JSON artifact, then aggregated into a Markdown summary and a sortable HTML table.
- **Manual App Builds**:
  - Node: `cd apps/nodeApp && npm ci && node app.js`
  - .NET: `cd apps/dotnetApp && dotnet run`

## Conventions & Patterns
- **Resource Naming**: All Azure resources use the pattern `app-<os>-<framework><version>-versions-australiaeast` for easy identification.
- **Matrix Workflows**: Workflows use matrix strategies to test all OS/runtime/version combinations.
- **JSON Artifacts**: All version data is passed as JSON, not plain text, to enable structured aggregation.
- **HTML Reporting**: The HTML report is generated line-by-line in PowerShell for YAML compatibility and accessibility.
- **No Tests**: Sample apps are intentionally minimal and do not include tests.

## Integration Points
- **Azure**: Uses `az` CLI for resource management and deployment. Requires service principal credentials in repo secrets.
- **GitHub Pages**: Final report is published to GitHub Pages via workflow.

## Key Files & Directories
- `apps/dotnetApp/Program.cs`: .NET version endpoint
- `apps/nodeApp/app.js`: Node.js version endpoint
- `.github/workflows/appservices.yml`: Main automation pipeline
- `.github/workflows/node.yml`, `.github/workflows/dotnet.yml`: App-specific build/test workflows (minimal)
- `README.md`: Project background and Azure setup instructions

## Example: Adding a New Runtime Version
1. Add the version to the appropriate matrix in `.github/workflows/appservices.yml` (e.g., `dotnet-version` or `node-version`).
2. Commit and push to `main`. The workflow will provision new apps and update the report automatically.

---
If any conventions or workflows are unclear or missing, please provide feedback for further refinement.
