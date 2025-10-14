# Changes June 2023: 24-03-Create-AKS-Cluster

## Step-01: 01-main.tf: Update Terraform Block
- Updated the versions in Terraform block
```t
terraform {
  # 1. Required Version Terraform
  required_version = ">= 1.0"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
```

## Step-02: 01-main.tf: Update Provider Block
- Updated `Provider Block` with `prevent_deletion_if_contains_resources = false`
- When creating AKS Cluster, `ContainerInsights` resource gets auto-created by default and during the resource deletion process `terraform destroy` it will timeout and throw an error that Terraform didn't find resource `ContainerInsights`.
- So with the below fix, our `terraform destroy` will be successful
```t
provider "azurerm" {
  features {
    # Updated as part of June2023 to delete "ContainerInsights Resources" when deleting the Resource Group
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
```

## Step-03: 02-variables.tf: Update Windows Password
- Updated the password as per latest password standards
```t
# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type = string
  default = "StackSimplify@102"  # Updated June 2023
  description = "This variable defines the Windows admin password k8s Worker nodes"  
}
```

## Step-04: 06-aks-administrators-azure-ad.tf: Name changes
- There is a change in argument name from `name` to `display_name`
- In addition, also added the argument `security_enabled = true`
```t
# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "aks_administrators" {
  #name        = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
   # Below two lines added as part of update June2023
  display_name = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
  security_enabled = true
  description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster."
}
```

## Step-05: 07-aks-cluster.tf: Availability Zones
- In node pools, argument name `availability_zones` changed to `zones` 
```t
  default_node_pool {
    name                 = "systempool"
    vm_size              = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    #availability_zones   = [1, 2, 3]
    # Added June2023
    zones = [1, 2, 3]
```
## Step-06: 07-aks-cluster.tf: Commented both Add-On Profiles
```t
# Add On Profiles
#  addon_profile {
#    azure_policy {enabled =  true}
#    oms_agent {
#      enabled =  true
#      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
#    }
#  }

# RBAC and Azure AD Integration Block
#  role_based_access_control {
#    enabled = true
#    azure_active_directory {
#      managed = true
#      admin_group_object_ids = [azuread_group.aks_administrators.id]
#    }
#  }
```
## Step-07: 07-aks-cluster.tf: Added oms_agent
```t
# Added June 2023
oms_agent {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
}
```
## Step-08: 07-aks-cluster.tf: Added Azure AD
```t
# Added June 2023
azure_active_directory_role_based_access_control {
  managed = true
  admin_group_object_ids = [azuread_group.aks_administrators.id]
}
```