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

nsgs = {
  nsg-1 = {
    nsg_name                   = "Public-VM-NSG"
    location                   = "eastus"
    resource_group_name        = "dev-rg"
    rule_name                  = "HTTPS-Allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    tags = {
      Environment = "Dev"
      Host        = "Frontend-VM"
      Purpose     = "HTTPS"
    }
  }


  nsg-2 = {
    nsg_name                   = "Backend-VM-NSG"
    location                   = "eastus"
    resource_group_name        = "dev-rg"
    rule_name                  = "MySQL-Allow"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    tags = {
      Environment = "Dev"
      Host        = "Backend-VM"
      Purpose     = "MySQL"
    }
  }
}

sas = {
  sas-1 = {
    name                     = "harekrishnadevstorage"
    location                 = "eastus"
    resource_group_name      = "dev-rg"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    tags = {
      Environment  = "Dev"
      Pupose       = "Staic-Assets"
      "Created By" = "Vikash"
    }
  }
}

conts = {
  cont-1 = {
    cont_name             = "devsecops"
    container_access_type = "private"
    storage_name          = "harekrishnadevstorage"
    resource_group_name   = "devrg"

  }
}

lbs = {
  lb = {
    pip_name            = "PublicIPForLB"
    location            = "eastus"
    resource_group_name = "dev-rg"
    allocation_method   = "Static"
    lb_name             = "Public_NLB"
    ip_config_name      = "PublicIPAddress"
  }
}

app_gateways = {
  appgw-1 = {
    name                       = "dev-app-gateway"
    resource_group_name        = "dev-rg"
    location                   = "eastus"
    sku_name                   = "Standard_v2"
    sku_tier                   = "Standard_v2"
    sku_capacity               = 2
    gateway_ip_config_name     = "app-gateway-ip-config"
    subnet_name                = "public-subnet"
    virtual_network_name       = "dev-vnet"
    frontend_port_name         = "frontend-port-80"
    frontend_port              = 80
    frontend_ip_config_name    = "frontend-ip-config"
    pip_name                   = "Frontend-VM-PIP"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-http-settings"
    cookie_based_affinity      = "Disabled"
    backend_path               = "/"
    backend_port               = 80
    backend_protocol           = "Http"
    request_timeout            = 60
    http_listener_name         = "http-listener"
    listener_protocol          = "Http"
    request_routing_rule_name  = "routing-rule-1"
    rule_type                  = "Basic"
    priority                   = 100
    tags = {
      Environment  = "Dev"
      "Created By" = "Vikash"
    }
  }
}


vms = {
  vm-1 = {
    name                            = "Frontend-VM"
    nic_name                        = "frontend-nic"
    resource_group_name             = "dev-rg"
    location                        = "eastus"
    size                            = "Standard_D4_v5"
    admin_username                  = "adminuser"
    admin_password                  = "testpassword@123"
    disable_password_authentication = "false"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
    publisher                       = "Canonical"
    offer                           = "ubuntu-24_04-lts"
    sku                             = "server"
    version                         = "latest"
    tags = {
      Environment  = "Frontend"
      "Created By" = "Vikash"
      OS           = "Ubuntu"
      Owner        = "Vikash"
      Backup       = "Yes"
    }
  }
  vm-2 = {
    name                            = "Backend-VM"
    nic_name                        = "Backend-nic"
    resource_group_name             = "dev-rg"
    location                        = "eastus"
    size                            = "Standard_D4_v5"
    admin_username                  = "adminuser"
    admin_password                  = "testpassword@123"
    disable_password_authentication = "false"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
    publisher                       = "Canonical"
    offer                           = "ubuntu-24_04-lts"
    sku                             = "server"
    version                         = "latest"
    tags = {
      Environment  = "Backend"
      "Created By" = "Vikash"
      OS           = "Ubuntu"
      Owner        = "Vikash"
      Backup       = "Yes"
    }

  }
}