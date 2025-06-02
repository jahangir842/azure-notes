terraform for azure

## Get started the official way

got to terraform registry

find azure provider,,, open it,,, 

copy latest provider code and put it

go to its documentation ,,, in filter search the resources that you want to use  ... copy its example code and use it ,,, find "example" word and replace all with you selected name.

You can find your subscription ID by running:

az account show --query id -o tsv

Set the Azure credentials as environment variables to avoid modifying main.tf. Terraform automatically picks these up.

for linux:

export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"


for windows powershell

$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_TENANT_ID = "your-tenant-id"




## Tutorials:

https://developer.hashicorp.com/terraform/tutorials/azure-get-started


