data "azurerm_resource_group" "aks_resource_group" {
  name = "${var.resource_group_name}"
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.vnet_name}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      windows_profile,
      tags
    ]
  }
  linux_profile {
    admin_username = "${var.aks_defaultuser}"

    ssh_key {
      key_data = "${var.aks_defaultuser_ssh_public_key}"
    }
  }

  default_node_pool {
    name                = "default"
    node_count          = "${var.agent_count}"
    vm_size             = "${var.aks_node_vm_size}"
    os_disk_size_gb     = 30
    max_pods            = 30
    min_count           = "${var.agent_count_min}"
    max_count           = "${var.agent_count_max}"
    enable_auto_scaling = "${var.agent_count_enable_autoscale}"
    vnet_subnet_id      = "${var.vnet_subnet_id}"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.2.0.0/24"
    dns_service_ip     = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    network_policy     = "calico"
    load_balancer_sku  = "basic"
  }

  service_principal {
    client_id     = "${var.sp_client_id}"
    client_secret = "${var.sp_client_secret}"
  }

  tags = {
    Environment = "${var.environment}"
    Network     = "azurecni"
    RBAC        = "true"
    Policy      = "calico"
  }
}
resource "null_resource" "configure_cr" {
    provisioner "local-exec" {
    command = "echo $ARM_CLIENT_ID && az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID && az extension add --name aks-preview && az aks update -n ${var.cluster_name} --attach-acr /subscriptions/${var.subscription_id}/resourceGroups/shared-rg/providers/Microsoft.ContainerRegistry/registries/${var.acr_name} --resource-group ${var.environment}-rg --subscription ${var.subscription_id}"
  }
depends_on = [azurerm_kubernetes_cluster.aks]
}