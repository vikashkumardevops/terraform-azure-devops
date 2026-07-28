resource "azurerm_application_gateway" "app_gateway" {
  for_each            = var.app_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.sku_capacity
  }

  gateway_ip_configuration {
    name      = each.value.gateway_ip_config_name
    subnet_id = data.azurerm_subnet.subnet[each.key].id
  }

  frontend_port {
    name = each.value.frontend_port_name
    port = each.value.frontend_port
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_config_name
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }

  backend_address_pool {
    name = each.value.backend_address_pool_name
  }

  backend_http_settings {
    name                  = each.value.backend_http_settings_name
    cookie_based_affinity = each.value.cookie_based_affinity
    path                  = lookup(each.value, "backend_path", "/")
    port                  = each.value.backend_port
    protocol              = each.value.backend_protocol
    request_timeout       = lookup(each.value, "request_timeout", 60)
  }

  http_listener {
    name                           = each.value.http_listener_name
    frontend_ip_configuration_name = each.value.frontend_ip_config_name
    frontend_port_name             = each.value.frontend_port_name
    protocol                       = each.value.listener_protocol
  }

  request_routing_rule {
    name                       = each.value.request_routing_rule_name
    rule_type                  = lookup(each.value, "rule_type", "Basic")
    http_listener_name         = each.value.http_listener_name
    backend_address_pool_name  = each.value.backend_address_pool_name
    backend_http_settings_name = each.value.backend_http_settings_name
    priority                   = lookup(each.value, "priority", 100)
  }

  tags = lookup(each.value, "tags", null)
}
