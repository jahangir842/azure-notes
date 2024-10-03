### Notes: Managing Azure Resources via Azure Portal

#### **Objective**:  
Explore Azure administration tasks, including resource provisioning, organizing resources into groups, moving resources between groups, and protecting resources from accidental deletion.

---

#### **Tasks Overview**:

1. **Create Resource Groups and Deploy Resources**  
   - Use Azure portal to create a **Resource Group** (e.g., `Test-RG`).  
   - Create a **disk** resource with the following:  
     - **Disk name**: `disk1`  
     - **Region**: East US  
     - **Disk type**: Standard HDD (32 GiB)  
   - Click **Review + Create**, then **Create**.

2. **Move Resources Between Resource Groups**  
   - Move disk resource to another resource group:  
     - Select **Test-RG** > Disk (`disk1`) > **Move** > **Move to another resource group**.  
     - Create new resource group (`Test-RG2`), acknowledge updates for scripts, and click **Move**.  
   - **Note**: Monitor the move process using the activity log.

3. **Implement and Test Resource Locks**  
   - Apply a **Delete Lock** to prevent accidental deletion:  
     - Create another disk (`disk2`) in `Test-RG3` (Standard HDD, 32 GiB).  
     - Go to **Locks** in `Test-RG3` and add a **Delete Lock**.  
     - Attempt to delete the disk; deletion will fail due to the lock.
   - Modify disk performance (e.g., upgrade to **Premium SSD**, 64 GiB).  
     - Lock does not prevent changes to performance settings, only deletion.

---

#### **Review**:  
- Created resource groups and deployed resources.
- Moved resources between groups.
- Applied resource locks and tested modifications.
