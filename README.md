# IAC Week 6 - Infrastructure as Code Project

---

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Usage](#usage)
- [Validation](#validation)
- [Testing](#testing)
- [License](#license)

## Overview
**Week 6 of Infrastructure as Code (IAC)**

This project demonstrates a fully automated infrastructure deployment pipeline using Terraform and Ansible. When changes are committed to the repository, the CI/CD pipeline automatically triggers the following workflow:

1. **Validation & Security Scanning** – Terraform and Ansible code are linted and validated against best practices using ansible-lint, yamllint, and Checkov to ensure security and best practices.

2. **Infrastructure Provisioning** – Once all checks pass, Terraform provisions the infrastructure across both Azure and ESXi. State consistency is maintained through a remote HCP Terraform backend.

3. **Configuration Management** – After infrastructure creation, Ansible configures the VMs and deploys a Docker container running a Caddy web server that serves a static website.


## Project Structure

```
iac-week6/
├── terraform/              # Terraform configuration files
│   ├── main.tf             # Main infrastructure definitions
│   ├── providers.tf
│   ├── vars-azure.tf
│   ├── vars-esxi.tf
│   ├── inventory.tpl      # Ansible inventory template
│   └── .checkov.yml       # checkov configuration
├── ansible/               # Ansible playbooks and configuration
│   ├── deploy-tf2-app.yml
│   ├── inventory.yml
│   ├── ansible.cfg
│   ├── requirements.yml   # Ansible role dependencies
│   └── roles/             # Custom Ansible roles
├── cloudinit/             # Cloud-init config for esxi VM
│   ├── userdata.yaml
│   └── metadata.yaml
├── tf2-app/               # docker application files
│   ├── compose.yml
│   ├── Dockerfile
│   └── dist/
└── README.md
```


## Prerequisites

- **Terraform**
- **Ansible**
- **Azure CLI**
- **OVF-tool**
- **Docker** and **Docker Compose**
- **Git**


## Configuration

Before running the project, you must configure the following:

- **TF_API_TOKEN** – Set as a secret/environment variable if using a remote backend like HCP Terraform
- **Backend Configuration** – Update `terraform/providers.tf` with your backend of choice
- **Provider Variables** – Configure Azure and ESXi credentials in `terraform/vars-azure.tf` and `terraform/vars-esxi.tf`
- **SSH Keys** – Update SSH key paths in `terraform/inventory.tpl` to use your own


## Usage

```bash
# 1. Clone the repository
git clone https://github.com/spooked03/iac-week6
cd iac-week6

# 2. Initialize Terraform
cd terraform
terraform init

# 3. Review the planned changes
terraform plan

# 4. Apply the infrastructure
terraform apply

# 5. Install Ansible dependencies
cd ../ansible
ansible-galaxy install -r requirements.yml

# 6. Deploy the application
ansible-playbook -i inventory.yml deploy-tf2-app.yml

# 7. Access the application
# Navigate to http://<azure-vm-ip>:8080
```


## Validation

The following commands can be used to validate the the code:

```bash
# Validate Terraform configuration
cd terraform
terraform validate

# Lint Ansible playbooks
cd ../ansible
ansible-lint

# Validate YAML syntax
yamllint .
```

## Testing

The following commands can be used to test the deployed infrastructure:

```bash
# Test server connectivity
ping <azure-vm-ip>
ping <ESXi-vm-ip>

# Check if the website is accessible
curl -I http://<azure-vm-ip>:8080
```

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
