# Azure DevOps - Build Pipeline - Publish Artifacts

## Step-01: Introduction
- We are going to Build and Push Docker Image to Azure Container Registry
- In addition, we need to publish our Kubernetes Manifests to Azure Pipelines so that we can leverage the same in Release Pipelines.


## Step-02: Create a Build Pipeline and Publish Artifacts to Azure Pipelines
- Go to Pipelines -> Create New Pipeline
- Where is your Code?: Github  
- Select Repository: azure-devops-github-acr-aks-app1
- Configure Your Pipeline: Docker (Build and Push Image to Azure Container Registry )
- Select an Azure Subscription: stacksimplify-paid-subscription
- Continue (Login as admin user)
- Container Registry: aksdevopsacr
- Image Name: app1-nginx
- Dockerfile: $(Build.SourcesDirectory)/Dockerfile
- Click on **Validate and Configure**
- Change Pipeline Name: 01-docker-build-and-push-to-acr-pipeline.yml
- Click on **Save and Run**
- Commit Message: Pipeline-1: Docker Build and Push to ACR
- Commit directly to master branch: check
- Click on **Save and Run**

 ## Step-03: Verify Build and Deploy logs
 - Build stage should pass. Verify logs
 - Deploy stage should pass. Verify logs





- 03-custom-pipeline-buildandpush-to-acr-and-publish-artifacts.yml

```yaml
## Publish Artifacts pipeline code in addition to Build and Push
    - bash: echo Before copying to Build Artifact Directory; ls -R $(Build.ArtifactStagingDirectory)        
    # Task: Copy files (Copy files from a source folder to target folder)    
    - task: CopyFiles@2
      inputs:
        SourceFolder: '$(System.DefaultWorkingDirectory)/kube-manifests'
        Contents: '**'
        TargetFolder: '$(Build.ArtifactStagingDirectory)'
        OverWrite: true
    # List files from Build Artifact Staging Directory - After Copy
    - bash: echo After copying to Build Artifact Directory; ls -R $(Build.ArtifactStagingDirectory)        
    # Task: Publish build artifacts (Publish build to Azure Pipelines)    
    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)'
        ArtifactName: 'kube-manifests'
        publishLocation: 'Container'
    - bash: echo After Published Build Artifacts to Pipeline; ls -R $(Build.ArtifactStagingDirectory)                

```