# 📝 Hub-and-Spoke Topology in Azure

---

## 🔹 1. What is Hub-and-Spoke Topology?

* A **Hub-and-Spoke topology** is a network architecture pattern in Azure where:

  * A **central hub Virtual Network (VNet)** acts as the core point of connectivity.
  * Multiple **spoke VNets** connect to the hub through **VNet peering**.
* It’s widely used for **enterprise-scale networks** to centralize shared services and maintain isolation of workloads.

👉 Think of the hub as the **“airport terminal”** and the spokes as **“flights”** – every flight (spoke) connects via the terminal (hub).

---

## 🔹 2. Components

1. **Hub VNet**

   * A regular Azure VNet, but designed as the **centralized point of connectivity**.
   * Hosts shared services:

     * **VPN Gateway / ExpressRoute Gateway** (for on-premises/hybrid connectivity).
     * **Azure Firewall / NVA (Network Virtual Appliance)** (for security and routing).
     * **Azure Bastion** (for secure VM management).
     * **DNS / Active Directory** (for centralized name resolution and identity services).

2. **Spoke VNets**

   * VNets that contain **application workloads** (VMs, App Services, databases).
   * Peer with the **hub VNet**.
   * Typically isolated from each other (unless connected via the hub).

3. **VNet Peering**

   * Low-latency, high-bandwidth connection between VNets.
   * Allows traffic forwarding via the hub.
   * Supports **transitive routing** through the hub (with proper configuration).

---

## 🔹 3. Key Characteristics

* **Centralized connectivity**: All on-premises and internet traffic flows through the hub.
* **Workload isolation**: Spoke VNets don’t directly talk to each other unless you explicitly allow it via the hub.
* **Shared services model**: Hub VNet provides common services (DNS, firewall, etc.) to all spokes.
* **Scalable**: You can add more spokes without redesigning the network.
* **Secure**: Centralized security policies are enforced at the hub.

---

## 🔹 4. Benefits

1. **Isolation of Workloads**

   * Different teams/apps have their own spoke VNet.
   * Prevents unintended access between applications.

2. **Centralized Security**

   * All traffic can be routed through **Azure Firewall / NVA** in the hub.
   * Easier to enforce compliance and governance.

3. **Cost Optimization**

   * Instead of deploying a VPN Gateway or Firewall in each spoke, you **share them from the hub**.
   * Example: One **Azure Firewall** in the hub can filter traffic for 10+ spokes.

4. **Simplified Management**

   * Single point of connectivity to on-premises.
   * Centralized DNS resolution and Bastion.

---

## 🔹 5. Challenges

1. **Hub as a bottleneck**

   * If traffic from all spokes flows through the hub, it can become a performance bottleneck.
   * You need to size the hub VNet resources (Gateway, Firewall) properly.

2. **Complex routing**

   * Requires **User Defined Routes (UDR)** to enforce traffic through the hub firewall.
   * Misconfigurations can cause traffic to bypass inspection.

3. **Cost of shared services**

   * Hub services (Firewall, VPN Gateway, Bastion) are not free – costs may add up.

4. **No direct transitive peering**

   * Spoke-to-spoke communication must go through the hub.
   * Azure VNet peering does not natively support transitive routing; you must configure **hub routing**.

---

## 🔹 6. Example Use Case

### Scenario: Enterprise with multiple applications

* **Hub VNet**:

  * Contains Azure Firewall, ExpressRoute Gateway, Bastion, and Private DNS.
* **Spoke VNets**:

  * **Spoke 1 (Finance App)**: SQL databases + app servers.
  * **Spoke 2 (HR App)**: HR portal servers.
  * **Spoke 3 (E-commerce App)**: Frontend + backend services.

Traffic flow:

* Finance → HR? Goes via **Hub Firewall**.
* Finance → On-prem? Goes via **Hub VPN Gateway**.
* HR → Internet? Routed via **Hub Firewall**.

This ensures **isolation + centralized control**.

---

## 🔹 7. Architecture Diagram (Textual)

```
             On-Premises
                  |
          +----------------+
          | VPN/ER Gateway |
          +----------------+
                  |
              (Hub VNet)
          +----------------+
          | Firewall, DNS  |
          | Bastion, AD    |
          +----------------+
         /       |        \
 (Spoke 1)   (Spoke 2)   (Spoke 3)
 Finance App   HR App   E-commerce App
```

---

## 🔹 8. When to Use

✅ Use Hub-and-Spoke when:

* You have multiple apps or workloads that must be **isolated**.
* You need **centralized connectivity to on-premises**.
* You want to **share costly services** (Firewall, VPN Gateway).
* You require **enterprise-scale governance**.

❌ Not ideal if:

* You only have **one or two small workloads**.
* Simplicity is more important than centralized control.

---

✅ **Summary:**
The **Hub-and-Spoke topology** in Azure is a **best-practice network design** for enterprises. It uses a **Hub VNet** to centralize security, connectivity, and shared services, while **Spoke VNets** isolate workloads. It provides **scalability, governance, and cost savings**, but requires careful routing and cost planning.

---

# 🛠 Example: Deploy Hub-and-Spoke Topology in Azure with PowerShell

---

## 🔹 1. Prerequisites

* Install and import the **Az PowerShell module**:

```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
Import-Module Az
```

* Login to Azure:

```powershell
Connect-AzAccount
```

* Select subscription (if needed):

```powershell
Set-AzContext -Subscription "Your-Subscription-ID"
```

---

## 🔹 2. Define Variables

```powershell
# General
$location = "EastUS"
$rgName   = "RG-HubSpokeDemo"

# VNets
$hubVnetName    = "Hub-VNet"
$spoke1VnetName = "Spoke1-VNet"
$spoke2VnetName = "Spoke2-VNet"

# Address Spaces
$hubAddressSpace    = "10.0.0.0/16"
$spoke1AddressSpace = "10.1.0.0/16"
$spoke2AddressSpace = "10.2.0.0/16"

# Subnets
$hubSubnetName   = "Hub-Subnet"
$spoke1SubnetName = "Spoke1-Subnet"
$spoke2SubnetName = "Spoke2-Subnet"
```

---

## 🔹 3. Create Resource Group

```powershell
New-AzResourceGroup -Name $rgName -Location $location
```

---

## 🔹 4. Create Hub and Spoke VNets

```powershell
# Hub VNet
$hubSubnet = New-AzVirtualNetworkSubnetConfig -Name $hubSubnetName -AddressPrefix "10.0.0.0/24"
$hubVnet = New-AzVirtualNetwork -Name $hubVnetName -ResourceGroupName $rgName -Location $location `
  -AddressPrefix $hubAddressSpace -Subnet $hubSubnet

# Spoke1 VNet
$spoke1Subnet = New-AzVirtualNetworkSubnetConfig -Name $spoke1SubnetName -AddressPrefix "10.1.0.0/24"
$spoke1Vnet = New-AzVirtualNetwork -Name $spoke1VnetName -ResourceGroupName $rgName -Location $location `
  -AddressPrefix $spoke1AddressSpace -Subnet $spoke1Subnet

# Spoke2 VNet
$spoke2Subnet = New-AzVirtualNetworkSubnetConfig -Name $spoke2SubnetName -AddressPrefix "10.2.0.0/24"
$spoke2Vnet = New-AzVirtualNetwork -Name $spoke2VnetName -ResourceGroupName $rgName -Location $location `
  -AddressPrefix $spoke2AddressSpace -Subnet $spoke2Subnet
```

---

## 🔹 5. Create VNet Peerings (Hub ↔ Spokes)

```powershell
# Hub <-> Spoke1
Add-AzVirtualNetworkPeering -Name "Hub-to-Spoke1" -VirtualNetwork $hubVnet -RemoteVirtualNetworkId $spoke1Vnet.Id -AllowForwardedTraffic -AllowGatewayTransit
Add-AzVirtualNetworkPeering -Name "Spoke1-to-Hub" -VirtualNetwork $spoke1Vnet -RemoteVirtualNetworkId $hubVnet.Id -AllowForwardedTraffic -UseRemoteGateways

# Hub <-> Spoke2
Add-AzVirtualNetworkPeering -Name "Hub-to-Spoke2" -VirtualNetwork $hubVnet -RemoteVirtualNetworkId $spoke2Vnet.Id -AllowForwardedTraffic -AllowGatewayTransit
Add-AzVirtualNetworkPeering -Name "Spoke2-to-Hub" -VirtualNetwork $spoke2Vnet -RemoteVirtualNetworkId $hubVnet.Id -AllowForwardedTraffic -UseRemoteGateways
```

---

## 🔹 6. (Optional) Add Shared Services in Hub

For example, deploy an **Azure Firewall** or **VPN Gateway** in the Hub:

```powershell
# Example: Public IP for Firewall
$firewallPip = New-AzPublicIpAddress -Name "HubFirewall-PIP" -ResourceGroupName $rgName -Location $location `
  -AllocationMethod Static -Sku Standard

# Example: Azure Firewall (in Hub subnet, you’d normally create a dedicated firewall subnet)
New-AzFirewall -Name "HubFirewall" -ResourceGroupName $rgName -Location $location -VirtualNetwork $hubVnet -PublicIpAddress $firewallPip
```

---

## 🔹 7. Verify Setup

* List peerings:

```powershell
Get-AzVirtualNetworkPeering -VirtualNetworkName $hubVnetName -ResourceGroupName $rgName
```

* Deploy VMs in spoke subnets and try:

  * Ping between **Spoke1 → Spoke2** (should go via hub if routing is configured).
  * Ping **Spoke → Hub** (should work directly).

---

## 🔹 8. Traffic Routing

* By default, hub-spoke peering allows traffic, but **to force traffic through a firewall in the hub**, you must use:

  * **User Defined Routes (UDRs)** in spoke subnets.
  * Example: Route `0.0.0.0/0` → next hop = Firewall private IP.

---

✅ **Result:** You now have a working **Hub-and-Spoke topology** with:

* 1 Hub VNet (shared services, firewall/gateway).
* 2 Spoke VNets (isolated workloads).
* VNet peering established for controlled traffic.

---

# 🛠 Example: Hub-and-Spoke Topology in Azure with Bicep

---

## 🔹 1. Overview

This Bicep template will:

* Create:

  * 1 **Hub VNet** with a subnet.
  * 2 **Spoke VNets** with subnets.
  * **Peering connections** between Hub ↔ Spoke1 and Hub ↔ Spoke2.
* You can extend it later with **Firewall**, **VPN Gateway**, or **Azure Bastion** in the hub.

---

## 🔹 2. Bicep Template

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Hub VNet name')
param hubVnetName string = 'Hub-VNet'

@description('Spoke1 VNet name')
param spoke1VnetName string = 'Spoke1-VNet'

@description('Spoke2 VNet name')
param spoke2VnetName string = 'Spoke2-VNet'

@description('Hub VNet address space')
param hubAddressSpace string = '10.0.0.0/16'

@description('Spoke1 VNet address space')
param spoke1AddressSpace string = '10.1.0.0/16'

@description('Spoke2 VNet address space')
param spoke2AddressSpace string = '10.2.0.0/16'

@description('Hub subnet address range')
param hubSubnetPrefix string = '10.0.0.0/24'

@description('Spoke1 subnet address range')
param spoke1SubnetPrefix string = '10.1.0.0/24'

@description('Spoke2 subnet address range')
param spoke2SubnetPrefix string = '10.2.0.0/24'

/* ---------------------------
   Create Hub VNet
---------------------------- */
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubAddressSpace
      ]
    }
    subnets: [
      {
        name: 'Hub-Subnet'
        properties: {
          addressPrefix: hubSubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Create Spoke1 VNet
---------------------------- */
resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke1VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spoke1AddressSpace
      ]
    }
    subnets: [
      {
        name: 'Spoke1-Subnet'
        properties: {
          addressPrefix: spoke1SubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Create Spoke2 VNet
---------------------------- */
resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke2VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spoke2AddressSpace
      ]
    }
    subnets: [
      {
        name: 'Spoke2-Subnet'
        properties: {
          addressPrefix: spoke2SubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   VNet Peerings
---------------------------- */

resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke1'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spoke1Vnet.id
    }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke1-to-Hub'
  parent: spoke1Vnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke2'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spoke2Vnet.id
    }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke2-to-Hub'
  parent: spoke2Vnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}
```

---

## 🔹 3. Deploy the Bicep Template

```powershell
# Variables
$rgName = "RG-HubSpokeDemo"
$location = "EastUS"

# Create resource group
New-AzResourceGroup -Name $rgName -Location $location

# Deploy Bicep
New-AzResourceGroupDeployment `
  -ResourceGroupName $rgName `
  -TemplateFile ./hub-spoke.bicep `
  -location $location
```

---

## 🔹 4. Next Steps

* Deploy **Azure Firewall** or **VPN Gateway** into the Hub VNet (`AzureFirewallSubnet` or `GatewaySubnet`).
* Add **User Defined Routes (UDRs)** in spoke subnets to **force traffic via Hub firewall**.
* Deploy **VMs in spokes** for testing.

---

✅ **Summary:**
This Bicep template gives you a **Hub-and-Spoke topology with 1 Hub + 2 Spokes + VNet peering**. It’s production-ready for extending with **firewalls, gateways, or Bastion** in the hub.

---

⚡️ Let’s level it up! We’ll extend the **Hub-and-Spoke Bicep** to include an **Azure Firewall in the Hub** and configure **User Defined Routes (UDRs)** so that all spoke traffic is forced through the firewall.

---

# 🛠 Hub-and-Spoke Topology with Azure Firewall (Bicep)

---

## 🔹 What this template does

1. Creates:

   * **Hub VNet** (with `Hub-Subnet` + `AzureFirewallSubnet`).
   * **2 Spoke VNets** (with subnets).
   * **Azure Firewall** in the Hub with a Public IP.
   * **Route tables** for each spoke, routing all outbound traffic (`0.0.0.0/0`) through the firewall private IP.
   * **VNet peerings** between Hub ↔ Spokes.

2. Result:

   * Any spoke → internet traffic flows through the **Hub Firewall**.
   * You can add Firewall rules later for filtering.

---

## 🔹 Extended Bicep Template

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Hub VNet name')
param hubVnetName string = 'Hub-VNet'

@description('Spoke1 VNet name')
param spoke1VnetName string = 'Spoke1-VNet'

@description('Spoke2 VNet name')
param spoke2VnetName string = 'Spoke2-VNet'

@description('Hub VNet address space')
param hubAddressSpace string = '10.0.0.0/16'

@description('Spoke1 VNet address space')
param spoke1AddressSpace string = '10.1.0.0/16'

@description('Spoke2 VNet address space')
param spoke2AddressSpace string = '10.2.0.0/16'

@description('Subnet ranges')
param hubSubnetPrefix string = '10.0.0.0/24'
param firewallSubnetPrefix string = '10.0.1.0/24'
param spoke1SubnetPrefix string = '10.1.0.0/24'
param spoke2SubnetPrefix string = '10.2.0.0/24'

/* ---------------------------
   Hub VNet
---------------------------- */
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubAddressSpace
      ]
    }
    subnets: [
      {
        name: 'Hub-Subnet'
        properties: {
          addressPrefix: hubSubnetPrefix
        }
      }
      {
        name: 'AzureFirewallSubnet' // Required subnet name for firewall
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Spoke VNets
---------------------------- */
resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke1VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spoke1AddressSpace
      ]
    }
    subnets: [
      {
        name: 'Spoke1-Subnet'
        properties: {
          addressPrefix: spoke1SubnetPrefix
        }
      }
    ]
  }
}

resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke2VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spoke2AddressSpace
      ]
    }
    subnets: [
      {
        name: 'Spoke2-Subnet'
        properties: {
          addressPrefix: spoke2SubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Azure Firewall (in Hub)
---------------------------- */
resource firewallPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'HubFirewall-PIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource hubFirewall 'Microsoft.Network/azureFirewalls@2023-05-01' = {
  name: 'Hub-Firewall'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    ipConfigurations: [
      {
        name: 'FW-config'
        properties: {
          subnet: {
            id: '${hubVnet.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
  }
  dependsOn: [
    hubVnet
    firewallPip
  ]
}

/* ---------------------------
   Route Tables for Spokes
---------------------------- */
resource spoke1RouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke1-RT'
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [
    hubFirewall
  ]
}

resource spoke2RouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke2-RT'
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [
    hubFirewall
  ]
}

/* Associate route tables with spoke subnets */
resource spoke1SubnetRTAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke1Vnet.name}/Spoke1-Subnet'
  properties: {
    addressPrefix: spoke1SubnetPrefix
    routeTable: {
      id: spoke1RouteTable.id
    }
  }
  dependsOn: [
    spoke1Vnet
    spoke1RouteTable
  ]
}

resource spoke2SubnetRTAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke2Vnet.name}/Spoke2-Subnet'
  properties: {
    addressPrefix: spoke2SubnetPrefix
    routeTable: {
      id: spoke2RouteTable.id
    }
  }
  dependsOn: [
    spoke2Vnet
    spoke2RouteTable
  ]
}

/* ---------------------------
   VNet Peerings
---------------------------- */
resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke1'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spoke1Vnet.id
    }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke1-to-Hub'
  parent: spoke1Vnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke2'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spoke2Vnet.id
    }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke2-to-Hub'
  parent: spoke2Vnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}
```

---

## 🔹 3. Deploy Template

```powershell
# Variables
$rgName = "RG-HubSpokeFirewallDemo"
$location = "EastUS"

# Create resource group
New-AzResourceGroup -Name $rgName -Location $location

# Deploy Bicep
New-AzResourceGroupDeployment `
  -ResourceGroupName $rgName `
  -TemplateFile ./hub-spoke-firewall.bicep `
  -location $location
```

---

## 🔹 4. Validation

* Deploy **test VMs** in Spoke1 and Spoke2.
* Try to reach the internet → traffic will flow through the firewall.
* Add firewall rules to allow/block outbound traffic.

---

✅ **Result:**
You now have a **Hub-and-Spoke with centralized Azure Firewall**. All outbound traffic from spokes is forced through the firewall (thanks to UDRs). This is a production-ready **secure network design**.

---

🚀 Now we’ll take the **final boss step**: extend the **Hub-and-Spoke with Firewall** design to include a **VPN Gateway / ExpressRoute Gateway in the Hub** so spokes can also securely connect to **on-premises networks**.

---

# 🛠 Hub-and-Spoke Topology with Azure Firewall + VPN/ExpressRoute Gateway (Bicep)

---

## 🔹 1. Architecture Overview

* **Hub VNet**

  * Subnets: `Hub-Subnet`, `AzureFirewallSubnet`, `GatewaySubnet`
  * Services:

    * **Azure Firewall** (centralized outbound filtering)
    * **VPN Gateway** (or ExpressRoute Gateway) for on-premises connectivity
* **Spokes**

  * VNets with workloads
  * Subnets with UDRs forcing traffic through the Hub Firewall
* **Traffic Flow**

  * Spokes ↔ Hub Firewall ↔ On-Prem via VPN/ER Gateway

---

## 🔹 2. Extended Bicep Template

Here’s the **core parts** of the Bicep file (building on the last version).

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Hub VNet name')
param hubVnetName string = 'Hub-VNet'

@description('Spoke1 VNet name')
param spoke1VnetName string = 'Spoke1-VNet'

@description('Spoke2 VNet name')
param spoke2VnetName string = 'Spoke2-VNet'

@description('Address Spaces')
param hubAddressSpace string = '10.0.0.0/16'
param spoke1AddressSpace string = '10.1.0.0/16'
param spoke2AddressSpace string = '10.2.0.0/16'

@description('Subnet ranges')
param hubSubnetPrefix string = '10.0.0.0/24'
param firewallSubnetPrefix string = '10.0.1.0/24'
param gatewaySubnetPrefix string = '10.0.2.0/24'
param spoke1SubnetPrefix string = '10.1.0.0/24'
param spoke2SubnetPrefix string = '10.2.0.0/24'

/* ---------------------------
   Hub VNet with Firewall + Gateway subnets
---------------------------- */
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubAddressSpace
      ]
    }
    subnets: [
      {
        name: 'Hub-Subnet'
        properties: {
          addressPrefix: hubSubnetPrefix
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
      {
        name: 'GatewaySubnet' // required name for VPN/ER gateways
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Spoke VNets
---------------------------- */
resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke1VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ spoke1AddressSpace ]
    }
    subnets: [
      {
        name: 'Spoke1-Subnet'
        properties: {
          addressPrefix: spoke1SubnetPrefix
        }
      }
    ]
  }
}

resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke2VnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ spoke2AddressSpace ]
    }
    subnets: [
      {
        name: 'Spoke2-Subnet'
        properties: {
          addressPrefix: spoke2SubnetPrefix
        }
      }
    ]
  }
}

/* ---------------------------
   Azure Firewall (same as before)
---------------------------- */
resource firewallPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'HubFirewall-PIP'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource hubFirewall 'Microsoft.Network/azureFirewalls@2023-05-01' = {
  name: 'Hub-Firewall'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    ipConfigurations: [
      {
        name: 'FW-config'
        properties: {
          subnet: {
            id: '${hubVnet.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
  }
  dependsOn: [ hubVnet, firewallPip ]
}

/* ---------------------------
   VPN Gateway in Hub
---------------------------- */
resource gatewayPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'HubGateway-PIP'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Dynamic' }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
  name: 'Hub-VPN-Gateway'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'gwconfig'
        properties: {
          subnet: {
            id: '${hubVnet.id}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: gatewayPip.id
          }
        }
      }
    ]
    gatewayType: 'Vpn' // change to 'ExpressRoute' if using ER
    vpnType: 'RouteBased'
    enableBgp: false
    sku: {
      name: 'VpnGw1' // change size as needed
      tier: 'VpnGw1'
    }
  }
  dependsOn: [ hubVnet, gatewayPip ]
}

/* ---------------------------
   Route tables for spokes (force traffic via Firewall)
---------------------------- */
resource spoke1RT 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke1-RT'
  location: location
  properties: {
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [ hubFirewall ]
}

resource spoke2RT 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke2-RT'
  location: location
  properties: {
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [ hubFirewall ]
}

/* Associate RTs to Spoke subnets */
resource spoke1SubnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke1Vnet.name}/Spoke1-Subnet'
  properties: {
    addressPrefix: spoke1SubnetPrefix
    routeTable: { id: spoke1RT.id }
  }
  dependsOn: [ spoke1Vnet, spoke1RT ]
}

resource spoke2SubnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke2Vnet.name}/Spoke2-Subnet'
  properties: {
    addressPrefix: spoke2SubnetPrefix
    routeTable: { id: spoke2RT.id }
  }
  dependsOn: [ spoke2Vnet, spoke2RT ]
}

/* ---------------------------
   VNet Peerings (Hub <-> Spokes)
---------------------------- */
resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke1'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: { id: spoke1Vnet.id }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke1-to-Hub'
  parent: spoke1Vnet
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke2'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: { id: spoke2Vnet.id }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}

resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke2-to-Hub'
  parent: spoke2Vnet
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}
```

---

## 🔹 3. Deployment

```powershell
$rgName = "RG-HubSpoke-FW-VPN"
$location = "EastUS"

New-AzResourceGroup -Name $rgName -Location $location

New-AzResourceGroupDeployment `
  -ResourceGroupName $rgName `
  -TemplateFile ./hub-spoke-fw-vpn.bicep `
  -location $location
```

---

## 🔹 4. Next Steps

1. **Connect VPN Gateway to On-Premises**

   * Create a `LocalNetworkGateway` (represents on-premises VPN device + IP ranges).
   * Create a `Connection` between Hub VPN Gateway and LocalNetworkGateway.
   * (This can be added into the Bicep too.)

2. **Firewall Rules**

   * Add NAT/Network/Application rules to Azure Firewall for internet + on-prem routing.

3. **Validation**

   * Deploy test VMs in Spokes.
   * Ping on-prem workloads (via VPN).
   * Test internet traffic → must go through Firewall.

---

✅ **Result:**
This extended Bicep creates a **fully enterprise-ready Hub-and-Spoke network** with:

* **Centralized Azure Firewall** (all outbound filtered).
* **VPN Gateway** (or ExpressRoute Gateway) for hybrid connectivity.
* **Forced tunneling from spokes through firewall**.
* **Gateway transit** so spokes use Hub gateway for on-prem connectivity.

---

# Complete, **end-to-end Bicep** that builds:

* Hub + 2 Spokes
* Azure Firewall in the Hub (with UDRs on spokes to force egress via FW)
* **VPN Gateway in the Hub**
* **Local Network Gateway (your on-prem)**
* **IPsec Connection** (site-to-site)

I’ve also included a sample **parameters file** and **PowerShell** deployment commands.

---

# Hub-and-Spoke + Firewall + Site-to-Site VPN (Bicep)

> ✅ Assumes **route-based** VPN, no BGP. You can enable BGP later if you need it.

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

// ===== Naming =====
@description('Hub VNet name')
param hubVnetName string = 'Hub-VNet'
@description('Spoke1 VNet name')
param spoke1VnetName string = 'Spoke1-VNet'
@description('Spoke2 VNet name')
param spoke2VnetName string = 'Spoke2-VNet'

// ===== Address Spaces =====
@description('Hub VNet address space')
param hubAddressSpace string = '10.0.0.0/16'
@description('Spoke1 VNet address space')
param spoke1AddressSpace string = '10.1.0.0/16'
@description('Spoke2 VNet address space')
param spoke2AddressSpace string = '10.2.0.0/16'

// ===== Subnets =====
@description('Hub-Subnet prefix')
param hubSubnetPrefix string = '10.0.0.0/24'
@description('AzureFirewallSubnet prefix (required name)')
param firewallSubnetPrefix string = '10.0.1.0/24'
@description('GatewaySubnet prefix (required name)')
param gatewaySubnetPrefix string = '10.0.2.0/24'
@description('Spoke1-Subnet prefix')
param spoke1SubnetPrefix string = '10.1.0.0/24'
@description('Spoke2-Subnet prefix')
param spoke2SubnetPrefix string = '10.2.0.0/24'

// ===== On-Prem (Local Network) =====
@description('Public IP of your on-prem VPN device')
param onPremPublicIp string
@description('On-prem address prefixes (LAN subnets) reachable over VPN')
param onPremAddressPrefixes array = [
  '192.168.0.0/24'
]
@description('IPsec shared key (PSK) for S2S connection)')
@secure()
param vpnSharedKey string

// ===== Hub VNet =====
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ hubAddressSpace ] }
    subnets: [
      { // workload/admin subnet (optional)
        name: 'Hub-Subnet'
        properties: { addressPrefix: hubSubnetPrefix }
      }
      { // mandatory name
        name: 'AzureFirewallSubnet'
        properties: { addressPrefix: firewallSubnetPrefix }
      }
      { // mandatory name
        name: 'GatewaySubnet'
        properties: { addressPrefix: gatewaySubnetPrefix }
      }
    ]
  }
}

// ===== Spoke VNets =====
resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke1VnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ spoke1AddressSpace ] }
    subnets: [
      {
        name: 'Spoke1-Subnet'
        properties: { addressPrefix: spoke1SubnetPrefix }
      }
    ]
  }
}

resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: spoke2VnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ spoke2AddressSpace ] }
    subnets: [
      {
        name: 'Spoke2-Subnet'
        properties: { addressPrefix: spoke2SubnetPrefix }
      }
    ]
  }
}

// ===== Azure Firewall in Hub =====
resource firewallPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'HubFirewall-PIP'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource hubFirewall 'Microsoft.Network/azureFirewalls@2023-05-01' = {
  name: 'Hub-Firewall'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard' // change to Premium if you need TLS inspection/IDPS
    }
    ipConfigurations: [
      {
        name: 'FW-config'
        properties: {
          subnet: {
            id: '${hubVnet.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
  }
  dependsOn: [ hubVnet, firewallPip ]
}

// ===== Route Tables for Spokes (force egress via FW) =====
resource spoke1RT 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke1-RT'
  location: location
  properties: {
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [ hubFirewall ]
}

resource spoke2RT 'Microsoft.Network/routeTables@2023-05-01' = {
  name: 'Spoke2-RT'
  location: location
  properties: {
    routes: [
      {
        name: 'DefaultToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
  dependsOn: [ hubFirewall ]
}

// Associate RTs with spoke subnets
resource spoke1SubnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke1Vnet.name}/Spoke1-Subnet'
  properties: {
    addressPrefix: spoke1SubnetPrefix
    routeTable: { id: spoke1RT.id }
  }
  dependsOn: [ spoke1Vnet, spoke1RT ]
}

resource spoke2SubnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${spoke2Vnet.name}/Spoke2-Subnet'
  properties: {
    addressPrefix: spoke2SubnetPrefix
    routeTable: { id: spoke2RT.id }
  }
  dependsOn: [ spoke2Vnet, spoke2RT ]
}

// ===== Hub <-> Spoke Peerings (with GW transit) =====
resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke1'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: { id: spoke1Vnet.id }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}
resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke1-to-Hub'
  parent: spoke1Vnet
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Hub-to-Spoke2'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: { id: spoke2Vnet.id }
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}
resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: 'Spoke2-to-Hub'
  parent: spoke2Vnet
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}

// ===== VPN Gateway in Hub =====
resource gatewayPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'HubGateway-PIP'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Dynamic' }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
  name: 'Hub-VPN-Gateway'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'gwconfig'
        properties: {
          subnet: { id: '${hubVnet.id}/subnets/GatewaySubnet' }
          publicIPAddress: { id: gatewayPip.id }
        }
      }
    ]
    gatewayType: 'Vpn'          // change to 'ExpressRoute' for ER
    vpnType: 'RouteBased'
    enableBgp: false            // set true if using BGP
    sku: {
      name: 'VpnGw1'            // size as needed (VpnGw2/3…)
      tier: 'VpnGw1'
    }
  }
  dependsOn: [ hubVnet, gatewayPip ]
}

// ===== Local Network Gateway (represents on-prem) =====
resource localGw 'Microsoft.Network/localNetworkGateways@2023-05-01' = {
  name: 'OnPrem-LNG'
  location: location
  properties: {
    gatewayIpAddress: onPremPublicIp
    localNetworkAddressSpace: {
      addressPrefixes: onPremAddressPrefixes
    }
  }
}

// ===== S2S Connection (Hub VPN GW <-> On-Prem LNG) =====
resource s2sConn 'Microsoft.Network/connections@2023-05-01' = {
  name: 'HubVPN-to-OnPrem'
  location: location
  properties: {
    connectionType: 'IPsec'
    virtualNetworkGateway1: {
      id: vpnGateway.id
    }
    localNetworkGateway2: {
      id: localGw.id
    }
    sharedKey: vpnSharedKey
    usePolicyBasedTrafficSelectors: false
    // Optionally pin IPSec policy (must match on-prem)
    // ipsecPolicies: [
    //   {
    //     saLifeTimeSeconds: 3600
    //     saDataSizeKilobytes: 102400000
    //     ipsecEncryption: 'AES256'
    //     ipsecIntegrity: 'SHA256'
    //     ikeEncryption: 'AES256'
    //     ikeIntegrity: 'SHA256'
    //     dhGroup: 'DHGroup14'
    //     pfsGroup: 'PFS14'
    //   }
    // ]
  }
  dependsOn: [ vpnGateway, localGw ]
}

// ===== Outputs =====
output firewallPrivateIp string = hubFirewall.properties.ipConfigurations[0].properties.privateIPAddress
output vpnGatewayPublicIp string = gatewayPip.properties.ipAddress
```

---

## Example `parameters.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": { "value": "EastUS" },
    "hubVnetName": { "value": "Hub-VNet" },
    "spoke1VnetName": { "value": "Spoke1-VNet" },
    "spoke2VnetName": { "value": "Spoke2-VNet" },
    "hubAddressSpace": { "value": "10.0.0.0/16" },
    "spoke1AddressSpace": { "value": "10.1.0.0/16" },
    "spoke2AddressSpace": { "value": "10.2.0.0/16" },
    "hubSubnetPrefix": { "value": "10.0.0.0/24" },
    "firewallSubnetPrefix": { "value": "10.0.1.0/24" },
    "gatewaySubnetPrefix": { "value": "10.0.2.0/24" },
    "spoke1SubnetPrefix": { "value": "10.1.0.0/24" },
    "spoke2SubnetPrefix": { "value": "10.2.0.0/24" },
    "onPremPublicIp": { "value": "203.0.113.10" },
    "onPremAddressPrefixes": { "value": ["192.168.0.0/24", "172.16.10.0/24"] },
    "vpnSharedKey": { "value": "ChangeMe_SuperSecret123!" }
  }
}
```

---

## PowerShell Deployment (you prefer PS over az cli)

```powershell
# Prereqs
Import-Module Az.Accounts, Az.Resources -ErrorAction Stop
Connect-AzAccount

# Variables
$rgName   = "RG-HubSpoke-FW-VPN"
$location = "EastUS"

# Create RG
New-AzResourceGroup -Name $rgName -Location $location

# Deploy
New-AzResourceGroupDeployment `
  -ResourceGroupName $rgName `
  -TemplateFile ./hub-spoke-fw-vpn-complete.bicep `
  -TemplateParameterFile ./parameters.json `
  -Verbose
```

---

## How to test (quick checklist)

1. **Check outputs**: note `vpnGatewayPublicIp` and share with your on-prem peer.
2. **Configure on-prem device**:

   * Tunnel to `vpnGatewayPublicIp`
   * PSK = `vpnSharedKey`
   * Local subnets = your on-prem LANs
   * Remote subnets = Azure spokes/hub spaces (10.0.0.0/16, 10.1.0.0/16, 10.2.0.0/16)
   * Route-based, IKEv2.
3. **Spoke egress**: from Spoke1/Spoke2 VM, browse/ping out — traffic should egress via **Azure Firewall**.
4. **Hybrid reachability**: from spoke VM, ping an on-prem host (e.g., 192.168.0.10).
5. **Firewall rules**: add Azure Firewall Network/Application rules to allow desired outbound/hybrid flows.

---

## Notes & gotchas (from the trenches)

* **Subnet names matter**: `AzureFirewallSubnet` and `GatewaySubnet` must be exactly these names.
* **Sizing**: start with `VpnGw1`; bump to `VpnGw2/3` for throughput/SLA.
* **GW transit**: already enabled — spokes use the hub gateway (`useRemoteGateways: true`).
* **Forced tunneling**: we’re forcing **internet egress** through Azure Firewall using UDRs. If you also want **on-prem egress** via your datacenter, add a `0.0.0.0/0` UDR to the **GatewaySubnet** side and adjust routes/firewall accordingly (common in ER designs).
* **BGP**: if your on-prem uses BGP, set `enableBgp: true` on `vpnGateway` and configure ASN/peers + propagate routes instead of static LNG prefixes.
* **IPsec policy**: uncomment `ipsecPolicies` if you must match strict on-prem crypto settings.
* **Firewall DNAT**: to publish workloads from spokes to internet, add Firewall **DNAT** rules to the FW public IP.

---

