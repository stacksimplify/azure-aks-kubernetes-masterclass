# Azure DevOps with Azure Repos and Azure Container Registry ACR

## Step-01: Introduction

## Step-02: Creat DevOps Organization & Project
- Go to
  - https://dev.azure.com/
- Our Organization will be automatically created (if not present)
- **Create New Organization**
  - Name your Azure DevOps organization: dev.azure.com/stacksimplify2
  - We'll host your projects in: East Asia
- **Create DevOps Project**    
  - Project Name: azure-aks-nginx-repos-acr
  - Project Description: 
```
1. Azure AKS Kubernetes Cluster
2. Nginx Application
3. Azure Repos as Git Repository
4. Azure Container Registries - ACR
```

## Step-03: Create local git Repo and Push to Azure Repos
- Go to DevOps Project -> azure-aks-nginx-repos-acr -> Repos
- Click on **Generate Git Credentials**
```
Azure Repos Git Creds
Username: stacksimplify
Password: ugp7q3l7y74kzmqxqdsnfsr26fpxxpv5w4mcih3ezpchto54qbrq
```
- Create a folder Azure Repos and clone the Repository from Azure Repos
```
mkdir azure-repos
cd azure-repos
git clone https://stacksimplify1@dev.azure.com/stacksimplify1/azure-aks-nginx-repos-acr/_git/azure-aks-nginx-repos-acr
cd azure-aks-nginx-repos-acr
```
- Copy Files & Folders
- **Giti-Repository-files**
  - Dockerfile
  - index.html
  - kube-manifests
    - 01-Deployment.yml
    - 02-LoadBalancer-Service.yml
  - pipeline-backup-files
    - azure-pipelines.yml
- Commit and Push to Azure Repos
```
# Commit to Local Repo and Push to Azure Repos
git status
git add .
git commit -am "V1 Commit"
git push
```

## Step-04: Create Service Connection to Azure Container Registry
- **Pre-requisite:** You should have a account on Docker Hub
- Go to Project Settings -> Pipelines -> Service Connections
- Click on **Create Service Connection**
- Select **Docker Registry** and Click **Next**


## Step-00: Create Azure AKS Service Connection 
- Go to Project Settings -> Pipelines -> Service Connections
- Click on **Create Service Connection**
- Search for **Kubernetes**
- **Authentication Method:** Azure Subscription
- **Azure Subscription:** Select your Azure Paid Subscription (Pay-As-You-Go)
- **Cluster:** aksdemo1
- **Namespace:** default
- **Service Connection Name:** k8s-aksdemo1-svc-connection
- **Description:** AKS DEMO1 cluster Service Connection for Azure Pipelines
- Click on **Save**

## Step-00: Create Build Pipeline







# #########################
# AZURE REPO STUFF

## Step-03: Create Project, Generate Git Credentials, Capture Git Repo URL
- Project Name: aks-nginxapp1
- Visibility: Private
- Click on **Create Project**
- Go to **Repos**
- Generate **git Credentials** and make a note of all 3 below.
```
Git Clone URL: https://stacksimplify1@dev.azure.com/stacksimplify1/aks-nginxapp1/_git/aks-nginxapp1
Username: stacksimplify
Password: vyfiwg5kev6zieh4spv63naelqavofu7rtzkvi2424pngfrc5bgq
```

## Step-04: Clone Git Repo, Copy Nginx Files, Commit and Push
```
# Create a folder in local desktop
mkdir AKS-DEVOPS-DEMO1
cd AKS-DEVOPS-DEMO1

# Execure below commands
git clone https://stacksimplify1@dev.azure.com/stacksimplify1/aks-nginxapp1/_git/aks-nginxapp1

# Go to that Git repo dierctory
cd aks-nginxapp1/
git status

# Copy below listed two files from docker-manifests folder
Dockerfile
index.html 

# Git Add, Commit and Push
git add .
git commit -am "First Commit"
git push

# Verify the same in Azure DevOps Management Console
- Two files should be displayed in Azure Repos
```

## Step-05: 



## References
-  https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops
- 
