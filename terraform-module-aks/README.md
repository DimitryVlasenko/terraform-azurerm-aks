# Terraform Azure AKS Module

This Terraform module deploys a modern Azure Kubernetes Service (AKS) cluster with Azure CNI, system-assigned managed identity, Azure RBAC, and monitoring integration. It supports automated or user-provided service principal configuration for AKS.

## Features
- Creates an AKS cluster with Azure CNI networking.
- Uses system-assigned managed identity for cluster operations.
- Enables Azure RBAC with Azure AD integration.
- Configures monitoring with Azure Monitor and Log Analytics.
- Supports automated maintenance windows.
- Provides flexible service principal management (auto-created or user-provided).
- Generates unique resource names using a random postfix.

## Prerequisites
- Terraform 1.5+.
- Azure credentials with permissions to create resource groups, AKS clusters, Azure AD applications, role assignments, and Log Analytics workspaces.
- A pre-existing VNet and subnet for AKS (provide `subnet_id`).
- A Log Analytics workspace (provide `log_analytics_workspace_id`).
- Azure provider configuration in the root module:
  ```hcl
  terraform {
    required_providers {
      azurerm = { source = "hashicorp/azurerm", version = "~> 3.116.0" }
      azuread = { source = "hashicorp/azuread", version = "~> 2.53.1" }
      random  = { source = "hashicorp/random", version = "~> 3.6.2" }
    }
  }
  provider "azurerm" {
    features {}
  }
  ```

## Usage
Example usage in a root module:
```hcl
module "aks" {
  source                     = "./terraform-azurerm-aks"
  resource_group_name        = "my-aks-rg"
  location                   = "East US"
  cluster_name               = "my-aks-cluster"
  kubernetes_version         = "1.29"
  subnet_id                  = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
  log_analytics_workspace_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.OperationalInsights/workspaces/xxx"
  auto_service_principal     = true
  tags                       = {
    Environment = "Production"
  }
}
```

### Service Principal Configuration
- **Automated Service Principal**:
  - Set `auto_service_principal = true` to automatically create an Azure AD application, service principal, and password.
  - The service principal is assigned the `Contributor` role on the resource group.
  - Outputs include `service_principal_client_id` and `service_principal_password`.
- **User-Provided Service Principal**:
  - Set `auto_service_principal = false` (default) and provide `service_principal_client_id` and `service_principal_client_secret`.
  - Ensure the provided service principal has `Contributor` permissions on the resource group and `Network Contributor` on the subnet.

## Inputs
| Name                        | Description                                      | Type           | Default                | Required |
|-----------------------------|--------------------------------------------------|----------------|------------------------|----------|
| `resource_group_name`       | Name of the resource group                       | string         | `"aks-rg"`             | No       |
| `location`                  | Azure region for resources                       | string         | `"East US"`            | No       |
| `cluster_name`              | Name of the AKS cluster                          | string         | `"aks-cluster"`        | No       |
| `kubernetes_version`        | Kubernetes version for the AKS cluster           | string         | `"1.29"`               | No       |
| `node_count`                | Number of nodes in the default node pool         | number         | `3`                    | No       |
| `vm_size`                   | VM size for the default node pool                | string         | `"Standard_D2_v2"`     | No       |
| `os_disk_size_gb`           | Disk size for nodes in GB                        | number         | `30`                   | No       |
| `subnet_id`                 | Subnet ID for the AKS cluster                    | string         |                        | Yes      |
| `max_pods`                  | Maximum number of pods per node                  | number         | `110`                  | No       |
| `enable_auto_scaling`       | Enable auto-scaling for the node pool            | bool           | `true`                 | No       |
| `min_count`                 | Minimum node count for auto-scaling              | number         | `3`                    | No       |
| `max_count`                 | Maximum node count for auto-scaling              | number         | `10`                   | No       |
| `availability_zones`        | Availability zones for the node pool             | list(string)   | `["1", "2", "3"]`      | No       |
| `admin_group_object_ids`    | Azure AD group object IDs for AKS admin access   | list(string)   | `[]`                   | No       |
| `service_cidr`              | Service CIDR for AKS network                     | string         | `"10.0.0.0/16"`        | No       |
| `dns_service_ip`            | DNS service IP for AKS                           | string         | `"10.0.0.10"`          | No       |
| `pod_cidr`                  | Pod CIDR for AKS network                         | string         | `"10.244.0.0/16"`      | No       |
| `log_analytics_workspace_id`| Log Analytics workspace ID for monitoring        | string         |                        | Yes      |
| `tags`                      | Tags to apply to resources                       | map(string)    | `{}`                   | No       |
| `auto_service_principal`    | Enable automatic creation of service principal    | bool           | `false`                | No       |
| `service_principal_client_id` | Client ID of the service principal (if not auto) | string         | `""`                   | No       |
| `service_principal_client_secret` | Client secret of the service principal (if not auto) | string     | `""`                   | No       |

## Outputs
| Name                        | Description                                      | Sensitive |
|-----------------------------|--------------------------------------------------|-----------|
| `aks_cluster_name`          | The name of the AKS cluster                      | No        |
| `aks_cluster_id`            | The ID of the AKS cluster                        | No        |
| `kube_config`               | The Kubernetes configuration for the AKS cluster | Yes       |
| `service_principal_client_id` | The client ID of the service principal          | No        |
| `service_principal_password`| The password of the auto-created service principal | Yes       |

## Notes
- Ensure CIDR ranges (`service_cidr`, `pod_cidr`) do not overlap with the VNet containing `subnet_id`.
- The module uses a system-assigned managed identity for AKS operations, but a service principal (auto or provided) is configured for additional integrations (e.g., CI/CD pipelines).
- Test the module with `terraform apply` to validate deployment in your Azure environment.