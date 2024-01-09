resource "tls_private_key" "demo" {
  algorithm = "RSA"
}

resource "azurerm_ssh_public_key" "demo" {
  name                = format("%s-ssh-key", var.prefix)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = tls_private_key.demo.public_key_openssh
}

resource "null_resource" "key" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.demo.private_key_pem}\" > ssh-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 ssh-key.pem"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ssh-key.pem"
  }
}