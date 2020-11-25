# We will define following in this file
# 1. Terraform Settings Block
# 2. Terraform Provider Block for AzureRM
# 3. Define a Random Pet Resource
# 4. Define Terraform Remote State Storage 

# Terraform Settings Block
terraform {
  # 1.Required Version of Terraform
  required_version = ">= 0.13"

  # 2.Required Providers
  required_providers {
    # Azure Resource Manager 2.x (Base Azure RM Module)
    azurem = {
      source = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    # Azure Active Directory Provider (require for AKS and Azure AD Integration)
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 1.0"      
    }
    # Random 3.x (Required to generate random names for Log Analytics Workspace)
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"      
    }    
     }
  # 3.Terraform Backend (Remote State Storage)

}

# This block is required for azurerm 2.x
provider azurerm {
  # v2.x azurerm requires "features" block
  features {}
}

# Create Random pet resource
resource "random_pet" "aksrandom" {}
