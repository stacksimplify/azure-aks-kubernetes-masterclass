# Azure Container Registry ACR & AKS

## Step-01: Introduction
- Docker Image Build and Push from Azure Cloud Shell

## Step-02: Create Azure Container Registry
- Go to Services -> Container Registries
- Click on **Add**
- Subscription: StackSimplify-Paid-Subsciption
- Resource Group: aks-rg1
- Registry Name: acrforaksdemo1
- Location: East US
- SKU: Basic  (Pricing Note: $0.167 per day)
- Click on **Review + Create**
- Click on **Create**

## Step-03: For existing AKS Cluster -  Attach ACR
```
# Export Required Values
export AKS_NAME=aksdemo1
export RG_NAME=aks-rg1
export ACR_NAME=acrforaksdemo1

# Verify export worked
echo $AKS_NAME, $RG_NAME, $ACR_NAME

# Update AKS Cluster to attach ACR
az aks update -n $AKS_NAME -g $RG_NAME --attach-acr $ACR_NAME
```
- Important Note: If your ACR is in different region, please use ACR resource id
```
# Get ACR Resource ID
az acr show -n $ACR_NAME --query "id" -o tsv
```

## Step-04: Build and Push Docker Image to ACR using CloudShell
```
# Change Directory where Dockerfile is present
cd /home/stack/azure-aks-kubernetes-masterclass/13-Azure-Container-Registry-Integration/docker-manifests

# Export Commands
export IMAGE_NAME=fromcloudshell1/kube-nginx:v1
export ACR_NAME=acrforaksdemo1
echo $IMAGE_NAME, $ACR_NAME

# Build Image
az acr build --image $IMAGE_NAME \
  --registry $ACR_NAME \
  --file Dockerfile .
```
## Step-05: Verify if our image got pushed to ACR
- Go to Services -> Container Registries -> acrfromaksdemo1
- Go to Repositories -> fromcloudshell/kube-nginx
- Make a note of docker pull command which gives us complete Docker Image path with tag
```
docker pull acrforaksdemo1.azurecr.io/fromcloudshell/kube-nginx:v1
```

## Step-06: Update Nginx App1 Deployment Image
```yml
    spec:
      containers:
        - name: app1-nginx
          image: acrforaksdemo1.azurecr.io/fromcloudshell/kube-nginx:v1
```

## Step-07: Deploy Application & Test
```
# Deploy
kubectl apply -f kube-manifests/

# List Pods
kubectl get pods

# Describe Pod
kubectl describe pod <pod-name>
kubectl describe pod acrdemo-cloudshell-deployment-749d4799d8-ggtqb

# Get Load Balancer IP
kubectl get svc

# Access Application
http://<External-IP-from-get-service-output>
```


## Pricing of Azure Container Registry
- https://azure.microsoft.com/en-us/pricing/details/container-registry/

## References
- https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration
- https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster