module "bigip" {
  count                          = var.bigip_count
  source                         = "F5Networks/bigip-module/azure"
  prefix                         = format("%s-2nic", var.prefix)
  resource_group_name            = azurerm_resource_group.rg.name
  f5_ssh_publickey               = azurerm_ssh_public_key.demo.public_key
  mgmt_subnet_ids                = [{ "subnet_id" = data.azurerm_subnet.mgmt.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids         = [module.mgmt-network-security-group.network_security_group_id]
  external_subnet_ids            = [{ "subnet_id" = data.azurerm_subnet.ext.id, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids     = [module.external-network-security-group-public.network_security_group_id]
  external_app_securitygroup_ids = [azurerm_application_security_group.bigip_asg.id]
  availability_zone              = var.availability_zone
  availabilityZones_public_ip    = var.availabilityZones_public_ip
  #f5_version                     = var.f5_version
  #f5_product_name	              = var.f5_image_name
}