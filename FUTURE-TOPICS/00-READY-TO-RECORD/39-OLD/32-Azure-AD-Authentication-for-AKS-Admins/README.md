# Azure AD Authentication for AKS Cluster Admins

## Step-01: Introduction
- We can use Azure AD Users and Groups to Manage AKS Clusters
- We can create Admin Users in Azure AD and Associate to Azure AD Group named `myAKSAdminGroup` and those users can access Azure AKS Cluster using kubectl. 

## Step-02: Pre-requisites
- The Azure CLI version (latest as on today)
- Kubectl (latest as on today)
```
# Azure CLI
az --version

# kubectl 
kubectl version --client

# Install kubeclt (if not installed)
sudo az aks install-cli
kubectl version --client
```

## Step-03: Create Azure AD Group and Record the object ID 
```
# Login to Azure and Provide your Azure subscription email id, password
az login

# Create an Azure AD group
az ad group create --display-name myAKSAdminGroup --mail-nickname myAKSAdminGroup

# List existing groups in the directory and make note of Object Id
az ad group list --filter "displayname eq '<group-name>'" -o table
az ad group list --filter "displayname eq 'myAKSAdminGroup'" -o table
```

## Step-04: Create an AKS cluster with Azure AD enabled
```
# Capture your Azure AD Tenant Id
az account show --query tenantId -o tsv

# Create an Azure resource group
az group create --name aks-rg5-aad --location centralus

# To get --aad-admin-group-object-ids
az ad group list --filter "displayname eq 'myAKSAdminGroup'" -o table

# To get --aad-tenant-id
az account show

# Create an AKS-managed Azure AD cluster
az aks create -g aks-rg5-aad \
              -n aksdemo5aad \
              --enable-aad \
              --aad-admin-group-object-ids <id> [--aad-tenant-id <id>] \
              --node-count 1

# Replace values
az aks create -g aks-rg5-aad \
              -n aksdemo5aad \
              --enable-aad \
              --aad-admin-group-object-ids d601be0d-ccf9-47a0-91a4-721d9cf840e6 \
              --aad-tenant-id c81f465b-99f9-42d3-a169-8082d61c677a \
              --node-count 1
```

## Step-05: Create User in Azure AD and Associate to Group myAKSAdminGroup
- Create User in Azure AD
- Associate User to `myAKSAdminGroup` group

## Step-06: Access an Azure AD enabled cluster
```
# Configure kubectl
az aks get-credentials --resource-group aks-rg5-aad --name aksdemo5aad --overwrite-existing

# List Nodes
kubectl get nodes

# Cluster Info
kubectl cluster-info
```

### Important Notes
- Once we do `devicelogin` everything is cached for subsequent kubectl commands.
- The moment you change the `$HOME/.kube/config` you will re-prompted for Azure Device Login for all kubectl commands
```
# Type-1
cp /Users/kdaida/.kube/config_demo5 /Users/kdaida/.kube/config

# Type-2
az aks get-credentials --resource-group aks-rg5-aad --name aksdemo5aad --overwrite-existing
```

## Step-07: Complete Admin Access
- If we have issues with AD Users or Groups and want to override that we can use `--admin` to override and directly connect to AKS Cluster
```
# Template
az aks get-credentials --resource-group myResourceGroup --name myManagedCluster --admin

# Replace RG and Cluster Name
az aks get-credentials --resource-group aks-rg5-aad --name aksdemo5aad --admin

```

## Step-08: For existing AKS Clusters Enable Azure AD Authentication
```
# For existing AKS Clusters
az aks update -g MyResourceGroup \
              -n MyManagedCluster \
              --enable-aad --aad-admin-group-object-ids <id-1> \[--aad-tenant-id <id>]
```

## Step-09: Clean-Up
```
# Delete Cluster
az aks delete --name aksdemo5aad --resource-group aks-rg5-aad
```


## References
- https://docs.microsoft.com/en-us/azure/aks/managed-aad




# OTHERS IGNORE

## Step-5: Create 
```
AKS_ID=$(az aks show \
    --resource-group aks-rg5-aad \
    --name aksdemo5aad \
    --query id -o tsv)

APPDEV_ID=$(az ad group create --display-name appdev --mail-nickname appdev --query objectId -o tsv)    

az role assignment create \
  --assignee $APPDEV_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID
```

```
OPSSRE_ID=$(az ad group create --display-name opssre --mail-nickname opssre --query objectId -o tsv)

az role assignment create \
  --assignee $OPSSRE_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID
```


```
AKSDEV_ID=$(az ad user create \
  --display-name "AKS Dev1" \
  --user-principal-name aksdev1@stacksimplifygmail.onmicrosoft.com \
  --password P@ssw0rd1 \
  --query objectId -o tsv)

az ad group member add --group appdev --member-id $AKSDEV_ID  
```

```
# Create a user for the SRE role
AKSSRE_ID=$(az ad user create \
  --display-name "AKS SRE1" \
  --user-principal-name akssre@stacksimplifygmail.onmicrosoft.com \
  --password P@ssw0rd1 \
  --query objectId -o tsv)

# Add the user to the opssre Azure AD group
az ad group member add --group opssre --member-id $AKSSRE_ID
```

```
az aks get-credentials --resource-group aks-rg5-aad --name aksdemo5aad --admin

kubectl create namespace dev
```
- File Name: role-dev-namespace.yaml
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-full-access
  namespace: dev
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]
```

```
kubectl apply -f kube-manifests/
az ad group show --group appdev --query objectId -o tsv
3ea873a9-47cf-42e5-8bd6-bdf380a7659d
```

- File Name: rolebinding-dev-namespace.yaml
```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-access
  namespace: dev
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: dev-user-full-access
subjects:
- kind: Group
  namespace: dev
  #name: groupObjectId
  name: 3ea873a9-47cf-42e5-8bd6-bdf380a7659d
```
```
kubectl apply -f kube-manifests/
```


```
kubectl create namespace sre
```

- File Name: role-sre-namespace.yaml
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: sre-user-full-access
  namespace: sre
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]
```

```
az ad group show --group opssre --query objectId -o tsv
28b2a1e5-2dbd-4438-9f1a-f7fca0116b60
```

- File Name: rolebinding-sre-namespace.yaml
```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: sre-user-access
  namespace: sre
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: sre-user-full-access
subjects:
- kind: Group
  namespace: sre
  #name: groupObjectId
  name: 28b2a1e5-2dbd-4438-9f1a-f7fca0116b60
```

```
kubectl apply -f kube-manifests/
```

## Username and Password
```
aksdev1@stacksimplifygmail.onmicrosoft.com
P@ssw0rd1

akssre@stacksimplifygmail.onmicrosoft.com
P@ssw0rd1
```


## Test
```
az aks get-credentials --resource-group aks-rg5-aad --name aksdemo5aad --overwrite-existing

kubectl get pods -n dev
kubectl run nginx-dev --image=nginx --namespace dev
kubectl get pods -n dev
```


```
az aks install-cli
kubectl version --client
az aks get-credentials --resource-group aks-rg1 --name aksdemo4 --admin
kubectl create ns dev
kubectl create ns sre
az ad group show --group appdev --query objectId -o tsv
3ea873a9-47cf-42e5-8bd6-bdf380a7659d

kubectl apply -f kube-manifests/
az aks get-credentials --resource-group aks-rg1 --name aksdemo4 --overwrite-existing

kubectl get pods -n dev

https://microsoft.com/devicelogin
kalyan1@stacksimplifygmail.onmicrosoft.com
DK@11Reddy

aksdev1@stacksimplifygmail.onmicrosoft.com
P@ssw0rd1
```