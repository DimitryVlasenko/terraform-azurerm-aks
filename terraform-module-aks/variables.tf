variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-rg"
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2_v2"
}

variable "os_disk_size_gb" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 30
}

variable "subnet_id" {
  description = "Subnet ID for the AKS cluster"
  type        = string
}

variable "max_pods" {
  description = "Maximum number of pods per node"
  type        = number
  default     = 110
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum node count for auto-scaling"
  type        = number
  default     = 3
}

variable "max_count" {
  description = "Maximum node count for auto-scaling"
  type        = number
  default     = 10
}

variable "availability_zones" {
  description = "Availability zones for the node pool"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs for AKS admin access"
  type        = list(string)
  default     = []
}

variable "service_cidr" {
  description = "Service CIDR for AKS network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
  default     = "10.0.0.10"
}

variable "pod_cidr" {
  description = "Pod CIDR for AKS network"
  type        = string
  default     = "10.244.0.0/16"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for monitoring"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "auto_service_principal" {
  description = "Enable automatic creation of service principal for AKS"
  type        = bool
  default     = false
}

variable "service_principal_client_id" {
  description = "Client ID of the service principal when auto_service_principal is false"
  type        = string
  default     = ""
}

variable "service_principal_client_secret" {
  description = "Client secret of the service principal when auto_service_principal is false"
  type        = string
  default     = ""
  sensitive   = true
}
