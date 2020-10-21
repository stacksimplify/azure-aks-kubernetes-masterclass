# Azure DevOps

## Step-01: Introduction

## Step-02: Create Github Project and Check-In Code
- Create a Github Repo with Name: azure-aks-app1-github-dockerhub
- Create Local folders
```
# Create a folder for all Repos we are going to create 
mkdir azure-devops-demo-repos
cd azure-devops-demo-repos

# Create a Directory for Repo
mkdir azure-aks-app1-github-dockerhub
cd azure-aks-app1-github-dockerhub
```
- Copy all files from `Giti-Repository-files` folder to our new repo folder `azure-aks-app1-github-dockerhub`
```
# Initialize Git Repo
cd azure-aks-app1-github-dockerhub
git init

# Do local Commit
git add .
git commit -am "V1 Base Commit"

# Link Github Remote Repository
git remote add origin https://github.com/stacksimplify/azure-aks-app1-github-dockerhub1.git

# Push to Remote Repository
git push --set-upstream origin master

# Go to Github Repo - Refresh and check files appeared in githbu repo
https://github.com/stacksimplify/azure-aks-app1-github-dockerhub
```


## Step-03: (PENDING) Review github checked-in files
- kube-manifests
- pipeline-backup-files
- Dockerfile
- index.html

## Step-04: Creat DevOps Organization
- Go to
  - https://dev.azure.com/
  - Sign in to Azure DevOps
- Our Organization will be automatically created and if you want to manually create organization you can create one. 


## Step-05 : Create DevOps Project
- Project Name: azure-aks-app1-github-dockerhub
- Project Description: AKS CICD Pipelines with Github and Dockerhub
- Visibility: Private
- Advanced: Leave to defaults
  - Version Control: Git
  - Work Item Process: Basic

## Step-06: Create Basic Build Pipeline
- Go to Pipelines -> Create New Pipeline
- Where is your Code?: Github  

## Step-06: Create Github Connections (NEED TO CHECK IF THIS IS NEEDED or NOT)
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
