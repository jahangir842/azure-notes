### Managing Azure Resource Groups

**Reference:**
- [Microsoft Learn: Azure resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [Microsoft Learn: Organise Azure resources effectively](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/organize-resources)
- [Microsoft Learn: ARM template](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/)
- https://www.youtube.com/watch?v=g6thrYZhPZY
- https://www.youtube.com/watch?v=gIhf-S7BCdo
- [ARM Playlist](https://www.youtube.com/playlist?list=PLGjZwEtPN7j8_kgw92LHBrry2gnVc3NXQ)

### Azure Resource Group

An **Azure Resource Group** is a logical container that holds related Azure resources. It helps manage, organize, and group resources such as virtual machines, storage accounts, and databases that share the same lifecycle. 

---

## Benifits of Azure Resource Groups: 

Azure Resource Groups offer several key benefits for managing and organizing cloud resources efficiently. Below are the primary advantages:

### 1. **Centralized Management with Inherited Access Control (IAM)**
   - **Benefit**: You can apply **Role-Based Access Control (RBAC)** at the Resource Group level. This means permissions assigned to a resource group are automatically **inherited by all resources within the group**, simplifying access control and ensuring consistency.
   - **Example**: Assigning the "Contributor" role to a user at the resource group level grants them access to all resources (e.g., VMs, storage accounts) within the group without configuring each resource individually.

### 2. **Cost Management and Budgeting**
   - **Benefit**: You can define **budgets** for a resource group to **track and control costs**. This helps with monitoring the cost of resources and preventing overspending.
   - **Example**: Setting a $500 budget for a resource group alerts you when 80% of that budget is consumed, allowing you to control costs for a specific project or department.

### 3. **Consistent Governance with Policies**
   - **Benefit**: Azure **Policies** can be applied to a resource group to enforce rules and ensure compliance with organizational or regulatory standards. These policies are applied automatically to all resources within the group.
   - **Example**: You can apply a policy that restricts the deployment of resources in non-compliant regions or mandates that all resources must have specific tags for cost tracking or compliance purposes.

### 4. **Simplified Deployment and Automation**
   - **Benefit**: Using **Azure Resource Manager (ARM) templates**, you can automate the deployment of resources within a resource group. This simplifies the management of multi-tier applications and ensures all components are deployed consistently.
   - **Example**: Automating the deployment of a web application consisting of a virtual network, virtual machines, and a database, all within the same resource group.

### 5. **Resource Group-Level Tagging and Organization**
   - **Benefit**: You can apply **tags** to a resource group for organizing and categorizing resources based on projects, environments, or departments. These tags help track and manage resources effectively. **Note:** The tags will not be inherited to resources.
   - **Example**: Tagging all resources within a resource group as `Project: XYZ` and `Environment: Production` helps easily identify and manage resources related to that project and environment.

### 6. **Resource Group-Level Monitoring**
   - **Benefit**: You can monitor all resources in a group centrally using Azure Monitor, with metrics and alerts scoped at the resource group level.
   - **Example**: Setting up alerts for CPU usage across all virtual machines in a resource group ensures centralized monitoring for all related infrastructure components.

### 7. **Scalability and Organization**
   - **Benefit**: Resource groups allow you to **logically group related resources** for easier scalability and organization. This is especially useful for managing large-scale applications with multiple components.
   - **Example**: Grouping all resources (VMs, databases, storage) for a specific application within a single resource group makes it easier to manage and scale them together.

By leveraging these features, Azure Resource Groups help streamline resource management, improve governance, and optimize cost and operational efficiency.

---

### **Create Resource Groups and Deploy Resources**

- **Objective**: Create a resource group and deploy resources within it using the Azure portal.

#### **Steps**:

1. **Create a Resource Group**:
   - In the Azure portal, navigate to **Resource Groups**.
   - Click **Create** and name the group (e.g., `Test-RG`).
   - Choose the **Region** (e.g., East US).
   - Click **Review + Create**, then **Create** to deploy the resource group.

2. **Create a Disk Resource**:
   - Navigate to the newly created resource group (`Test-RG`).
   - Choose **Add** and select **Disk** as the resource to deploy.
   - Configure the disk with the following settings:
     - **Disk name**: `disk1`
     - **Region**: East US
     - **Disk type**: Standard HDD
     - **Size**: 32 GiB
   - Click **Review + Create**, then select **Create** to finalize the disk creation.

---

### **Move Resources Between Resource Groups**

- **Objective**: Move resources from one resource group to another.

#### **Steps**:

1. **Move Disk Resource to Another Resource Group**:
   - Navigate to **Test-RG**, select the **Disk** resource (`disk1`).
   - Click on **Move** > **Move to another resource group**.
   - Create a new resource group (e.g., `Test-RG2`), or select an existing one.
   - Acknowledge the updates required for any associated scripts (if applicable).
   - Click **Move** to initiate the process.

2. **Monitor the Move Process**:
   - Track the progress of the move operation through the **Activity Log** in the Azure portal.
   - Ensure that the resource has been successfully relocated to the new resource group.

---

### **Implement and Test Resource Locks**

- **Objective**: Apply locks to resources to prevent accidental deletion or modification.

#### **Steps**:

1. **Apply a Delete Lock**:
   - Create a second disk resource (`disk2`) in another resource group (e.g., `Test-RG3`):
     - Disk type: Standard HDD
     - Size: 32 GiB
   - Navigate to **Test-RG3**.
   - Go to **Locks** and click **Add** to create a new lock.
     - Lock type: **Delete Lock**
     - Description: Prevents the deletion of critical resources.
   - Save the lock.

2. **Test the Delete Lock**:
   - Attempt to delete the `disk2` resource.
   - The deletion will fail due to the applied lock, indicating successful protection.

3. **Modify Disk Performance**:
   - Change the disk’s performance (e.g., upgrade from Standard HDD to **Premium SSD** and increase size to 64 GiB).
   - The lock will not prevent modifications to the performance settings of the resource, only deletion.

---

### **Review of Actions Taken**

- **Created Resource Groups**:
  - Successfully created and configured resource groups (`Test-RG`, `Test-RG2`, `Test-RG3`).
  
- **Deployed Resources**:
  - Deployed two disk resources (`disk1`, `disk2`) within these resource groups.

- **Moved Resources**:
  - Moved the disk resource (`disk1`) from `Test-RG` to `Test-RG2`.

- **Applied Resource Locks**:
  - Implemented and tested **Delete Locks** on the disk resource (`disk2`) in `Test-RG3`, preventing accidental deletion but allowing performance modifications.

---

### **Key Learnings and Best Practices**

- **Resource Group Management**: Organizing resources logically using resource groups is critical for efficient management and monitoring.
  
- **Resource Locks**: Applying resource locks can help prevent unintentional changes, especially in production environments. Locks can prevent deletion but allow configuration changes, providing a balance between protection and flexibility.

- **Activity Monitoring**: Use the Azure **Activity Log** to monitor resource movements and administrative actions for better transparency and auditing.

---
### Azure Resource Manager (ARM)

**Azure Resource Manager (ARM)** is the deployment and management service for Microsoft Azure. It provides a unified management layer for deploying, managing, and monitoring resources in Azure.

#### **Key Features of ARM**:

1. **Declarative Syntax**:
   - ARM uses a declarative syntax to define the desired state of resources in JSON format. This allows users to describe what resources they want rather than how to create them.
   - Example of an ARM template:
     ```json
     {
       "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
       "contentVersion": "1.0.0.0",
       "resources": [
         {
           "type": "Microsoft.Storage/storageAccounts",
           "apiVersion": "2021-04-01",
           "name": "[parameters('storageAccountName')]",
           "location": "[parameters('location')]",
           "sku": {
             "name": "Standard_LRS"
           },
           "kind": "StorageV2",
           "properties": {}
         }
       ]
     }
     ```

2. **Resource Grouping**:
   - Resources can be organized into resource groups, which act as containers for related resources. This simplifies management and monitoring, allowing users to deploy, update, and delete resources collectively.
   - Resource groups also allow for role-based access control (RBAC) and resource policies to be applied at the group level.

3. **Role-Based Access Control (RBAC)**:
   - ARM supports RBAC to manage who has access to resources and what actions they can perform. Permissions can be assigned at different levels (subscription, resource group, or individual resources).
   - Example of RBAC roles:
     - Owner: Full access to all resources.
     - Contributor: Can manage resources but cannot grant access to others.
     - Reader: Can view resources but cannot make changes.

4. **Tagging**:
   - ARM allows tagging of resources to organize and categorize them. Tags consist of key-value pairs and can help manage costs, track resources, and enforce policies.

5. **Deployment Templates**:
   - ARM templates are JSON files that define the infrastructure and configuration for Azure resources. They can be versioned and reused, promoting consistency across deployments.
   - Templates can be parameterized, enabling dynamic deployments based on input values.

6. **Change Tracking and Auditing**:
   - ARM provides built-in logging and auditing features. Users can track changes made to resources, providing visibility into modifications and compliance.

7. **Integration with DevOps**:
   - ARM templates can be integrated into CI/CD pipelines to automate the deployment of infrastructure as code. Tools like Azure DevOps and GitHub Actions support ARM template deployment.

8. **Deployment Modes**:
   - ARM supports two deployment modes:
     - **Incremental Mode**: Adds resources defined in the template to the existing resource group without affecting resources not defined in the template.
     - **Complete Mode**: Deletes any resources not defined in the template, ensuring the resource group matches the template exactly.

#### **Common Use Cases**:

- **Infrastructure as Code (IaC)**: Automating the deployment and management of Azure resources using templates.
- **Environment Consistency**: Ensuring consistent environments across development, testing, and production.
- **Resource Management**: Efficiently organizing and managing resources within resource groups.
- **Cost Management**: Utilizing tagging to track costs associated with specific projects or teams.

#### **Example of an ARM Template**:

Here’s a simple ARM template that deploys a resource group with a storage account:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2021-04-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {}
    }
  ],
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "minLength": 3,
      "maxLength": 24,
      "metadata": {
        "description": "The name of the storage account."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    }
  }
}
```

#### **Conclusion**:
Azure Resource Manager provides a robust framework for deploying, managing, and monitoring Azure resources. Its declarative approach, along with features like RBAC, tagging, and deployment templates, makes it an essential tool for Azure administrators and developers aiming to manage cloud resources efficiently and effectively.
