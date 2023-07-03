# Create AKS Cluster

## Step-01: Introduction
- Create Azure AKS Cluster
- Connect to Azure AKS Cluster using Azure Cloud Shell
- Explore Azure AKS Cluster Resources
- Install Azure CLI and Connect to Azure AKS Cluster using Azure CLI on local desktop
- Deploy Sample Application on AKS Cluster and test


## Step-02: Create AKS Cluster
- Create Kubernetes Cluster
- **Basics**
  - **Subscription:** StackSimplify-Paid-Subscription
  - **Resource Group:** Creat New: aks-rg1
  - **Cluster preset configuration:** Standard
  - **Kubernetes Cluster Name:** aksdemo1
  - **Region:** (US) Central US
  - **Availability zones:** Zones 1, 2, 3
  - **AKS Pricing Tier:** Free
  - **Kubernetes Version:** Select what ever is latest stable version
  - **Automatic upgrade:** Enabled with patch (recommended)
  - **Node Size:** Standard DS2 v2 (Default one)
  - **Scale method:** Autoscale
  - **Node Count range:** 1 to 5
- **Node Pools**
  - leave to defaults
- **Access**
  - **Authentication and Authorization:** 	Local accounts with Kubernetes RBAC
  - Rest all leave to defaults
- **Networking**
  - **Network Configuration:** Azure CNI
  - Review all the auto-populated details 
    - Virtual Network
    - Cluster Subnet
    - Kubernetes Service address range
    - Kubernetes DNS Service IP Address
    - DNS Name prefix
  - **Traffic routing:** leave to defaults
  - **Security:** Leave to defaults
- **Integrations**
  - **Azure Container Registry:** None
  - All leave to defaults
- **Advanced**
  -  All leave to defaults
- **Tags**
  - leave to defaults
- **Review + Create**
  - Click on **Create**


## Step-03: Cloud Shell - Configure kubectl to connect to AKS Cluster
- Go to https://shell.azure.com
```t
# Template
az aks get-credentials --resource-group <Resource-Group-Name> --name <Cluster-Name>

# Replace Resource Group & Cluster Name
az aks get-credentials --resource-group aks-rg1 --name aksdemo1

# List Kubernetes Worker Nodes
kubectl get nodes 
kubectl get nodes -o wide
```

## Step-04: Explore Cluster Control Plane and Workload inside that
```t
# List Namespaces
kubectl get namespaces
kubectl get ns

# List Pods from all namespaces
kubectl get pods --all-namespaces

# List all k8s objects from Cluster Control plane
kubectl get all --all-namespaces
```

## Step-05: Explore the AKS cluster on Azure Management Console
- Explore the following features on high-level
- **Overview**
  - Activity Log
  - Access Control (IAM)
  - Security
  - Diagnose and solver problems
  - Microsoft Defender for Cloud
- **Kubernetes Resources**  
  - Namespaces
  - Workloads
  - Services and Ingress
  - Storage
  - Configuration
- **Settings**
  - Node Pools
  - Cluster Configuration
  - Extensions + Applications
  - Backup (preview)
  - Open Service Mesh
  - GitOps
  - Automated Deployments (preview)
  - Policies
  - Properties
  - Locks
- **Monitoring**
  - Insights
  - Alerts
  - Metrics
  - Diagnostic Settings
  - Advisor Recommendations
  - Logs
  - Workbooks
- **Automation** 
  - Tasks
  - Export Template    



## Step-06: Local Desktop - Install Azure CLI and Azure AKS CLI
```t
# Install Azure CLI (MAC)
brew update && brew install azure-cli

# Login to Azure
az login

# Install Azure AKS CLI
az aks install-cli

# Configure Cluster Creds (kube config)
az aks get-credentials --resource-group aks-rg1 --name aksdemo1

# List AKS Nodes
kubectl get nodes 
kubectl get nodes -o wide
```
- **Reference Documentation Links**
- https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
- https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

## Step-07: Deploy Sample Application and Test
- Don't worry about what is present in these two files for now. 
- By the time we complete **Kubernetes Fundamentals** sections, you will be an expert in writing Kubernetes manifest in YAML.
- For now just focus on result. 
```t
# Deploy Application
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

## Step-07: Clean-Up
```t
# Delete Applications
kubectl delete -f kube-manifests/
```

## References
- https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

## Why Managed Identity when creating Cluster?
- https://docs.microsoft.com/en-us/azure/aks/use-managed-identity