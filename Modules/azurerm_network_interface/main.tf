resource "azurerm_network_interface" "nic" {
  for_each = var.nics
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
  
  ip_configuration {
    name                          = each.value.ip_config_name
    private_ip_address_allocation = each.value.private_ip_address_allocation
     subnet_id                     = data.azurerm_subnet.subnet[each.key].id
     public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}