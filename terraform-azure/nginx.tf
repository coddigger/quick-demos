resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  #  upgrade_policy_mode = "Manual"
  sku                             = "Standard_DS1_v2"
  admin_username                  = "azureuser"
  admin_password                  = random_string.password.result
  disable_password_authentication = false
  computer_name_prefix            = format("%s-vmss-", var.prefix)
  custom_data                     = base64encode(file("./templates/nginx.tpl"))


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching               = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "singlenic"
    primary = true

    ip_configuration {
      name      = "ipconf"
      subnet_id = data.azurerm_subnet.ext.id
      primary   = true
    }
  }

  tags = {
    Name       = format("%s-vmss-", var.prefix)
    uk_se_name = var.uk_se_name
  }
}