resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  address_prefixes     = [var.subnet_prefixes[count.index]]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.subnet_names)
  name                = "nsg-${var.subnet_names[count.index]}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_network_security_rule" "nsg_rule" {
  count                       = length(var.subnet_names)
  name                        = "allow_ssh_http_https"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[count.index].name
}

resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}