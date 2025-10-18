# TF2 App - Quick Start Deployment

## 🚀 Deploy in 3 Commands

```bash
# 1. Install Ansible collection
cd ansible
ansible-galaxy collection install -r requirements.yml

# 2. Deploy TF2 App
ansible-playbook -i inventory.yaml deploy-tf2-app.yml

# 3. Open in browser
# http://192.168.1.130:8080
```

Done! Your TF2 app is running.

---