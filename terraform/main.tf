provider "azurerm" {
  features {}
  #subscription_id = "1411a036-a526-4973-8426-f985e176b945"
}
terraform {
  backend "azurerm" {
    resource_group_name  = "dotnetapp-rg"
    storage_account_name = "dotnetstoragest123"  # ✅ Your actual storage account
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dotnetapp"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_container_registry.acr]
}

# OPTIONAL BUT RECOMMENDED:
# Allow AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id

  depends_on = [azurerm_kubernetes_cluster.aks]
}
