# Terraform Basics

## Step-01: Introduction
- Install Terraform
- Understand what is Terraform
- Understand Terrafom basic / essential commands
  - terraform version
  - terraform init
  - terraform plan
  - terraform validate
  - terraform apply
  - terraform show
  - terraform refresh
  - terraform providers
  - terraform destroy


## Pre-requisite-1: Install Visual Studio Code (VS Code Editor)
- [Download Visual Studio Code](https://code.visualstudio.com/download)

## Pre-requisite-2: Install HashiCorp Terraform plugin for VS Code
- [Install Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

## Step-02: Terraform Install
- **Referene Link:**
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### MAC OS
```
# Install on MAC OS
brew install hashicorp/tap/terraform

# Verify Terraform Version
terraform -version

# To Upgrade on MAC OS
brew upgrade hashicorp/tap/terraform

# Verify Terraform Version
terraform -version

# Verify Installation
terraform -help
terraform -help plan

# Enable Tab Completion
terraform -install-autocomplete
```

## Step-03: Install Azure CLI
```
# AZ CLI Current Version (if installed)
az --version

# Install Azure CLI (if not installed)
brew update && brew install azure-cli

# Upgrade az cli version
az --version
brew upgrade azure-cli
az --version

# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

## Step-04: Understand terrafrom init & provider azurerm
- Understand about [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- Understand about [azurerm terraform provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), version and features
- terraform init: Initialize a Terraform working directory
- terraform apply: Builds or changes infrastructure
```
# Change Directory to v1 folder
cd v1-terraform-azurerm-provider

# Initialize Terraform
terraform init

# Explore ".terraform" folder
cd .terraform
Go inside folders and review (.terraform/plugins/registry.terraform.io/hashicorp/azurerm/2.35.0/darwin_amd64)

# Execute terraform apply
terraform apply 
ls -lrta
discuss about "terraform.tfstate"

# Delete .terraform folder (Understand what happens)
rm -rf .terraform 
terraform apply (Should say could not load plugin)
To fix execute "terraform init" 

# Clean-Up V1 folder
rm terraform.tfstate
ls -lrta
```

## Step-04: Understand terraform plan, apply & Create Azure Resource Group
- Authenticate to Azure using Azure CLI `az login`
- Understand about `terraform plan`
- Understand about `terraform apply`
- Create Azure Resource Group using Terraform
- terraform init: Initialize a Terraform working directory
- terraform plan: Generate and show an execution plan
- terraform apply: Builds or changes infrastructure
```
# Change Directory to v2 folder
cd ../
cd v2-terraform-azurerm-resource-group

# Initialize Terraform
terraform init

# Validate terraform templates
terraform validate

# Dry run to see what resources gets created
terraform plan

# Create Resource Group in Azure
terraform apply
```
- Verify if resource group created in Azure using Management Console


## Step-05: Make changes to Resource Group and Deploy
- Add tags to Resource Group as below
```
# Create a Azure Resource Group
resource "azurerm_resource_group" "aksdev" {
  name     = "aks-rg2-tf"
  location = "Central US"

# Add Tags
  tags = {
    "environment" = "k8sdev"
  }
}
```
- Run terraform plan and apply
```
# Dry run to see what resources gets created
terraform plan

# Create Resource Group in Azure
terraform apply
```
- Verify if resource group created in Azure using Management Console

## Step-06: Modify Resource Group Name and Understand what happens
- Change Resource Group name from `aks-rg2-tf` to `aks-rg2-tf2` in main.tf
```
# Understand what happens with this change
terraform plan

# Apply changes
terraform apply
```
- Verify if resource group with new name got re-created in Azure using Management Console

## Step-07: Understand terraform show, refresh and providers
- terraform show: Inspect Terraform state or plan
- terraform refresh: Update local state file against real resources
- terraform providers: Prints a tree of the providers used in the configuration
```
# Terraform Show
terraform show

# Terraform Refresh
terraform refresh

# Terraform Graph
terraform graph

# Terraform Providers
terraform providers
```

## Step-08: Understand terraform destroy
- Understand about `terraform destroy`
```
# Delete newly created Resource Group in Azure 
terraform destroy

# Delete State 
rm -rf .terraform
rm -rf terraform.tfstate
```


## References
- [Main Azure Resource Manager Reference](https://www.terraform.io/docs/providers/azurerm/index.html)
- [Azure Get Started on Terraform](https://learn.hashicorp.com/collections/terraform/azure-get-started)
- [Terraform Resources and Modules](https://www.terraform.io/docs/configuration/index.html#resources-and-modules)

## Kubernetes Terraform Azure References
- https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html
- https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes/basic-cluster
- https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
- https://learn.hashicorp.com/tutorials/terraform/aks
- https://github.com/hashicorp/learn-terraform-provision-aks-cluster

