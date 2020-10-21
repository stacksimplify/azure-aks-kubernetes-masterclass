# AKS Taints & Tolerations

## Step-01: Introduction
- **Taint:** A taint is applied to a node that indicates only specific pods can be scheduled on them.
- **Toleration:** A toleration is then applied to a pod that allows them to tolerate a node's taint

## Step-02: Create a NodePool with Node Taint
```
# Create Node Pool with a Node Taint
az aks nodepool add --resource-group aks-rg3 \
                    --cluster-name aksdemo3 \
                    --os-type linux \
                    --name linux103 \
                    --node-count 1 \
                    --labels environment=production nodepoolos=windows app=dotnet-apps \
                    --tags environment=production nodepoolos=windows app=dotnet-apps \
                    --node-taints apptype=java:NoSchedule
```

