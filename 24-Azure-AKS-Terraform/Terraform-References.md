## References
- https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes
- https://build5nines.com/terraform-create-an-aks-cluster/
- Documentation Option References
  - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#key_data
  - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity
- AGIC: https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
- https://www.terraform.io/docs/provisioners/local-exec.html  
- Third Party kubectl Plugin: https://registry.terraform.io/providers/gavinbunney/kubectl/latest
- https://github.com/terraform-providers/terraform-provider-azurerm/issues/2421
```
Since TF only support AKS without RBAC or AKS with RBAC & AAD and not the option AKS with RBAC currently. It is important to have this capability.
```
- https://github.com/dwaiba/aks-terraform/blob/master/main.tf
- https://dev.to/cdennig/fully-automated-creation-of-an-aad-integrated-kubernetes-cluster-with-terraform-15cm
- https://dev.to/cdennig/azure-devops-terraform-provider-22fb
- https://github.com/dwaiba/aks-terraform/blob/master/main.tf
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster