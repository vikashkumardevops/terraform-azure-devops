resource "azurerm_storage_container" "example" {
    for_each = var.conts
  name                  = each.value.cont_name
  container_access_type = each.value.container_access_type
  storage_account_id    = data.azurerm_storage_account.data_sas[each.key].id
}