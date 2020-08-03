# Azure Key Vault for Kubernetes Secrets

## Step-01: Introduction

## Step-02: 
- principalId, clientId, subscriptionId, and nodeResourceGroup 
```
# Template
az aks show --name contosoAKSCluster --resource-group contosoResourceGroup

# Replace Cluster Name and Resource Group
az aks show --resource-group aks-rg4 --name aksdemo5
```

```
export resourceGroupName=aks-rg4
export NODE_RESOURCE_GROUP=MC_aks-rg4_aksdemo5_eastus
export SUBID=82808767-144c-4c66-a320-b30791668b0a
export clientId=fb5f07c8-7ccc-4f07-b75a-a65a1fb8a926
export principalId=ed4ca4a2-03e6-494f-99a2-b94e5c9e7818
```

## Step-03: Install Secret Store CSI Driver
```
# Verify Helm version
helm version

# Add Help Repo
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts

# Install CSI Secrets Store Provider
helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name

# Verify pods
kubectl get pods

# Verify Daemonsets
kubectl get daemonsets
```
## Step-04: Create Azure Key Vault
```
# Create Key Vault
az keyvault create --name "Usermgmtwebapp-mysqldb" --resource-group "aks-rg4" --location eastus

# Add a secret to Key Vault
az keyvault secret set --vault-name "Usermgmtwebapp-mysqldb" --name "mysq-db-password" --value "Redhat1449"

# View the secret
az keyvault secret show --name "mysq-db-password" --vault-name "Usermgmtwebapp-mysqldb"
```

## Step-05: Update 02-SecretProviderClass-Cleaned-Comments.yml
## PENDING
```
# List Secrets from Key Vault
az keyvault secret list --vault-name Usermgmtwebapp-mysqldb

# Get Tenant Id of Key Vault
az keyvault show  --output yaml --resource-group aks-rg4 --name Usermgmtwebapp-mysqldb
```

## Step-06: Managed Identities
```
az role assignment create --role "Managed Identity Contributor" --assignee $clientId --scope /subscriptions/$SUBID/resourcegroups/$NODE_RESOURCE_GROUP

az role assignment create --role "Virtual Machine Contributor" --assignee $clientId --scope /subscriptions/$SUBID/resourcegroups/$NODE_RESOURCE_GROUP
```

```
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts

helm install pod-identity aad-pod-identity/aad-pod-identity
```

```
export identityName=myfirstidentity
az identity create -g $resourceGroupName -n $identityName
```
```log
{
  "clientId": "91597281-2411-4cdf-b6df-4b8b7abd925f",
  "clientSecretUrl": "https://control-eastus.identity.azure.net/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourcegroups/aks-rg4/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myfirstidentity/credentials?tid=c81f465b-99f9-42d3-a169-8082d61c677a&oid=797605aa-0d4e-4f9e-9296-0211a6eb68ad&aid=91597281-2411-4cdf-b6df-4b8b7abd925f",
  "id": "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourcegroups/aks-rg4/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myfirstidentity",
  "location": "eastus",
  "name": "myfirstidentity",
  "principalId": "797605aa-0d4e-4f9e-9296-0211a6eb68ad",
  "resourceGroup": "aks-rg4",
  "tags": {},
  "tenantId": "c81f465b-99f9-42d3-a169-8082d61c677a",
  "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
}
```
```
export principalId_ADIdentity=797605aa-0d4e-4f9e-9296-0211a6eb68ad
export clientId_ADIdentity=91597281-2411-4cdf-b6df-4b8b7abd925f
export VAULT_NAME=Usermgmtwebapp-mysqldb

```

```
az role assignment create --role "Reader" --assignee $principalId_ADIdentity --scope /subscriptions/$SUBID/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$VAULT_NAME

az keyvault set-policy -n $VAULT_NAME --secret-permissions get --spn $clientId_ADIdentity
```
```log
stack@Azure:~$ az role assignment create --role "Reader" --assignee $principalId_ADIdentity --scope /subscriptions/$SUBID/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$VAULT_NAME
{
  "canDelegate": null,
  "id": "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/aks-rg4/providers/Microsoft.KeyVault/vaults/Usermgmtwebapp-mysqldb/providers/Microsoft.Authorization/roleAssignments/4df7ac05-6ce6-4241-8ced-6bd946c0e635",
  "name": "4df7ac05-6ce6-4241-8ced-6bd946c0e635",
  "principalId": "797605aa-0d4e-4f9e-9296-0211a6eb68ad",
  "principalType": "ServicePrincipal",
  "resourceGroup": "aks-rg4",
  "roleDefinitionId": "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7",
  "scope": "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/aks-rg4/providers/Microsoft.KeyVault/vaults/Usermgmtwebapp-mysqldb",
  "type": "Microsoft.Authorization/roleAssignments"
}
```
```log
stack@Azure:~$ az keyvault set-policy -n $VAULT_NAME --secret-permissions get --spn $clientId_ADIdentity
{- Finished ..
  "id": "/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/aks-rg4/providers/Microsoft.KeyVault/vaults/Usermgmtwebapp-mysqldb",
  "location": "eastus",
  "name": "Usermgmtwebapp-mysqldb",
  "properties": {
    "accessPolicies": [
      {
        "applicationId": null,
        "objectId": "58c3943f-7d3e-4109-b02b-3578e2234791",
        "permissions": {
          "certificates": [
            "get",
            "list",
            "delete",
            "create",
            "import",
            "update",
            "managecontacts",
            "getissuers",
            "listissuers",
            "setissuers",
            "deleteissuers",
            "manageissuers",
            "recover"
          ],
          "keys": [
            "get",
            "create",
            "delete",
            "list",
            "update",
            "import",
            "backup",
            "restore",
            "recover"
          ],
          "secrets": [
            "get",
            "list",
            "set",
            "delete",
            "backup",
            "restore",
            "recover"
          ],
          "storage": [
            "get",
            "list",
            "delete",
            "set",
            "update",
            "regeneratekey",
            "setsas",
            "listsas",
            "getsas",
            "deletesas"
          ]
        },
        "tenantId": "c81f465b-99f9-42d3-a169-8082d61c677a"
      },
      {
        "applicationId": null,
        "objectId": "797605aa-0d4e-4f9e-9296-0211a6eb68ad",
        "permissions": {
          "certificates": null,
          "keys": null,
          "secrets": [
            "get"
          ],
          "storage": null
        },
        "tenantId": "c81f465b-99f9-42d3-a169-8082d61c677a"
      }
    ],
    "createMode": null,
    "enablePurgeProtection": null,
    "enableRbacAuthorization": null,
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "networkAcls": null,
    "privateEndpointConnections": null,
    "provisioningState": "Succeeded",
    "sku": {
      "name": "standard"
    },
    "softDeleteRetentionInDays": 90,
    "tenantId": "c81f465b-99f9-42d3-a169-8082d61c677a",
    "vaultUri": "https://usermgmtwebapp-mysqldb.vault.azure.net/"
  },
  "resourceGroup": "aks-rg4",
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}
stack@Azure:~$
```

## Step-0 Deploy the SecretProviderClass yaml 
```
kubectl apply -f kube-manifests/02-SecretProviderClass-Cleaned-Comments.yml
```

## Step-06: 

## Referencces
- https://docs.microsoft.com/en-us/azure/key-vault/general/key-vault-integrate-kubernetes
- https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-cli
- https://github.com/Azure/secrets-store-csi-driver-provider-azure
