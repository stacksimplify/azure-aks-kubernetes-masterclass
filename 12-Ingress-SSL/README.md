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

## Step-03: Create Record Sets in DNS Zones
- Go to Services -> DNS Zones -> kubeoncloud.com
- **app1.kubeoncloud.com**
  - Create **Record Set**
  - Name: app1.kubeoncloud.com
  - Type: A
  - Alias Record Set: YES
  - Alias Type :Azure Resource
  - Choose Subsciption: StackSimplify-Paid-Subscription
  - Azure Resource: myAKSPublicIP
  - Click on **OK**
- **app2.kubeoncloud.com**
  - Create **Record Set**
  - Name: app2.kubeoncloud.com
  - Type: A
  - Alias Record Set: YES
  - Alias Type :Azure Resource
  - Choose Subsciption: StackSimplify-Paid-Subscription
  - Azure Resource: myAKSPublicIP
  - Click on **OK**  

## Step-04: Install Ingress Controller
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

## Step-06: Review or Create Cluster Issuer Kubernetes Manifest
- Create or Review Cert Manager Cluster Issuer Kubernetes Manigest
```yml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: dkalyanreddy@gmail.com
    privateKeySecretRef:
      name: letsencrypt
    solvers:
      - http01:
          ingress:
            class: nginx
```

## Step-07: Review Application NginxApp1,2 K8S Manifests
- 01-NginxApp1-Deployment.yml
- 02-NginxApp1-ClusterIP-Service.yml
- 01-NginxApp2-Deployment.yml
- 02-NginxApp2-ClusterIP-Service.yml

## Step-08: Create ore Review Ingress SSL Kubernetes Manifest
- 01-Ingress-SSL.yml

## Step-09: Deploy All Manifests & Verify
- Certificate Request, Generation, Approal and Download and be ready might take from 1 hour to many days if we make any mistakes.
- For me it took, only 5 minutes to get the certificate from **https://letsencrypt.org/**
```
# Deploy
kubectl apply -R -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify SSL Certificates (It should turn to True)
kubectl get certificate
```
```log
stack@Azure:~$ kubectl get certificate
NAME                      READY   SECRET                    AGE
app1-kubeoncloud-secret   True    app1-kubeoncloud-secret   45m
app2-kubeoncloud-secret   True    app2-kubeoncloud-secret   45m
stack@Azure:~$
```

## Step-10: Access Application
```
http://app1.kubeoncloud.com/app1/index.html
http://app2.kubeoncloud.com/app2/index.html
```

## Step-11: Verify Ingress logs for Client IP
```
# List Pods
kubectl -n ingress-basic get pods

# Check logs
kubectl -n ingress-basic logs -f nginx-ingress-controller-xxxxxxxxx
```
## Step-12: Clean-Up
```
# Delete Apps
kubectl delete -R -f kube-manifests/

# Delete Ingress Controller
kubectl delete namespace ingress-basic
```

## Cert Manager
- https://docs.cert-manager.io/en/latest/reference/issuers.html
- https://docs.cert-manager.io/en/latest/reference/ingress-shim.html

## AWS DNS Migrate to Azure
- https://docs.microsoft.com/en-us/azure/dns/dns-delegate-domain-azure-dns
- https://cloudmonix.com/blog/delegate-dns-domain-from-aws-to-azure/
- https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1beta1.Issuer