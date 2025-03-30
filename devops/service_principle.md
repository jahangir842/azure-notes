# Creating an Azure Service Principal with RBAC using Azure CLI

## Overview
A **Service Principal** in Azure is an identity used by applications, services, and automation tools to access Azure resources securely. It is commonly used to enable role-based access control (RBAC) for scripts, applications, and deployments.

This guide explains how to create a Service Principal using the Azure CLI (`az ad sp create-for-rbac`) with a specific role and scope.

---

## Prerequisites
Before running the command, ensure that:
- You have **Azure CLI** installed. If not, install it from [Azure CLI GitHub](https://github.com/Azure/azure-cli) or follow the [official documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
- You are logged in to your Azure account:
  ```bash
  az login
  ```
- You have the necessary permissions to create a Service Principal and assign roles.

---

## Creating a Service Principal for RBAC
Run the following command to create a Service Principal with the **Contributor** role and a specified **subscription scope**:

```bash
az ad sp create-for-rbac \
  --name "sp-demo" \
  --role contributor \
  --scopes /subscriptions/91caddb0-2111-48c6-9eb3-e83c855916c8 \
  --sdk-auth
```

### Explanation of Parameters:
- `--name "sp-demo"` → The display name of the Service Principal.
- `--role contributor` → Assigns the **Contributor** role (can be changed to other roles like `Reader`, `Owner`, etc.).
- `--scopes /subscriptions/91caddb0-2111-48c6-9eb3-e83c855916c8` → Specifies the **scope** (subscription ID) where permissions will be applied.
- `--sdk-auth` → Outputs a JSON object containing authentication details, which can be used for SDKs and automation scripts.

### Example Output:
```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "subscriptionId": "91caddb0-2111-48c6-9eb3-e83c855916c8",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "resourceManagerEndpointUrl": "https://management.azure.com/"
}
```

Save this output securely, as it contains credentials for authentication.

---

## Verifying the Service Principal
After creation, you can verify the Service Principal by running:

```bash
az ad sp list --display-name "sp-demo"
```

or check role assignments with:

```bash
az role assignment list --assignee "http://sp-demo"
```

---

## Managing the Service Principal
### Retrieving Credentials
To retrieve details of an existing Service Principal:
```bash
az ad sp show --id "http://sp-demo"
```

### Resetting Credentials
To generate a new password (client secret):
```bash
az ad sp credential reset --name "sp-demo"
```

### Deleting the Service Principal
If no longer needed, delete the Service Principal:
```bash
az ad sp delete --id "http://sp-demo"
```

---

## Conclusion
This guide demonstrated how to create, verify, manage, and delete a Service Principal using Azure CLI. Service Principals are essential for automation, CI/CD pipelines, and secure resource access in Azure.

For more details, refer to:
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/ad/sp)
- [Azure CLI GitHub Repository](https://github.com/Azure/azure-cli)

