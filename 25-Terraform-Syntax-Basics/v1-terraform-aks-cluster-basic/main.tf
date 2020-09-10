# Terraform Provider Block: Define Provider
provider "azurerm" {
  features {}
}

# Terraform Resource Block: Create Azure Resoure Group
resource "azurerm_resource_group" "aksdev" {
  name     = var.resource_group_name   # Variables from variables.tf
  location = var.location              # Variables from variables.tf
}

# Terraform Resource Block: Create Azure Kubernetes Cluter
resource "azurerm_kubernetes_cluster" "aksdev" {
  name                = "aksdev-k8s"
  location            = azurerm_resource_group.aksdev.location
  resource_group_name = azurerm_resource_group.aksdev.name
  dns_prefix          = "aksdev-k8s"

# Terraform Block - Mandatory Item for Azure AKS Cluster
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

# Terraform Block - Optional Item
  identity {
    type = "SystemAssigned"
  }

# Terraform Block - Optional Item
  tags = {
    Environment = "dev"
  }

}
