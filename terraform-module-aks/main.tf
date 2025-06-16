# Generating a random string for unique resource naming
resource "random_string" "postfix" {
  length  = 8
  special = false
  upper   = false
}

# Creating resource group for AKS
resource "azurerm_resource_group" "aks" {
  name     = join("-", [var.resource_group_name, random_string.postfix.result])
  location = var.location
  tags     = var.tags
}

# Creating Azure AD application for AKS service principal when auto_service_principal is true
resource "azuread_application" "aks" {
  count        = var.auto_service_principal ? 1 : 0
  display_name = join("-", [var.cluster_name, random_string.postfix.result, "app"])
}

# Creating service principal for AKS when auto_service_principal is true
resource "azuread_service_principal" "aks" {
  count     = var.auto_service_principal ? 1 : 0
  client_id = azuread_application.aks[0].client_id
}

# Generating random password for service principal when auto_service_principal is true
resource "random_password" "aks_sp_password" {
  count   = var.auto_service_principal ? 1 : 0
  length  = 20
  special = true
}

# Creating service principal password when auto_service_principal is true
resource "azuread_application_password" "aks" {
  count          = var.auto_service_principal ? 1 : 0
  application_id = azuread_application.aks[0].id
  value          = random_password.aks_sp_password[0].result
  end_date_relative = "17520h" # 2 years
}

# Assigning Contributor role to service principal for the resource group when auto_service_principal is true
resource "azurerm_role_assignment" "aks_sp_contributor" {
  count                = var.auto_service_principal ? 1 : 0
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aks[0].object_id
}

# Creating AKS cluster with modern configurations
resource "azurerm_kubernetes_cluster" "aks" {
  name                = join("-", [var.cluster_name, random_string.postfix.result])
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = join("-", [var.cluster_name, random_string.postfix.result])
  kubernetes_version  = var.kubernetes_version

  # Default node pool configuration
  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    os_disk_size_gb     = var.os_disk_size_gb
    vnet_subnet_id      = var.subnet_id
    max_pods            = var.max_pods
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_count : null
    max_count           = var.enable_auto_scaling ? var.max_count : null
    type                = "VirtualMachineScaleSets"
    availability_zones  = var.availability_zones
  }

  # Using managed identity for security
  identity {
    type = "SystemAssigned"
  }

  # Using provided service principal when auto_service_principal is false
  dynamic "service_principal" {
    for_each = var.auto_service_principal ? [] : [1]
    content {
      client_id     = var.service_principal_client_id
      client_secret = var.service_principal_client_secret
    }
  }

  # Enabling Azure RBAC for better security
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  # Enabling network profile with Azure CNI
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    pod_cidr           = var.pod_cidr
  }

  # Enabling monitoring with OMS agent
  oms_agent {
    enabled                    = true
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # Enabling auto-upgrade for patch versions
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [22, 23]
    }
  }

  # Adding tags
  tags = var.tags

  # Ensuring dependencies are created before AKS
  depends_on = [
    azurerm_resource_group.aks,
    var.auto_service_principal ? azuread_service_principal.aks[0].id : null,
    var.auto_service_principal ? azurerm_role_assignment.aks_sp_contributor[0].id : null
  ]
}

# Creating role assignment for AKS managed identity
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Creating diagnostic settings for AKS
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = join("-", [var.cluster_name, random_string.postfix.result, "diagnostics"])
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
    enabled  = true
  }
  enabled_log {
    category = "kube-controller-manager"
    enabled  = true
  }
  enabled_log {
    category = "cluster-autoscaler"
    enabled  = true
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}