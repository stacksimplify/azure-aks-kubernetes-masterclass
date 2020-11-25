# Terraform Configuration Language - Basics

## Step-01: Introduction
- Understand Terraform language basics by creating a simple Azure AKS cluster using terraform.
- Understand Input Variables in Terraform
- Understand Output Values in Terraform

## Step-02: Terraform Configuration Language 
- Understand Resources
- Understand Blocks
- Understand Arguments
- Understand Identifiers
- Understand Comments
- [Terraform Configuration Syntax](https://www.terraform.io/docs/configuration/syntax.html)
```
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

# Example
resource "azurerm_resource_group" "aksdev" {   # BLOCK
  name     = "aks-rg2-tf" # Argument
  location = var.region   # Argument with value as expression (Variable value replaced from varibales.tf )

  tags = {  #BLOCK
    "environment" = "k8sdev"
  }
}
```

## Step-03: Create a very basic AKS Cluster using Terraform
- Create a simple AKS Cluster using terraform
- Understand AKS resource for terraform
- Discuss about `nodepool`, `identity` and `tags` blocks in Azure AKS Resource for terraform.

```

# Terraform Resource Block: Create Azure Kubernetes Cluter
resource "azurerm_kubernetes_cluster" "aksdev" {
  name                = "aksdev-k8s"
  location            = azurerm_resource_group.aksdev.location
  resource_group_name = azurerm_resource_group.aksdev.name
  dns_prefix          = "aksdev-k8s"

# Terraform Block - Mandatory Item for Azure AKS Cluster
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

# Terraform Block - Optional Item
  identity {
    type = "SystemAssigned"
  }

# Terraform Block - Optional Item
  tags = {
    Environment = "dev"
  }

}
```


## Step-04: Terraform Input Variables
- Implement input variables in terraform for AKS Cluster
- Understand different options available to pass input variables
  - variables.tf
  - arguments
  - arguments with a file containing variables
### Using variables.tf
- Define couple of input variables in `variables.tf`
- Reference them in `main.tf`
- Variables we are going to play with
  - Resource Group Name
  - Location or Region

### Using Command Line (Optional)
```
-var = 
```

### Using Command Line and load from file (Optional)
```
-var-file = 
```




## Step-05: Terraform Output Values
- Understand what are output values
- Implement output values for AKS Cluster terraform manifests
- Start with simple stuff and uncomment all required stuff
```
output "location" {
  value = azurerm_resource_group.aksdev.location
}

output "clusterid" {
  value = azurerm_kubernetes_cluster.aksdev.id
}
```

## Step-06: Migrate Terraform backend from local to Remote (Azure Storage Accounts)
- Understand terraform state in detail
- Migrate terraform state from local to Remote (Azure Storage Account)
  - Create Azure Storage Account (Azure CLI or Terraform)
  - Migrate `terraform.tfstate` from local to Azure Storage Account Container




