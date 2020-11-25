# Location
variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "Central US"
}

# Resource Group
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "terraform-storage-rg"
}

# Environment 
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "dev"
}
