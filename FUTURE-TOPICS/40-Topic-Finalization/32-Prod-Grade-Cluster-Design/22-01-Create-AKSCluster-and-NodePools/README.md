## Step-01: Introduction

## Step-02: Create Cluster with System Node Pool
```
# Setup Environment Variables
export RESOURCE_GROUP=aks-prod
export REGION=centralus
export AKS_CLUSTER=aksdemo-prod
echo $RESOURCE_GROUP, $REGION, $AKS_CLUSTER

# Create Resource Group
az group create --location ${REGION} \
                --name ${RESOURCE_GROUP}

# Create AKS cluster and enable the cluster autoscaler
az aks create --resource-group ${RESOURCE_GROUP} \
              --name ${AKS_CLUSTER} \
              --zones {1, 2, 3} \
              --enable-managed-identity \
              --generate-ssh-keys \
              --node-count 1 \
              --enable-cluster-autoscaler \
              --min-count 1 \
              --max-count 5 \


# Configure Credentials
az aks get-credentials --name ${AKS_CLUSTER}  --resource-group ${RESOURCE_GROUP} 

# List Nodes
kubectl get nodes
kubectl get nodes -o wide

# Cluster Info
kubectl cluster-info

# kubectl Config Current Context
kubectl config current-context
```


## Step-03: Create User Node Pool

 az aks get-versions --location centralus -o table
## Cluster Features
- Region - will be picked based on Resource group location
- Zones: 1, 2, 3
- k8s Version: default
- Node Size: 
- Node Count: 2
- Node Pool Name: System-NodePool 
- Virtual Nodes: Enable (not default)
- VM Scale Sets: enabled by default
- Authentication Method: default is service principal, Use Managed Identity
- Kubernetes Role-based access control (RBAC): Enabled by default
- AKS-managed Azure Active Directory: disabled by default
- Node pool OS disk encryption: Default Encryption at rest with a platform managed key
### Networking
- Networking: default kubenet, Use Azure CNI
  - Virtual Network: vnet name
  - Cluster Subnet: 10.240.0.0/16
  - Kubernetes Service Address Range: 10.0.0.0/16
  - Kubernetes DNS Service IP: 10.0.0.10
  - Docker Bridge Address: 172.17.0.1/16
  - DNS Name prefix: clustername-dns
- Load balancer: standard (by default)
- Enable HTTP application routing: disabled by default (not needed for prod grade clusters)
- Security
  - Enable private cluster: disabled by default
  - Set authorized IP ranges: disabled by default, enable and use with your IP Range if your K8S API Server is public
  - Network policy: None (default),  Use Azure
### Integrations
- Container Monitoring: disabled by default (Enable - requires log analytics space)  
- Azure Policy:  Disabled by default (Enable if required)


