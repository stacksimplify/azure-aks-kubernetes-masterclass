#resource "azurerm_kubernetes_cluster_node_pool" "user" {
#  availability_zones    = [1, 2, 3]
#  enable_auto_scaling   = true
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#  max_count             = 3
#  min_count             = 1
#  mode                  = "User"
#  name                  = "user"
#  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
#  os_disk_size_gb       = 30
#  vm_size               = "Standard_DS2_v2"
#}