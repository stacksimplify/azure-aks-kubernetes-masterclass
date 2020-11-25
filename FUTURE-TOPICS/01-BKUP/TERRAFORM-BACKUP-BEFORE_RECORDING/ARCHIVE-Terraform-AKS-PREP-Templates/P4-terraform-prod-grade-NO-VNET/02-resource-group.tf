resource "azurerm_resource_group" "primary" {
  location = local.location
  name     = local.resource_group_name
}