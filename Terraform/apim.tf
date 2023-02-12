resource "azurerm_public_ip" "apim_public_ip" {
  name                = "apim-public-ip"
  location            = "East US"
  resource_group_name = azurerm_resource_group.RGP_APIM.name
  allocation_method   = "Static"
}

resource "azurerm_api_management" "APIM" {
  name                = var.APIM
  location            = "East US"
  resource_group_name = azurerm_resource_group.RGP_APIM.name
  publisher_name      = "Pichincha Bank Challenge"
  publisher_email     = "hernan.rdr78@outlook.es"
  sku_name = "Developer_1"
  depends_on          = [azurerm_resource_group.RGP_APIM]
  
  virtual_network_configuration {
    subnet_id = azurerm_subnet.APIM_SNT.id
  }
}
