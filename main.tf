terraform {
  required_version = ">= 0.14"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = "1.60.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.api_key
  region           = var.region
  zone             = var.zone
}

resource "random_string" "random" {
  length  = 4
  special = false
}

resource "ibm_pi_image" "boot_image" {
  pi_image_name             = "rhcos-${random_string.random.id}"
  pi_cloud_instance_id      = var.workspace_id
  pi_image_bucket_name      = var.image_bucket_name
  pi_image_bucket_access    = "public"
  pi_image_bucket_region    = var.image_bucket_location
  pi_image_bucket_file_name = var.image_bucket_file_name
  pi_image_storage_type     = "tier1"
}

resource "ibm_pi_dhcp" "dhcp_service" {
  pi_cloud_instance_id = var.workspace_id
  pi_cidr              = var.machine_cidr
  pi_dhcp_name         = random_string.random.id
  pi_dhcp_snat_enabled = true
  pi_dns_server        = var.dns_server
}

data "ibm_pi_dhcp" "dhcp_service" {
  pi_cloud_instance_id = var.workspace_id
  pi_dhcp_id           = ibm_pi_dhcp.dhcp_service.dhcp_id
}

data "ibm_pi_key" "key" {
  pi_cloud_instance_id = var.workspace_id
  pi_key_name          = var.keypair_name
}

resource "time_sleep" "wait_for_master_macs" {
  create_duration = "3m"

  depends_on = [ibm_pi_instance.master]
}

data "ibm_pi_dhcp" "dhcp_service_refresh" {
  depends_on           = [time_sleep.wait_for_master_macs]
  pi_cloud_instance_id = var.workspace_id
  pi_dhcp_id           = resource.ibm_pi_dhcp.dhcp_service.dhcp_id
}

resource "ibm_pi_instance" "master" {
  count                = 3
  pi_memory            = "2"
  pi_processors        = "0.25"
  pi_instance_name     = "vm-${random_string.random.id}"
  pi_proc_type         = "shared"
  pi_image_id          = ibm_pi_image.boot_image.image_id
  pi_key_pair_name     = data.ibm_pi_key.key.id
  pi_sys_type          = var.system_type
  pi_cloud_instance_id = var.workspace_id
  pi_health_status     = "WARNING"
  pi_network {
    network_id = data.ibm_pi_dhcp.dhcp_service.network_id
  }
}

locals {
  macs       = flatten(ibm_pi_instance.master[*].pi_network[0].mac_address)
  master_ips = [for lease in data.ibm_pi_dhcp.dhcp_service_refresh.leases : lease.instance_ip if contains(local.macs, lease.instance_mac)]
}