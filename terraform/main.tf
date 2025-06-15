provider "azurerm" {
  features {}
  subscription_id = "1411a036-a526-4973-8426-f985e176b945"
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

terraform {
  backend "azurerm" {
    resource_group_name  = "dotnetapp-rg"
    storage_account_name = "dotnetstoragest123"  # ✅ Your actual storage account
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}