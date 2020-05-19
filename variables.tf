
variable "agent_count" {
  description = "count of nodes in the AKS cluster, e.g. 2"
  default     = 1
}

variable "agent_count_min" {
  description = "count of nodes in the AKS cluster, e.g. 2"
  default     = 0
}

variable "agent_count_max" {
  description = "count of nodes in the AKS cluster, e.g. 2"
  default     = 10
}

variable "agent_count_enable_autoscale" {
  description = "count of nodes in the AKS cluster, e.g. 2"
  default     = true
}

# create a service endpoint for Microsoft.SQL?
variable "create_sql_service_endpoint" {
  default = false
}

# azure ad aks default user
variable "aks_defaultuser" {
  default = "mamelch"
}

variable "aks_defaultuser_ssh_public_key" {
  description = "the public key of the aks default user for ssh access to the nodes."
}

variable "dns_prefix" {
  description = "DNS prefix for this AKS cluster"
}

variable cluster_name {
  description = "Name of the AKS cluster"
}

variable resource_group_name {
  description = "Resource Group Name for AKS"
}

variable "vnet_subnet_id" {
  description = "subnet id"
}

variable vnet_name {
  description = "VNET Name for AKS"
}

variable "sp_client_id" {
  description = "The client id of the service principal"
}

variable "sp_client_secret" {
  description = "The client secret of the service principal"
}

variable location {
  default = "westeurope"
}

variable kubernetes_version {
  default = "1.13.7"
}

variable aks_node_vm_size {
  default = "Standard_B2s"
}

# default tags applied to all resources
variable "environment" {
  default = "prod"
}

# Workaround for Windows machines
variable "sleep_command" {
  description = "use timeout command for Windows machines"
  default     = "sleep"
}
variable "subscription_name" {
  description = "subscription name"
}
variable "subscription_id" {
  description = "subscription id"
}
variable "environment" {
  description = "environment"
}
variable "kubeconfig_to_disk" {
  description = "This disables or enables the kube config file from being written to disk."
  type        = string
  default     = "true"
}
variable "output_directory" {
  type    = string
  default = "./output"
}
variable "kubeconfig_filename" {
  description = "Name of the kube config file saved to disk."
  type        = string
  default     = "bedrock_kube_config"
}

variable "acr_name" {}