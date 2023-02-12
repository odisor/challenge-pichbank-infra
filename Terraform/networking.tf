
resource "azurerm_network_security_group" "apim-nsg" {
  name                = var.APIM_NSG
  location            = "East US"
  resource_group_name = azurerm_resource_group.RGP_APIM.name
  depends_on          = [azurerm_resource_group.RGP_AKS]
}

resource "azurerm_network_security_rule" "https_allow" {
  name                        = "https_inbound_allow"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = element((azurerm_subnet.AKS_SNT.address_prefixes), 0)
  resource_group_name        = azurerm_resource_group.RGP_APIM.name
  network_security_group_name = azurerm_network_security_group.apim-nsg.name
}

resource "azurerm_network_security_rule" "sql_allow" {
  name                        = "AllowAnyCustom1433Outbound"
  priority                   = 100
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "1443"
  source_address_prefix      = "*"
  destination_address_prefix = "Sql"
  resource_group_name        = azurerm_resource_group.RGP_APIM.name
  network_security_group_name = azurerm_network_security_group.apim-nsg.name
}

resource "azurerm_virtual_network" "network" {
  name                = var.VNT
  location            = "East US"
  resource_group_name = var.AKS_RESOURCE_GROUP
  address_space       = var.VNT_ADDRESS_PREFIX
  depends_on          = [azurerm_resource_group.RGP_AKS]

}

resource "azurerm_subnet" "AKS_SNT" {
  name                 = "AKS-SNT"
  resource_group_name  = azurerm_resource_group.RGP_AKS.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "APIM_SNT" {
  name                 = "APIM-SNT"
  resource_group_name  = azurerm_resource_group.RGP_AKS.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.241.0.0/16"]
}

resource "azurerm_subnet_network_security_group_association" "APIM_SNT_NSG" {
  subnet_id                 = azurerm_subnet.APIM_SNT.id
  network_security_group_id = azurerm_network_security_group.apim-nsg.id
}