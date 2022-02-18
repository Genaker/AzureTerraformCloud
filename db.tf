#Magento MySQL Server
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
