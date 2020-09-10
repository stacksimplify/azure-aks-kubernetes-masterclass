# Azure DevOps - Build, Push to ACR and Deploy to AKS

## Step-01: Introduction
- Add a Deployment Pipeline in Azure Pipelines to Deploy newly built docker image from ACR to Azure AKS

[![Image](https://www.stacksimplify.com/course-images/azure-devops-pipelines-deploy-to-aks.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)

## Step-02: Create Pipeline for Deploy to AKS
- Go to Pipleines -> Create new Pipleine
- Where is your code?: Github
- Select a Repository: "select your repo" (stacksimplify/azure-aks-app1-github-acr)
- Configure your pipeline: Deploy to Azure Kubernetes Service
- Select Subscription: stacksimplify-paid-subscription (select your subscription)
- Provide username and password (Azure cloud admin user)
- Deploy to Azure Kubernetes Service
  - Cluster: aksdemo1
  - Namespace: existing (default)
  - Container Registry: acsforaksdemo1
  - Image Name: app1nginxaks
  - Service Port: 80
- Click on **Validate and Configure**
- Review your pipeline YAML
 -  Change Pipeline Name: 02-docker-build-push-to-acs-deployt-to-aks-pipeline.yml
 - Click on **Save and Run**
 - Commit Message: Docker, Build, Push and Deploy to AKS
 - Commit directly to master branch: check
 - Click on  **Save and Run**

 ## Step-03: Verify Build and Deploy logs
 - Build will pass
 - Deploy should fail due to two reasons
  - k8s Deployment version used is not compatible
  - k8s selector not used in Deployment manifest
  - Fix those things in next step and push changes to git repo

 ## Step-04: Sync Local Git Repo with Remote Git Repo with new pipeline chnages
 ```
 # Pull
 git pull
 ```

 ## Step-05: Fix deployment.yml & Check-In to Git Repo
 ### File name: manifests/deployment.yml
 ```yaml
 # Change-1: Change apiVersion from apps/v1beta1 to apps/v1
 apiVersion : apps/v1

 # Change-2: Add spec.selector.matchLabels
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app1nginxaks1
 ```
 ### Check-in Changes to Git Repo

 ```
 # Commit
 git add .
 git commit -am "deployment.yml fixes"
 git push

 ```

### Verify Build and Deploy pipeline logs
- Go to Pipeline -> Verify logs
```
# Get Public IP
kubectl get svc

# Access Application
http://<Public-IP-from-Get-Service-Output>
```

## Step-06: Rename Pipeline Name
- Go to pipeline -> Rename / Move
- Name: 02-Docker-BuildPushToACR-DeployToAKSCluster

## Step-07: Make Changes to index.html and Verify
```
# Make changes to index.html
Change version to V3

# Commit and Push
git commit -am "V3 commit"
git push

# Verify Build and Deploy logs
- Build logs
- Pipeline logs

# Get Public IP
kubectl get svc

# Access Application
http://<Public-IP-from-Get-Service-Output>

``` 

## Step-08: Disable Pipeline
- Go to Pipeline -> 01-Docker-Build-and-Push-to-ACR -> Settings -> Disable


## Step-09: Review Pipeline code
- Click on Pipeline -> Edit Pipeline
- Review pipeline code
- Review Service Connections
 ```yaml
 # Deploy to Azure Kubernetes Service
# Build and push image to Azure Container Registry; Deploy to Azure Kubernetes Service
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
- master

resources:
- repo: self

variables:

  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: 'fb9c2af0-54f0-428c-866a-7332f0aa524b'
  imageRepository: 'app1nginxaks'
  containerRegistry: 'acrforaksdemo1.azurecr.io'
  dockerfilePath: '**/Dockerfile'
  tag: '$(Build.BuildId)'
  imagePullSecret: 'acrforaksdemo115229169-auth'

  # Agent VM image name
  vmImageName: 'ubuntu-latest'
  

stages:
- stage: Build
  displayName: Build stage
  jobs:  
  - job: Build
    displayName: Build
    pool:
      vmImage: $(vmImageName)
    steps:
    - task: Docker@2
      displayName: Build and push an image to container registry
      inputs:
        command: buildAndPush
        repository: $(imageRepository)
        dockerfile: $(dockerfilePath)
        containerRegistry: $(dockerRegistryServiceConnection)
        tags: |
          $(tag)
          
    - upload: manifests
      artifact: manifests

- stage: Deploy
  displayName: Deploy stage
  dependsOn: Build

  jobs:
  - deployment: Deploy
    displayName: Deploy
    pool:
      vmImage: $(vmImageName)
    environment: 'stacksimplifyazureaksapp1githubdockerhub1-6349.default'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: KubernetesManifest@0
            displayName: Create imagePullSecret
            inputs:
              action: createSecret
              secretName: $(imagePullSecret)
              dockerRegistryEndpoint: $(dockerRegistryServiceConnection)
              
          - task: KubernetesManifest@0
            displayName: Deploy to Kubernetes cluster
            inputs:
              action: deploy
              manifests: |
                $(Pipeline.Workspace)/manifests/deployment.yml
                $(Pipeline.Workspace)/manifests/service.yml
              imagePullSecrets: |
                $(imagePullSecret)
              containers: |
                $(containerRegistry)/$(imageRepository):$(tag)


 ``` 