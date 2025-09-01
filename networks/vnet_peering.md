# 📝 **Azure VNet Peering**

## 1. What is VNet Peering?

* **Azure VNet Peering** connects two Azure **Virtual Networks (VNets)** so they can communicate with each other as if they were on the same network.
* Provides **low-latency, high-bandwidth connectivity** between VNets.
* Traffic between peered VNets stays **on the Microsoft backbone network** (never goes over the public internet).

📌 Think of it as creating a private bridge between two VNets.

---

## 2. Types of VNet Peering

1. **Intra-region VNet Peering**

   * Peers VNets **within the same Azure region**.
   * Example: Peering `VNet1` and `VNet2` in `East US`.
   * Traffic between them remains inside that Azure region’s backbone.

2. **Global VNet Peering**

   * Peers VNets across **different Azure regions**.
   * Example: Peering `VNet1` in `East US` with `VNet2` in `West Europe`.
   * Traffic flows over the Microsoft backbone, **not the internet**.

---

## 3. Key Features

* **Private communication**: Resources (VMs, databases, etc.) in different VNets can talk privately via private IPs.
* **Low latency**: Traffic uses Azure’s internal backbone network.
* **High bandwidth**: Same throughput as if they were in the same VNet.
* **No downtime**: Peering is seamless.
* **Non-transitive**: If `VNetA` is peered with `VNetB` and `VNetB` is peered with `VNetC`, **A cannot talk to C** unless explicitly peered.

---

## 4. Requirements

* **Non-overlapping address spaces**

  * Peered VNets must have unique IP ranges (e.g., `10.0.0.0/16` and `10.1.0.0/16`).
  * Overlapping subnets are not allowed.
* **Permissions**

  * You need `Network Contributor` or equivalent role on both VNets.

---

## 5. Pricing

* Peering itself is **free**.
* **Data transfer** between peered VNets incurs charges:

  * **Intra-region**: Cheaper.
  * **Global peering**: More expensive because it crosses regions.

---

## 6. Common Use Cases

1. **Hub-and-Spoke Topology**

   * Hub VNet contains shared resources (e.g., firewall, VPN gateway).
   * Spoke VNets (application VNets) peer with the hub for central services.

2. **Multi-region deployments**

   * Connect VNets in different regions for **disaster recovery** or **geo-redundancy**.

3. **Isolation & Segmentation**

   * Separate workloads into different VNets but still allow controlled communication.

---

## 7. Example Scenarios

### Example 1: Intra-Region Peering

* `VNet1 (10.0.0.0/16)` in East US
* `VNet2 (10.1.0.0/16)` in East US
* Peered → VMs in both VNets can talk directly with private IPs.

### Example 2: Global Peering

* `VNetA (10.0.0.0/16)` in East US
* `VNetB (10.2.0.0/16)` in West Europe
* Peered with **Global VNet Peering** → cross-region private communication.

### Example 3: Hub-and-Spoke

* `HubVNet (10.0.0.0/16)` has a **VPN Gateway** and firewall.
* `SpokeVNet1 (10.1.0.0/16)` and `SpokeVNet2 (10.2.0.0/16)` peer with `HubVNet`.
* All internet traffic goes through the Hub firewall.

---

## 8. Limitations

* **No transitive routing**: Must peer all required VNets explicitly.
* **Cannot peer across Azure Government/China clouds**.
* **Different subscriptions allowed**, but both must be in the **same Azure Active Directory tenant**.

---

## 9. How to Configure VNet Peering

### Example via PowerShell

```powershell
# Variables
$rgName = "MyResourceGroup"
$vnet1 = "VNet1"
$vnet2 = "VNet2"

# Get VNets
$vnet1Obj = Get-AzVirtualNetwork -Name $vnet1 -ResourceGroupName $rgName
$vnet2Obj = Get-AzVirtualNetwork -Name $vnet2 -ResourceGroupName $rgName

# Create Peering from VNet1 to VNet2
Add-AzVirtualNetworkPeering -Name "VNet1-to-VNet2" `
  -VirtualNetwork $vnet1Obj `
  -RemoteVirtualNetworkId $vnet2Obj.Id `
  -AllowForwardedTraffic `
  -AllowGatewayTransit

# Create Peering from VNet2 to VNet1
Add-AzVirtualNetworkPeering -Name "VNet2-to-VNet1" `
  -VirtualNetwork $vnet2Obj `
  -RemoteVirtualNetworkId $vnet1Obj.Id `
  -AllowForwardedTraffic `
  -UseRemoteGateways
```

---

✅ In short:

* **Azure VNet Peering = Azure’s way of connecting VNets privately over Microsoft’s backbone.**
* Similar to AWS VPC Peering but with support for **global peering** and better integration with **hub-and-spoke topologies**.

---
