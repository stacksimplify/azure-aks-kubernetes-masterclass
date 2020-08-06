# Azure Container Registry ACR - Build and Push from Local Docker Desktop

## Step-01: Introduction

## Step-02: Build Docker Image Locally
```
# Change Directory
cd 14-Azure-Container-Registry-Build-Push-from-local-docker/docker-manifests

# Docker Build
docker build -t kube-nginx-acr:v1 .

# List Docker Images
docker images
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
export ACR_NAMESPACE=localdocker
export ACR_IMAGE_NAME=kube-nginx-acr
export ACR_INAGE_TAG=v1
echo $ACR_REGISTRY, $ACR_NAMESPACE, $ACR_IMAGE_NAME, $ACR_INAGE_TAG

# Login to ACR
docker login $ACR_REGISTRY

# Tag
docker tag kube-nginx-acr:v1  $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_INAGE_TAG
It replaces as below
docker tag kube-nginx-acr:v1 acrforaksdemo1.azurecr.io/localdocker/kube-nginx-acr:v1

# List Docker Images to verify
docker images

# Push Docker Images
docker push $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_INAGE_TAG
```
### Verify Docker Image in ACR Repository
- Go to Services -> Container Registries -> acrforaksdemo1
- Go to **Repositories** -> **localdocker/kube-nginx-acr**

## Step-05: Update & Deploy to AKS & Test
### Update Deployment Manifest with Image Name
```yml
    spec:
      containers:
        - name: acrdemo-localdocker
          image: acrforaksdemo1.azurecr.io/localdocker/kube-nginx-acr:v1
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

## Step-06: Clean-Up
```
# Delete Applications
kubectl delete -f kube-manifests/
```