###########################################################################################################################################################################
#######     PROVIDERS
###########################################################################################################################################################################

variable "AKS_RESOURCE_GROUP" {
  type        = string
  description = "This is the AKS rg name"
}

variable "APIM_RESOURCE_GROUP" {
  type        = string
  description = "This is the APIM rg name"
}

variable "ACR" {
  type        = string
  description = "This is the acr name"
}

variable "VNT" {
  type        = string
  description = "This is the vnet name"
}

variable "APIM" {
  type        = string
  description = "This is the API manager name"
}

variable "VNT_ADDRESS_PREFIX" {
  type        = list(string)
  description = "This is the vnet address prefix"
}

variable "LOG_ANALYTICS_WORKSPACE_NAME" {
  type        = string
  description = "This is the LAW name"
}

variable "APIM_NSG" {
  type        = string
  description = "This is the APIM NSG name"
}

variable "AKS_CLUSTER" {
  type        = string
  description = "This is the aks name"
}

variable "DIAGNOSTIC_SETTING_NAME" {
type          = string
description   = "This is the ds name"
}

variable "STORAGE_ACCOUNT_NAME" {
  type        = string
  description = "This is the sa name"
}

variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "This is the working Azure Subscription ID"
  
}

