# PODs with YAML
## Step-01: Kubernetes YAML Top level Objects
- Discuss about the k8s YAML top level objects
- **01-kube-base-definition.yml**
```yml
apiVersion:
kind:
metadata:
  
spec:
```
-  **Pod API Objects Reference:**  https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#pod-v1-core

## Step-02: Create Simple Pod Definition using YAML 
- We are going to create a very basic pod definition
- **02-pod-definition.yml**
```yml
apiVersion: v1 # String
kind: Pod  # String
metadata: # Dictionary
  name: myapp-pod
  labels: # Dictionary 
    app: myapp         
spec:
  containers: # List
    - name: myapp
      image: stacksimplify/kubenginx:1.0.0
      ports:
        - containerPort: 80
```
- **Create Pod**
```
# Create Pod
kubectl create -f 02-pod-definition.yml
[or]
kubectl apply -f 02-pod-definition.yml

# List Pods
kubectl get pods
```

## Step-03: Create a NodePort Service
- **03-pod-nodeport-service.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: myapp-pod-nodeport-service  # Name of the Service
spec:
  type: NodePort
  selector:
  # Loadbalance traffic across Pods matching this label selector
    app: myapp
  # Accept traffic sent to port 80    
  ports: 
    - name: http
      port: 80    # Service Port
      targetPort: 80 # Container Port
      nodePort: 31231 # NodePort
```
- **Create NodePort Service for Pod**
```
# Create Service
kubectl apply -f 03-pod-nodeport-service.yml

# List Service
kubectl get svc

# Get Public IP
kubectl get nodes -o wide

# Access Application
http://<WorkerNode-Public-IP>:<NodePort>
http://<WorkerNode-Public-IP>:31231
```

## API Object References
-  **Pod**: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#pod-v1-core
- **Service**: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#service-v1-core


