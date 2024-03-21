variable "api_key" {
  type        = string
  description = "IBM Cloud API key associated with user's identity"
}

variable "region" {
  default = "dal"
}

variable "zone" {
  type    = string
  default = "dal10"
}

variable "workspace_id" {
    type = string
}

variable "image_bucket_name" {
  type        = string
  description = "Name of the COS bucket containing the image to be imported."
}

variable "image_bucket_location" {
  type        = string
  description = "The region in which to create the Cloud Object Store bucket. Used for the igntion file."
}

variable "image_bucket_file_name" {
  type        = string
  description = "File name of the image in the COS bucket."
}

variable "machine_cidr" {
  type        = string
  description = "The machine network (IPv4 only)"
}

variable "dns_server" {
  type        = string
  description = "The desired DNS server for the DHCP instance to server."
  default     = "1.1.1.1"
}

variable "keypair_name" {
  default = ""
}

variable "system_type" {
  default = "s922"
}