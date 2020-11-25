# Define Output Values for AKS Cluster
output "aks_resource_group" {
  value = azurerm_resource_group.aks_rg.name
}

output "location" {
  value = azurerm_resource_group.aks_rg.location
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}







