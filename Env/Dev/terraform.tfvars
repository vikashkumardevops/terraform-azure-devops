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

nics = {
  nic-1 = {
    name                          = "frontend-nic"
    location                      = "eastus"
    resource_group_name           = "dev-rg"
    ip_config_name                = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_name                   = "public-subnet"
    virtual_network_name          = "dev-vnet"
    pip_name                      = "Frontend-VM-PIP"
    tags = {
      Environment = "Dev"
      Subnet      = "Public"
    }

  }

  nic-2 = {
    name                          = "backend-nic"
    location                      = "eastus"
    resource_group_name           = "dev-rg"
    ip_config_name                = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_name                   = "private-subnet"
    virtual_network_name          = "dev-vnet"
    pip_name                      = "Backend-VM-PIP"
    tags = {
      Environment = "Dev"
      Subnet      = "Private"
    }

  }
}