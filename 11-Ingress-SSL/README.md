# Ingress - SSL

## Step-01: Introduction

## Step-02: Create Static Public IP
```
# Get the resource group name of the AKS cluster 
az aks show --resource-group aks-rg2 --name aksdemo2 --query nodeResourceGroup -o tsv

# Create a public IP address with the static allocation
az network public-ip create --resource-group <REPLACE-OUTPUT-RG-FROM-PREVIOUS-COMMAND> --name myAKSPublicIP --sku Standard --allocation-method static --query publicIp.ipAddress -o tsv

# Replace Resource Group value
az network public-ip create --resource-group MC_aks-rg2_aksdemo2_eastus --name myAKSPublicIP --sku Standard --allocation-method static --query publicIp.ipAddress -o tsv
```
- Make a note of Static IP which we will use in next step when installing Ingress Controller


## Step-03: Install Ingress Controller
```
# Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Add the official stable repository
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.service.loadBalancerIP="REPLACE_STATIC_IP" 

# Replace Static IP captured in Step-02
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.service.loadBalancerIP="52.149.203.205" 


# List Ingress Service
kubectl get service -l app=nginx-ingress --namespace ingress-basic
```

## Step-04: Add an A record to your DNS zone
```
ssldemo.apps.stacksimplifygmail.onmicrosoft.com

```

## Step-05: Install Cert Manager
```
# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml

# Label the ingress-basic namespace to disable resource validation
kubectl label namespace ingress-basic cert-manager.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager \
  --namespace ingress-basic \
  --version v0.13.0 \
  jetstack/cert-manager
```

## Step-06: Create Cluster Issuer


## Step-07: Deploy Demo Application

## Step-08: Create Ingress SSL Resource & Deploy


## Step-0: Verify Certificate is ready
```
kubectl get certificate --namespace ingress-basic
```

## Cert Manager
- https://docs.cert-manager.io/en/latest/reference/issuers.html
- https://docs.cert-manager.io/en/latest/reference/ingress-shim.html

## AWS DNS Migrate to Azure
- https://docs.microsoft.com/en-us/azure/dns/dns-delegate-domain-azure-dns
- https://cloudmonix.com/blog/delegate-dns-domain-from-aws-to-azure/