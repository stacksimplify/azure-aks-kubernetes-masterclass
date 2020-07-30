# Deployments with YAML

## Step-01: Copy templates from ReplicaSet
- Copy templates from ReplicaSet and change the `kind: Deployment` 
- Update Container Image version to `3.0.0`
- Update NodePort service `nodePort: 31233`
- Change all names to Deployment
- Change all labels and selectors to `myapp3`

```
# Create Deployment
kubectl apply -f 02-deployment-definition.yml
kubectl get deploy
kubectl get rs
kubectl get po

# Create NodePort Service
kubectl apply -f 03-deployment-nodeport-service.yml

# List Service
kubectl get svc

# Get Public IP
kubectl get nodes -o wide

# Access Application
http://<Worker-Node-Public-IP>:31233
```
## API References
- **Deployment:** https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deployment-v1-apps
