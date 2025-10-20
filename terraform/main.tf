resource "esxi_guest" "web" {
  guest_name = "iac-week6-esxi"
  disk_store = var.disk_store
  memsize    = var.vm_memory
  numvcpus   = var.vm_cpus

  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.vm_network
  }

  # Cloud-init configuration
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = filebase64("${path.module}/../cloudinit/userdata.yaml")

    "metadata.encoding" = "base64"
    "metadata"          = filebase64("${path.module}/../cloudinit/metadata.yaml")
  }
}

# azure
data "azurerm_ssh_public_key" "existing" {
  name                = var.ssh_key_name
  resource_group_name = var.resource_group_name
}

# Data source to reference existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "iac-vnet" {
  name                = "iac-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "iac-subnet" {
  name                 = "iac-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.iac-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "iac-pip" {
  name                = "iac-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "iac-nsg" {
  name                = "iac-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "iac-nsg-association" {
  subnet_id                 = azurerm_subnet.iac-subnet.id
  network_security_group_id = azurerm_network_security_group.iac-nsg.id
}

# Create network interface
resource "azurerm_network_interface" "iac-nic" {
  name                = "iac-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "iac-ipconfig"
    subnet_id                     = azurerm_subnet.iac-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.iac-pip.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "iac-week6-azure"
  admin_username                  = "sietse"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.iac-nic.id]
  size                            = var.vm_size
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sietse"
    public_key = data.azurerm_ssh_public_key.existing.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"

  }
}

# Generate Ansible inventory after IPs are available
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    esxi_vm         = esxi_guest.web
    azure_vm        = azurerm_linux_virtual_machine.main
    azure_public_ip = azurerm_public_ip.iac-pip.ip_address
  })
  filename = "${path.module}/../ansible/inventory.yml"

  depends_on = [
    esxi_guest.web,
    azurerm_linux_virtual_machine.main,
    azurerm_public_ip.iac-pip
  ]
}

# Outputs
output "vm_ip" {
  description = "IP of the Ubuntu VM"
  value       = esxi_guest.web.ip_address
}

output "vm_name" {
  description = "Name of the Ubuntu VM"
  value       = esxi_guest.web.guest_name
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i ~/.ssh/id_ed25519-skylab ubuntu@${esxi_guest.web.ip_address}"
}

output "ansible_inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = "${path.module}/ansible/inventory.yaml"
}
