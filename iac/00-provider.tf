terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "allowed_ip" {
  description = "IP público (CIDR) liberado para acessar a VM via SSH, ex.: 203.0.113.10/32"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_public_key_path" {
  description = "Caminho da chave pública SSH usada para acessar a VM"
  type        = string
  default     = "~/.ssh/devsecops_lab.pub"
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-devsecops-lab"
  location = "brazilsouth"
}
