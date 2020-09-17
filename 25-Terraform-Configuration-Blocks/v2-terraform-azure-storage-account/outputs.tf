output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.tfstate_rg.name
}
output "terraform_state_storage_account" {
  value = azurerm_storage_account.tfstate_sta.name
}
output "terraform_state_storage_container_dev" {
  value = azurerm_storage_container.tfstate_container.name
}