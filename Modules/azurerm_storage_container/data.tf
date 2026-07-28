data "azurerm_storage_account" "data_sas" {
  for_each            = var.conts
  name                = each.value.storage_name
  resource_group_name = each.value.resource_group_name
}