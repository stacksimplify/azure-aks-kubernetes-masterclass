# DevOps using Github Actions

## Step-01: Introduction
- What is Github Actions?
- Understand Github Actions Pricing


## Step-02: Create Resource Group
```
# Setup Environment Variables
export RESOURCE_GROUP=aks-rg1-github-actions
export REGION=centralus
export CONTAINER_REGISTRY=acraksgademo1
export AKS_CLUSTER=aks-githubactions-demo

# Create Resource Group
az group create --location ${REGION} \
                --name ${RESOURCE_GROUP}
```

## Step-03: Create Azure Container Registry
```
# Create Azure Container Registy
az acr create --name ${CONTAINER_REGISTRY} \
              --resource-group ${RESOURCE_GROUP} \
              --location ${REGION} \
              --sku "Basic" \
              --admin-enabled true 
              
```

## Step-04: Create AKS Cluster 
- Create AKS Cluster by associating it with Azure Container Registry
```
# Create Cluster
az aks create --name ${AKS_CLUSTER} \
              --resource-group ${RESOURCE_GROUP} \
              --location ${REGION} \
              --attach-acr ${CONTAINER_REGISTRY} \
              --node-vm-size Standard_DS2_v2 \
              --node-count 1

# Configure Credentials
az aks get-credentials --name ${AKS_CLUSTER}  --resource-group ${RESOURCE_GROUP} 

# List Nodes
kubectl get nodes
```

## Step-05: Create Github Repository Remote & Local
### Create Github Repository on Github
- Create New Repository
- Name: azure-aks-devops-github-actions
- Description: Azure AKS DevOps using Github Actions
- Repo Type: Public or Private (your choice)
- Click on **Create Repository**


### Create Local Repository and Push Changes to Remote Git Repo
- Copy all files from `Github-Repo-Files` folder to your local repo
```
# Create Local Repo folder
cd azure-devops-demos
mkdir azure-aks-devops-github-actions
cd azure-aks-devops-github-actions

# Copy Files
Copy all files from `Github-Repo-Files` folder to your local repo

# Initialize Repo
git init
git add .
git commit -am "First Commit" 
git remote add origin https://github.com/stacksimplify/azure-aks-devops-github-actions.git
git push --set-upstream origin master
```

## Step-06: Create Service Principal 
```
# Export Commands
az account list --output table
export SUBSCRIPTION_ID=82808767-144c-4c66-a320-b30791668b0a

# Template
az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> --sdk-auth

# Replace
az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP} --sdk-auth
```

## Step-07: Configure Github Secrets
### AZURE_CREDENTIALS
- Name: AZURE_CREDENTIALS
- Value: Output from Step-06
- Below is sample for reference
```json
{
  "clientId": "621530f6-76c0-45b8-b894-4303321b805d",
  "clientSecret": "AMG-Pzpj.oSbPF2fR4uDqK514.rbRjKqmp",
  "subscriptionId": "82808767-144c-4c66-a320-b30791668b0a",
  "tenantId": "c81f465b-99f9-42d3-a169-8082d61c677a",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

### Azure Container Registry Credentials
- Get Registry username and password from Azure Container Registry
- Go to Services -> Container Registries -> acraksgademo1 -> Access Keys
```
REGISTRY_USERNAME: acraksgademo1
REGISTRY_PASSWORD: xxxxxxxxxx
```

## Step-08: Crate Githbu Actions workflow
- Go to Github Repo -> azure-aks-devops-github-actions -> Click on **Actions**
- Review workflow `main.yml`
- Save and commit
```yaml
# This workflow will build a docker container, publish it to Azure Container Registry, and deploy it to Azure Kubernetes Service.
#
# To configure this workflow:
#
# 1. Set up the following secrets in your workspace: 
#     a. REGISTRY_USERNAME with ACR username
#     b. REGISTRY_PASSWORD with ACR Password
#     c. AZURE_CREDENTIALS with the output of `az ad sp create-for-rbac --sdk-auth`
#
# 2. Change the values for the REGISTRY_NAME, CLUSTER_NAME, CLUSTER_RESOURCE_GROUP and NAMESPACE environment variables (below).
on: [push]

# Version: V1
# Environment variables available to all jobs and steps in this workflow
#${REGISTRY_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}
env:
  REGISTRY_NAME: acraksgademo1
  CLUSTER_NAME: aks-githubactions-demo
  CLUSTER_RESOURCE_GROUP: aks-rg1-github-actions
  NAMESPACE: default
  IMAGE_NAME: app1-nginx
  IMAGE_TAG: ${{ github.sha }}
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    
    # Connect to Azure Container registry (ACR)
    - uses: azure/docker-login@v1
      with:
        login-server: ${{ env.REGISTRY_NAME }}.azurecr.io
        username: ${{ secrets.REGISTRY_USERNAME }} 
        password: ${{ secrets.REGISTRY_PASSWORD }}
    
    # Container build and push to a Azure Container registry (ACR)
    - run: |
        docker build . -t ${{ env.REGISTRY_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ github.sha }}
        docker push ${{ env.REGISTRY_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ github.sha }}
    
    # Set the target Azure Kubernetes Service (AKS) cluster. 
    - uses: azure/aks-set-context@v1
      with:
        creds: '${{ secrets.AZURE_CREDENTIALS }}'
        cluster-name: ${{ env.CLUSTER_NAME }}
        resource-group: ${{ env.CLUSTER_RESOURCE_GROUP }}
    
    # Create namespace if doesn't exist
    - run: |
        kubectl create namespace ${{ env.NAMESPACE }} --dry-run -o json | kubectl apply -f -
    
    # Create imagepullsecret for Azure Container registry (ACR)
    - uses: azure/k8s-create-secret@v1
      with:
        container-registry-url: ${{ env.REGISTRY_NAME }}.azurecr.io
        container-registry-username: ${{ secrets.REGISTRY_USERNAME }}
        container-registry-password: ${{ secrets.REGISTRY_PASSWORD }}
        secret-name: ${{ env.REGISTRY_NAME }}-registry-connection
        namespace: ${{ env.NAMESPACE }}
    
    # Deploy app to AKS
    - uses: azure/k8s-deploy@v1
      with:
        manifests: |
          manifests/deployment.yml
          manifests/service.yml
        images: |
          ${{ env.REGISTRY_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ github.sha }}
        imagepullsecrets: |
          ${{ env.REGISTRY_NAME }}-registry-connection
        namespace: ${{ env.NAMESPACE }}
```

## Step-09: Review Build logs, ACR and AKS Deployment
- Review build logs
- Verify Azure Container Regisry to confirm if new container image pushed to ACR
- Verify Kubernetes deployment and service got created
```
# List Pods
kubectl get pods

# List Services
kubectl get svc

# Access Application
http://<Public-IP-from-Get-SVC-Outputs>
```

## Step-10: Make changes to index.html and check-in code
```
# Change index.html
change to v2

# Commit and Push
git commit -am "App V2 Commit"
git push
```

## Step-11: Review Build logs, ACR and AKS Deployment
- Review build logs
- Verify Azure Container Regisry to confirm if new container image pushed to ACR
- Verify Kubernetes deployment and service got created
```
# List Pods
kubectl get pods

# List Services
kubectl get svc

# Access Application
http://<Public-IP-from-Get-SVC-Outputs>
```

## Step-12: Clean-Up
```
# Delete Resource Group
az group delete -n ${RESOURCE_GROUP}
```


## References
- https://docs.microsoft.com/en-us/azure/aks/kubernetes-action
- https://github.com/marketplace/actions/deploy-to-kubernetes-cluster

