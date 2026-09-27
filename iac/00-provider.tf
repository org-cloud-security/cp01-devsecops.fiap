terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-devsecops-tfstate"
    storage_account_name = "stdevsecopstfstate"
    container_name       = "tfstate"
    key                  = "lab.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

variable "allowed_ip" {
  description = "IP público (CIDR) liberado para acessar a VM via SSH, ex.: 203.0.113.10/32"
  type        = string
  default     = "179.135.148.89/32"
}

variable "ssh_public_key" {
  description = "Conteúdo da chave pública SSH usada para acessar a VM"
  type        = string
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-devsecops-lab"
  location = "brazilsouth"
}
