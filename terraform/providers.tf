# Terraform configuration
terraform {
  backend "remote" {
    organization = "spooked"

    workspaces {
      name = "iac"
    }
  }

  required_providers {
    esxi = {
      source = "josenk/esxi"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

# esxi
provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

# azure
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  features {}
}
