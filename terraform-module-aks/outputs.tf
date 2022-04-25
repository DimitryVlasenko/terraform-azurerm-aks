output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}
output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "kubeconfig_done" {
  value = join("", local_file.cluster_credentials.*.id)
}
