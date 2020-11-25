terraform {
  # Use a recent version of Terraform
  required_version = ">= 0.13"

  # Map providers to thier sources, required in Terraform 13+
  required_providers {
    # Azure Active Directory 1.x
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    # Azure Resource Manager 2.x
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    # Random 3.x
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    # Null Provider for ACI Connector Linux Delete Pod
    null = {
      source  = "hashicorp/null"
      version = ">=2.1.2"
    }

  }
}

provider azurerm {
  # v2.x required "features" block
  features {}
}

locals {
  aks_cluster_name    = "${local.resource_group_name}-${local.environment}"
  location            = "centralus"
  resource_group_name = "aks-terraform5"
  environment         = "prod"
}

resource "random_pet" "primary" {}
