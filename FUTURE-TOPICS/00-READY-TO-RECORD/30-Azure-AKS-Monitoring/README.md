# Azure AKS - Monitoring

## Step-01: Introduction

## Step-02: 
```
# Generate Load
kubectl run apache-bench -i --tty --rm --image=httpd -- ab -n 50000 -c 1000 http://hpa-demo-service-nginx.default.svc.cluster.local/ 
```