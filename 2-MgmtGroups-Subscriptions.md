### **Management Groups and Subscriptions in Azure**

### **1. Management Groups**
- **Definition**: Management groups are a way to organize Azure subscriptions into a hierarchy for governance and management. They allow you to manage access, policies, and compliance across multiple subscriptions.
  
- **Purpose**:
  - **Hierarchy**: You can create a hierarchy of management groups, allowing for the application of policies and role-based access control (RBAC) at different levels.
  - **Policy Enforcement**: Apply Azure Policy at the management group level, ensuring consistent governance across all associated subscriptions.
  - **Cost Management**: Helps in tracking and managing costs across multiple subscriptions by grouping them logically.

- **Structure**:
  - **Root Management Group**: Every Azure tenant has a root management group that acts as the top level in the hierarchy.
  - **Child Management Groups**: You can create child management groups under the root management group or other management groups.
  - **Subscriptions**: Subscriptions can be associated with any management group, making it easier to manage access and compliance.

- **Benefits**:
  - Streamlined governance and compliance management.
  - Centralized management of policies and permissions across multiple subscriptions.
  - Simplified cost management and reporting.

### **Azure Management Group Limits**

The following are the key limits for **Management Groups** in Azure:

| **Resource**                             | **Limit**                                                        |
|------------------------------------------|------------------------------------------------------------------|
| **Management groups per Microsoft Entra tenant** | 10,000                                                           |
| **Subscriptions per management group**   | Unlimited                                                        |
| **Levels of management group hierarchy** | Root level plus 6 levels (excluding subscription level)           |
| **Direct parent management group per management group** | One                                                      |
| **Management group level deployments per location** | 800                                                            |
| **Locations of management group level deployments**  | 10                                                             |

### **Notes:**
- The 6 levels of hierarchy don't include the subscription level.
- For management group level deployments, if you reach the limit of 800, delete old deployments using:
  - **PowerShell**: `Remove-AzManagementGroupDeployment`
  - **Azure CLI**: `az deployment mg delete`
 
---

### **2. Azure Subscriptions**
- **Definition**: An Azure subscription is a logical container used to provision and manage Azure resources. Each subscription has its own set of resources, quotas, and billing.

- **Purpose**:
  - **Resource Management**: Subscriptions allow organizations to manage Azure resources in an isolated and organized manner.
  - **Billing and Quotas**: Each subscription has its own billing account, meaning usage and costs are tracked separately.
  - **Access Control**: Role-Based Access Control (RBAC) can be implemented at the subscription level, allowing for granular access management.

- **Structure**:
  - Subscriptions are tied to a specific Azure Active Directory (AAD) tenant, which serves as the identity and access management layer.
  - You can have multiple subscriptions under a single tenant, each serving different departments, projects, or environments (e.g., development, testing, production).

- **Types of Subscriptions**:
  - **Free Tier**: Provides limited access to Azure services for free.
  - **Pay-As-You-Go**: Allows you to pay for only what you use on a monthly basis.
  - **Enterprise Agreement (EA)**: Offers discounted rates for larger organizations based on a commitment to use Azure services over a specified term.
  - **Microsoft Customer Agreement (MCA)**: A newer model that simplifies the purchasing and management experience.

- **Benefits**:
  - Flexibility to organize resources by project, team, or environment.
  - Enhanced security and governance through RBAC at the subscription level.
  - Clear visibility and control over costs and resource usage.
 
### **Azure Subscription Limits**

The following are the key limits for **Azure Subscriptions**:

| **Resource**                                         | **Limit**                                                        |
|------------------------------------------------------|------------------------------------------------------------------|
| **Azure subscriptions associated with a Microsoft Entra tenant** | Unlimited                                                        |
| **Coadministrators per subscription**                | Unlimited                                                        |
| **Resource groups per subscription**                 | 980                                                              |
| **Azure Resource Manager API request size**          | 4,194,304 bytes                                                  |
| **Tags per subscription**                            | 50                                                               |
| **Unique tag calculations per subscription**         | 80,000                                                           |
| **Subscription-level deployments per location**      | 800                                                              |
| **Locations of Subscription-level deployments**      | 10                                                               |

### **Notes:**
- You can apply up to 50 tags directly to a subscription, but it can contain an unlimited number of tags spread across resources and resource groups.
- Resource Manager returns tag details only when the number of unique tags is 80,000 or less. Unique tags are combinations of resource ID, tag name, and tag value.
- Deployments are automatically deleted from history when nearing the 800 limit to prevent reaching the cap.

### **Conclusion**
Management groups and subscriptions are essential components of Azure's organizational structure, allowing for effective governance, resource management, and compliance. By leveraging these tools, organizations can maintain a structured and efficient approach to managing their Azure environments.
