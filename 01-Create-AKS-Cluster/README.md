# Create AKS Cluster

## Step-01: Introduction
- Understand about AKS Cluster

## Step-02: Create AKS Cluster
- Create Kubernetes Cluster
- **Basics**
  - **Subscription:** Free Trial
  - **Resource Group:** Creat New: aks-rg1
  - **Kubernetes Cluster Name:** aksdemo1
  - **Region:** East Us
  - **Kubernetes Version:** Select what ever is latest stable version
  - **Node Size:** Standard DS2 v2 (Default one) (or) (B2s - 4GB RAM 2VPCU)
  - **Node Count:** 2
- **Node Pools**
  - leave to defaults
- **Authentication**
  - leave to defaults
- **Networking**
  - **Network Configuration:** Advanced
  - **Network Policy:** Azure
  - Rest all leave to defaults
- **Integrations**
  - leave to defaults
- **Tags**
  - leave to defaults
- **Review + Create**
  - Click on **Create**


## Step-03: Configure kubectl to connect to AKS Cluster
```
# Template
az aks get-credentials --resource-group <Resource-Group-Name> --name <Cluster-Name>

# Replace Resource Group & Cluster Name
az aks get-credentials --resource-group aks-rg1 --name aksdemo1

# List Kubernetes Worker Nodes
kubectl get nodes 
kubectl get nodes -o wide
```

## Step-04: Explore the AKS cluster on Azure Management Console
- Explore the Virtual machines
- Explore the Network


## Step-05: Deploy Sample Application and Test
- Don't worry about what is present in these two files for now. 
- By the time we complete **Kubernetes Fundamentals** sections, you will be an expert in writing Kubernetes manifest in YAML.
- For now just focus on result. 
```
# Deploy Application
cd /home/stack/azure-aks-kubernetes-masterclass/01-Create-AKS-Cluster  
kubectl apply -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify Deployment
kubectl get deployment

# Verify Service (Make a note of external ip)
kubectl get service

# Access Application
http://<External-IP-from-get-service-output>
```

## Step-06: Clean-Up
```
# Delete Applications
kubectl delete -f kube-manifests/
```

