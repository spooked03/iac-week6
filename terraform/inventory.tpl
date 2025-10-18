---
all:
  hosts:
    ${esxi_vm.guest_name}:
      ansible_host: ${esxi_vm.ip_address}
    ${azure_vm.name}:
      ansible_host: ${azure_public_ip}
  vars:
    ansible_user: sietse
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
  children:
    esxi:
      hosts:
        ${esxi_vm.guest_name}:
          ansible_host: ${esxi_vm.ip_address}
      vars:
        ansible_ssh_private_key_file: ~/.ssh/id_ed25519-skylab
    azure:
      hosts:
        ${azure_vm.name}:
          ansible_host: ${azure_public_ip}
      vars:
        ansible_ssh_private_key_file: ~/.ssh/id_ed25519-azure
