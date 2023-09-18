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
  source = "cyber-scot/automation-account/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  automation_account_name = "aa-${var.short}-${var.loc}-${var.env}-01"

  powershell_modules = [
    {
      name    = "Az.Accounts"
      version = "2.13.0"
      uri     = "https://psg-prod-eastus.azureedge.net/packages/az.accounts.2.13.0.nupkg"
    },
  ]

  # Python Packages
  python3_packages = [
    {
      name           = "requests"
      content_uri    = "https://pypi.org/packages/source/r/requests/requests-2.31.0.tar.gz"
      hash_algorithm = "sha256"
      hash_value     = "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
