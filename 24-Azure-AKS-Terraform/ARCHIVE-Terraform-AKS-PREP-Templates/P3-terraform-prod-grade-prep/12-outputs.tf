output "location" {
  value = azurerm_resource_group.primary.location
}
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_resource_group" {
  value = azurerm_resource_group.primary.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "cluster_username" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.username
}

output "cluster_password" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.password
}

output "uai_client_id" {
  value = data.azurerm_user_assigned_identity.aciconnectorlinux.client_id
}

output "uai_principal_id" {
  value = data.azurerm_user_assigned_identity.aciconnectorlinux.principal_id
}


