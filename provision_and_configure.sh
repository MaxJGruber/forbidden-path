#!/bin/bash

read -p "Enter the quantity of EC2 instance to provision (1-10) (default: 1):" server_count
server_count=${server_count:-1}
echo "Very well. We shall provision $server_count instances for you."

read -p "Ubuntu 24 or Amazon Linux 2023 (ubuntu/amazon) (default: ubuntu)" type
type=${type:-ubuntu}
echo "You chose $type instances."

# 1. Provision with Terraform
cd terraform
terraform init -upgrade
terraform apply -auto-approve -var="quantity=$server_count" -var="AMI_type=$type"
TF_OUTPUT_JSON=$(terraform output -json)          # capture outputs
cd ..
 
# 2. Build a one-shot inventory file
PUBLIC_IPS=$(echo "$TF_OUTPUT_JSON" | jq -r '.public_ips.value[]')
INV_FILE=$(mktemp)
{
  echo "[freshly_built]"
  for ip in $PUBLIC_IPS; do
    echo "${ip} ansible_user=ubuntu ansible_ssh_private_key_file=../paris-key-max.pem"
  done
} > "$INV_FILE"
 
# 3. Run Ansible against new hosts
ANSIBLE_CFG=$(mktemp)
echo -e "[defaults]\ninventory = ${INV_FILE}" > "$ANSIBLE_CFG"
export ANSIBLE_CONFIG="$ANSIBLE_CFG"
 
cd ansible
ansible-playbook site.yml
 
echo "✔ Done — servers ready at: $PUBLIC_IPS"
echo "  Inventory used: $INV_FILE"