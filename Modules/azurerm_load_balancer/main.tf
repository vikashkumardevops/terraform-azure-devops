resource "azurerm_public_ip" "lb_pip" {
  for_each            = var.lbs
  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
}

resource "azurerm_lb" "example" {
  for_each            = var.lbs
  name                = each.value.lb_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  frontend_ip_configuration {
    name                 = each.value.ip_config_name
    public_ip_address_id = azurerm_public_ip.lb_pip[each.key].id
  }
}