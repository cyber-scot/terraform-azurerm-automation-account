resource "azurerm_automation_account" "aa" {
  name                          = var.automation_account_name
  location                      = var.location
  resource_group_name           = var.rg_name
  tags                          = var.tags
  sku_name                      = title(var.sku_name)
  public_network_access_enabled = var.public_network_access_enabled
  local_authentication_enabled  = var.local_authentication_enabled

  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == "SystemAssigned, UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  # Add dynamic block for encryption if you plan to use it
  dynamic "encryption" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }
}


resource "azurerm_automation_module" "powershell_modules" {
  count                   = length(var.powershell_modules) > 0 ? length(var.powershell_modules) : 0
  name                    = var.powershell_modules[count.index].name
  resource_group_name     = var.rg_name
  automation_account_name = azurerm_automation_account.aa.name
  module_link {
    uri = var.powershell_modules[count.index].uri

    dynamic "hash" {
      for_each = var.powershell_modules[count.index].hash != null ? [var.powershell_modules[count.index].hash] : []
      content {
        algorithm = hash.value.algorithm
        value     = hash.value.value
      }
    }
  }
}

resource "azurerm_automation_python3_package" "python3_packages" {
  count                   = length(var.python3_packages) > 0 ? length(var.python3_packages) : 0
  name                    = var.python3_packages[count.index].name
  resource_group_name     = var.rg_name
  automation_account_name = azurerm_automation_account.aa.name
  content_uri             = var.python3_packages[count.index].content_uri
  content_version         = var.python3_packages[count.index].content_version
  hash_algorithm          = var.python3_packages[count.index].hash_algorithm
  hash_value              = var.python3_packages[count.index].hash_value
  tags                    = var.python3_packages[count.index].tags
}

resource "azurerm_automation_schedule" "schedules" {
  count                   = length(var.automation_schedule) > 0 ? length(var.automation_schedule) : 0
  name                    = var.automation_schedule[count.index].name
  resource_group_name     = var.rg_name
  automation_account_name = azurerm_automation_account.aa.name
  frequency               = var.automation_schedule[count.index].frequency
  description             = var.automation_schedule[count.index].description
  interval                = var.automation_schedule[count.index].interval
  start_time              = var.automation_schedule[count.index].start_time
  expiry_time             = var.automation_schedule[count.index].expiry_time
  timezone                = var.automation_schedule[count.index].timezone
  week_days               = var.automation_schedule[count.index].week_days
  month_days              = var.automation_schedule[count.index].month_days

  dynamic "monthly_occurrence" {
    for_each = var.automation_schedule[count.index].monthly_occurrence != null ? var.automation_schedule[count.index].monthly_occurrence : []
    content {
      day        = monthly_occurrence.value.day
      occurrence = monthly_occurrence.value.occurrence
    }
  }
}

resource "azurerm_automation_runbook" "runbook" {
  count                   = length(var.runbooks)
  name                    = var.runbooks[count.index].name
  location                = var.location
  resource_group_name     = var.rg_name
  automation_account_name = azurerm_automation_account.aa.name
  runbook_type            = var.runbooks[count.index].runbook_type
  log_progress            = var.runbooks[count.index].log_progress
  log_verbose             = var.runbooks[count.index].log_verbose
  description             = var.runbooks[count.index].description
  content                 = var.runbooks[count.index].content

  dynamic "publish_content_link" {
    for_each = var.runbooks[count.index].publish_content_link != null ? [var.runbooks[count.index].publish_content_link] : []
    content {
      uri     = publish_content_link.value.uri
      version = publish_content_link.value.version
      dynamic "hash" {
        for_each = publish_content_link.value.hash != null ? [publish_content_link.value.hash] : []
        content {
          algorithm = hash.value.algorithm
          value     = hash.value.value
        }
      }
    }
  }

  dynamic "draft" {
    for_each = var.runbooks[count.index].draft != null ? [var.runbooks[count.index].draft] : []
    content {
      edit_mode_enabled = draft.value.edit_mode_enabled

      dynamic "content_link" {
        for_each = draft.value.content_link != null ? [draft.value.content_link] : []
        content {
          uri     = content_link.value.uri
          version = content_link.value.version

          dynamic "hash" {
            for_each = content_link.value.hash != null ? [content_link.value.hash] : []
            content {
              algorithm = hash.value.algorithm
              value     = hash.value.value
            }
          }
        }
      }

      output_types = draft.value.output_types

      dynamic "parameters" {
        for_each = draft.value.parameters != null ? draft.value.parameters : []
        content {
          key           = parameters.value.key
          type          = parameters.value.type
          mandatory     = parameters.value.mandatory
          position      = parameters.value.position
          default_value = parameters.value.default_value
        }
      }
    }
  }
}
