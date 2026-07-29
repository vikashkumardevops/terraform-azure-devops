module "resource_group" {
  source = "../../Modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../Modules/azurerm_virtual_network"
  vnets      = var.vnets
}

module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../../Modules/azurerm_subnet"
  subnets    = var.subnets

}

module "public_ip" {
  depends_on = [module.resource_group]
  source     = "../../Modules/azurerm_public_ip"
  pips       = var.pips
}

module "nics" {
  depends_on = [module.subnet, module.public_ip]
  source     = "../../Modules/azurerm_network_interface"
  nics       = var.nics
}

module "nsg" {
  depends_on = [module.resource_group]
  source     = "../../Modules/azurerm_network_security_group"
  nsgs       = var.nsgs
}

module "storage_account" {
  depends_on = [module.resource_group]
  source     = "../../Modules/azurerm_storage_account"
  sas        = var.sas
}

module "storage_container" {
  depends_on = [module.storage_account]
  source     = "../../Modules/azurerm_storage_container"
  conts      = var.conts
}

module "app_gateway" {
  depends_on   = [module.subnet, module.public_ip]
  source       = "../../Modules/azurerm_application_gateway"
  app_gateways = var.app_gateways
}

module "linux_virtual_machine" {
  depends_on = [module.nics]
  source     = "../../Modules/azurerm_linux_virtual_machine"
  vms        = var.vms
}