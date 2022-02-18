# Load Balancer 

# Create Network Security Group and rule Ingress Rule
resource "azurerm_network_security_group" "magento" {
  name                = "MAgentSecurityGrpup"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
  name                       = "HTTP"
  priority                   = 900
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "HTTPS"
  priority                   = 901
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "SSH"
  priority                   = 902
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  }
}


 esource "azurerm_lb" "magento" {
 name                = "magento-lb"
 location            = var.location
 resource_group_name = azurerm_resource_group.rg.name

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   public_ip_address_id = azurerm_public_ip.magento.id
 }

 tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "magento" {
 loadbalancer_id     = azurerm_lb.magento.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "SSH" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.magento.id
  name                = "ssh-running-probe"
  port                = "22"
}

resource "azurerm_lb_probe" "http" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.magento.id
  name                = "magentoLBHTTPProbe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

resource "azurerm_lb_probe" "https" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.magento.id
  name                = "magentoLBHTTPSProbe"
  protocol            = "Https"
  port                = 443
  request_path        = "/"
}


resource "azurerm_lb_rule" "http" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "magentoLBHTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_rule" "https" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "magentoLBHTTPSRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  probe_id                       = azurerm_lb_probe.https.id
}

resource "azurerm_virtual_machine_scale_set" "magento" {
 name                = "MagentoScaleConfig"
 location            = var.location
 resource_group_name = azurerm_resource_group.vmss.name
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_DS1_v2"
   tier     = "Standard"
   capacity = 2
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "magento-"
   admin_username       = var.admin_user
   admin_password       = var.admin_password
   custom_data          = file("magento.sh")
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "NetworkProfile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = azurerm_subnet.magento.id
     load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.magento.id]
     primary = true
   }
 }

 tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "myAutoscaleSetting"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_virtual_machine_scale_set.magento.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_virtual_machine_scale_set.magento.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 90
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_virtual_machine_scale_set.magento.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }  
}


