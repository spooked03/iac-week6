# Azure Provider Variables
variable "subscription_id" {
  type    = string
  default = "c064671c-8f74-4fec-b088-b53c568245eb"
}

variable "resource_group_name" {
  type    = string
  default = "S1193726"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "ssh_key_name" {
  type    = string
  default = "id_ed25519-azure"
}
