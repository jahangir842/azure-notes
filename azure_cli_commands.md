
## Install Azure Cli

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt

## get started

https://learn.microsoft.com/en-us/cli/azure/get-started-tutorial-1-prepare-environment?view=azure-cli-latest&tabs=bash


## creae sp

https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal


```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/91caddb0-2111-48c6-9eb3-e83c855916c8" --sdk-auth
```