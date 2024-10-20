### **Azure Virtual Networking and Network Management**

Azure Virtual Networking (VNet) is a core component of Azure’s networking infrastructure. VNets provide isolation, segmentation, and control over inbound and outbound traffic. This guide covers various aspects of creating and managing Azure networking, including VNets, subnets, DNS zones, and network security groups (NSGs).

---

#### **1. Creating a Resource Group**

A **Resource Group** is a logical container where all Azure resources are grouped for easy management.

- **Steps**:
  - In the Azure portal, search for **Resource Groups**.
  - Select **Create**.
  - Provide a **Name** and select the **Region**.
  - Click **Review + Create**, then **Create**.

---

#### **2. Creating a Virtual Network (VNet)**

A **Virtual Network** (VNet) allows Azure resources to communicate securely with each other, the internet, and on-premises networks.

- **Steps**:
  - In the Azure portal, search for **Virtual Networks**.
  - Click **Create** and select your **Resource Group**.
  - Provide a **Name** for the VNet and select the **Region**.
  - In the **IP Addresses** tab, remove the default address space (if needed) and add your desired **Address Space** (e.g., `10.0.0.0/16`).
  - Review the total addresses allocated in the address space. Azure will display the number of available IPs for your chosen CIDR block.
  - Click **Next: Security** and configure additional security features if needed.
  - Click **Review + Create**, then **Create**.

---

#### **3. Creating Subnets**

Subnets divide a VNet into smaller address ranges, providing isolation and security.

- **Steps**:
  - In your newly created VNet, go to **Subnets** under **Settings**.
  - Click **+ Subnet** to create a new subnet.
  - Provide a **Name** (e.g., "default" for a default subnet).
  - Specify the **Address Prefix** (e.g., `10.0.1.0/24`).
  - The subnet will allocate 251 IP addresses, with 5 reserved for Azure (e.g., network ID, broadcast, DNS, etc.).
  - You can create additional subnets by repeating this process, adjusting the starting IP of the address prefix as necessary.

---

#### **4. Network Security Groups (NSG)**

Network Security Groups (NSGs) are used to filter network traffic to and from Azure resources. You can associate NSGs with subnets or network interfaces (NICs) to control access.

- **Creating NSG**:
  - Search for **Network Security Groups** and click **Create**.
  - Provide a **Name** and associate it with the relevant **Resource Group** and **Region**.
  - Click **Review + Create**, then **Create**.

- **Configuring NSG Rules**:
  - Under your newly created NSG, navigate to **Inbound Security Rules** to control incoming traffic.
  - Click **+ Add** to create a new inbound rule, for example:
    - **Service**: RDP (for remote access).
    - **Priority**: Lower numbers have higher priority (e.g., 100).
    - **Action**: Allow.
  - Similarly, you can define **Outbound Security Rules** to control outgoing traffic.
  - Apply the NSG to a NIC or a subnet.

---

#### **5. Creating Virtual Machines (VMs)**

Virtual machines (VMs) are key components in Azure, and network configuration plays an important role in managing access and communication between VMs.

- **Steps to Create a VM**:
  - In the Azure portal, search for **Virtual Machines** and click **Create**.
  - Provide a **Name** and select the **Region**.
  - Turn **Public Inbound Ports** off.
  - Ensure **Public IP** is set to "No" to prevent direct public access.
  - Disable **NIC NSG** by setting it to "None" (optional if you manage NSG separately).
  - Review and create the VM.

- **Create a Second VM**: Follow the same process to create another VM in the same or different subnet, depending on your network design.

---

#### **6. Configuring IP Addresses**

Each VM has a **Network Interface (NIC)** that handles network communication. By default, VMs get **Dynamic Private IPs**, but they can be changed to static IPs.

- **Steps**:
  - Go to the first VM’s **Networking** tab, then click the network interface card (NIC).
  - Under **IP Configurations**, click on **ipconfig1** (the default configuration).
  - Change the **Private IP Address** from **Dynamic** to **Static**.
  - Check the option to **Associate Public IP Address** if you want to add a public IP.
  - You can create a new public IP by searching for **Public IP Addresses** in the portal, then associating it with the NIC.

---

#### **7. Assigning NSGs to VMs**

Once the NSG is configured, you need to associate it with your VMs to control traffic.

- **Steps**:
  - Go to the VM’s **Networking** settings.
  - Under **Network Interface**, associate the created **NSG**.
  - In the **Inbound Rules** of the NSG, ensure that the rule allowing **RDP** (Remote Desktop Protocol) is configured.
  - After NSG is assigned, you can use **RDP** to connect to the VM using the assigned public IP.

---

#### **8. DNS Zones: Private and Public**

Azure supports both **Private** and **Public DNS Zones** for managing domain name resolution.

- **Private DNS Zones**:
  - Used for internal name resolution within a virtual network.
  - To create:
    - Search for **Private DNS Zones** and click **Create**.
    - Provide a name (e.g., `corvit.com`) and select the appropriate resource group.
    - Leave the rest as default and create the DNS zone.

  - **Add Virtual Network Link**:
    - After creating the private DNS zone, link it to a VNet.
    - Go to **Virtual Network Links** in the DNS zone and create a link.
    - Name it and link the zone to the VNet. You can leave the "Resource ID" field empty if not known.

- **Public DNS Zones**:
  - Used for publicly accessible resources.
  - Similar to creating a private DNS zone, but it's exposed to the internet and external clients.

- **Managing DNS Record Sets**:
  - In your DNS zone, you can manage **Record Sets** (A, CNAME, etc.).
  - Record sets can automatically update if the server’s IP changes, or they can be manually edited.

---

#### **9. Routing in Azure**

Unlike AWS, Azure handles routing automatically between VNets and subnets. However, you can create custom routes if needed, especially for controlling traffic flow.

---

#### **10. Cleaning Up Resources**

To avoid unnecessary costs or keep your environment clean, you can delete the resource group, which will also delete all associated resources.

- **Steps**:
  - First, remove individual components like VMs, NICs, or NSGs if necessary.
  - Move any **subscriptions** out of the management group (if applicable).
  - Finally, delete the resource group by searching for it, selecting it, and clicking **Delete**.

---

### **Conclusion**

Azure’s Virtual Networking, combined with tools like NSGs and DNS zones, provides a powerful way to manage traffic, security, and network communication in cloud environments. By leveraging these features, you can effectively build and secure cloud networks for your applications and services.
