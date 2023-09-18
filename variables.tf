variable "automation_account_name" {
  type        = string
  description = "The name of the automation account"
}

variable "automation_schedule" {
  description = "Configuration for the Automation Schedule"
  type = list(object({
    name        = string
    frequency   = string
    description = optional(string)
    interval    = optional(number)
    start_time  = optional(string)
    expiry_time = optional(string)
    timezone    = optional(string)
    week_days   = optional(list(string))
    month_days  = optional(list(number))
    monthly_occurrence = optional(list(object({
      day        = string
      occurrence = number
    })))
  }))
  default = []
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault Key which should be used to Encrypt the data in this Automation Account."
  type        = string
  default     = null
}

variable "local_authentication_enable" {
  type        = bool
  description = "Whether local authentication enabled"
  default     = false
}

variable "local_authentication_enabled" {
  type        = bool
  description = "Whether local authentication should be anbled"
  default     = false
}

variable "location" {
  description = "The location for this resource to be put in"
  type        = string
}

variable "powershell_modules" {
  description = "List of PowerShell modules to be added"
  type = list(object({
    name = string
    uri  = string
    hash = object({
      algorithm = string
      value     = string
    })
  }))
  default = []
}


variable "public_network_access_enabled" {
  type        = bool
  description = "If public network access is enabled"
  default     = false
}

variable "python3_packages" {
  description = "List of Python3 packages to be added"
  type = list(object({
    name            = string
    content_uri     = string
    content_version = optional(string)
    hash_algorithm  = optional(string)
    hash_value      = optional(string)
    tags            = optional(map(string))
  }))
  default = []
}

variable "rg_name" {
  description = "The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists"
  type        = string
}

variable "runbooks" {
  description = "List of runbooks to be created."
  type = list(object({
    name         = string
    runbook_type = string
    log_progress = bool
    log_verbose  = bool
    description  = optional(string)
    content      = optional(string)
    publish_content_link = optional(object({
      uri     = string
      version = optional(string)
      hash = optional(object({
        algorithm = string
        value     = string
      }))
    }))
    draft = optional(object({
      edit_mode_enabled = bool
      content_link = optional(object({
        uri     = string
        version = optional(string)
        hash = optional(object({
          algorithm = string
          value     = string
        }))
      }))
      output_types = optional(list(string))
      parameters = optional(list(object({
        key           = string
        type          = string
        mandatory     = optional(bool)
        position      = optional(number)
        default_value = optional(string)
      })))
    }))
  }))
  default = []
}

variable "sku_name" {
  type        = string
  description = "The SKU of the automation account, Basic is the only supported value"
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."
}

variable "user_assigned_identity_id" {
  description = "The User Assigned Managed Identity ID to be used for accessing the Customer Managed Key for encryption."
  type        = string
  default     = null
}
