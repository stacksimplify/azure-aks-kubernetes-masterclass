data "azurerm_user_assigned_identity" "aciconnectorlinux" {
  name                = "aciconnectorlinux-${local.resource_group_name}-${local.environment}"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

output "uai_client_id" {
  value = data.azurerm_user_assigned_identity.aciconnectorlinux.client_id
}

output "uai_principal_id" {
  value = data.azurerm_user_assigned_identity.aciconnectorlinux.principal_id
}

resource "azurerm_role_assignment" "aciconnectorlinux" {
  scope                = azurerm_resource_group.primary.id 
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.aciconnectorlinux.principal_id
}