# We will define 
# 1. Terraform Settings Block
# 2. Terraform Provide Block for AzureRM
# 3. Define a Random Pet Resource
# 4. Define Terraform Remote State Storage 

# Terraform Settings Block (https://www.terraform.io/docs/configuration/terraform.html)
terraform {
  # Use a recent version of Terraform
  required_version = ">= 0.13"

  # Map providers to thier sources, required in Terraform 13+
  required_providers {
    # Azure Resource Manager 2.x (Base Azure RM Module)
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    # Azure Active Directory 1.x (required for AKS and Azure AD Integration)
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    # Random 3.x (Required to generate random names for Log Analytics Workspace)
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
# Configure Terraform State Storage
    backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstatexlrwdrzs"
    container_name        = "prodtfstate"
    key                   = "terraform.tfstate"
  }
}


# Terraform Provider Block: Define Provider
provider azurerm {
  # v2.x azurerm requires "features" block
  features {}
}

# Terraform Resource Block: Create Random pet resource
resource "random_pet" "aksrandom" {}



