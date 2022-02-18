# Magento MySQL Server

resource "azurerm_subnet" "mysql" {
name                 = "MySQLSubnet"
resource_group_name  = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.rg.name
address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_mysql_server" "magento" {
  name                = "Magento-Mysql-Server"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "GP_Gen5_2"

  storage_profile {
    storage_mb            = 51200
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = "magento"
  administrator_login_password = "magento1234sdfsdf2312!!@dobeSucks"
  version                      = "5.7"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_private_endpoint" "magento" {
  name                = "msql-endpoint"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.magento.id

  private_service_connection {
    name                           = "mysql-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_server.magento.id
    subresource_names              = [ "mysqlServer" ]
    is_manual_connection           = false
  }
}
