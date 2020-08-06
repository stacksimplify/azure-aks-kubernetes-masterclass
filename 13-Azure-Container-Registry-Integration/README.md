# Azure Container Registry ACR & AKS


## Step-01: Introduction

## Step-02: Create Azure Container Registry
- Go to Services -> Container Registries
- Click on **Add**
- Subscription: StackSimplify-Paid-Subsciption
- Resource Group: aks-rg1
- Registry Name: acrforaksdemo1
- Location: East US
- SKU: Basic  (Pricing Note: $0.167 per day)
- Click on **Review + Create**
- Click on **Create**

## Step-03: For existing AKS Cluster -  Attach ACR
```
# Export Required Values
export AKS_NAME=aksdemo1
export RG_NAME=aks-rg1
export ACR_NAME=acrforaksdemo1

# Verify export worked
echo $AKS_NAME, $RG_NAME, $ACR_NAME

# Update AKS Cluster to attach ACR
az aks update -n $AKS_NAME -g $RG_NAME --attach-acr $ACR_NAME
```
- Important Note: If your ACR is in different region, please use ACR resource id
```
# Get ACR Resource ID
az acr show -n $ACR_NAME --query "id" -o tsv
```

## Step-04: Build and Push Docker Image to ACR using CloudShell
```
# Change Directory where Dockerfile is present
cd docker-manifests

az acr build --image sample/hello-world:v1 \
  --registry myContainerRegistry008 \
  --file Dockerfile .
```


## Pricing of Azure Container Registry
- https://azure.microsoft.com/en-us/pricing/details/container-registry/

## References
- https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration
- https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster