terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "registry.example.com/telmate/proxmox"
      version = ">= 1.0.0"
    }
  }
}

#Configure ProxMox API user/permissions and API url
provider "proxmox" {
  pm_api_url = "https://proxmox-ip:8006/api2/json"

  pm_api_token_id = "terraform@pam!terraform_token"

  pm_api_token_secret = "terraform-token"

  pm_tls_insecure = true
}