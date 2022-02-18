# Load Balancer 

 resource "azurerm_lb" "magento" {
   name                = "MagentoBalancer"
   location            = azurerm_resource_group.test.location
   resource_group_name = azurerm_resource_group.test.name

   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.test.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "magento" {
   loadbalancer_id     = azurerm_lb.magento.id
   name                = "BackEndAddressPool"
 }


