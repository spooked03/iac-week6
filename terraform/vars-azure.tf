# Azure Provider Variables
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default = "c064671c-8f74-4fec-b088-b53c568245eb"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "S1193726"
}

variable "location" {
  description = "Azure region location"
  type        = string
  default     = "West Europe"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "ssh_key_name" {
  description = "Name of the existing SSH key in Azure"
  type        = string
  default     = "id_ed25519-azure"
}

