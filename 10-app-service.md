### Reference:
- [Getting started with Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/getting-started?pivots=stack-net)
- https://www.youtube.com/watch?v=4BwyqmRTrx8

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
   - Azure App Service Plans offer different pricing tiers that dictate the capabilities and resources available for your applications. These include:
     - **Free**: Limited features, ideal for testing and development.
     - **Shared**: Similar to Free but allows apps to share resources in the same plan.
     - **Basic**: Dedicated resources, scaling, and custom domains.
     - **Standard**: Supports auto-scaling and custom domains, with increased performance.
     - **Premium**: Enhanced performance, additional features, and support for more instances.
     - **Isolated**: Fully isolated environments, best for compliance and security needs.

2. **Instance Scaling**:
   - **Vertical Scaling**: Changing the pricing tier to allocate more resources (CPU, memory).
   - **Horizontal Scaling**: Increasing or decreasing the number of instances running your app.

3. **Regional Availability**:
   - The App Service Plan can be created in specific Azure regions, affecting latency and compliance.

4. **Resource Limits**:
   - Each pricing tier has its limits on the number of instances, storage, and traffic that can be handled.

5. **Custom Domain and SSL Support**:
   - Higher tiers support custom domains and SSL certificates for secure connections.

6. **Integrated Features**:
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

## **Lab: Creating an Azure Web App with Azure App Service**

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
   - Choose your **Publish** method (Code or Docker container).
   - Select the **Runtime stack** (e.g., .NET, Node.js, Python).
   - Choose the **Region** (same as your App Service Plan).
   - Under **App Service Plan**, select the plan you created earlier.
   - Click **Review + Create**, then **Create**.

5. **Deploy Your Application**:
   - After deployment, go to the **Web App** overview page.
   - Click on **Deployment Center** in the left menu.
   - Select your source control (e.g., GitHub, Bitbucket) for continuous deployment or choose **Local Git** for manual deployment.
   - Follow the prompts to connect to your source and configure the deployment.

6. **Access Your Web App**:
   - Once the app is deployed, click on the URL provided in the Web App overview (e.g., `https://myuniquewebappname.azurewebsites.net`).
   - Your web app should be live!

7. **Monitoring and Scaling**:
   - Navigate to **Metrics** and **Logs** under the Web App to monitor performance.
   - Go to **Scale Up** or **Scale Out** options in the left menu to adjust resources as needed.

### **Conclusion**

Azure App Service is a powerful platform for building and hosting web applications with features that streamline development, enhance scalability, and ensure security. The lab provided hands-on experience in creating and deploying a web app, showcasing the simplicity and efficiency of the Azure App Service environment.
