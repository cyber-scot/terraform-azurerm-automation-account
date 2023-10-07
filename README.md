
```hcl
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
    for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "SystemAssigned,UserAssigned" ? [var.identity_type] : []
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
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.aa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_module.powershell_modules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_module) | resource |
| [azurerm_automation_python3_package.python3_packages](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_python3_package) | resource |
| [azurerm_automation_runbook.runbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule.schedules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusters"></a> [clusters](#input\_clusters) | A list of clusters to create | <pre>list(object({<br>    name                                = string<br>    kubernetes_version                  = string<br>    location                            = string<br>    rg_name                             = string<br>    dns_prefix                          = string<br>    sku_tier                            = string<br>    private_cluster_enabled             = bool<br>    tags                                = map(string)<br>    http_application_routing_enabled    = optional(bool)<br>    azure_policy_enabled                = optional(bool)<br>    role_based_access_control_enabled   = optional(bool)<br>    open_service_mesh_enabled           = optional(bool)<br>    private_dns_zone_id                 = optional(string)<br>    private_cluster_public_fqdn_enabled = optional(bool)<br>    custom_ca_trust_certificates_base64 = optional(list(string), [])<br>    disk_encryption_set_id              = optional(string)<br>    edge_zone                           = optional(string)<br>    image_cleaner_enabled               = optional(bool)<br>    image_cleaner_interval_hours        = optional(number)<br>    automatic_channel_upgrade           = optional(string, null)<br>    local_account_disabled              = optional(bool)<br>    node_os_channel_upgrade             = optional(string)<br>    node_resource_group                 = optional(string)<br>    oidc_issuer_enabled                 = optional(bool)<br>    dns_prefix_private_cluster          = optional(string)<br>    workload_identity_enabled           = optional(bool)<br>    identity_type                       = optional(string)<br>    identity_ids                        = optional(list(string))<br>    linux_profile = optional(object({<br>      admin_username = string<br>      ssh_key = list(object({<br>        key_data = string<br>      }))<br>    }))<br>    default_node_pool = optional(object({<br>      enable_auto_scaling                 = optional(bool)<br>      agents_max_count                    = optional(number)<br>      agents_min_count                    = optional(number)<br>      agents_type                         = optional(string)<br>      capacity_reservation_group_id       = optional(string)<br>      orchestrator_version                = optional(string)<br>      custom_ca_trust_enabled             = optional(bool)<br>      custom_ca_trust_certificates_base64 = optional(list(string))<br>      enable_host_encryption              = optional(bool)<br>      host_group_id                       = optional(string)<br>      pool_name                           = optional(string)<br>      vm_size                             = optional(string)<br>      os_disk_size_gb                     = optional(number)<br>      subnet_id                           = optional(string)<br>      enable_node_public_ip               = optional(bool)<br>      availability_zones                  = optional(list(string))<br>      count                               = optional(number)<br>      fips_enabled                        = optional(bool)<br>      kubelet_disk_type                   = optional(string)<br>      max_pods                            = optional(number)<br>      message_of_the_day                  = optional(string)<br>      node_public_ip_prefix_id            = optional(string)<br>      node_labels                         = optional(map(string))<br>      node_taints                         = optional(list(string))<br>      only_critical_addons_enabled        = optional(bool)<br>      os_sku                              = optional(string)<br>      pod_subnet_id                       = optional(string)<br>      proximity_placement_group_id        = optional(string)<br>      scale_down_mode                     = optional(string)<br>      snapshot_id                         = optional(string)<br>      temporary_name_for_rotation         = optional(string)<br>      tags                                = optional(map(string))<br>      ultra_ssd_enabled                   = optional(bool)<br>      linux_os_config = optional(object({<br>        swap_file_size_mb             = optional(number)<br>        transparent_huge_page_defrag  = optional(string)<br>        transparent_huge_page_enabled = optional(string)<br>        sysctl_config = optional(object({<br>          fs_aio_max_nr                      = optional(number)<br>          fs_file_max                        = optional(number)<br>          fs_inotify_max_user_watches        = optional(number)<br>          fs_nr_open                         = optional(number)<br>          kernel_threads_max                 = optional(number)<br>          net_core_netdev_max_backlog        = optional(number)<br>          net_core_optmem_max                = optional(number)<br>          net_core_rmem_default              = optional(number)<br>          net_core_rmem_max                  = optional(number)<br>          net_core_somaxconn                 = optional(number)<br>          net_core_wmem_default              = optional(number)<br>          net_core_wmem_max                  = optional(number)<br>          net_ipv4_ip_local_port_range_max   = optional(number)<br>          net_ipv4_ip_local_port_range_min   = optional(number)<br>          net_ipv4_neigh_default_gc_thresh1  = optional(number)<br>          net_ipv4_neigh_default_gc_thresh2  = optional(number)<br>          net_ipv4_neigh_default_gc_thresh3  = optional(number)<br>          net_ipv4_tcp_fin_timeout           = optional(number)<br>          net_ipv4_tcp_keepalive_intvl       = optional(number)<br>          net_ipv4_tcp_keepalive_probes      = optional(number)<br>          net_ipv4_tcp_keepalive_time        = optional(number)<br>          net_ipv4_tcp_max_syn_backlog       = optional(number)<br>          net_ipv4_tcp_max_tw_buckets        = optional(number)<br>          net_ipv4_tcp_tw_reuse              = optional(number)<br>          net_netfilter_nf_conntrack_buckets = optional(number)<br>          net_netfilter_nf_conntrack_max     = optional(number)<br>          vm_max_map_count                   = optional(number)<br>          vm_swappiness                      = optional(number)<br>          vm_vfs_cache_pressure              = optional(number)<br>        }))<br>      }))<br>      kubelet_config = optional(object({<br>        allowed_unsafe_sysctls    = optional(list(string))<br>        container_log_max_line    = optional(number)<br>        container_log_max_size_mb = optional(number)<br>        cpu_cfs_quota_enabled     = optional(bool)<br>        cpu_cfs_quota_period      = optional(string)<br>        cpu_manager_policy        = optional(string)<br>        image_gc_high_threshold   = optional(number)<br>        image_gc_low_threshold    = optional(number)<br>        pod_max_pid               = optional(number)<br>        topology_manager_policy   = optional(string)<br>      }))<br>    }))<br>    azure_active_directory_role_based_access_control = optional(object({<br>      managed                = optional(bool)<br>      tenant_id              = optional(string)<br>      admin_group_object_ids = optional(list(string))<br>      client_app_id          = optional(string)<br>      server_app_id          = optional(string)<br>      server_app_secret      = optional(string)<br>      azure_rbac_enabled     = optional(bool)<br>    }))<br>    service_principal = optional(object({<br>      client_id     = string<br>      client_secret = string<br>    }))<br>    identity = optional(object({<br>      type         = string<br>      identity_ids = optional(list(string))<br>    }))<br>    oms_agent = optional(object({<br>      log_analytics_workspace_id = string<br>    }))<br>    network_profile = optional(object({<br>      network_plugin = string<br>      network_policy = string<br>      dns_service_ip = string<br>      outbound_type  = string<br>      pod_cidr       = string<br>      service_cidr   = string<br>    }))<br>    aci_connector_linux = optional(object({<br>      subnet_name = string<br>    }))<br>    api_server_access_profile = optional(object({<br>      authorized_ip_ranges     = list(string)<br>      subnet_id                = string<br>      vnet_integration_enabled = bool<br>    }))<br>    auto_scaler_profile = optional(object({<br>      balance_similar_node_groups      = optional(bool)<br>      expander                         = optional(string)<br>      max_graceful_termination_sec     = optional(number)<br>      max_node_provisioning_time       = optional(string)<br>      max_unready_nodes                = optional(number)<br>      max_unready_percentage           = optional(number)<br>      new_pod_scale_up_delay           = optional(string)<br>      scale_down_delay_after_add       = optional(string)<br>      scale_down_delay_after_delete    = optional(string)<br>      scale_down_delay_after_failure   = optional(string)<br>      scan_interval                    = optional(string)<br>      scale_down_unneeded              = optional(string)<br>      scale_down_unready               = optional(string)<br>      scale_down_utilization_threshold = optional(number)<br>      empty_bulk_delete_max            = optional(number)<br>      skip_nodes_with_local_storage    = optional(bool)<br>      skip_nodes_with_system_pods      = optional(bool)<br>    }))<br>    confidential_computing = optional(object({<br>      sgx_quote_helper_enabled = optional(bool)<br>    }))<br>    maintenance_window = optional(object({<br>      allowed = optional(list(object({<br>        day   = string<br>        hours = list(number)<br>      })))<br>      not_allowed = optional(list(object({<br>        start = string<br>        end   = string<br>      })))<br>    }))<br>    maintenance_window_auto_upgrade = optional(object({<br>      frequency   = string<br>      interval    = number<br>      duration    = number<br>      day_of_week = optional(string)<br>      week_index  = optional(string)<br>      start_time  = optional(string)<br>      utc_offset  = optional(string)<br>      start_date  = optional(string)<br>      not_allowed = optional(list(object({<br>        start = string<br>        end   = string<br>      })))<br>    }))<br><br>    maintenance_window_node_os = optional(object({<br>      frequency   = string<br>      interval    = number<br>      duration    = number<br>      day_of_week = optional(string)<br>      week_index  = optional(string)<br>      start_time  = optional(string)<br>      utc_offset  = optional(string)<br>      start_date  = optional(string)<br>      not_allowed = optional(list(object({<br>        start = string<br>        end   = string<br>      })))<br>    }))<br>    http_proxy_config = optional(object({<br>      http_proxy  = string<br>      https_proxy = string<br>      trusted_ca  = string<br>    }))<br>    ingress_application_gateway = optional(object({<br>      gateway_id   = optional(string)<br>      gateway_name = optional(string)<br>      subnet_cidr  = optional(string)<br>      subnet_id    = optional(string)<br>    }))<br>    storage_profile = optional(object({<br>      blob_driver_enabled         = optional(bool)<br>      disk_driver_enabled         = optional(bool)<br>      disk_driver_version         = optional(string)<br>      file_driver_enabled         = optional(bool)<br>      snapshot_controller_enabled = optional(bool)<br>    }))<br>    service_mesh_profile = optional(object({<br>      mode                             = string<br>      internal_ingress_gateway_enabled = optional(bool)<br>      external_ingress_gateway_enabled = optional(bool)<br>    }))<br>    key_management_service = optional(object({<br>      key_vault_key_id        = optional(string)<br>      keyvault_network_access = optional(string)<br>    }))<br>    key_vault_secrets_provider = optional(object({<br>      secret_rotation_enabled  = optional(bool)<br>      secret_rotation_interval = optional(string)<br>    }))<br>    kubelet_config = optional(object({<br>      allowed_unsafe_sysctls    = optional(list(string))<br>      container_log_max_line    = optional(number)<br>      container_log_max_size_mb = optional(number)<br>      cpu_cfs_quota_enabled     = optional(bool)<br>      cpu_cfs_quota_period      = optional(string)<br>      cpu_manager_policy        = optional(string)<br>      image_gc_high_threshold   = optional(number)<br>      image_gc_low_threshold    = optional(number)<br>      pod_max_pid               = optional(number)<br>      topology_manager_policy   = optional(string)<br>    }))<br>    kubelet_identity = optional(object({<br>      user_assigned_identity_id = string<br>    }))<br>    microsoft_defender = optional(object({<br>      log_analytics_workspace_id = optional(string)<br>    }))<br>    monitor_metrics = optional(object({<br>      annotations_allowed = optional(list(string))<br>      labels_allowed      = optional(list(string))<br>    }))<br>    windows_profile = optional(object({<br>      admin_username = string<br>      admin_password = optional(string)<br>      license        = optional(string)<br>      gmsa = optional(object({<br>        dns_server  = string<br>        root_domain = string<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aa_dsc_primary_access_key"></a> [aa\_dsc\_primary\_access\_key](#output\_aa\_dsc\_primary\_access\_key) | The DSC primary access key |
| <a name="output_aa_dsc_secondary_access_key"></a> [aa\_dsc\_secondary\_access\_key](#output\_aa\_dsc\_secondary\_access\_key) | The DSC secondary access key |
| <a name="output_aa_dsc_server_endpoint"></a> [aa\_dsc\_server\_endpoint](#output\_aa\_dsc\_server\_endpoint) | The DSC server endpoint of the automation account |
| <a name="output_aa_id"></a> [aa\_id](#output\_aa\_id) | The ID of the automation account |
| <a name="output_aa_identity"></a> [aa\_identity](#output\_aa\_identity) | The identity block of the automation account |
| <a name="output_aa_name"></a> [aa\_name](#output\_aa\_name) | The name of the automation account |
| <a name="output_automation_module_ids"></a> [automation\_module\_ids](#output\_automation\_module\_ids) | List of IDs for the Automation Modules. |
| <a name="output_automation_python3_package_ids"></a> [automation\_python3\_package\_ids](#output\_automation\_python3\_package\_ids) | List of IDs for the Automation Python3 Packages. |
| <a name="output_automation_runbook_ids"></a> [automation\_runbook\_ids](#output\_automation\_runbook\_ids) | List of IDs for the Automation Runbooks. |
| <a name="output_automation_schedule_ids"></a> [automation\_schedule\_ids](#output\_automation\_schedule\_ids) | List of IDs for the Automation Schedules. |
