# Azure DevOps -  Release Pipelines

## Step-01: Introduction
- Understand Release Pipelines concept

[![Image](https://www.stacksimplify.com/course-images/azure-devops-release-pipelines-for-azure-aks.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)

## Step-02: Create Namespaces
```
# Create Namespaces
kubectl create ns dev
kubectl create ns qa
kubectl create ns staging
kubectl create ns prod
```

## Step-03: Create Release Pipeline - Add Artifacts
- Release Pipeline Name: 01-app1-release-pipeline

### Add Artifact
- Source Type: Build
- Project: leave to default (azure-aks-app1-github-acr)
- Source (Build Pipeline): 03-buildpush-to-acr-and-publish-artifacts-to-azure-pipelines
- Default Version: Latest (auto-populated)
- Source Alias: leave to default (auto-populated)
- Click on **Add**

### Continuous Deployment Trigger
- Continuous deployment trigger: Enabled

## Step-04: Release Pipeline - Create Dev Stage
- Go to Pipelines -> Releases
- Create new **Release Pipeline**
### Create Dev Pipeline and Test
- Stage Name: Dev
- Create Task 
- Agent Job: Change to Ubunut Linux
#### Add Task: Deploy to Kubernetes
- Display Name: deploy
- Action: deploy
- Kubernetes Service Connection: Create Connection
  - Authentication Method: Azure Subscription
  - Cluster Name: aksdemo1
  - Namespace: dev
  - Service Connection Name: dev-ns-aksdemo1-svc-conn
  - Click on Save
- Namespace: dev
- Strategy: None
- Manifest: Select 01-Deployment-and-LoadBalancer-Service.yml  from build artifacts
```
# Sample Value for Manifest after adding it
Manifest: $(System.DefaultWorkingDirectory)/_03-buildpush-to-acr-and-publish-artifacts-to-azure-pipelines/kube-manifests/01-Deployment-and-LoadBalancer-Service.yml  
```
- Container: acrforaksdemo1.azurecr.io/app1nginxaks
- Rest all leave to defaults
- Click on **SAVE** to save release

## Step-05: Check-In Code and Test
- Update index.html
```
# Commit and Push
git commit -am "V11 Commit"
git push
```
- View Build Logs
- View Dev Release logs
- Access App after successful deployment
```
# Get Public IP
kubectl get svc -n dev

# Access Application
http://<Public-IP-from-Get-Service-Output>
```

## Step-06: Create QA, Staging and Prod Release Stages
- Create QA, Staging and Prod Stages
- Add Email Approvals
- Click on **SAVE** to save release

## Step-07: Check-In Code and Test
- Update index.html
```
# Commit and Push
git commit -am "V12 Commit"
git push
```
- View Build Logs
- View Dev Release logs
- Access App after successful deployment
- Approve deployment at qa, staging and prod stages
```
# Get Public IP
kubectl get svc -n dev
kubectl get svc -n qa
kubectl get svc -n staging
kubectl get svc -n prod


# Access Application
http://<Public-IP-from-Get-Service-Output>
```
