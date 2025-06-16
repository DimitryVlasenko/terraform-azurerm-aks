output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "kube_config" {
  description = "The Kubernetes configuration for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "service_principal_client_id" {
  description = "The client ID of the service principal (auto-created or provided)"
  value       = var.auto_service_principal ? azuread_service_principal.aks[0].client_id : var.service_principal_client_id
}

output "service_principal_password" {
  description = "The password of the auto-created service principal (empty if provided by user)"
  value       = var.auto_service_principal ? random_password.aks_sp_password[0].result : ""
  sensitive   = true
}