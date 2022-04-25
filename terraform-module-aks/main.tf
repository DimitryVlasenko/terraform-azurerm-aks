data "azurerm_resource_group" "aks_resource_group" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.agent_count
    vm_size             = var.aks_node_vm_size
    os_disk_size_gb     = 30
    max_pods            = 30
    min_count           = var.agent_count_min
    max_count           = var.agent_count_max
    enable_auto_scaling = var.agent_count_enable_autoscale
    vnet_subnet_id      = var.vnet_subnet_id
  }

  azure_active_directory_role_based_access_control {
    managed = var.azure_ad_managed
    azure_rbac_enabled = var.azure_rbac_enabled
    admin_group_object_ids = [var.admin_group_object_ids]
  }

  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  tags = {
    Environment = var.environment
    Network     = "azurecni"
    RBAC        = "true"
  }
}

data "azurerm_container_registry" "env_container_registry" {
  name = var.container_registry_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = var.sp_client_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.env_container_registry.id
  skip_service_principal_aad_check = true
}