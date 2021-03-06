#!/bin/bash

subscription_id="c4774376-bc4c-48e6-93eb-c0ac26c6345d"
client_id="c7bc50dc-800f-494a-8311-25674a9acc77"
client_secret="XxDSNe3v6.p5P5~~B6FPB0jYE66~B_3SI4"
tenant_id="c8cd0425-e7b7-4f3d-9215-7e5fa3f439e8"
vm_name="Vault-Instance"
vault_download_url="https://releases.hashicorp.com/vault/1.5.3+ent/vault_1.5.3+ent_linux_amd64.zip"
vault_name="ultra-new-item"
key_name="LH-keyvault"
resource_group_name="prima-test"

# Update and Upgrade
sudo apt-get update && sudo apt-get upgrade -y

# Install unzip and jq
sudo apt-get install -y unzip jq

# Install AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

useradd azureuser
useradd vault

usermod -a -G sudo azureuser
usermod -a -G sudo vault

VAULT_ZIP="vault.zip"
VAULT_URL=$vault_download_url
curl --silent --output /tmp/$VAULT_ZIP $VAULT_URL
unzip -o /tmp/$VAULT_ZIP -d /usr/local/bin/
chmod 0755 /usr/local/bin/vault
chown vault:vault /usr/local/bin/vault
mkdir -pm 0755 /etc/vault.d
mkdir -pm 0755 /opt/vault
chown azureuser:azureuser /opt/vault

export VAULT_ADDR=http://127.0.0.1:8200

cat << EOF > /lib/systemd/system/vault.service
[Unit]
Description=Vault Agent
Requires=network-online.target
After=network-online.target
[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d/config.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=azureuser
Group=azureuser
[Install]
WantedBy=multi-user.target
EOF


cat << EOF > /etc/vault.d/config.hcl
storage "file" {
  path = "/opt/vault"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
seal "azurekeyvault" {
  client_id      = "$client_id"
  client_secret  = "$client_secret"
  tenant_id      = "$tenant_id"
  vault_name     = "$vault_name"
  key_name       = "$key_name"
}
ui=true
disable_mlock = true
EOF


sudo chmod 0664 /lib/systemd/system/vault.service
systemctl daemon-reload
sudo chown -R vault:vault /etc/vault.d
sudo chmod -R 0644 /etc/vault.d/*

cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

systemctl enable vault
systemctl start vault


sudo cat << EOF > /tmp/azure_auth.sh
set -v
export VAULT_ADDR="http://127.0.0.1:8200"

vault auth enable azure

vault write auth/azure/config tenant_id="$tenant_id" resource="https://management.azure.com/" client_id="$client_id" client_secret="$client_secret"

vault write auth/azure/role/dev-role policies="default" bound_subscription_ids="$subscription_id" bound_resource_groups="$resource_group_name"

vault write auth/azure/login role="dev-role" \
  jwt="$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F'  -H Metadata:true -s | jq -r .access_token)" \
  subscription_id="$subscription_id" \
  resource_group_name="$resource_group_name" \
  vm_name="$vm_name"
EOF

sudo chmod +x /tmp/azure_auth.sh
