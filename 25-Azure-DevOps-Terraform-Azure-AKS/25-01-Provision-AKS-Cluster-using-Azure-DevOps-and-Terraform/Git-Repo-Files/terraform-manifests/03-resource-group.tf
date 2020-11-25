# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf
resource "azurerm_resource_group" "aks_rg" {
  location = var.location
  name     = "${var.resource_group_name}-${var.environment}"
}

# Terraform Resource to Create Resource Group with Local Variables
# Optional - If you use local variables
#resource "azurerm_resource_group" "aks" {
# location = local.location
#  name     = local.resource_group_name
#}