resource "azurerm_kubernetes_cluster" "aks" {
  dns_prefix          = local.aks_cluster_name
  location            = azurerm_resource_group.primary.location
  name                = local.aks_cluster_name
  resource_group_name = azurerm_resource_group.primary.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.primary.name}-nrg"


  default_node_pool {
    name       = "system"
    #node_count = 1
    vm_size    = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    vnet_subnet_id = azurerm_subnet.aks-default.id 
    type           = "VirtualMachineScaleSets"
  }

  identity { type = "SystemAssigned" }

# Add On Profiles
  addon_profile {
    aci_connector_linux {
      enabled = true
      subnet_name = azurerm_subnet.aks-vnode.name
    }    
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
  admin_username            = "azureuser"
  admin_password            = "P@ssw0rd1234"
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

tags = {
  Environment = "prod-1"
}


}