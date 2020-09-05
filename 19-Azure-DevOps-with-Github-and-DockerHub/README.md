# Azure DevOps

## Step-01: Introduction

## Step-02: Create Github Project and Check-In Code
- Github Repo Name: azure-aks-nginx-github-dockerhub

## Step-03: Creat DevOps Organization
- Go to
  - https://dev.azure.com/
- Our Organization will be automatically created.

## Step-04: Create DevOps Project
- Project Name:
- Project Description: 

## Step-05: Create Github Connections (NEED TO CHECK IF THIS IS NEEDED or NOT)
- Go to DevOps Project -> azure-aks-nginx-github-dockerhub
- Go to Project Settings -> Boards -> Github connections
- Click on **Connect your Github Account**
- Add GitHub repositories: azure-aks-nginx-github-dockerhub
- Click on **SAVE**
- Click on **Approve, Install, & Authorize**


## Step-00: Create Service Connection to Github Repository (NEED TO CHECK IF THIS IS NEEDED or NOT)
- **Pre-requisite:** You should have a account on Docker Hub
- Go to Project Settings -> Pipelines -> Service Connections
- Click on **Create Service Connection**
- Select **Docker Registry** and Click **Next**
- Registry Type: Docker Hub
- Docker Id: stacksimplify (Provide your Docker Username)
- Docker Password: 
- Email:
- Service Connection Name: DockerHubStackSimplify
- Security: Check box enable - grant access permissions to all pipelines
- Click on **Verify and Save**

## Step-00: Create Service Connection to Docker Registry
- **Pre-requisite:** You should have a account on Docker Hub
- Go to Project Settings -> Pipelines -> Service Connections
- Click on **Create Service Connection**
- Select **Docker Registry** and Click **Next**
- Registry Type: Docker Hub
- Docker Id: stacksimplify (Provide your Docker Username)
- Docker Password: 
- Email:
- Service Connection Name: DockerHubStackSimplify
- Security: Check box enable - grant access permissions to all pipelines
- Click on **Verify and Save**

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
