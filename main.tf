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