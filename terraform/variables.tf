variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "dotnetapp-rg"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
  validation {
    condition     = contains(["East US", "West US", "Central India", "East US 2"], var.location)
    error_message = "Location must be a valid Azure region like 'East US', 'East US 2', etc."
  }
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "dotnetacr123"
  validation {
    condition     = length(var.acr_name) <= 50 && can(regex("^[a-zA-Z0-9]+$", var.acr_name))
    error_message = "ACR name must be alphanumeric and <= 50 characters."
  }
}

variable "aks_name" {
  description = "Name of the Azure Kubernetes Service cluster"
  type        = string
  default     = "dotnet-aks-cluster"
}
