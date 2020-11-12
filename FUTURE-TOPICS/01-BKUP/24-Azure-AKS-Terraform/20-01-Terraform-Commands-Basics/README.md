# Terraform Basics

## Step-01: Introduction
- Install Terraform
- Understand what is Terraform
- Understand Terrafom basic commands
  - terraform version
  - terraform init
  - terraform plan
  - terraform validate
  - terraform apply
  - terraform destroy
  - terraform refresh
  - terraform graph
  - More to be added  

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
# Install Azure CLI (if not installed)
brew update && brew install azure-cli

# Azure CLI Login
az login
```

## Step-04: Understand terrafrom init & provider azurerm
- Understand about Terraform Providers
- Understand about azurerm, version and features
```
# Initialize Terraform
terraform init

# Delete State 
rm -rf .terraform
rm -rf terraform.tfstate
```

## Step-04: Understand terraform plan, apply & Create Azure Resource Group
- Authenticate to Azure using Azure CLI `az login`
- Understand about `terraform plan`
- Understand about `terraform apply`
- Create Azure Resource Group using Terraform
```
# Authenticate to Azure using az cli
az login

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
- Change Resource Group name from `aks-rg2-tf` to `aks-rg2-tf2`
```
# Understand what happens with this change
terraform plan

# Apply changes
terraform apply
```
- Verify if resource group with new name got re-created in Azure using Management Console

## Step-07: Understand terraform destroy
- Understand about `terraform destroy`
```
# Delete newly created Resource Group in Azure 
terraform destroy

# Delete State 
rm -rf .terraform
rm -rf terraform.tfstate
```


## References
- **Main Azure RM Reference:** https://www.terraform.io/docs/providers/azurerm/index.html
- **Azure Get Started on Terraform:** https://learn.hashicorp.com/collections/terraform/azure-get-started
- **Terraform Resources and Modules:** https://www.terraform.io/docs/configuration/index.html#resources-and-modules
## Kubernetes Terraform Azure References
- https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html
- https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes/basic-cluster
- https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
- https://learn.hashicorp.com/tutorials/terraform/aks
- https://github.com/hashicorp/learn-terraform-provision-aks-cluster

