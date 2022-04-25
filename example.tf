data "azurerm_virtual_network" "your-vnet" {
  name                = "your_vnet"
  resource_group_name = "your_rg"
}
data "azurerm_subnet" "your-subnet" {
  virtual_network_name = data.azurerm_virtual_network.your-vnet.name
  name                 = "your_subnet"
  resource_group_name  = "your_rg"
}
module "aks" {
  source = "../terraform-module-aks"

  aks_node_vm_size               = "standard_d2s_v3"
  dns_prefix                     = "env"
  cluster_name                   = "your_cluster"
  resource_group_name            = "your_rg"
  vnet_name                      = "your vnet name"
  vnet_subnet_id                 = data.azurerm_subnet.your-subnet.id
  location                       = "cloud_region"
  agent_count_min                = 1
  agent_count_max                = 3
  agent_count_enable_autoscale   = true
  kubernetes_version             = "1.21.9"
  environment                    = "environment"
  sp_client_id                   = "your existing SP id"
  sp_client_secret               = "your existing client secret for SP"
  subscription_id                = "your subscription id"
  container_registry_name        = "your container registry name"
  azure_ad_managed               = true
  azure_rbac_enabled             = true
  admin_group_object_ids         = "admin group object id"
}