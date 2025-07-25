output "acr_login_server" {
  description = "The login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}
