# Azure Private Link Service Setup Guide

This guide provides detailed steps to set up an Azure Private Link architecture in the `canadacentral` region, using resource group `test-rg`, VNets `vnet-1` and `vnet-pe`, Private Link Service, Private Endpoint, and related components. The setup is automated where possible using Azure CLI commands and an Ansible playbook for connectivity testing. It assumes a confirmed quota for `standardDSv2Family` (Limit: 10) in `canadacentral`.

Official reference: [Microsoft Azure Private Link Service Documentation](https://learn.microsoft.com/en-us/azure/private-link/create-private-link-service-cli)

## Step 1: Create the Architecture in Canada Central

### Creating Resource Group
Create a resource group named `test-rg` in the `canadacentral` region.

```bash
az group create --name test-rg --location canadacentral
```

### Creating Producer VNet and Subnet
Set up the producer virtual network (`vnet-1`) and its subnet (`subnet-1`).

```bash
az network vnet create \
  --resource-group test-rg \
  --location canadacentral \
  --name vnet-1 \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name subnet-1 \
  --subnet-prefixes 10.0.0.0/24
```

### Updating Subnet for Private Link Service
Disable private link service network policies on `subnet-1` to allow Private Link Service creation.

```bash
az network vnet subnet update \
  --name subnet-1 \
  --vnet-name vnet-1 \
  --resource-group test-rg \
  --private-link-service-network-policies Disabled
```

### Creating Private Link Service
Create a Private Link Service associated with `vnet-1` and `subnet-1`, using a load balancer.

```bash
az network private-link-service create \
  --resource-group test-rg \
  --name private-link-service \
  --vnet-name vnet-1 \
  --subnet subnet-1 \
  --lb-name load-balancer \
  --lb-frontend-ip-configs frontend \
  --location canadacentral
```

### Creating Consumer VNet and Subnet
Set up the consumer virtual network (`vnet-pe`) and its subnet (`subnet-pe`).

```bash
az network vnet create \
  --resource-group test-rg \
  --location canadacentral \
  --name vnet-pe \
  --address-prefixes 10.1.0.0/16 \
  --subnet-name subnet-pe \
  --subnet-prefixes 10.1.0.0/24
```

### Creating Private Endpoint
Create a Private Endpoint in `vnet-pe` to connect to the Private Link Service.

```bash
export resourceid=$(az network private-link-service show \
  --name private-link-service \
  --resource-group test-rg \
  --query id \
  --output tsv)
az network private-endpoint create \
  --connection-name connection-1 \
  --name private-endpoint \
  --private-connection-resource-id $resourceid \
  --resource-group test-rg \
  --subnet subnet-pe \
  --manual-request false \
  --vnet-name vnet-pe \
  --location canadacentral
```

## Step 2: Creating Backend VM
Deploy a backend VM in `vnet-1`, `subnet-1` with NGINX installed to serve as the Private Link Service backend.

```bash
az vm create \
  --resource-group test-rg \
  --name backend-vm \
  --vnet-name vnet-1 \
  --subnet subnet-1 \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --admin-password Pakistan@786 \
  --location canadacentral \
  --size Standard_DS1_v2 \
  --public-ip-address ""
```

### Installing NGINX on Backend VM
Install and start NGINX on the backend VM.

```bash
az vm run-command invoke \
  --resource-group test-rg \
  --name backend-vm \
  --command-id RunShellScript \
  --scripts "sudo apt-get update && sudo apt-get install -y nginx && sudo systemctl start nginx"
```

## Step 3: Creating Client VM
Deploy a client VM in `vnet-pe`, `subnet-pe` to test connectivity to the Private Endpoint.

```bash
az vm create \
  --resource-group test-rg \
  --name client-vm \
  --vnet-name vnet-pe \
  --subnet subnet-pe \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --admin-password Pakistan@786 \
  --location canadacentral \
  --size Standard_DS1_v2 \
  --public-ip-address ""
```

## Step 4: Configuring Load Balancer Backend Pool
Add the backend VM to the load balancer’s backend pool.

```bash
az network lb address-pool add \
  --resource-group test-rg \
  --lb-name load-balancer \
  --name backend-pool \
  --vnet vnet-1 \
  --backend-address name=backend-vm ip-address=$(az vm show -d --resource-group test-rg --name backend-vm --query privateIps -o tsv)
```

### Verifying Backend Pool Configuration
Verify that the backend VM is correctly added to the load balancer’s backend pool.

```bash
az network lb address-pool show \
  --resource-group test-rg \
  --lb-name load-balancer \
  --name backend-pool \
  --query backendIpConfigurations
```

## Step 5: Retrieving Private Endpoint IP
Obtain the Private Endpoint’s IP address for connectivity testing.

```bash
az network private-endpoint show \
  --name private-endpoint \
  --resource-group test-rg \
  --query "networkInterfaces[0].ipConfigurations[0].privateIPAddress" \
  --output tsv
```

Note the IP address (e.g., `10.1.0.x`) for use in connectivity testing.

## Step 6: Testing Connectivity
Since the VMs lack public IPs, use either a temporary public IP or Azure Bastion to access the client VM for testing.

### Option 1: Assigning Temporary Public IP
Assign a temporary public IP to the client VM for SSH access.

```bash
az network public-ip create \
  --resource-group test-rg \
  --name client-vm-public-ip \
  --location canadacentral \
  --sku Standard
az network nic ip-config update \
  --resource-group test-rg \
  --nic-name $(az vm show --resource-group test-rg --name client-vm --query "networkProfile.networkInterfaces[0].id" -o tsv | awk -F'/' '{print $NF}') \
  --name ipconfigclient-vm \
  --public-ip-address client-vm-public-ip
```

SSH into the client VM and test connectivity to the Private Endpoint.

```bash
ssh azureuser@$(az vm show -d --resource-group test-rg --name client-vm --query publicIps -o tsv)
curl http://<private-endpoint-ip>
```

**Expected Output**: NGINX welcome page HTML or a 200 HTTP status code.

### Cleaning Up Temporary Public IP
Remove the temporary public IP after testing.

```bash
az network nic ip-config update \
  --resource-group test-rg \
  --nic-name $(az vm show --resource-group test-rg --name client-vm --query "networkProfile.networkInterfaces[0].id" -o tsv | awk -F'/' '{print $NF}') \
  --name ipconfigclient-vm \
  --remove publicIpAddress
az network public-ip delete \
  --resource-group test-rg \
  --name client-vm-public-ip
```

### Option 2: Setting Up Azure Bastion
Create a subnet and Azure Bastion for secure access to the client VM.

```bash
az network vnet subnet create \
  --resource-group test-rg \
  --vnet-name vnet-pe \
  --name AzureBastionSubnet \
  --address-prefixes 10.1.1.0/24
az network public-ip create \
  --resource-group test-rg \
  --name bastion-ip \
  --location canadacentral \
  --sku Standard
az network bastion create \
  --resource-group test-rg \
  --name bastion \
  --public-ip-address bastion-ip \
  --vnet-name vnet-pe \
  --location canadacentral
```

SSH into the client VM using Azure Bastion and test connectivity.

```bash
az network bastion ssh \
  --name bastion \
  --resource-group test-rg \
  --target-resource-id $(az vm show --resource-group test-rg --name client-vm --query id -o tsv) \
  --auth-type password \
  --username azureuser \
  --password Pakistan@786
curl http://<private-endpoint-ip>
```

## Step 7: Automating Connectivity Test with Ansible
Use the following Ansible playbook to automate connectivity testing from the client VM to the Private Endpoint.

<xaiArtifact artifact_id="5f5f60c4-6b28-49fa-98bd-425b3c9d1b92" artifact_version_id="94dc8dd6-7bad-4bba-9e34-5f86a51f4474" title="test_private_link.yml" contentType="text/yaml">
---
- name: Test Private Link Connectivity in Canada Central
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Retrieving Private Endpoint IP
      ansible.builtin.command:
        cmd: az network private-endpoint show --name private-endpoint --resource-group test-rg --query "networkInterfaces[0].ipConfigurations[0].privateIPAddress" --output tsv
      register: private_endpoint_ip
      changed_when: false

    - name: Testing connectivity from client VM
      ansible.builtin.command:
        cmd: az vm run-command invoke --resource-group test-rg --name client-vm --command-id RunShellScript --scripts "curl -s -o /dev/null -w '%{http_code}' http://{{ private_endpoint_ip.stdout }}"
      register: curl_result
      changed_when: false

    - name: Verifying HTTP response code
      ansible.builtin.assert:
        that:
          - curl_result.stdout | int == 200
        fail_msg: "Failed to connect to Private Endpoint. HTTP code: {{ curl_result.stdout }}"
        success_msg: "Successfully connected to Private Endpoint. HTTP code: {{ curl_result.stdout }}"

## Step 8: Clean up resources
When no longer needed, use the az group delete command to remove the resource group, private link service, load balancer, and all related resources.

```bash
az group delete \
    --name test-rg 
```
