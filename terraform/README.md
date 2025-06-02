### Getting Started with Terraform for Azure

#### 1. Use the Official Provider

Begin by visiting the [Terraform Registry](https://registry.terraform.io/).

* Search for the **Azure Provider** (also known as `azurerm`).
* Open the provider page.
* Copy the **latest provider block** and paste it into your Terraform configuration (`main.tf` or equivalent).

#### 2. Explore Provider Documentation

* On the Azure provider's page, navigate to the **documentation** section.
* Use the **search or filter** functionality to find the specific **resource types** you plan to use (e.g., `azurerm_virtual_machine`, `azurerm_resource_group`, etc.).
* Copy the provided **example configuration** of each resource.
* Replace placeholder terms like `"example"` with a meaningful name related to your infrastructure.

#### 3. Set Up Azure Credentials

To authenticate Terraform with Azure, set the following environment variables. This allows Terraform to securely authenticate without hardcoding credentials in your `.tf` files.

You can retrieve your **Azure Subscription ID** by running:

```bash
az account show --query id -o tsv
```

Then, export the credentials using the appropriate method for your operating system.

##### For Linux/macOS:

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
```

##### For Windows PowerShell:

```powershell
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_TENANT_ID = "your-tenant-id"
```

#### 4. Official Tutorials and Learning Resources

To follow step-by-step tutorials, refer to the official guide from HashiCorp:

👉 [Terraform + Azure: Get Started](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)




