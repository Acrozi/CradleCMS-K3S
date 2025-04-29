variable "ssh_key_path" {
  description = "Path to the SSH key"
}

variable "template_name" {
  description = "The name of the Proxmox VM template"
}

variable "proxmox_host" {
  description = "The Proxmox host where VMs will be deployed"
}

variable "ciuser" {
  description = "The Cloud-init user"
}

locals {
  ssh_key = file(var.ssh_key_path)
}