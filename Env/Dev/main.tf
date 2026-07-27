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