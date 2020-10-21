# Istio & Azure AKS

## Step-01: Introduction

## Step-02: Create AKS Cluster
```
# Create Cluster

# Configure Credentials
az aks get-credentials --name aksdemo1 --resource-group aks-rg1

# List Nodes
kubectl get nodes
```

## Step-03: Install Istioctl command line - MacOs
- Get latest Istio release from [Istio Release Page](https://github.com/istio/istio/releases/tag/1.7.2)
```
# Specify the Istio version that will be leveraged throughout these instructions
ISTIO_VERSION=1.7.2

curl -sL "https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-osx.tar.gz" | tar xz

cd istio-$ISTIO_VERSION
sudo cp ./bin/istioctl /usr/local/bin/istioctl
sudo chmod +x /usr/local/bin/istioctl
istioctl version
```
- For [Linux](https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install?pivots=client-operating-system-linux)
- For [Windows](https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install?pivots=client-operating-system-windows)
- For [MacOS](https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install?pivots=client-operating-system-macos)

## Step-04: Istio Versions vs Kubernetes Versions
- [Istio vs Kubernetes versions](https://istio.io/latest/faq/general/#what-deployment-environment)
- [Istio Performance and Scalability](https://istio.io/latest/docs/ops/deployment/performance-and-scalability/)

## Step-05: Create Namespace, Secrets for Istio

### Create Namespace
```
# Create Namespace
kubectl create namespace istio-system --save-config
```

### Create Grafana Secrets
```
export GRAFANA_USERNAME=$(echo -n "grafana" | base64)
#export GRAFANA_PASSPHRASE=$(echo -n "REPLACE_WITH_YOUR_SECURE_PASSWORD" | base64)
export GRAFANA_PASSPHRASE=$(echo -n "Password101" | base64)
echo $GRAFANA_USERNAME
echo $GRAFANA_PASSPHRASE

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: grafana
  namespace: istio-system
  labels:
    app: grafana
type: Opaque
data:
  username: $GRAFANA_USERNAME
  passphrase: $GRAFANA_PASSPHRASE
EOF
```

### Add Kiali Secrets

```
export KIALI_USERNAME=$(echo -n "kiali" | base64)
#export KIALI_PASSPHRASE=$(echo -n "REPLACE_WITH_YOUR_SECURE_PASSWORD" | base64)
export KIALI_PASSPHRASE=$(echo -n "Password101" | base64)
echo $KIALI_USERNAME
echo $KIALI_PASSPHRASE

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: istio-system
  labels:
    app: kiali
type: Opaque
data:
  username: $KIALI_USERNAME
  passphrase: $KIALI_PASSPHRASE
EOF
```
### List Graphana and Kiali Secrets
```
# List Secrets from istio-system namespace
kubectl get secrets -n istio-system
```

## Step-06: Review Istio Control Plane spec
```yaml
apiVersion: install.istio.io/v1alpha2
kind: IstioControlPlane
spec:
  # Use the default profile as the base
  # More details at: https://istio.io/docs/setup/additional-setup/config-profiles/
  profile: default
  values:
    global:
      # Ensure that the Istio pods are only scheduled to run on Linux nodes
      defaultNodeSelector:
        beta.kubernetes.io/os: linux
      # Enable mutual TLS for the control plane
      controlPlaneSecurityEnabled: true
      mtls:
        # Require all service to service communication to have mtls
        enabled: false
    grafana:
      # Enable Grafana deployment for analytics and monitoring dashboards
      enabled: true
      security:
        # Enable authentication for Grafana
        enabled: true
    kiali:
      # Enable the Kiali deployment for a service mesh observability dashboard
      enabled: true
    tracing:
      # Enable the Jaeger deployment for tracing
      enabled: true
```

## Step-07: Install Istio Components
```
# Switch Directory to Control Plane Spec
cd kube-manifests/

# Install Istio Components
istioctl manifest apply -f istio.aks.yaml --logtostderr --set installPackagePath=./install/kubernetes/operator/charts
```

## Step-08: 