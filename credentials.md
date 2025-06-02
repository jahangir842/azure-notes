
### Step 1: create sp:

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/91caddb0-2111-48c6-9eb3-e83c855916c8" --sdk-auth
```

Option '--sdk-auth' has been deprecated and will be removed in a future release.
Creating 'Contributor' role assignment under scope '/subscriptions/91caddb0-2111-48c6-9eb3-e83c855916c8'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "clientId": "01746100-7eef-4da7-9a2f-2bf546bc5b7b",
  "clientSecret": "NGz8Q~dzbWMikvHcxrMDXDFRuqq5mfh9DS-WsdkQ",
  "subscriptionId": "91caddb0-2111-48c6-9eb3-e83c855916c8",
  "tenantId": "13bef5f4-26a5-4f50-9ca5-cc0f6bb93162",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}

______________________________________________________________________________________________________________
### Step 2: export the env variable

export ARM_CLIENT_ID="01746100-7eef-4da7-9a2f-2bf546bc5b7b"
export ARM_CLIENT_SECRET="NGz8Q~dzbWMikvHcxrMDXDFRuqq5mfh9DS-WsdkQ"
export ARM_SUBSCRIPTION_ID="91caddb0-2111-48c6-9eb3-e83c855916c8"
export ARM_TENANT_ID="13bef5f4-26a5-4f50-9ca5-cc0f6bb93162"


______________________________________________________________________________________________________________

### Step 2: export the env variable

now use the terrafom, it will be authenticated with above service principle

______________________________________________________________________________________________________________

```az account show```
{
  "environmentName": "AzureCloud",
  "homeTenantId": "13bef5f4-26a5-4f50-9ca5-cc0f6bb93162",
  "id": "91caddb0-2111-48c6-9eb3-e83c855916c8",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Subscription 1",
  "state": "Enabled",
  "tenantDefaultDomain": "jahangir80842hotmail.onmicrosoft.com",
  "tenantDisplayName": "Default Directory",
  "tenantId": "13bef5f4-26a5-4f50-9ca5-cc0f6bb93162",
  "user": {
    "name": "jahangir80842@hotmail.com",
    "type": "user"
  }
}


### Subscription name:

```bash
Subscription 1
```

### Subscription id:

```bash
91caddb0-2111-48c6-9eb3-e83c855916c8
```

### Default Directory 

```bash
jahangir80842hotmail.onmicrosoft.com
```



## creae sp
```bash
https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal
```
