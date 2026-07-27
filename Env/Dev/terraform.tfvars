rgs = {
  rg-1 = {
    name     = "dev-rg"
    location = "eastus"
    tags = {
        Environment = "Dev"
        "Created by" = "Vikash"
    }
  }
}

vnets = {
    vnet-1 = {
        name = "dev-vnet"
        location = "eastus"
        resource_group_name = "dev-rg"
         tags = {
        Environment = "Dev"
        "Created by" = "Vikash"
        }
    }
}