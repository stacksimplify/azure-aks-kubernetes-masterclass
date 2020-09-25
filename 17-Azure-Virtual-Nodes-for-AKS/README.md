---
title: Azure AKS Kubernetes Namespaces Resource Quota
description: Understand Kubernetes Namespaces Resource Quota Concept Azure Kubernetes Service 
---

# Azure Virtual Nodes for Azure AKS (Serverless)

## Step-01: Introduction
- Understand Azure Virtual Nodes
- Understand Virtual Kubelet Concept
- Virtual nodes require AKS clusters with Azure CNI networking

[![Image](https://www.stacksimplify.com/course-images/azure-aks-virtual-nodes.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1){:target="_blank"}  

## Step-02: Create a new cluster using Azure Management Console
- **Basics**
  - **Subscription:** Free Trial
  - **Resource Group:** Creat New: aks-rg2
  - **Kubernetes Cluster Name:** aksdemo2
  - **Region:** (US) Central US
  - **Kubernetes Version:** Select what ever is latest stable version
  - **Node Size:** Standard DS2 v2 (Default one)
  - **Node Count:** 1
- **Node Pools**
  - **Virtual Nodes:** Enabled
  - leave to defaults
- **Authentication**
  - Authentication method: 	System-assigned managed identity
  - Rest all leave to defaults
- **Networking**
  - **Network Configuration:** Advanced
  - **Network Policy:** Azure
  - Rest all leave to defaults
- **Integrations**
  - Azure Container Registry: None
  - leave to defaults
- **Tags**
  - leave to defaults
- **Review + Create**
  - Click on **Create**


## Step-03: Verify Nodes
```
# Verify Nodes
kubectl get nodes
```

## Step-04: Update Deployment Manifest to Schedule Pod on Virtual Nodes
- The below section should be added in Deployment for Azure AKS to schedule the pod on Azure Virtual Nodes
- Review the manifests
```yaml
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule
```

## Step-05: Deploy Application Manifests
```
# Deploy
kubectl apply -f kube-manifests/

# Verify pods
kubectl get pods -o wide

# Get Public IP
kubectl get svc

# Access Application
http://<Public-ip-captured-from-get-service>
```

## Step-06: Scale the Deployment 
```
# List Deployments
kubectl get deploy

# Scale the Deployment to 10 Replicas
kubectl scale --replicas=10 deployment app1-nginx-deployment

# List Pods
kubectl get pods
```

## Step-07: Clean-Up
```
# Delete Application
kubectl delete -f kube-manifests/

# Delete this new cluster created for Virtual Nodes (if you want to)
az aks delete --name aksdemo2 --resource-group aks-rg2
```

## References
## Azure Virtual Nodes - Limitations
- https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli#known-limitations

## Virtual kubelet
- https://github.com/virtual-kubelet/virtual-kubelet
- https://github.com/virtual-kubelet/azure-aci/blob/master/README.md

## Virtual Node Autoscale
- https://github.com/Azure-Samples/virtual-node-autoscale