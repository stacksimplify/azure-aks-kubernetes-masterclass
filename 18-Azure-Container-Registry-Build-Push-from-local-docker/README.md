# Azure Container Registry ACR - Build and Push from Local Docker Desktop

## Step-01: Introduction
- Build a Docker Image from our Local Docker on our Desktop
- Push to Azure Container Registry

[![Image](https://www.stacksimplify.com/course-images/azure-aks-container-registry-integration.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)

## Step-02: Create Azure Container Registry
- Go to Services -> Container Registries
- Click on **Add**
- Subscription: StackSimplify-Paid-Subsciption
- Resource Group: aks-rg1
- Registry Name: acrforaksdemo1   (NAME should be unique across Azure Cloud)
- Location: Central US
- SKU: Basic  (Pricing Note: $0.167 per day)
- Click on **Review + Create**
- Click on **Create**

## Step-02: Build Docker Image Locally
```
# Change Directory
cd docker-manifests
 
# Docker Build
docker build -t kube-nginx-acr:v1 .

# List Docker Images
docker images
docker images kube-nginx-acr:v1
```

## Step-03: Run locally and test
```
# Run locally and Test
docker run --name kube-nginx-acr --rm -p 80:80 -d kube-nginx-acr:v1

# Access Application locally
http://localhost

# Stop Docker Image
docker stop kube-nginx-acr
```

## Step-04: Enable Docker Login for ACR Repository 
- Go to Services -> Container Registries -> acrforaksdemo1
- Go to **Access Keys**
- Click on **Enable Admin User**
- Make a note of Username and password

## Step-05: Push Docker Image to ACR

### Build, Test Locally, Tag and Push to ACR
```
# Export Command
export ACR_REGISTRY=acrforaksdemo1.azurecr.io
export ACR_NAMESPACE=app1
export ACR_IMAGE_NAME=kube-nginx-acr
export ACR_IMAGE_TAG=v1
echo $ACR_REGISTRY, $ACR_NAMESPACE, $ACR_IMAGE_NAME, $ACR_IMAGE_TAG

# Login to ACR
docker login $ACR_REGISTRY

# Tag
docker tag kube-nginx-acr:v1  $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_IMAGE_TAG
It replaces as below
docker tag kube-nginx-acr:v1 acrforaksdemo1.azurecr.io/app1/kube-nginx-acr:v1

# List Docker Images to verify
docker images kube-nginx-acr:v1
docker images $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_IMAGE_TAG

# Push Docker Images
docker push $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_INAGE_TAG
```
### Verify Docker Image in ACR Repository
- Go to Services -> Container Registries -> acrforaksdemo1
- Go to **Repositories** -> **localdocker/kube-nginx-acr**


## Step-05: Configure ACR integration for existing AKS clusters
```
#Set ACR NAME
export ACR_NAME=acrforaksdemo1
echo $ACR_NAME

# Template
az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acr-name>

# Replace Cluster, Resource Group and ACR Repo Name
az aks update -n aksdemo1 -g aks-rg1 --attach-acr $ACR_NAME
```


## Step-06: Update & Deploy to AKS & Test
### Update Deployment Manifest with Image Name
```yaml
    spec:
      containers:
        - name: acrdemo-localdocker
          image: acrforaksdemo1.azurecr.io/app1/kube-nginx-acr:v1
          imagePullPolicy: Always
          ports:
            - containerPort: 80
```

### Deploy to AKS and Test
```
# Deploy
kubectl apply -f kube-manifests/

# List Pods
kubectl get pods

# Describe Pod
kubectl describe pod <pod-name>

# Get Load Balancer IP
kubectl get svc

# Access Application
http://<External-IP-from-get-service-output>
```

## Step-07: Clean-Up
```
# Delete Applications
kubectl delete -f kube-manifests/
```

## Step-08: Detach ACR from AKS Cluster (Optional)
```
#Set ACR NAME
export ACR_NAME=acrforaksdemo1
echo $ACR_NAME

# Detach ACR with AKS Cluster
az aks update -n aksdemo1 -g aks-rg1 --detach-acr $ACR_NAME
```

