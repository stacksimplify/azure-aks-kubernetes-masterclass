resource "null_resource" "aks-get-credentials" {
  provisioner "local-exec" {
    command = <<EOF
            sleep 360
      EOF
  }

  provisioner "local-exec" {
    command = "rm -rf ~/.kube && az aks get-credentials --name ${local.aks_cluster_name} --resource-group ${local.resource_group_name} --admin"
  }

  provisioner "local-exec" {
    command = "kubectl -n kube-system get pod $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')"
  }
  depends_on = [azurerm_kubernetes_cluster.aks, azurerm_role_assignment.aciconnectorlinux]    
}

### Optional Not needed
#resource "null_resource" "delete-aciconnector-pod" {
#  provisioner "local-exec" {
#    command = "kubectl -n kube-system delete pod $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')"
#  }

#  provisioner "local-exec" {
#    command = <<EOF
#            sleep 60
#      EOF
#  }

#  provisioner "local-exec" {
#    command = "kubectl -n kube-system get pod $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')"
#  }

#  depends_on = [null_resource.aks-get-credentials]    
#}


