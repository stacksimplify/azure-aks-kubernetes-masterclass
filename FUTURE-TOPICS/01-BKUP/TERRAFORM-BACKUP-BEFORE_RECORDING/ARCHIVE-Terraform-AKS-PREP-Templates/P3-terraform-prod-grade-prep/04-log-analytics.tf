resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${random_pet.primary.id}"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  retention_in_days   = 30
}