module "mgmt-network-security-group" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  tags = {
    Name       = format("%s-sg-mgmt", var.prefix)
    uk_se_name = var.uk_se_name
  }
}

#
# Create the Network Security group Module to associate with BIGIP-External-Nic
#
module "external-network-security-group-public" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
  tags = {
    Name       = format("%s-sg-ext", var.prefix)
    uk_se_name = var.uk_se_name
  }
}

resource "azurerm_network_security_rule" "mgmt_allow_https" {
  name                        = "Allow_Https"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  source_address_prefix       = data.http.myip.response_body
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.mgmt-network-security-group]
}

resource "azurerm_network_security_rule" "mgmt_allow_ssh" {
  name                        = "Allow_ssh"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  source_address_prefix       = data.http.myip.response_body
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.mgmt-network-security-group]
}

resource "azurerm_network_security_rule" "external_allow_https" {
  name                        = "Allow_Https"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  source_address_prefix       = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.external-network-security-group-public]
}

# resource "azurerm_network_security_rule" "external_allow_ssh" {
#   name                        = "Allow_ssh"
#   priority                    = 202
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   destination_address_prefix  = "*"
#   source_address_prefixes     = var.AllowedIPs
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
#   depends_on                  = [module.external-network-security-group-public]
# }

resource "azurerm_application_security_group" "bigip_asg" {
  name                = format("%s-external-asg-%s", var.prefix, random_id.id.hex)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags = {
    Name       = format("%s-external-asg-%s", var.prefix, random_id.id.hex)
    uk_se_name = var.uk_se_name
  }
}