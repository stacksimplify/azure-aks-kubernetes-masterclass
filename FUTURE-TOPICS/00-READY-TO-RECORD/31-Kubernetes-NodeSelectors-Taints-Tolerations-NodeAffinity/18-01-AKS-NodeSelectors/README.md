# Azure AKS Nodepools and Kubernetes NodeSelectors

## Step-01: 
1. Node Selector
2. Taints & Tolerations
3. Node Affinity
4. Inter-pod Affinity
5. Anti Affinity

### Other Concepts
- Create Cluster
- Create Second Nodepool
- Manage Nodepools
  - Upgrade Nodepool
  - Scale Nodepool
  - Delete Nodepool
- Schedule pods using taints and tolerations
  - Specify a taint, label, or tag for a node pool
  - Setting nodepool taints 

## Step-02: Create AKS Cluster with default Nodepool 
- Understand Node Pool Types (System & User Nodepools)
- Create AKS cluster with default nodepool. We also call it as System Nodepool
```
# Create a resource group in East US
az group create --name aks-rg3 --location centralus


# Set Windows Password for Windows k8s worker Nodes in Windows nodepool
export PASSWORD_WIN="P@ssw0rd1234"
echo $PASSWORD_WIN

# Create AKS Cluster
az aks create --name aksdemo3 \
              --resource-group aks-rg3 \
              --vm-set-type VirtualMachineScaleSets \
              --enable-managed-identity \
              --generate-ssh-keys \
              --network-plugin azure \
              --windows-admin-password $PASSWORD_WIN \
              --windows-admin-username azureuser \
              --node-count 1 \
              --nodepool-labels environment=production nodepoolos=linux app=webservers \
              --nodepool-name linux101 \
              --nodepool-tags environment=production nodepoolos=linux app=webservers

# Configure Kubectl
az aks get-credentials --name aksdemo3 --resource-group aks-rg3
kubectl get nodes
kubectl get nodes -o wide
kubectl get pods -n kube-system -o wide

# List Node Pools
az aks nodepool list --cluster-name aksdemo3 --resource-group aks-rg3
az aks nodepool list --cluster-name aksdemo3 --resource-group aks-rg3 --output table


# List Nodes using Labels
kubectl get nodes -o wide -l app=webservers
kubectl get nodes -o wide -l app=webservers,environment=production

# List which pods are running in system nodepool from kube-system namespace
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system
```

## Step-03: Create a new Linux Nodepool
- Default [--os-type](https://docs.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az_aks_nodepool_add) is Linux, if not mentioned default it will take linux.
- Supported OS Types are Linux or Windows
```
# Create New Linux Node Pool 
az aks nodepool add --resource-group aks-rg3 \
                    --cluster-name aksdemo3 \
                    --name linux102 \
                    --node-count 1 \
                    --labels environment=production nodepoolos=linux app=java-apps \
                    --tags environment=production nodepoolos=linux app=java-apps


# List Node Pools
az aks nodepool list --cluster-name aksdemo3 --resource-group aks-rg3 --output table
Note: Understand the mode System vs User

# List Nodes using Labels
kubectl get nodes -o wide -l nodepoolos=linux
kubectl get nodes -o wide -l app=webservers
kubectl get nodes -o wide -l app=java-apps


# List which pods are running in system nodepool from kube-system namespace
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system
```



## Step-04: Create a Node Pool for Windows Apps
- To run an AKS cluster that supports node pools for Windows Server containers, your cluster needs to use a network policy that uses [Azure CNI](https://docs.microsoft.com/en-us/azure/aks/concepts-network#azure-cni-advanced-networking) (advanced) network plugin
- Default windows Node size is Standard_D2s_v3 as on today
- The following limitations apply to Windows Server node pools:
  - The AKS cluster can have a maximum of 10 node pools.
  - The AKS cluster can have a maximum of 100 nodes in each node pool.
  - The Windows Server node pool name has a limit of 6 characters.
```
# Create New Linux Node Pool 
az aks nodepool add --resource-group aks-rg3 \
                    --cluster-name aksdemo3 \
                    --os-type Windows \
                    --name win101 \
                    --node-count 1 \
                    --labels environment=production nodepoolos=windows app=dotnet-apps \
                    --tags environment=production nodepoolos=windows app=dotnet-apps


# List Node Pools
az aks nodepool list --cluster-name aksdemo3 --resource-group aks-rg3 --output table

# List Nodes using Labels
kubectl get nodes -o wide
kubectl get nodes -o wide -l nodepoolos=linux
kubectl get nodes -o wide -l nodepoolos=windows
kubectl get nodes -o wide -l environment=production
```

## Step-04: Review Manifests
### WebServer Apps NodeSelector
- Review kubernetes manifests from **kube-manifests/01-Webserver-Apps**
```yaml
# To schedule pods on based on NodeSelectors
      nodeSelector:
        app: webservers
```

### Java Apps NodeSelector
- Review kubernetes manifests from **kube-manifests/02-Java-Apps**
```yaml
# To schedule pods on based on NodeSelectors
      nodeSelector:
        app: java-apps            
```

## Step-05: Deploy Apps based on NodeSelectors and Verify
```
# Deploy Apps
kubectl apply -R -f kube-manifests/

# List Pods
kubectl get pods -o wide
Note-1: Review the Node section in the output to understand on which node each pod is scheduled
Note-2: Windows app tool 12 minutes to download the image and start.

# List Pods with Node Name where it scheduled
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name 
```

## Step-06: Access Applications
```
# List Services to get Public IP for each service we deployed 
kubectl get svc

# Access Webserver App
http://<public-ip-of-webserver-app>/app1/index.html

# Access Java-App
http://<public-ip-of-java-app>
Username: admin101
Password: password101

# Access Windows App
http://<public-ip-of-windows-app>
```

## Step-07: Clean-Up
```
# Delete Apps
kubectl delete -R -f kube-manifests/
```


## Backup
```
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name --all-namespaces
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name 
```

## References
- https://docs.microsoft.com/en-in/azure/aks/concepts-clusters-workloads
- https://docs.microsoft.com/en-in/azure/aks/operator-best-practices-advanced-scheduler
- https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools
- https://docs.microsoft.com/en-us/azure/aks/windows-container-cli