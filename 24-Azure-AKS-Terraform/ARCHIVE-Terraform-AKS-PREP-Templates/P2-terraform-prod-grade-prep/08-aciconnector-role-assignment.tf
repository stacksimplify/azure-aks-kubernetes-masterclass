data "azurerm_user_assigned_identity" "aciconnectorlinux" {
  name                = "aciconnectorlinux-${local.aks_cluster_name}"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_role_assignment" "aciconnectorlinux" {
  scope                = azurerm_resource_group.primary.id 
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.aciconnectorlinux.principal_id
}