# Load Balancers:

Azure provides **different types of load balancers**, depending on your needs:

---

## 🔹 1. **Azure Load Balancer (Layer 4)**

* Works at the **Transport Layer (TCP/UDP)**.
* It does **not** look inside the packet (no SSL termination or HTTP header inspection).
* Can be **Public** or **Internal**.

### Types:

1. **Public Load Balancer (PLB)**

   * Has a **public IP**.
   * Routes traffic from the internet to Azure VMs.
   * Example: A website hosted on multiple VMs.
   * Traffic Flow: Internet → Public LB → VM backend pool.

2. **Internal Load Balancer (ILB)**

   * Has a **private IP** inside your Virtual Network (VNet).
   * Used for **internal-only apps**, databases, or services.
   * Example: Backend tier of a 3-tier app where only the web servers call the database via ILB.
   * Traffic Flow: VM in VNet → ILB → VM backend pool.

---

## 🔹 2. **Azure Application Gateway (Layer 7)**

* Works at the **Application Layer (HTTP/HTTPS)**.
* Supports **URL-based routing**, **host-based routing**, **SSL termination**, and **Web Application Firewall (WAF)**.
* Best for **web applications**.
* Example:

  * Requests to `example.com/api/*` → API backend pool
  * Requests to `example.com/images/*` → Image backend pool

---

## 🔹 3. **Azure Traffic Manager (DNS-based load balancing)**

* Works at the **DNS level**, not real-time packet forwarding.
* Routes clients to the best endpoint **based on DNS policies** like:

  * **Priority routing** (failover)
  * **Performance routing** (lowest latency)
  * **Geographic routing** (nearest region)
* Example: Direct users from Europe → Azure Europe region, US users → Azure US region.

---

## 🔹 4. **Azure Front Door (Layer 7, Global load balancing + CDN)**

* Global HTTP(S) load balancer with **Anycast IP**.
* Provides **SSL offloading, caching, acceleration, Web Application Firewall**.
* Combines CDN + Application Gateway capabilities.
* Example: A global e-commerce app using Front Door to accelerate traffic worldwide.

---

## ✅ When to use what?

| Service                 | Layer                   | Use Case                                                                          |
| ----------------------- | ----------------------- | --------------------------------------------------------------------------------- |
| **Azure Load Balancer** | L4 (TCP/UDP)            | Simple, fast load balancing inside a region (VMs, AKS nodes, SQL Always On, etc.) |
| **Application Gateway** | L7 (HTTP/HTTPS)         | Web apps with routing rules, SSL offload, WAF                                     |
| **Traffic Manager**     | DNS                     | Multi-region failover, geo-routing                                                |
| **Front Door**          | L7 (HTTP/HTTPS, Global) | Global apps needing CDN + acceleration + WAF                                      |

---

👉 Example Scenario:

* A **global web app**: Use **Front Door** for global routing + WAF.
* Inside a region, Front Door sends traffic to **Application Gateway** for URL routing.
* App Gateway forwards to a **Backend Pool behind an Internal Load Balancer**, distributing to VM scale sets or AKS nodes.

---
