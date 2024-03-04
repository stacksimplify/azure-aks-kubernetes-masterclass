# December 2023 Changes

## Step-01: Ingress Class Name Argument added in Ingress Services
- Updated in `sections: 09, 10, 12, 13, 14`
```yaml
# List Ingress Clasess from k8s Cluster
kubectl get ingressclass

# Change-1: Comment the below annotation because its deprecated
  annotations:
    #kubernetes.io/ingress.class: "nginx"

# Change-2: Add the `ingressClassName` in ingress.spec
spec:
  ingressClassName: nginx
```

## Step-02: Section-10 Ingress Service defaultBackend
- `defaultBackend` not working
```yaml
## COMMENTED defaultBackend
  #defaultBackend:
  #  service:
  #    name: usermgmt-webapp-clusterip-service
  #    port:
  #      number: 80

## UNCOMMENTED ROOT CONTEXT PATH 
          - path: /
            pathType: Prefix
            backend:
              service:
                name: usermgmt-webapp-clusterip-service
                port: 
                  number: 80                  
                               
```

## Step-03: Section-12: Updated external-dns.yaml
- Updated the `external-dns.yaml`, primarily the latest Docker Image `registry.k8s.io/external-dns/external-dns:v0.14.0`
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
  - apiGroups: [""]
    resources: ["services","endpoints","pods", "nodes"]
    verbs: ["get","watch","list"]
  - apiGroups: ["extensions","networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get","watch","list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
  - kind: ServiceAccount
    name: external-dns
    namespace: default
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
        - name: external-dns
          image: registry.k8s.io/external-dns/external-dns:v0.14.0
          args:
            - --source=service
            - --source=ingress
            #- --domain-filter=example.com # (optional) limit to only example.com domains; change to match the zone created above.
            - --provider=azure
            #- --azure-resource-group=MyDnsResourceGroup # (optional) use the DNS zones from the tutorial's resource group
            - --txt-prefix=externaldns-
          volumeMounts:
            - name: azure-config-file
              mountPath: /etc/kubernetes
              readOnly: true
      volumes:
        - name: azure-config-file
          secret:
            secretName: azure-config-file
```

## Step-04: Section-14: Updated cert-manager to latest version
```t
# Change-1: Helm Command with latest version
helm install \
  cert-manager jetstack/cert-manager \
  --namespace ingress-basic \
  --version v1.13.3 \
  --set installCRDs=true

# Change-2: cluster-issuer.yaml
- Added the "ingressClassName: nginx" 
### BEFORE CHANGE
    solvers:
      - http01:
          ingress:
            class: nginx  

### AFTER CHANGE
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx            
```