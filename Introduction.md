# Azure Portal and Identity Management

## Azure Portal

- **Portal URL**: Access Azure services and resources through [portal.azure.com](https://portal.azure.com).
- **Login**: Sign in using your Azure account credentials (ID and password).
  
## Licenses in Azure

Azure offers different licensing tiers for identity management:
- **Free Tier**: Provides basic identity management services with limitations.
- **P1 License**: Premium plan with additional features for identity protection and management.
- **P2 License**: Includes advanced identity governance and security features.
- **Microsoft 365 Suite**: Includes multiple identity management features bundled with productivity tools.

> Note: Free tier includes **55,000 free identities**.

---

## Azure Directory and Tenants

- **Default Directory**: Azure assigns a default directory upon account creation. 
- **Directory = Tenant**: The term directory is used interchangeably with tenant in Azure.

### Managing Tenants in Entra ID
- **Entra ID (Azure AD)**: Microsoft Entra ID is the rebranded Azure Active Directory, used to manage identities and tenants.
- **Overview**: In the Entra ID Overview section, you can manage and view:
  - Tenants you own.
  - Tenants you have joined as an external or guest user.

- **Switching Tenants**: 
  - You can switch between tenants by selecting one from the list or clicking the **gear icon** in the top-right corner of the portal.
  - **Tenant Location**: When creating a new tenant, you will be asked for the tenant’s location (geographic region).
  - **Tenant Visibility**: The active tenant will be displayed in the top corner of the portal, next to your email.

### Tenant Management Permissions
- Only **Super Admins** have the ability to create tenants.
- **Global Admins** cannot create new tenants.
  
---

## User Management in Azure AD

### Initial Setup:
- When you first set up a directory, the only user in the system is your own account (created during Azure signup).
- No groups are present initially.

### Creating a New User:
You can create new users through the following two methods:
1. **Create User**: Directly create a user within the Azure tenant.
2. **Invite User**: Invite external users to join your directory as guest users.

#### Steps to Create a New User:
- **User Principal Name (UPN)**: This is the user’s login ID (e.g., `username@domain.com`).
- **Domain**: If linked with Office 365, you can choose the domain for the user.
- **User Type**: The user can be of the following types:
  - **Member**: Standard user within your organization.
  - **Guest**: External users invited to collaborate.

- **Finalizing Creation**:
  - After providing the necessary details, review the user creation settings.
  - Copy the user’s login name and temporary password for future use.

> Note: A user’s **identity** comes from the **tenant** they belong to.

### Logging in as the New User
Once the user is created, they can log in to the Azure portal using their login credentials.

---

## Azure Roles

### Entra ID Role vs Service Role

- **Entra ID Role**: Specific to managing identities and tenant-wide permissions. For example, Global Admin, User Administrator, etc.
- **Service Role**: Roles associated with managing Azure resources, such as Virtual Machines, Storage, or Networking services.

---

## Additional Information: Course and Pricing

- **AZ-401 Certification**:
  - **Classroom Price**: $2,500 for instructor-led training.
  - **Includes**: Scenarios and hands-on labs to prepare for the certification.
  - **Free Courses**: May not include practical scenarios for learning.
