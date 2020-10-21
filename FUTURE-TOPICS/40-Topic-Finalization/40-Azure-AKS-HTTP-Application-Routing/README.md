# Azure AKS - Enable HTTP Application Routing Feature

## Step-01:

## Step-02: Create AKS Cluster with HTTP Application Routing Enabled
- Create Cluster with HTTP Application Routing Enabled
- In Networking tab, enable HTTP Application Routing
- Rest all is same

## Step-03: For existing clusters, enable HTTP Application Routing
```
# Enable HTTP Application Routing 
az aks enable-addons --resource-group myResourceGroup --name myAKSCluster --addons http_application_routing

# Replace Resource Group and Cluster Name
az aks enable-addons --resource-group aks-rg1 --name aksdemo1 --addons http_application_routing
```

## Step-04: List DNS Zone associated with AKS Cluster
```
# List DNS Zone
az aks show --resource-group myResourceGroup --name myAKSCluster --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table

# Replace Resource Group and Cluster Name
az aks show --resource-group aks-rg1 --name aksdemo1 --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table
```
- **Sample Output**
```
Result
----------------------------------------
974030cd6cf24732aaaa.centralus.aksapp.io
```

## Step-05: Review kube-manifests
- 01-NginxApp1-Deployment.yml
- 02-NginxApp1-ClusterIP-Service.yml
- 03-Ingress-HTTPApplicationRouting-ExternalDNS.yml
```yml
# Change-1: Add Annotation related to HTTP Application Routing
  annotations:
    kubernetes.io/ingress.class: addon-http-application-routing

# Change-2: Update DNS Zone name with additional App Name as host
spec:
  rules:
  - host: app1.974030cd6cf24732aaaa.centralus.aksapp.io
    http:
```
## Step-06: Deploy, Verify & Test
```
# Deploy
kubectl apply -f kube-manifests/

# List Pods
kubectl get pods

# List Ingress Service (Wait for Public IP to be assigned)
kubectl get ingress

# Verify new Recordset added in DNS Zones
Go to Services -> DNS Zones -> 974030cd6cf24732aaaa.centralus.aksapp.io

# Access Application
http://app1.974030cd6cf24732aaaa.centralus.aksapp.io/app1/index.html

# Verify External DNS Log
kubectl -n kube-system logs -f $(kubectl -n kube-system get po | egrep -o 'addon-http-application-routing-external-dns-[A-Za-z0-9-]+')
```
- **Important Note:** If immediately application via DNS doesnt workm Wait for 10 to 20 minutes for all the DNS changes to kick-in

## Step-07: Clean Up
```
# Delete Apps
kubectl delete -f  kube-manifests/

# Disable Add-On HTTP Application Routing to AKS cluster
az aks disable-addons --addons http_application_routing --name aksdemo3 --resource-group aks-rg1 --no-wait
```