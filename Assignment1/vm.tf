resource "azurerm_linux_virtual_machine" "vm" {
  count                           = 3
  name                            = "vm-${count.index}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub") # Replace with the path to your public SSH key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "loadbalancer" {
  name                = "terraform-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "backendpool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

resource "azurerm_lb_rule" "lbrule" {
  name                           = "http_rule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  frontend_ip_configuration_name = azurerm_lb.loadbalancer.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
}

resource "azurerm_lb_probe" "lbprobe" {
  name                = "http_probe"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}
