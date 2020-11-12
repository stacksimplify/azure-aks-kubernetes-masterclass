# Provision Azure AKS using Terraform using Azure DevOps

## Step-01: Introduction

## Step-02: Install Azure Market Place Plugins in Azure DevOps
- Terraform 1 (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)
- Terraform 2 (https://marketplace.visualstudio.com/items?itemName=charleszipp.azure-pipelines-tasks-terraform)

## Step-03: Create Github Repository

### Create Github Repository in Github
- Create Repository in your github
- Name: azure-devops-aks-kubernetes-terraform-pipeline
- Descritpion: Provision AKS Cluster using Azure DevOps Pipelines
- Repository Type: Public or Private (Your Choice)
- Click on **Create Repository**

### Copy files, Initialize Local Repo, Push to Remote Git Repo
```
# Create folder in local deskop
cd azure-devops-aks-demo-repos
mkdir azure-devops-aks-kubernetes-terraform-pipeline
cd azure-devops-aks-kubernetes-terraform-pipeline

# Copy files from Git-Repo-Files folder to new folder created in local desktop
main.tf
outputs.tf
variables.tf
azure-pipelines-backup-for-reference.yml
README.md

# Initialize Git Repo
cd azure-devops-aks-kubernetes-terraform-pipeline
git init

# Add Files & Commit to Local Repo
git add .
git commit -am "First Commit"

# Add Remote Origin and Push to Remote Repo
git remote add origin https://github.com/stacksimplify/azure-devops-aks-kubernetes-terraform-pipeline.git
git push --set-upstream origin master 

# Verify the same on Github Repository
Refersh browser for Repo you have created
Example: https://github.com/stacksimplify/azure-devops-aks-kubernetes-terraform-pipeline.git
```     

## Step-05: Review Terraform files
- main.tf
- variables.tf
- outputs.tf
- azure-pipelines-backup-for-reference.yml


## Step-06: Create New Azure DevOps Project for IAC
- Go to -> Azure DevOps -> Select Organization -> Create New Project
- Project Name: terraform-azure-aks
- Project Descritpion: Provision Azure AKS Cluster using Azure DevOps & Terraform
- Visibility: Private
- Click on **Create**

## Step-07: Create Azure RM Service Connection for Terraform Commands
- This is a pre-requisite step required during Azure Pipelines
- We can create from Azure Pipelines -> Terraform commands screen but just to be in a orderly manner we are creating early.
- Go to -> Azure DevOps -> Select Organization -> Select project **terraform-azure-aks**
- Go to **Project Settings**
- Go to Pipelines -> Service Connections -> Create Service Connection
- Choose a Service Connection type: Azure Resource Manager
- Authentication Method: Service Princiapl (automatic)
- Scope Level: Subscription
- Subscription: Pay-As-You-Go
- Resource Group: LEAVE EMPTY
- Service Connection Name: terraform-aks-azurerm-svc-con
- Description: Azure RM Service Connection for provisioning AKS Cluster using Terraform on Azure DevOps
- Security: Grant access permissions to all pipelines (check it - leave to default)
- Click on **SAVE**


## Step-08: Create Azure Pipeline to Provision AKS Cluster
- Go to -> Azure DevOps -> Select Organization -> Select project **terraform-azure-aks**
- Go to Pipelines -> Pipelines -> Create Pipeline
### Where is your Code?
  - Github
  - Select a Repository: stacksimplify/azure-devops-aks-kubernetes-terraform-pipeline
  - Provide your github password
  - Click on **Approve and Install** on Github
### Configure your Pipeline
 - Select Pipeline: Starter Pipeline  
 - Design your Pipeline
 - Pipeline Name: 01-terraform-provision-aks-cluster-pipeline.yml
### Add Task: Terraform Initialize
- Select Task: Terraform CLI
- Command: init
- Configuration Directory: $(System.DefaultWorkingDirectory)
- Command Options: leave empty
- Backend Type: azurerm
- Azure RM Configuration: 
  - Backend Azure Subscription: terraform-aks-azurerm-svc-con
- Create Backend (if not exists): check it
- Resource Group Name: terraform-state-storage-rg1
- Resource Group Location: centralus
- Storage Account Name: tfsabackendkalyan123 (Should be unique across Azure Cloud)
- Storage Account SKU: Standard_RAGRS (leave to default)
- Container Name: tfcontainer
- Key: k8s-dev.tfstate
- Click on **Add**

### Add Task: Terraform Apply
- Select Task: Terraform CLI
- Command: apply
- Configuration Directory: $(System.DefaultWorkingDirectory)
- Environment Azure Subscription (select if not configured inside terraform code): terraform-aks-azurerm-svc-con
- Command Options: Leave empty
- Click on **Add**

### Pipeline Save and Run
- Click on **Save and Run**
- Click on **Job** and Verify Pipeline

## Step-09: Verify all the resources created 
### Verify Pipeline logs
- Verify Pipeline logs for all the tasks

### Verify new Storage Account in Azure Mgmt Console
- Verify if `terraform init` command ran successfully from Azure Pipelines
- Verify Storage Account
- Verify Storage Container
- Verify tfstate file got created in storage container

### Verify new AKS Cluster in Azure Mgmt Console
- Verify Resource Group 
- Verify AKS Cluster

### Connect to AKS Cluster
```
# Setup kubeconfig
az aks get-credentials --resource-group <Resource-Group-Name>  --name <AKS-Cluster-Name>
az aks get-credentials --resource-group terraform-aks-rg1  --name aks-dev-k8s-cluster

# List Kubernetes Worker Nodes
kubectl get nodes
```

### Final Pipeline Code for reference
```yaml
trigger:
- master

pool:
  vmImage: 'ubuntu-latest'

steps:
- script: echo Hello, world!
  displayName: 'Run a one-line script'

# Terraform Initialize
- task: TerraformCLI@0
  inputs:
    command: 'init'
    backendType: 'azurerm'
    backendServiceArm: 'terraform-aks-azurerm-svc-con'
    ensureBackend: true
    backendAzureRmResourceGroupName: 'terraform-state-storage-rg1'
    backendAzureRmResourceGroupLocation: 'centralus'
    backendAzureRmStorageAccountName: 'tfsabackendkalyan123'
    backendAzureRmContainerName: 'tfcontainer'
    backendAzureRmKey: 'k8s-dev.tfstate'

# Terraform Apply
- task: TerraformCLI@0
  inputs:
    command: 'apply'
    environmentServiceName: 'terraform-aks-azurerm-svc-con'
``` 

## Step-10: Update nodes to 2 in main.tf
- Update number of nodes 2 in `main.tf` and check-in code
```
# First sync local git repo with remote repo
cd azure-devops-aks-kubernetes-terraform-pipeline
git pull

# Update main.tf
  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

# Git Commit and Push
git status
git commit -am "Nodes changed to 2"
git push  
```

## Step-11: Verify Pipeline logs
- Verify Pipeline logs
- Once pipeline run completed verify nodes
```
# Get Nodes
kubectl get nodes
```


## Step-12: Generate SSH Public Key
```
# Create Public Key for SSH Access
mkdir aks-ssh-keys
cd aks-ssh-keys
ssh-keygen -m PEM -t rsa -b 4096 
file name: id_aks_ubuntu_rsa
Passphrase: empty

# List files
ls -lrt
id_aks_ubuntu_rsa
id_aks_ubuntu_rsa.pub

# Note:  We should have these files in our git repos for security Reasons
```