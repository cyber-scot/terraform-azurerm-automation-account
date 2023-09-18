module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

locals {
  one_hour_from_now = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(timestamp(), "1h"))
}

module "aa" {
  source = "../../"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  automation_account_name = "aa-${var.short}-${var.loc}-${var.env}-01"

  powershell_modules = [
    {
      name    = "Az"
      version = "10.3.0"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.10.3.0.nupkg"
    },
    {
      name    = "Az.Accounts"
      version = "2.13.0"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.accounts.2.13.0.nupkg"
    },
    {
      name    = "Az.Advisor"
      version = "2.0.0"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.advisor.2.0.0.nupkg"
    },
    {
      name    = "Az.Aks"
      version = "5.5.1"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.aks.5.5.1.nupkg"
    },
    {
      name    = "Az.Websites"
      version = "3.1.1"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.websites.3.1.1.nupkg"
    }
  ]

  # Python Packages
  python3_packages = [
    {
      name           = "azure-mgmt-resource"
      uri            = "https://files.pythonhosted.org/packages/81/65/128984a9bdca0542a6fabd748e4b84398de625193379ac7fc3a0805465cd/azure-mgmt-resource-23.0.1.zip"
      hash_algorithm = "SHA256"
      hash_value     = "c2ba6cfd99df95f55f36eadc4245e3dc713257302a1fd0277756d94bd8cb28e0"
    },
  ]

  automation_schedule = [
    {
      name        = "Weekly-Schedule"
      frequency   = "Week"
      description = "This is an example schedule"
      interval    = 1
      start_time  = local.one_hour_from_now
      timezone    = "Europe/London"
      week_days   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
  ]
}
