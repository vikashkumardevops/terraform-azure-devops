module "resource_group" {
  source = "../../Modules/azurerm_resource_group"
  rgs = var.rgs
}