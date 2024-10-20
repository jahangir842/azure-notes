### Managing Azure Resource Groups

**Reference:**
- [Microsoft Learn: Azure resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [Microsoft Learn: Organise Azure resources effectively](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/organize-resources)
- https://www.youtube.com/watch?v=g6thrYZhPZY
- https://www.youtube.com/watch?v=gIhf-S7BCdo


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

