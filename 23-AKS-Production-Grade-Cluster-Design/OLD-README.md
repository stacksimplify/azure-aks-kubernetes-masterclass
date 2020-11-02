## Cluster Features
- Region - will be picked based on Resource group location
- Zones: 1, 2, 3
- k8s Version: default
- Node Size: 
- Node Count: 2
- Node Pool Name: System-NodePool 
- Virtual Nodes: Enable (not default)
- VM Scale Sets: enabled by default
- Authentication Method: default is service principal, Use Managed Identity
- Kubernetes Role-based access control (RBAC): Enabled by default
- AKS-managed Azure Active Directory: disabled by default
- Node pool OS disk encryption: Default Encryption at rest with a platform managed key
### Networking
- Networking: default kubenet, Use Azure CNI
  - Virtual Network: vnet name
  - Cluster Subnet: 10.240.0.0/16
  - Kubernetes Service Address Range: 10.0.0.0/16
  - Kubernetes DNS Service IP: 10.0.0.10
  - Docker Bridge Address: 172.17.0.1/16
  - DNS Name prefix: clustername-dns
- Load balancer: standard (by default)
- Enable HTTP application routing: disabled by default (not needed for prod grade clusters)
- Security
  - Enable private cluster: disabled by default
  - Set authorized IP ranges: disabled by default, enable and use with your IP Range if your K8S API Server is public
  - Network policy: None (default),  Use Azure
### Integrations
- Container Monitoring: disabled by default (Enable - requires log analytics space)  
- Azure Policy:  Disabled by default (Enable if required)


