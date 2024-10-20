### Managing Azure Resource Groups

#### **1. Overview of Tasks**

This guide covers key tasks involved in managing Azure Resource Groups, including creating resource groups, deploying resources, moving resources between groups, and applying resource locks to protect resources from accidental changes.

---

### **2. Create Resource Groups and Deploy Resources**

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

### **3. Move Resources Between Resource Groups**

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

### **4. Implement and Test Resource Locks**

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

### **5. Review of Actions Taken**

- **Created Resource Groups**:
  - Successfully created and configured resource groups (`Test-RG`, `Test-RG2`, `Test-RG3`).
  
- **Deployed Resources**:
  - Deployed two disk resources (`disk1`, `disk2`) within these resource groups.

- **Moved Resources**:
  - Moved the disk resource (`disk1`) from `Test-RG` to `Test-RG2`.

- **Applied Resource Locks**:
  - Implemented and tested **Delete Locks** on the disk resource (`disk2`) in `Test-RG3`, preventing accidental deletion but allowing performance modifications.

---

### **6. Key Learnings and Best Practices**

- **Resource Group Management**: Organizing resources logically using resource groups is critical for efficient management and monitoring.
  
- **Resource Locks**: Applying resource locks can help prevent unintentional changes, especially in production environments. Locks can prevent deletion but allow configuration changes, providing a balance between protection and flexibility.

- **Activity Monitoring**: Use the Azure **Activity Log** to monitor resource movements and administrative actions for better transparency and auditing.

---

This comprehensive approach to managing Azure Resource Groups ensures resources are deployed, moved, and protected efficiently, while allowing necessary modifications when needed.
