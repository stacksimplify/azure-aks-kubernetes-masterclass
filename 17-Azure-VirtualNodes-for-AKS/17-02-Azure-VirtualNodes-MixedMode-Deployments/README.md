# Azure AKS Virtual Nodes Mixed Mode Deployments

## Step-01: Introduction
- We are going to deploy MySQL on regular AKS nodepools (default system nodepool)
- We are going to deploy **User Management Web Application** on Azure Virtual Nodes
- All this we are going to do using NodeSelectors concept in Kubernetes

## Step-02: Review Kubernetes Manifests
### MySQL Deployment 
- **File Name:** 04-mysql-deployment.yml**
- No changes in it, MySQL pod will get scheduled on default AKS nodepool

### User Management Web Application Deployment
- **File Name:** 06-UserMgmtWebApp-Deployment.yml
- User Management web app pod will schedule on Azure Virtual Node
```yaml
# To schedule pods on Azure Virtual Nodes            
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule    
```

## Step-03: Deploy App & Test
```
# Deploy
kubectl apply -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify Pods scheduled on which Nodes
kubectl get pods -o wide

# List Kubernetes Nodes
kubectl get nodes 
kubectl get nodes -o wide

# List Node Pools
az aks nodepool list --cluster-name aksdemo2 --resource-group aks-rg2 --output table

# Access Application
kubectl get svc
http://<Public-IP-from-Get-Service-Output>
Username: admin101
Password: password101
```


## Step-04: Clean-Up Apps
```
# Delete App
kubectl delete -f kube-manifests/
```


```
az aks nodepool list --cluster-name aksdemo2 --resource-group aks-rg2 --output table
az aks nodepool show --cluster-name aksdemo2 --resource-group aks-rg2 --name agentpool

kubectl exec --stdin --tty usermgmt-webapp-57c6949bff-blqlf -- /bin/bash

```