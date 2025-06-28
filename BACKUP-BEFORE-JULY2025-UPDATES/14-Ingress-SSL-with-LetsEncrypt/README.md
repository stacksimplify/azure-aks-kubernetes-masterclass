# Ingress - SSL

## Step-01: Introduction
- Implement SSL using Lets Encrypt

[![Image](https://www.stacksimplify.com/course-images/azure-aks-ingress-ssl-letsencrypt.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)

## Step-02: Install Cert Manager
```t
# Label the ingress-basic namespace to disable resource validation
kubectl label namespace ingress-basic cert-manager.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager jetstack/cert-manager \
  --namespace ingress-basic \
  --version v1.13.3 \
  --set installCRDs=true

## SAMPLE OUTPUT
Kalyans-Mac-mini:azure-aks-kubernetes-masterclass-internal24 kalyanreddy$ helm install \
>   cert-manager jetstack/cert-manager \
>   --namespace ingress-basic \
>   --version v1.13.3 \
>   --set installCRDs=true
NAME: cert-manager
LAST DEPLOYED: Fri Dec 29 12:47:27 2023
NAMESPACE: ingress-basic
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
cert-manager v1.13.3 has been deployed successfully!

In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

More information on the different types of issuers and how to configure them
can be found in our documentation:

https://cert-manager.io/docs/configuration/

For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:

https://cert-manager.io/docs/usage/ingress/
Kalyans-Mac-mini:azure-aks-kubernetes-masterclass-internal24 kalyanreddy$ 

# Verify Cert Manager pods
kubectl get pods --namespace ingress-basic

# Verify Cert Manager Services
kubectl get svc --namespace ingress-basic
```

## Step-06: Review or Create Cluster Issuer Kubernetes Manifest
### Review Cluster Issuer Kubernetes Manifest
- Create or Review Cert Manager Cluster Issuer Kubernetes Manigest
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: dkalyanreddy@gmail.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx            
```

### Deploy Cluster Issuer
```t
# Deploy Cluster Issuer
kubectl apply -f kube-manifests/01-CertManager-ClusterIssuer/cluster-issuer.yml

# List Cluster Issuer
kubectl get clusterissuer

# Describe Cluster Issuer
kubectl describe clusterissuer letsencrypt
```


## Step-07: Review Application NginxApp1,2 K8S Manifests
- 01-NginxApp1-Deployment.yml
- 02-NginxApp1-ClusterIP-Service.yml
- 01-NginxApp2-Deployment.yml
- 02-NginxApp2-ClusterIP-Service.yml

## Step-08: Create or Review Ingress SSL Kubernetes Manifest
- 01-Ingress-SSL.yml

## Step-09: Deploy All Manifests & Verify
- Certificate Request, Generation, Approal and Download and be ready might take from 1 hour to couple of days if we make any mistakes and also fail.
- For me it took, only 5 minutes to get the certificate from **https://letsencrypt.org/**
```t
# Deploy
kubectl apply -R -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify Cert Manager Pod Logs
kubectl get pods -n ingress-basic
kubectl -n ingress-basic logs -f <cert-manager-55d65894c7-sx62f> -n ingress-basic #Replace Pod name

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

```log
# Sample Success Log
I0824 13:09:00.495721       1 controller.go:129] cert-manager/controller/orders "msg"="syncing item" "key"="default/app2-kubeoncloud-secret-2792049964-67728538" 
I0824 13:09:00.495900       1 sync.go:102] cert-manager/controller/orders "msg"="Order has already been completed, cleaning up any owned Challenge resources" "resource_kind"="Order" "resource_name"="app2-kubeoncloud-secret-2792049964-67728538" "resource_namespace"="default" 
I0824 13:09:00.496904       1 controller.go:135] cert-manager/controller/orders "msg"="finished processing work item" "key"="default/app2-kubeoncloud-secret-2792049964-67728538
```

## Step-10: Access Application
```t
# URLs
http://sapp1.kubeoncloud.com/app1/index.html
http://sapp2.kubeoncloud.com/app2/index.html
```

## Step-11: Verify Ingress logs for Client IP
```t
# List Pods
kubectl -n ingress-basic get pods

# Check logs
kubectl -n ingress-basic logs -f nginx-ingress-controller-xxxxxxxxx
```
## Step-12: Clean-Up
```t
# Delete Apps
kubectl delete -R -f kube-manifests/

# Delete Ingress Controller
kubectl delete namespace ingress-basic
```

## Cert Manager
- https://cert-manager.io/docs/installation/#default-static-install
- https://cert-manager.io/docs/installation/helm/
- https://docs.cert-manager.io/
- https://cert-manager.io/docs/installation/helm/#1-add-the-jetstack-helm-repository
- https://cert-manager.io/docs/configuration/
- https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-6---configure-a-lets-encrypt-issuer
- https://letsencrypt.org/how-it-works/

  