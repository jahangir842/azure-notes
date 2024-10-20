### Reference:
- [Getting started with Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/getting-started?pivots=stack-net)
- https://www.youtube.com/watch?v=4BwyqmRTrx8
- [app-service-sidecar](https://github.com/Azure-Samples/app-service-sidecar-tutorial-prereqs)
  
---

### **Azure App Service Overview**

Azure App Service is a fully managed platform for building, deploying, and scaling web applications, APIs, and mobile backends. It supports multiple programming languages and frameworks, including 

- .NET
- Java
- Node.js
- Python
- PHP
- Ruby
- **docker** (Yes, docker too)

---

**4 main options when creating a web app in Azure:**

1. **Web App**: A dynamic app supporting various languages (e.g., .NET, Node.js, Python).
2. **Static Web App**: For static content (HTML, CSS, JavaScript), ideal for frontend frameworks.
3. **Web App + Database**: Combines a web app with a database (e.g., MySQL, SQL) for data-driven applications.
4. **WordPress Web App**: A pre-configured option to quickly set up and host a WordPress site.

---

### **Key Features**

1. **Fully Managed Environment**:
   - Automatic updates, scaling, and load balancing, allowing developers to focus on application logic rather than infrastructure management.

2. **Multiple Hosting Options**:
   - **Web Apps**: Host web applications and services.
   - **API Apps**: Deploy RESTful APIs securely.
   - **Mobile Apps**: Build and host mobile backends.
   - **Function Apps**: Run serverless functions to handle events.

3. **Integrated DevOps**:
   - Continuous integration and deployment (CI/CD) support with GitHub, Azure DevOps, and Bitbucket.
   - Built-in support for staging slots for testing before production.

4. **Auto-Scaling**:
   - Automatically scales applications based on demand, ensuring optimal performance.

5. **Custom Domains and SSL**:
   - Supports custom domains and provides free SSL certificates for secure connections.

6. **Built-in Monitoring**:
   - Integration with Azure Monitor and Application Insights for performance monitoring and diagnostics.

7. **Security Features**:
   - Supports authentication/authorization with Azure EntraID, Facebook, Google, and other providers.
   - Network security through Virtual Network Integration and Private Endpoints.

---

### **Benefits of Azure App Service**

- **Speed**: Rapidly deploy and update applications with built-in templates and services.
- **Scalability**: Easily scale applications up or down based on traffic demands.
- **Flexibility**: Supports a wide range of programming languages and frameworks.
- **Cost-effective**: Pay only for the resources you use, with various pricing tiers to fit different needs.
- **Compliance**: Helps meet industry standards with built-in security and compliance features.

---

### Azure App Service Plan Overview

An **Azure App Service Plan** defines the region (datacenter) of the physical server where your application will be hosted and dictates the amount of resources (CPU, memory, etc.) that will be allocated to your application. It is essential for configuring the scaling and performance characteristics of your Azure Web Apps, API Apps, and Mobile Apps.

### Key Concepts

1. **Pricing Tiers**:
   In Azure, a **SKU (Stock Keeping Unit)** for web apps defines the pricing tier and resource level for the app. It specifies performance (CPU, memory), features (e.g., scaling, custom domains), and cost. These include:
    
   - **Free Tier (F1):** Limited resources, ideal for testing.
   - **Basic (B1, B2, B3):** Dedicated compute resources, suitable for small-scale apps.
   - **Standard (S1, S2, S3):** Auto-scaling, custom domains, and SSL support.
   - **Premium (P1v3, P2v3, P3v3):** Enhanced performance, more scaling options.
   - **Isolated (I1, I2, I3):** For high-security and isolated environments.

3. **Instance Scaling**:
   - **Vertical Scaling**: Changing the pricing tier to allocate more resources (CPU, memory).
   - **Horizontal Scaling**: Increasing or decreasing the number of instances running your app.

4. **Regional Availability**:
   - The App Service Plan can be created in specific Azure regions, affecting latency and compliance.

5. **Resource Limits**:
   - Each pricing tier has its limits on the number of instances, storage, and traffic that can be handled.

6. **Custom Domain and SSL Support**:
   - Higher tiers support custom domains and SSL certificates for secure connections.

7. **Integrated Features**:
   - Each plan includes features such as auto-scaling, backups, and diagnostics depending on the tier selected.

### Creating an Azure App Service Plan

#### Steps to Create an App Service Plan in Azure Portal

1. **Log in to Azure Portal**:
   - Navigate to [Azure Portal](https://portal.azure.com) and sign in.

2. **Create a Resource Group** (if necessary):
   - Go to **Resource Groups** > **+ Create**.
   - Fill in the details and click **Create**.

3. **Create App Service Plan**:
   - Search for **App Service Plans** in the search bar and click on it.
   - Click on **+ Create**.
   - Fill in the necessary information:
     - **Subscription**: Choose your subscription.
     - **Resource Group**: Select or create a new resource group.
     - **Name**: Give a unique name for your App Service Plan.
     - **Region**: Select the Azure region where you want to host your app.
     - **Pricing Tier**: Click on the **Pricing tier** dropdown and select the tier that meets your requirements (e.g., **Basic**, **Standard**, **Premium**).

4. **Configuration Settings**:
   - Adjust settings such as scaling options and enable auto-scaling if required based on the selected tier.

5. **Review + Create**:
   - Review your configuration and click **Create**.

---

### Managing App Service Plans

- **Scaling**:
  - You can scale up or down based on your application needs from the App Service Plan settings.
  
- **Changing Pricing Tiers**:
  - If your application grows, you can upgrade to a higher pricing tier with more resources or features.

- **Monitoring**:
  - Use Azure Monitor and Application Insights to monitor the performance and health of your applications within the App Service Plan.

### Conclusion

Azure App Service Plans are a fundamental aspect of deploying applications in Azure. They provide the necessary infrastructure, scaling options, and features to ensure that your web apps and APIs are performant, secure, and easy to manage. Understanding and selecting the right App Service Plan is critical for optimizing cost and performance based on your application’s requirements.

---

### **Scale Up and Scale Out in Azure App Service**

**Scaling** in Azure App Service refers to adjusting the resources allocated to your web app to handle varying loads. There are two primary scaling strategies: **Scale Up** and **Scale Out**.

#### **Scale Up (Vertical Scaling)**

- **Definition**: Scaling up involves increasing the resources of your existing app service plan. This typically means moving to a higher pricing tier that provides more CPU, memory, and storage.
  
- **When to Use**: 
  - When your app is resource-intensive and requires more compute power.
  - If you are reaching the limits of your current plan (e.g., high CPU or memory usage).
  
- **Example**:
  - Upgrading from a **Basic** tier to a **Standard** or **Premium** tier to gain more resources and additional features, such as enhanced performance, auto-scaling, and more.

#### **Scale Out (Horizontal Scaling)**

- **Definition**: Scaling out means adding more instances of your app service plan. This increases the number of VM instances running your application, allowing it to handle more concurrent requests.
  
- **When to Use**: 
  - When you experience high traffic and need to manage more simultaneous users.
  - If your application is stateless, allowing it to run on multiple instances without issues.
  
- **Example**:
  - Adding more instances to your **Standard** tier plan to handle increased traffic, where each instance is capable of serving requests independently.

### **Key Differences**:

| **Aspect**            | **Scale Up**                         | **Scale Out**                         |
|-----------------------|--------------------------------------|---------------------------------------|
| **Action**            | Increase resources of existing plan  | Add more instances of the app service |
| **Capacity**          | Limited by maximum tier              | Limited by subscription quota         |
| **Performance**       | Better performance for resource-heavy apps | Improved handling of high traffic     |
| **Cost**              | Higher cost per instance             | Potentially more economical for high traffic |


### **Conclusion**:

- **Scale Up** is suitable for improving the capabilities of your current application, while **Scale Out** is essential for handling high traffic by distributing the load across multiple instances.
- Choosing between the two strategies depends on the nature of your application and its resource requirements. Often, a combination of both strategies is used for optimal performance.

---

### **Deployment Slot in Azure App Service** (Not in Freetier)

A **deployment slot** in Azure App Service allows you to host different versions of your web application within the same App Service plan. Each slot represents a separate environment where you can deploy and test your application without affecting the production version. 

#### **Key Features:**
- **Isolation**: Each slot operates independently, enabling you to test new features or bug fixes without impacting the live application.
- **Configuration**: You can configure each slot with its settings (e.g., connection strings, app settings), or share configurations between slots.
- **Swap Functionality**: You can easily swap a deployment slot with your production slot, promoting the changes to the live environment while minimizing downtime.
- **Rollback**: If issues arise after a swap, you can quickly swap back to the previous version.

#### **Common Use Cases:**
- **Staging Environment**: Use a staging slot to test new features or updates before they go live.
- **A/B Testing**: Run different versions of your app in different slots to test performance or user experience.
- **Hotfixes**: Deploy urgent fixes to a separate slot and then swap it into production when ready.

#### **How It Works:**
1. **Create a Slot**: In the Azure Portal, navigate to your App Service and select **Deployment Slots**. Click on **Add Slot** and provide a name.
2. **Deploy to the Slot**: Deploy your application to the newly created slot.
3. **Test Your Application**: Validate that everything works as expected.
4. **Swap Slots**: Once validated, you can swap the slot with the production environment, promoting the new version.

Using deployment slots enhances your deployment strategy by allowing safe and efficient application updates.

---

## **Lab 1: Creating an Azure Web App with Azure App Service**

This lab guides you through creating a simple web application using Azure App Service.

#### **Prerequisites**

- An Azure account (you can sign up for a free account if you don’t have one).
- Basic knowledge of Azure Portal and web applications.

#### **Steps to Create an Azure Web App**

1. **Log in to Azure Portal**:
   - Go to [Azure Portal](https://portal.azure.com) and sign in.

2. **Create a Resource Group** (Optional):
   - Navigate to **Resource groups** in the left sidebar.
   - Click **+ Create**.
   - Enter a name for the resource group (e.g., `MyResourceGroup`) and select a region.
   - Click **Review + Create**, then **Create**.

3. **Create an App Service Plan**:
   - In the Azure Portal, search for **App Service Plans**.
   - Click **+ Create**.
   - Select your **Subscription** and **Resource Group**.
   - Enter a name for the plan (e.g., `MyAppServicePlan`).
   - Select **Pricing tier** (e.g., **F1** for Free).
   - Click **Review + Create**, then **Create**.

4. **Create a Web App**:
   - Search for **Web Apps** in the Azure Portal.
   - Click **+ Create**.
   - Select your **Subscription** and **Resource Group**.
   - Enter a name for your web app (must be unique, e.g., `myuniquewebappname`).
   - Choose your **Publish** method (Code, Static Web App or Container).
   - Select the **Runtime stack** (e.g., .NET, Node.js, Python, php).
   - Select the **Operating System** (Windows or Linux)
   - Choose the **Region** (same as your App Service Plan).
   - Under **App Service Plan**, select the plan you created earlier or create new now.
   - Click **Review + Create**, then **Create**.

5. **Deploy Your Application**:
   - After this template deployment, go to the **Web App** overview page.
   - Click on **Deployment Center** in the left menu.
   - Select your source control (e.g., GitHub, Bitbucket) for continuous deployment or choose **Local Git** for manual deployment.
   - Follow the prompts to connect to your source and configure the deployment.

6. **Access Your Web App**:
   - Once the app is deployed, click on the URL provided in the Web App overview (e.g., `https://myuniquewebappname.azurewebsites.net`).
   - Your web app should be live!

7. **Monitoring and Scaling**:
   - Navigate to **Metrics** and **Logs** under the Web App to monitor performance.
   - Go to **Scale Up** or **Scale Out** options in the left menu to adjust resources as needed.

---

### Lab 2: Deploy WordPress in Azure App Service

1. **Sign in to Azure Portal**:
   - Go to [Azure Portal](https://portal.azure.com) and log in.

2. **Navigate to App Services**:
   - In the left-hand menu, select **App Services**.
   - Click on **Create**.

3. **Select WordPress**:
   - Select **WordPress on App Service**.

4. **Configure WordPress Basics**:
   - **Subscription**: Choose your subscription.
   - **Resource Group**: Select an existing group or create a new one.
   - **Region**: Select your region (e.g., **West US**).
   - **Name**: Provide a unique name for the web app (e.g., `yourappname.azurewebsites.net`).
   - **Uncheck** Unique default hostname to make the site address shorter.

5. **Select Hosting Plan**:
   - Choose a hosting plan such as **Basic** (includes a burstable MySQL database).
   - If only free and basic plans are supported, select the **Basic** plan or upgrade the subscription for more options.

6. **WordPress Setup**:
   - **Site Language**: Select the preferred language for your WordPress site (e.g., **English (United States)**).
   - **Admin Email**: Provide an admin email for the WordPress dashboard.
   - **Admin Username**: Set your WordPress admin username.
   - **Admin Password**: Choose a secure password and confirm it.

7. **Review and Create**:
   - After entering all details, click **Review + Create**.
   - Once validated, click **Create** to deploy WordPress on Azure App Service.

8. **Access Your WordPress Site**:
   - Once deployment completes, go to **App Services** and select your WordPress app.
   - Use the provided URL to access your WordPress site and log in using the admin credentials.
   - Or just access it through your address: **yourappname.azurewebsites.net/wp-admin**
