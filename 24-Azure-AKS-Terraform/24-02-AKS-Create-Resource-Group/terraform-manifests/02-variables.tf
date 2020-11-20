# https://www.terraform.io/docs/configuration/variables.html
# Input Variables
# Output Values
# Local Values

# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)
# 4. Azure AKS Cluster Name

# Azure Location
variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "terraform-aks-rg1"
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "prod"
}

# Locals (Optional)
locals {
  aks_cluster_name    = "${local.resource_group_name}-${local.environment}"
  location            = "centralus"
  resource_group_name = "aks-terraform5"
  environment         = "prod"
}