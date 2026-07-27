rgs = {
  rg-1 = {
    name     = "dev-rg"
    location = "eastus"
    tags = {
      Environment  = "Dev"
      "Created by" = "Vikash"
    }
  }
}

vnets = {
  vnet-1 = {
    name                = "dev-vnet"
    location            = "eastus"
    resource_group_name = "dev-rg"
    address_space       = ["10.0.0.0/16"]
    tags = {
      Environment  = "Dev"
      "Created by" = "Vikash"
    }
  }
}

subnets = {
  "subnet-1" = {
    name                 = "public-subnet"
    resource_group_name  = "dev-rg"
    virtual_network_name = "dev-vnet"
    address_prefixes     = ["10.0.1.0/24"]
  }
  "subnet-2" = {
    name                 = "private-subnet"
    resource_group_name  = "dev-rg"
    virtual_network_name = "dev-vnet"
    address_prefixes     = ["10.0.2.0/24"]
  }
}


pips = {
  pip-1 = {
    name                = "Frontend-VM-PIP"
    resource_group_name = "dev-rg"
    location            = "eastus"
    allocation_method   = "Static"
    tags = {
      Environment  = "Dev"
      "Created By" = "Vikash"
    }
  }

  pip-2 = {
    name                = "Backend-VM-PIP"
    resource_group_name = "dev-rg"
    location            = "eastus"
    allocation_method   = "Static"
    tags = {
      Environment  = "Dev"
      "Created By" = "Vikash"
    }
  }
}