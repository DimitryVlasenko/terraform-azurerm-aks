# Example usage of the AKS module with automatic service principal creation
module "aks_auto_sp" {
  source                     = "./"
  resource_group_name        = "my-aks-rg"
  location                   = "East US"
  cluster_name               = "my-aks-cluster-auto"
  kubernetes_version         = "1.29"
  node_count                 = 3
  vm_size                    = "Standard_D2_v2"
  os_disk_size_gb            = 30
  subnet_id                  = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
  max_pods                   = 110
  enable_auto_scaling        = true
  min_count                  = 3
  max_count                  = 10
  availability_zones         = ["1", "2", "3"]
  admin_group_object_ids     = ["xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
  service_cidr               = "10.0.0.0/16"
  dns_service_ip             = "10.0.0.10"
  pod_cidr                   = "10.244.0.0/16"
  log_analytics_workspace_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.OperationalInsights/workspaces/xxx"
  auto_service_principal     = true
  tags                       = {
    Environment = "Production"
    Project     = "AKS-Deployment"
  }
}

# Example usage of the AKS module with user-provided service principal
module "aks_provided_sp" {
  source                     = "./"
  resource_group_name        = "my-aks-rg"
  location                   = "East US"
  cluster_name               = "my-aks-cluster-provided"
  kubernetes_version         = "1.29"
  node_count                 = 3
  vm_size                    = "Standard_D2_v2"
  os_disk_size_gb            = 30
  subnet_id                  = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
  max_pods                   = 110
  enable_auto_scaling        = true
  min_count                  = 3
  max_count                  = 10
  availability_zones         = ["1", "2", "3"]
  admin_group_object_ids     = ["xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
  service_cidr               = "10.0.0.0/16"
  dns_service_ip             = "10.0.0.10"
  pod_cidr                   = "10.244.0.0/16"
  log_analytics_workspace_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.OperationalInsights/workspaces/xxx"
  auto_service_principal     = false
  service_principal_client_id = "yyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
  service_principal_client_secret = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
  tags                       = {
    Environment = "Production"
    Project     = "AKS-Deployment"
  }
}
