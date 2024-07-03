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
  default     = "rhcos-powervs-images-us-south"
}

variable "image_bucket_location" {
  type        = string
  description = "The region in which to create the Cloud Object Store bucket. Used for the igntion file."
  default     = "us-south"
}

variable "image_bucket_file_name" {
  type        = string
  description = "File name of the image in the COS bucket."
  default     = "rhcos-417-94-202405291927-0-ppc64le-powervs.ova.gz"
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