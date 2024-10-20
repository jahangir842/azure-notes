### Creating and Managing Disks in Azure

Azure provides flexible and scalable disk storage options for your virtual machines (VMs) and other resources. The following is a detailed step-by-step guide to creating and managing disks in Azure, focusing on selecting the right type of disk, configuring essential settings, and automating disk creation through templates.

---

#### **Step-by-Step Process to Create a Disk in Azure**

1. **Create a Resource (Disk)**
   - **Start by searching for "Disks"** in the Azure portal search bar.
   - The **Disks blade** will open, which is available under the **Compute** or **Storage** category. This is where you manage disks in Azure.

2. **Creating a New Disk**
   - Click **"Create"** to initiate the creation of a new disk.
   - You will be asked to configure essential settings for the new disk.

3. **Subscription Selection**
   - Select the appropriate **Azure subscription** under which the disk will be created. Ensure that the subscription has sufficient resources available.

4. **Resource Group**
   - Choose an existing **Resource Group** or create a new one.
     - Example: Create a new resource group called `rg-01` to logically organize the disk with related resources.
   - **Resource Groups** help manage and organize related resources in Azure, making it easier to manage, track, and delete multiple resources at once.

5. **Disk Name and Region**
   - Provide a **name** for the disk. Example: `disk01`.
   - Select a **Region** where the disk will be deployed.
     - **Recommended regions** often offer more features and availability zone options.
     - **Other regions** may have different pricing or limited features, so choose based on proximity, availability, or redundancy requirements.

6. **Availability Zone (Optional)**
   - Choose an **Availability Zone (AZ)** if required, or leave it unselected if no specific zone is needed.
     - Availability zones provide high availability by replicating resources across different physical locations within a region.

---

#### **Disk Configuration Options**

1. **Size and Disk Type**
   - **Size**: Choose or change the size of the disk based on your requirements. Sizes typically range from small (32 GB) to large (16 TB+) depending on your application or workload.
   - **Disk Type**: Azure offers different types of disks based on performance and cost.
     - **Standard HDD**: Cheapest, suited for low-cost storage, but slower in performance.
     - **Standard SSD**: Economical SSD option, faster than HDD, with reasonable performance.
     - **Premium SSD**: High-performance SSD with low latency and high IOPS (input/output operations per second).
     - **Why SSD?**: SSDs are faster and provide higher performance than HDDs. For mission-critical applications or workloads with frequent read/write operations, SSD is recommended. They come with a higher **SLA** (99.9% uptime for standard SSD, 99.99% for premium SSD across zones).

2. **Replication Options**
   - **Locally Redundant Storage (LRS)**: Ensures three synchronous copies of your data within a single datacenter. Suitable for scenarios where cost is a priority.
   - **Zone Redundant Storage (ZRS)**: Replicates your data across multiple availability zones, providing higher durability. Recommended for applications that need higher availability (99.99% SLA).

3. **Public Access Settings**
   - You can **Enable** or **Disable public access** depending on security requirements.
   - Public access is generally **disabled** by default for security purposes unless the disk needs to be accessed by external resources.

---

#### **After Disk Creation**

1. **Access and Verify the Disk**
   - Once the disk creation process is complete, go to the **newly created resource** by selecting it from the **Notifications** or the **Resource Group**.
   - Verify the disk properties:
     - **Size**
     - **Type (SSD or HDD)**
     - **Availability Zone**
   - The disk will not have an **Operating System (OS)** by default; it is treated as a data disk unless explicitly attached to a VM with an OS installed.

---

#### **Automation Options**

1. **Export Template for Automation**
   - After creating a disk, you can automate future disk creation by exporting the configuration as an **Azure Resource Manager (ARM) template**.
   - Navigate to the disk’s settings and select **Automation** > **Export Template**.
   - Azure will generate the **template** in JSON format, which defines the configuration of the disk.
     - You can either **view** the JSON or **download** it for future use.

2. **Understanding the ARM Template**
   - The **JSON template** contains the full configuration, including disk type, size, availability zone, replication type (LRS or ZRS), and other settings.
   - You can edit and reuse this template to deploy new disks programmatically or through automation services like Azure DevOps or the Azure CLI.
   - Example structure in the exported JSON file:
     ```json
     {
       "resources": [
         {
           "type": "Microsoft.Compute/disks",
           "apiVersion": "2020-12-01",
           "name": "disk01",
           "location": "East US",
           "properties": {
             "creationData": {
               "createOption": "Empty"
             },
             "diskSizeGB": 128,
             "diskIOPSReadWrite": 500,
             "diskMBpsReadWrite": 60,
             "encryption": {
               "type": "EncryptionAtRestWithPlatformKey"
             }
           }
         }
       ]
     }
     ```

---

#### **Review Resource Group and Deployment**

1. **Navigate to the Resource Group**
   - After creating the disk, check the **Resource Group (rg-01)** to see the newly created disk and other associated resources.
   - Resource Groups can be **geographically based** or grouped logically based on function.

2. **Deployment Information**
   - Under the Resource Group's settings, you can review the **Deployments** made within it.
   - Every deployment generates a **deployment file** (template) that can be viewed or downloaded in JSON format.
   - This file helps track what resources were deployed and their configuration.

---

#### **Disk Usage Scenarios**

1. **Attaching a Disk to a VM**
   - The most common use case for disks in Azure is attaching them to a virtual machine (VM). Disks can be:
     - **OS Disk**: A disk with the operating system pre-installed.
     - **Data Disk**: A secondary disk used to store application data.
   
2. **Backup and Storage**
   - Disks are also used as storage mediums for backup solutions, high-performance databases, and other applications that require fast read/write speeds or high durability.

---

#### **Best Practices for Disks in Azure**

1. **Choose SSD for Critical Workloads**:
   - SSDs provide better performance and higher reliability for mission-critical applications. They also come with higher SLAs, ensuring better uptime and availability.

2. **Select Appropriate Replication**:
   - For critical data, consider using **Zone Redundant Storage (ZRS)** or **Geographically Redundant Storage (GRS)** if multi-region replication is required for disaster recovery.

3. **Use Automation**:
   - Leverage ARM templates or other automation tools to standardize and streamline disk deployments across your environment, reducing manual errors and ensuring consistency.

4. **Cost Management**:
   - Premium SSDs and higher redundancy options (like ZRS) are more expensive. Ensure to balance performance needs with cost by selecting the right disk type for each workload.

---

#### **Cleanup and Resource Management**

1. **Deleting Resources**
   - After use, ensure to clean up by deleting unnecessary resources to avoid incurring costs.
     - **Delete Users** and any custom roles assigned to disk management.
     - **Remove the disk** and delete it from the Resource Group.
     - **Move or remove any subscriptions** from the associated **Management Group** if the group is no longer needed. 
   - Do not delete **Resource Groups** with active subscriptions or important resources inside, as they could cause data loss or service disruption.

---

### **Conclusion**

Azure provides highly flexible disk storage options with various performance tiers and redundancy features. Whether creating a disk for a virtual machine or managing storage across multiple zones, it is essential to configure disks based on workload requirements, such as size, performance (SSD vs. HDD), and availability needs. Azure’s automation tools like ARM templates make it easier to deploy and manage resources consistently and efficiently.

---

## Lab: Working with Azure Disks

In this lab, we will explore Azure Disks, including creating managed disks, attaching them to virtual machines, and using snapshots and backups for data protection. The steps will guide you through the process of working with Azure Disks in the Azure portal.

### **Lab Overview**

**Objectives:**
1. Create an Azure managed disk.
2. Attach the disk to an existing Azure Virtual Machine (VM).
3. Create a snapshot of the disk.
4. Backup the disk.
5. Detach and delete the disk.

### **Pre-requisites**

- An active Azure subscription.
- Access to the Azure portal ([https://portal.azure.com](https://portal.azure.com)).
- An existing Azure Virtual Machine (VM) to which you can attach disks.

---

### **Step 1: Create a Managed Disk**

1. **Log in to Azure Portal**:
   - Open your web browser and navigate to [Azure Portal](https://portal.azure.com).
   - Log in with your Azure credentials.

2. **Create a Managed Disk**:
   - In the Azure portal, use the search bar at the top to search for **Disks** and click on it.
   - Click on **+ Create**.
   - Fill in the details:
     - **Subscription**: Select your subscription.
     - **Resource Group**: Choose an existing resource group or create a new one (e.g., "MyDiskResourceGroup").
     - **Disk Name**: Enter a name for your disk (e.g., "MyManagedDisk").
     - **Region**: Select the same region as your VM.
     - **Availability Options**: Choose "No redundancy" for this lab.
     - **Source Type**: Select "None" since we are creating a new disk.
     - **Disk Type**: Choose the type of disk (e.g., "Standard SSD", "Premium SSD", or "Standard HDD").
     - **Size + performance**: Select the size of the disk based on your needs (e.g., 128 GB).
   - Click on **Review + Create**, then **Create**.

3. **Verify Disk Creation**:
   - After a few moments, you will see a notification that the disk has been created successfully.
   - Click on **Go to resource** to view your managed disk.

---

### **Step 2: Attach the Managed Disk to an Existing VM**

1. **Navigate to the Virtual Machine**:
   - In the Azure portal, search for **Virtual Machines** and click on it.
   - Select the VM to which you want to attach the disk (e.g., "MyTestVM").

2. **Attach the Disk**:
   - In the VM's blade, click on **Disks** under the "Settings" section.
   - Click on **+ Add data disk**.
   - In the **Name** dropdown, select the managed disk you just created (e.g., "MyManagedDisk").
   - Leave the **LUN** as the default (0) unless you have specific requirements.
   - Ensure **Enable auto-delete on detach** is checked if you want Azure to automatically delete the disk when detached.
   - Click **Save** to attach the disk.

3. **Verify Disk Attachment**:
   - After the save operation completes, you should see your managed disk listed under the **Data disks** section.

---

### **Step 3: Create a Snapshot of the Managed Disk**

1. **Navigate to the Managed Disk**:
   - In the Azure portal, go back to **Disks**.
   - Click on the disk you created earlier (e.g., "MyManagedDisk").

2. **Create a Snapshot**:
   - In the disk's blade, click on **Snapshots** in the "Settings" section.
   - Click on **+ Create snapshot**.
   - Fill in the details:
     - **Name**: Enter a name for the snapshot (e.g., "MyDiskSnapshot").
     - **Resource Group**: Choose the same resource group as the managed disk or create a new one.
     - **Snapshot Type**: Choose "Full" (this will create a full snapshot of the disk).
   - Click on **Review + Create**, then **Create**.

3. **Verify Snapshot Creation**:
   - After a few moments, you will see a notification indicating the snapshot has been created successfully.
   - Navigate back to **Snapshots** in the Azure portal to confirm the snapshot appears in the list.

---

### **Step 4: Backup the Managed Disk**

1. **Navigate to the Managed Disk**:
   - Go back to **Disks** and select the managed disk (e.g., "MyManagedDisk").

2. **Create a Backup**:
   - In the disk's blade, click on **Backups** in the "Settings" section.
   - Click on **+ Backup**.
   - Choose the **Backup policy** (if no policy exists, you'll need to create one first).
   - Click on **Backup** to start the backup process.

3. **Verify Backup Creation**:
   - After the backup process completes, you can check the backup status in the **Backups** section of the managed disk.

---

### **Step 5: Detach and Delete the Managed Disk**

1. **Detach the Disk from the VM**:
   - Go back to the VM (e.g., "MyTestVM").
   - Click on **Disks**.
   - Click on the disk you attached earlier.
   - Click on **Detach** to remove the disk from the VM. Confirm the action.

2. **Delete the Managed Disk**:
   - After detaching, go back to **Disks** in the Azure portal.
   - Select the disk you created (e.g., "MyManagedDisk").
   - Click on **Delete** at the top of the disk's blade.
   - Confirm the deletion.

---

### **Conclusion**

In this lab, you learned how to create and manage Azure Disks, attach them to a virtual machine, create snapshots for backup purposes, and finally, detach and delete the disk. Azure Disks provide a robust storage solution that can be used to enhance the performance and reliability of your virtual machines. You can further explore Azure Disk features, such as geo-replication and scaling options, to optimize your cloud storage strategy.
