# Terraform Steps to Provision Azure AKS Cluster
# Step-01: Create Terraform State Storage in Azure Storage Account
# Step-02: Create Resource-1: Azure Resource Group
# Step-03: Create variables.tf and pick resource group name and location from variables.tf
# Step-04: Create Resource-3: Azure Kubernetes Service (AKS Cluster)
# Step-05: Define default system node pool
# Step-06: Define identity (system-assigned) and tags
# Step-07: Create outputs.tf

# Configure Terraform State Storage
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstatexlrwdrzs"
    container_name        = "devtfstate"
    key                   = "terraform.tfstate"
  }
}


# Terraform Provider Block: Define Provider
provider "azurerm" {
  features {}
}

# Terraform Resource Block: Create Azure Resoure Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name   # Variables from variables.tf
  location = var.location              # Variables from variables.tf
}

# Terraform Resource Block: Create Azure Kubernetes Cluter
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-${var.environment}-k8s-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-${var.environment}-k8s"

# Terraform Block - Mandatory Item for Azure AKS Cluster
  default_node_pool {
    name       = "systempool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

# Terraform Block - Optional Item
  identity {
    type = "SystemAssigned"
  }

# Terraform Block - Optional Item
  tags = {
    Environment = var.environment
  }

}
