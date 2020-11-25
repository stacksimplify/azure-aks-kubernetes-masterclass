# Define Provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "tfstate_rg" {
  name     = var.resource_group_name   # Variables from variables.tf
  location = var.location              # Variables from variables.tf

}

# Generate a random storage name
resource "random_string" "tfstate_random_name" {
    length = 8
    special = false
    upper = false
    number = false
}

# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "tfstate_sta" {
  depends_on = [azurerm_resource_group.tfstate_rg]  
  name                     = "terraformstate${random_string.tfstate_random_name.result}"
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Hot"

/*
  lifecycle {
    prevent_destroy = true
  } 
*/

  tags = {
    environment = "All Environments"
  }
}

# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "tfstate_container" {
  depends_on = [azurerm_storage_account.tfstate_sta]
  name                  = "${var.environment}tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_sta.name
}


