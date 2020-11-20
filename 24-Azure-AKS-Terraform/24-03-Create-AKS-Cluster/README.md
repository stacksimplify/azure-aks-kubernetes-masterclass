# Create AKS Cluster

## Step-01: Introduction


## Step-02: Create SSH Public Key for Linux VMs
```
# Create Folder
mkdir $HOME/.ssh/aks-prod-sshkeys-terraform

# Create SSH Key
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f ~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey \
    -N mypassphrase

# List Files
ls -lrt $HOME/.ssh/aks-prod-sshkeys-terraform
```

## Step-03: Create 3 more Terraform Input Vairables to variables.tf
- SSH Public Key for Linux VMs
- Windows Admin username
- Windows Admin Password
```
# V2 Changes
# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type = string
  default = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"  
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type = string
  default = "P@ssw0rd1234"
  description = "This variable defines the Windows admin password k8s Worker nodes"  
}
```

## Step-04: Create a Terraform Datasource for getting latest Azure AKS Versions 
- Understand **Terraform Datasources** concept as part of this step
- Use Azure AKS versions datasource API to get the latest version and use it
- Create **04-aks-versions-datasource.tf**
- **Important Note:**
  - `include_preview` defaults to true which means we get preview version as latest version which we should not use in production.
  - So we need to enable this flag in datasource and make it to false to use latest version which is not in preview for our production grade clusters
```
# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.aks_rg.location
  include_preview = false  
}
```
- [Data Source: azurerm_kubernetes_service_versions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions)

## Step-05: Create Azure Log Analytics Workspace Terraform Resource
- The Azure Monitor for Containers (also known as Container Insights) feature provides performance monitoring for workloads running in the Azure Kubernetes cluster.
- We need to create Log Analytics workspace and reference its id in AKS Cluster when enabling the monitoring feature.
- Create a file **05-log-analytics-workspace.tf**
```
# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${random_pet.aksrandom.id}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  retention_in_days   = 30
}
```

## Step-06: Create Azure AD Group for AKS Admins Terraform Resource
- To enable AKS AAD Integration, we need to provide Azure AD group object id. 
- We wil create a Azure Active Directory group for AKS Admins
```
# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "aks_administrators" {
  name        = "${azurerm_resource_group.aks_rg.name}-${var.environment}-administrators"
  description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-${var.environment} cluster."
}
```

## Step-07: Create AKS Cluster Terraform Resource
- Create a file named  **07-aks-cluster.tf**
- Understand and discuss about the terraform resource named  [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
- This is going to be a very big terraform template when compared to what we created so far  we will do it slowly step by step.

```
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-${var.environment}"
  location            = azurerm_resource_group.aks_rg.location
  name                = "${azurerm_resource_group.aks_rg.name}-${var.environment}"
  resource_group_name = azurerm_resource_group.aks_rg.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"


  default_node_pool {
    name       = "systempool"
    vm_size    = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type           = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "production"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "production"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }    
  }

# Identity (System Assigned or Service Principal)
  identity { type = "SystemAssigned" }

# Add On Profiles
  addon_profile {
    azure_policy { enabled = true }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

# RBAC and Azure AD Integration Block
role_based_access_control {
  enabled = true
  azure_active_directory {
    managed                = true
    admin_group_object_ids = [azuread_group.aks_administrators.object_id]
  }
}  

# Windows Admin Profile
windows_profile {
  admin_username            = var.windows_admin_username
  admin_password            = var.windows_admin_password
}

# Linux Profile
linux_profile {
  admin_username = "ubuntu"
  ssh_key {
      key_data = file(var.ssh_public_key)
  }
}

# Network Profile
network_profile {
  load_balancer_sku = "Standard"
  network_plugin = "azure"
}

# AKS Cluster Tags 
tags = {
  Environment = "prod"
}


}
```

## Step-08: Deploy Terraform Resources
```
# Change Directory 
cd 24-03-Create-AKS-Cluster/v2-terraform-manifests-aks

# Initialize Terraform from this new folder
# Anyway our state storage is from Azure Storage we are good from any folder
terraform init


# Try terraform validate
terraform validate

# Try terraform plan (Should fail telling us to re-initialize backed)
terraform plan

# Re-Initialize Terraform Backend
terraform init 

# Verify if any local state file
ls -lrta
```

## Step-09: Access Terraform created AKS cluster using AKS default admin
```
# Azure AKS Get Credentials with --admin
az aks get-credentials --resource-group terraform-aks --name terraform-aks-prod --admin

# List Kubernetes Nodes
kubectl get nodes
```

## Step-10: Verify Resources using Azure Management Console
- Resource Group
  - terraform-aks
  - terraform-aks-nrg
- AKS Cluster & Node Pool
  - Cluster: terraform-aks-prod
  - AKS System Pool
- Log Analytics Workspace
- Azure AD Group
  - terraform-aks-prod-administrators


## Step-10: Create a User in Azure AD and Associate User to AKS Admin Group in Azure AD
- Create a user in Azure Active Directory
  - User Name: taksadmin1
  - Name: taksadmin1
  - First Name: taks
  - Last Name: admin1
  - Password: @AKSadmin11
  - Groups: terraform-aks-prod-administrators
  - Click on Create
- Login and change password 
  - URL: https://portal.azure.com
  - Username: taksadmin1@stacksimplifygmail.onmicrosoft.com  (Change your domain name)
  - Old Password: @AKSadmin11
  - New Password: @AKSadmin22
  - Confirm Password: @AKSadmin22


## Step-11: Access Terraform created AKS Cluster 
```
# Azure AKS Get Credentials with --admin
az aks get-credentials --resource-group terraform-aks --name terraform-aks-prod --overwrite-existing

# List Kubernetes Nodes
kubectl get nodes
URL: https://microsoft.com/devicelogin
Code: GUKJ3T9AC (sample)
Username: taksadmin1@stacksimplifygmail.onmicrosoft.com  (Change your domain name)
Password: @AKSadmin22
```