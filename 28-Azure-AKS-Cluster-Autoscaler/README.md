# Azure AKS - Cluster Autoscaler

## Step-01: Introduction
- The Kubernetes Cluster Autoscaler automatically adjusts the number of nodes in your cluster when pods fail to launch due to lack of resources or when nodes in the cluster are underutilized and their pods can be rescheduled onto other nodes in the cluster.

## Step-02: Create Cluster with Cluster Autoscaler Enabled
```
# Setup Environment Variables
export RESOURCE_GROUP=aks-rg1-autoscaling
export REGION=centralus
export AKS_CLUSTER=aks-autoscaling-demo

# Create Resource Group
az group create --location ${REGION} \
                --name ${RESOURCE_GROUP}

# Create AKS cluster and enable the cluster autoscaler
az aks create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${AKS_CLUSTER} \
  --node-count 1 \
  --vm-set-type VirtualMachineScaleSets \
  --load-balancer-sku standard \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 5

# Configure Credentials
az aks get-credentials --name ${AKS_CLUSTER}  --resource-group ${RESOURCE_GROUP} 

# List Nodes
kubectl get nodes
kubectl get nodes -o wide
```
## Step-04: Review & Deploy Sample Application
```
# Deploy Application
kubectl apply -f kube-manifests/
```

## Step-05: Scale our application to 30 pods
- In 2 to 3 minutes, one after the other new nodes will added and pods will be scheduled on them. 
- Our max number of nodes will be 5 which we provided during cluster creation.
```
# Scale UP the demo application to 30 pods
kubectl get pods
kubectl get nodes 
kubectl scale --replicas=20 deploy ca-demo-deployment 
kubectl get pods

# Verify nodes
kubectl get nodes -o wide
```
## Step-06: Cluster Scale DOWN: Scale our application to 1 pod
- It might take 5 to 20 minutes to cool down and come down to minimum nodes which will be 2 which we configured during nodegroup creation
```
# Scale down the demo application to 1 pod
kubectl scale --replicas=1 deploy ca-demo-deployment 

# Verify nodes
kubectl get nodes -o wide
```

## Step-07: Clean-Up
- We will leave cluster autoscaler and undeploy only application
```
# Delete Apps
kubectl delete -f kube-manifests/

# Delete Cluster, Resource Group  (Optional)
az group delete -n ${RESOURCE_GROUP}
```


## References
- https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler