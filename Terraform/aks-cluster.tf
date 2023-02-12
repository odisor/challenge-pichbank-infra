resource "azurerm_kubernetes_cluster" "aks" {

  name                 = var.AKS_CLUSTER
  location             = "East US"
  resource_group_name  = azurerm_resource_group.RGP_AKS.name
  dns_prefix           = var.AKS_CLUSTER
  azure_policy_enabled = true

  default_node_pool {
    name                = "systempool"
    node_count          = 1
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    vnet_subnet_id      = azurerm_subnet.AKS_SNT.id
    vm_size             = "standard_b2s"
    zones               = ["1"]
  }

  auto_scaler_profile {
    scale_down_unneeded         = "1m"
    scale_down_delay_after_add  = "1m"
    scale_down_unready          = "1m"
    skip_nodes_with_system_pods = true
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.0.0.0/16"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_kubernetes_cluster_node_pool" "linuxnp" {
  name                  = "linuxagent1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  os_type               = "Linux"
  node_count            = 2
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 3
  mode                  = "User"
  vm_size               = "standard_b2s"
  zones                 = ["1"]
  vnet_subnet_id        = azurerm_subnet.AKS_SNT.id
}

/*
resource "azurerm_kubernetes_cluster_node_pool" "winnp" {
  name                  = "win1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  os_type               = "Windows"
  node_count            = 1
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = 3
  mode                  = "User"
  vm_size               = "Standard_D2as_v5"
  zones                 = ["1"]
  vnet_subnet_id        = element(azurerm_virtual_network.network.subnet.*.id, 0)
}
*/
resource "azurerm_monitor_diagnostic_setting" "diagnostic_logs" {
  name               = var.DIAGNOSTIC_SETTING_NAME
  target_resource_id = azurerm_kubernetes_cluster.aks.id
  storage_account_id = azurerm_storage_account.storage.id

  dynamic "log" {
    for_each = ["kube-apiserver", "kube-controller-manager", "cluster-autoscaler", "kube-scheduler", "kube-audit", "kube-audit-admin", "guard"]
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }
}


