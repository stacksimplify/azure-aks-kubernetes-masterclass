# Azure DevOps - Build Pipeline - Publish Artifacts

## Step-01: Introduction
- We are going to Build and Push Docker Image to Azure Container Registry
- In addition, we need to publish our Kubernetes Manifests to Azure Pipelines so that we can leverage the same in Release Pipelines.

[![Image](https://www.stacksimplify.com/course-images/azure-devops-pipelines-deploy-to-aks.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)

## Step-02: Create a Build Pipeline and Publish Artifacts to Azure Pipelines
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