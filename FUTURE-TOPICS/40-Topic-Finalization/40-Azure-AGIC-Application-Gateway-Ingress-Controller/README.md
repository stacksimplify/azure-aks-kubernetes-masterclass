# Azure AGIC -  Application Gateway Ingress Controller

## Step-01: Introduction

## Step-02: Register the AKS-IngressApplicationGatewayAddon feature flag 
- As it is in preview mode, we need to register for this preview feature
```
# Register for AKS Ingress AGIC Preview Feature
az feature register --name AKS-IngressApplicationGatewayAddon --namespace microsoft.containerservice

# Verify Registration Status
az feature list -o table --query "[?contains(name, 'microsoft.containerservice/AKS-IngressApplicationGatewayAddon')].{Name:name,State:properties.state}"

# Refresh the registration of the Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerService

# Install or Update AKS Preview Extenstion
az extension add --name aks-preview
az extension list
```

## Step-03: Deploy AGIC
```
# TEMPLATE
az network public-ip create -n myPublicIp -g MyResourceGroup --allocation-method Static --sku Standard
az network vnet create -n myVnet -g myResourceGroup --address-prefix 11.0.0.0/8 --subnet-name mySubnet --subnet-prefix 11.1.0.0/16 
az network application-gateway create -n myApplicationGateway -l canadacentral -g myResourceGroup --sku Standard_v2 --public-ip-address myPublicIp --vnet-name myVnet --subnet mySubnet

# REPLACE
az network public-ip create -n myPublicIp -g aks-rg1 --allocation-method Static --sku Standard
az network vnet create -n myVnet -g aks-rg1 --address-prefix 11.0.0.0/8 --subnet-name mySubnet --subnet-prefix 11.1.0.0/16 
az network application-gateway create -n myApplicationGateway -l centralus -g aks-rg1 --sku Standard_v2 --public-ip-address myPublicIp --vnet-name myVnet --subnet mySubnet
```


## Step-04: PEER two virtual networks
```
# Template
nodeResourceGroup=$(az aks show -n myCluster -g myResourceGroup -o tsv --query "nodeResourceGroup")
aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g myResourceGroup --vnet-name myVnet --remote-vnet $aksVnetId --allow-vnet-access

appGWVnetId=$(az network vnet show -n myVnet -g myResourceGroup -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access

# Replace
nodeResourceGroup=$(az aks show -n aksdemo1 -g aks-rg1 -o tsv --query "nodeResourceGroup")

aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")

az network vnet peering create -n AppGWtoAKSVnetPeering -g aks-rg1 --vnet-name myVnet --remote-vnet $aksVnetId --allow-vnet-access

appGWVnetId=$(az network vnet show -n myVnet -g aks-rg1 -o tsv --query "id")

az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access
```
## References
- https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fbread%2Ftoc.json
- https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview


## References
- https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview