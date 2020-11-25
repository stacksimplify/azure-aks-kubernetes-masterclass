# Get your cluster-info
#data "azurerm_kubernetes_cluster" "aks" {
 # name     = local.aks_cluster_name
 # resource_group_name = local.resource_group_name
 # depends_on = [
  #  azurerm_kubernetes_cluster.aks
  #]  
#}

# Same parameters as kubernetes provider
#provider "kubectl" {
#  load_config_file       = false
#  host                   = "https://${azurerm_kubernetes_cluster.aks.endpoint}"
#  token                  = data.azurerm_kubernetes_cluster.aks.access_token
#  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.master_auth.0.cluster_ca_certificate)
#}

resource "null_resource" "aks-get-credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --name ${local.aks_cluster_name} --resource-group ${local.resource_group_name}"
    #interpreter = ["/bin/bash", "-Command"]
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]    
}

resource "null_resource" "delete-aciconnector-pod" {
  provisioner "local-exec" {
    command = "kubectl -n kube-system delete pod $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')"
    #interpreter = ["/bin/bash", "-Command"]
  }
  depends_on = [
    null_resource.aks-get-credentials
  ]    
}


