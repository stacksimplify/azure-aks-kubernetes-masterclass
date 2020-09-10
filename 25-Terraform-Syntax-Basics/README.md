# Terraform Configuration Language - Basics

## Step-01: Introduction

## Step-02: Terraform Configuration Language 
- Understand Resources
- Understand Blocks
- Understand Arguments
- Understand Identifiers
- Understand Comments
- Reference: https://www.terraform.io/docs/configuration/syntax.html
```
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

# Example
resource "azurerm_resource_group" "aksdev" {   # BLOCK
  name     = "aks-rg2-tf" # Argument
  location = var.region   # Argument with value as expression (Variable value replaced from varibales.tf )

  tags = {  #BLOCK
    "environment" = "k8sdev"
  }
}
```

## Step-03: Create a very basic AKS Cluster using Terraform


## Step-04: Terraform Input Variables
### Using variables.tf
- Define couple of input variables in `variables.tf`
- Reference them in `main.tf`
- Variables we are going to play with
  - Resource Group Name
  - Location or Region

### Using Command Line 
```
-var = 
```

### Using Command Line and load from file
```
-var-file = 
```




## Step-05: Terraform Output Values




## Step-00: Terraform Configuration Blocks
- Resources
- Provider Requirements
- Provider Configuration
- Input Variables
- Output Variables
- Local Values
- Modules
- Datasources
- Backend Configuration
- Terraform Settings
- Provisioners


## Step-00: Cluster Parameters
- Basics
  - Resource Group: aks-rg1
  - Cluster Name: aksdemo1
  - Region: Central US
  - Kubernetes Version: 1.16.3 (Default Version as on today)
  - Node Size: Standard DS2 V2 (default)
  - Node Count: 3 (default)
- Node Pools
  - Node Pools (Default-1 or more)
  - Virtual Nodes: Disabled (default)
  - VM Scale Sets: Enabled (default)
- Authentication
  - Cluster Infra Authentication Method: Service Principal / System Assigned Managed Identity
  - k8s RBAC: Enabled (default)
  - AKS-managed Azure Active Directory: Disabled (default)
  - Node pool OS disk encryption: Encryption Type: Encryption at rest with a platform managed key (Default)
- Networking
  - Networking Configuration: Basic (default) - Use Advanced
  - Virtual Network: (New) aks-rg1-vnet
  - Cluster Subnet: (new) default (10.240.0.0/16)
  - Kubernetes Service Address Range: 10.0.0.0/16
  - Kubernetes DNS Service IP Address: 10.0.0.0
  - Docker Bridge Address: 172.17.0.1/16
  - DNS Name Prefix: aksdemo1-dns
  - Load Balancer: Standard (default)
  - Private Cluster: Disabled (default)
  - Network policy: None (default), Change to Azure
  - HTTP Application Routing: disabled (default)
- Integrations
  - Container Registry: None (default)
  - Container monitoring: Enabled (default)
  - Log Analytics Workspace: DefaultWorkspace-xxxxxxx
- Tags
  - Notthing  

```
TERRAFORM PLAN OUTPUT
Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.aksdev will be created
  + resource "azurerm_kubernetes_cluster" "aksdev" {
      + dns_prefix              = "aksdev-k8s"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + kube_admin_config       = (known after apply)
      + kube_admin_config_raw   = (sensitive value)
      + kube_config             = (known after apply)
      + kube_config_raw         = (sensitive value)
      + kubelet_identity        = (known after apply)
      + kubernetes_version      = (known after apply)
      + location                = "centralus"
      + name                    = "aksdev-k8s"
      + node_resource_group     = (known after apply)
      + private_cluster_enabled = (known after apply)
      + private_fqdn            = (known after apply)
      + private_link_enabled    = (known after apply)
      + resource_group_name     = "aksdev-rg1"
      + sku_tier                = "Free"
      + tags                    = {
          + "Environment" = "dev"
        }

      + addon_profile {
          + aci_connector_linux {
              + enabled     = (known after apply)
              + subnet_name = (known after apply)
            }

          + azure_policy {
              + enabled = (known after apply)
            }

          + http_application_routing {
              + enabled                            = (known after apply)
              + http_application_routing_zone_name = (known after apply)
            }

          + kube_dashboard {
              + enabled = (known after apply)
            }

          + oms_agent {
              + enabled                    = (known after apply)
              + log_analytics_workspace_id = (known after apply)
              + oms_agent_identity         = (known after apply)
            }
        }

      + auto_scaler_profile {
          + balance_similar_node_groups      = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
        }

      + default_node_pool {
          + max_pods             = (known after apply)
          + name                 = "default"
          + node_count           = 1
          + orchestrator_version = (known after apply)
          + os_disk_size_gb      = (known after apply)
          + type                 = "VirtualMachineScaleSets"
          + vm_size              = "Standard_DS2_v2"
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + network_profile {
          + dns_service_ip     = (known after apply)
          + docker_bridge_cidr = (known after apply)
          + load_balancer_sku  = (known after apply)
          + network_plugin     = (known after apply)
          + network_policy     = (known after apply)
          + outbound_type      = (known after apply)
          + pod_cidr           = (known after apply)
          + service_cidr       = (known after apply)

          + load_balancer_profile {
              + effective_outbound_ips    = (known after apply)
              + idle_timeout_in_minutes   = (known after apply)
              + managed_outbound_ip_count = (known after apply)
              + outbound_ip_address_ids   = (known after apply)
              + outbound_ip_prefix_ids    = (known after apply)
              + outbound_ports_allocated  = (known after apply)
            }
        }

      + role_based_access_control {
          + enabled = (known after apply)

          + azure_active_directory {
              + admin_group_object_ids = (known after apply)
              + client_app_id          = (known after apply)
              + managed                = (known after apply)
              + server_app_id          = (known after apply)
              + server_app_secret      = (sensitive value)
              + tenant_id              = (known after apply)
            }
        }

      + windows_profile {
          + admin_password = (sensitive value)
          + admin_username = (known after apply)
        }
    }

  # azurerm_resource_group.aksdev will be created
  + resource "azurerm_resource_group" "aksdev" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "aksdev-rg1"
    }


```




## References
- https://www.terraform.io/docs/configuration/syntax.html
- https://learn.hashicorp.com/collections/terraform/azure-get-started