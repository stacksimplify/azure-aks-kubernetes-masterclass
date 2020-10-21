# Configure Azure Provider
provider "azurerm" {
  # Version is optional
  # Terraform recommends to pin to a specific version of provide
  #version = "=2.20.0"
  #version = "~>2.20.0"
  features {}
}


# Create a Azure Resource Group
resource "azurerm_resource_group" "aksdev" {
  name     = "aks-rg2-tf"
  location = "Central US"

}

