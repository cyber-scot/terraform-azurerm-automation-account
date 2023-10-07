variable "clusters" {
  description = "A list of clusters to create"
  type = list(object({
    name                                = string
    kubernetes_version                  = string
    location                            = string
    rg_name                             = string
    dns_prefix                          = string
    sku_tier                            = string
    private_cluster_enabled             = bool
    tags                                = map(string)
    http_application_routing_enabled    = optional(bool)
    azure_policy_enabled                = optional(bool)
    role_based_access_control_enabled   = optional(bool)
    open_service_mesh_enabled           = optional(bool)
    private_dns_zone_id                 = optional(string)
    private_cluster_public_fqdn_enabled = optional(bool)
    custom_ca_trust_certificates_base64 = optional(list(string), [])
    disk_encryption_set_id              = optional(string)
    edge_zone                           = optional(string)
    image_cleaner_enabled               = optional(bool)
    image_cleaner_interval_hours        = optional(number)
    automatic_channel_upgrade           = optional(string, null)
    local_account_disabled              = optional(bool)
    node_os_channel_upgrade             = optional(string)
    node_resource_group                 = optional(string)
    oidc_issuer_enabled                 = optional(bool)
    dns_prefix_private_cluster          = optional(string)
    workload_identity_enabled           = optional(bool)
    identity_type                       = optional(string)
    identity_ids                        = optional(list(string))
    linux_profile = optional(object({
      admin_username = string
      ssh_key = list(object({
        key_data = string
      }))
    }))
    default_node_pool = optional(object({
      enable_auto_scaling                 = optional(bool)
      agents_max_count                    = optional(number)
      agents_min_count                    = optional(number)
      agents_type                         = optional(string)
      capacity_reservation_group_id       = optional(string)
      orchestrator_version                = optional(string)
      custom_ca_trust_enabled             = optional(bool)
      custom_ca_trust_certificates_base64 = optional(list(string))
      enable_host_encryption              = optional(bool)
      host_group_id                       = optional(string)
      pool_name                           = optional(string)
      vm_size                             = optional(string)
      os_disk_size_gb                     = optional(number)
      subnet_id                           = optional(string)
      enable_node_public_ip               = optional(bool)
      availability_zones                  = optional(list(string))
      count                               = optional(number)
      fips_enabled                        = optional(bool)
      kubelet_disk_type                   = optional(string)
      max_pods                            = optional(number)
      message_of_the_day                  = optional(string)
      node_public_ip_prefix_id            = optional(string)
      node_labels                         = optional(map(string))
      node_taints                         = optional(list(string))
      only_critical_addons_enabled        = optional(bool)
      os_sku                              = optional(string)
      pod_subnet_id                       = optional(string)
      proximity_placement_group_id        = optional(string)
      scale_down_mode                     = optional(string)
      snapshot_id                         = optional(string)
      temporary_name_for_rotation         = optional(string)
      tags                                = optional(map(string))
      ultra_ssd_enabled                   = optional(bool)
      linux_os_config = optional(object({
        swap_file_size_mb             = optional(number)
        transparent_huge_page_defrag  = optional(string)
        transparent_huge_page_enabled = optional(string)
        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(number)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
      }))
      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_line    = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))
    }))
    azure_active_directory_role_based_access_control = optional(object({
      managed                = optional(bool)
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      client_app_id          = optional(string)
      server_app_id          = optional(string)
      server_app_secret      = optional(string)
      azure_rbac_enabled     = optional(bool)
    }))
    service_principal = optional(object({
      client_id     = string
      client_secret = string
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    oms_agent = optional(object({
      log_analytics_workspace_id = string
    }))
    network_profile = optional(object({
      network_plugin = string
      network_policy = string
      dns_service_ip = string
      outbound_type  = string
      pod_cidr       = string
      service_cidr   = string
    }))
    aci_connector_linux = optional(object({
      subnet_name = string
    }))
    api_server_access_profile = optional(object({
      authorized_ip_ranges     = list(string)
      subnet_id                = string
      vnet_integration_enabled = bool
    }))
    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool)
      expander                         = optional(string)
      max_graceful_termination_sec     = optional(number)
      max_node_provisioning_time       = optional(string)
      max_unready_nodes                = optional(number)
      max_unready_percentage           = optional(number)
      new_pod_scale_up_delay           = optional(string)
      scale_down_delay_after_add       = optional(string)
      scale_down_delay_after_delete    = optional(string)
      scale_down_delay_after_failure   = optional(string)
      scan_interval                    = optional(string)
      scale_down_unneeded              = optional(string)
      scale_down_unready               = optional(string)
      scale_down_utilization_threshold = optional(number)
      empty_bulk_delete_max            = optional(number)
      skip_nodes_with_local_storage    = optional(bool)
      skip_nodes_with_system_pods      = optional(bool)
    }))
    confidential_computing = optional(object({
      sgx_quote_helper_enabled = optional(bool)
    }))
    maintenance_window = optional(object({
      allowed = optional(list(object({
        day   = string
        hours = list(number)
      })))
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))
    maintenance_window_auto_upgrade = optional(object({
      frequency   = string
      interval    = number
      duration    = number
      day_of_week = optional(string)
      week_index  = optional(string)
      start_time  = optional(string)
      utc_offset  = optional(string)
      start_date  = optional(string)
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))

    maintenance_window_node_os = optional(object({
      frequency   = string
      interval    = number
      duration    = number
      day_of_week = optional(string)
      week_index  = optional(string)
      start_time  = optional(string)
      utc_offset  = optional(string)
      start_date  = optional(string)
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))
    http_proxy_config = optional(object({
      http_proxy  = string
      https_proxy = string
      trusted_ca  = string
    }))
    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))
    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool)
      disk_driver_enabled         = optional(bool)
      disk_driver_version         = optional(string)
      file_driver_enabled         = optional(bool)
      snapshot_controller_enabled = optional(bool)
    }))
    service_mesh_profile = optional(object({
      mode                             = string
      internal_ingress_gateway_enabled = optional(bool)
      external_ingress_gateway_enabled = optional(bool)
    }))
    key_management_service = optional(object({
      key_vault_key_id        = optional(string)
      keyvault_network_access = optional(string)
    }))
    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool)
      secret_rotation_interval = optional(string)
    }))
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(list(string))
      container_log_max_line    = optional(number)
      container_log_max_size_mb = optional(number)
      cpu_cfs_quota_enabled     = optional(bool)
      cpu_cfs_quota_period      = optional(string)
      cpu_manager_policy        = optional(string)
      image_gc_high_threshold   = optional(number)
      image_gc_low_threshold    = optional(number)
      pod_max_pid               = optional(number)
      topology_manager_policy   = optional(string)
    }))
    kubelet_identity = optional(object({
      user_assigned_identity_id = string
    }))
    microsoft_defender = optional(object({
      log_analytics_workspace_id = optional(string)
    }))
    monitor_metrics = optional(object({
      annotations_allowed = optional(list(string))
      labels_allowed      = optional(list(string))
    }))
    windows_profile = optional(object({
      admin_username = string
      admin_password = optional(string)
      license        = optional(string)
      gmsa = optional(object({
        dns_server  = string
        root_domain = string
      }))
    }))
  }))
  default = []
}
