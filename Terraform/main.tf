###########################################################################################################################################################################
#######     PROVIDERS
###########################################################################################################################################################################

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.AZURE_SUBSCRIPTION_ID
}

###########################################################################################################################################################################
#######     CORE RESOURCES
###########################################################################################################################################################################

resource "azurerm_resource_group" "RGP_AKS" {
  name     = var.AKS_RESOURCE_GROUP
  location = "East US"
}

resource "azurerm_resource_group" "RGP_APIM" {
  name     = var.APIM_RESOURCE_GROUP
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = lower(var.ACR)
  location            = "East US"
  resource_group_name = azurerm_resource_group.RGP_AKS.name
  sku                 = "Standard"
  admin_enabled       = false
  depends_on          = [azurerm_resource_group.RGP_AKS]
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.LOG_ANALYTICS_WORKSPACE_NAME
  location            = "East US"
  resource_group_name = azurerm_resource_group.RGP_AKS.name
  sku                 = "PerGB2018"
  retention_in_days   = "90"
  depends_on          = [azurerm_resource_group.RGP_AKS]
}

resource "azurerm_log_analytics_solution" "log_analytics" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.log_analytics.location
  resource_group_name   = azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_storage_account" "storage" {
  name                      = lower(var.STORAGE_ACCOUNT_NAME)
  location                  = "East US"
  resource_group_name       = azurerm_resource_group.RGP_AKS.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  depends_on          = [azurerm_resource_group.RGP_AKS]
}
