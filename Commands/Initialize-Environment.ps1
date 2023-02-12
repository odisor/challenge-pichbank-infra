az login

<#
az account set --subscription "Azure Pass - Sponsorship"

az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Monitor
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.Kubernetes
#>


#Define variables

$APP_ID = "PICHBANK2"
$env:TF_VAR_AKS_RESOURCE_GROUP = "RGP-$($APP_ID)-AKS"
$env:TF_VAR_APIM_RESOURCE_GROUP = "RGP-$($APP_ID)-APIM"
$env:TF_VAR_ACR = "ACR$($APP_ID)"
$env:TF_VAR_VNT  = "VNT-$($APP_ID)"
$env:TF_VAR_APIM  = "APIM-$($APP_ID)"
$env:TF_VAR_VNT_ADDRESS_PREFIX = '["10.0.0.0/8"]'
$env:TF_VAR_APIM_NSG = "NSG-$($APP_ID)-API"
$env:TF_VAR_LOG_ANALYTICS_WORKSPACE_NAME = "LAW-$($APP_ID)-AKS"
$env:TF_VAR_AKS_CLUSTER = "AKS-$($APP_ID)"
$env:TF_VAR_DIAGNOSTIC_SETTING_NAME = "DS-$($APP_ID)-AKS"
$env:TF_VAR_STORAGE_ACCOUNT_NAME = "SA$($APP_ID)"
$env:TF_VAR_AZURE_SUBSCRIPTION_ID = <your subs ID here>
