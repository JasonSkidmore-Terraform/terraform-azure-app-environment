#!/bin/bash

subscription_id="c4774376-bc4c-48e6-93eb-c0ac26c6345d"
client_id="c7bc50dc-800f-494a-8311-25674a9acc77"
client_secret="XxDSNe3v6.p5P5~~B6FPB0jYE66~B_3SI4"
tenant_id="c8cd0425-e7b7-4f3d-9215-7e5fa3f439e8"
vm_name="Vault-Instance"
vault_download_url="https://releases.hashicorp.com/vault/1.5.3+ent/vault_1.5.3+ent_linux_amd64.zip"
consul_download_url="https://releases.hashicorp.com/consul/1.8.4+ent/consul_1.8.4+ent_linux_amd64.zip"
vault_name="ultra-new-item"
key_name="LH-keyvault"
resource_group_name="prima-test"

# Update and Upgrade
sudo apt-get update && sudo apt-get upgrade -y

# Install unzip and jq
sudo apt-get install -y unzip jq

# Install AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#------------------------
# Install Postgres client
#------------------------

# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt-get -y install postgresql-client-12

#------------------------
# Create Users
#------------------------

sudo useradd --system --home /etc/vault.d --shell /bin/false vault
sudo useradd --system --home /etc/consul.d --shell /bin/false consul

useradd -m azureuser
usermod -a -G sudo azureuser
#chown azureuser:azureuser


#------------------------
# Install Consul
#------------------------

# export CONSUL_VERSION="1.8.0"
# export CONSUL_URL="https://releases.hashicorp.com/consul"
# curl --silent --remote-name \
#   ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
# unzip consul_${CONSUL_VERSION}_linux_amd64.zip
# sudo chown root:root consul
# sudo mv consul /usr/bin/
# consul --version
# sudo useradd --system --home /etc/consul.d --shell /bin/false consul
# sudo mkdir --parents /opt/consul
# sudo chown --recursive consul:consul /opt/consul


CONSUL_ZIP="consul.zip"
CONSUL_URL=$consul_download_url
curl --silent --output /tmp/$CONSUL_ZIP $CONSUL_URL
unzip -o /tmp/$CONSUL_ZIP -d /usr/local/bin/
chmod 0755 /usr/local/bin/consul
chown consul:consul /usr/local/bin/consul
mkdir -pm 0755 /etc/consul.d
mkdir -pm 0755 /opt/consul
chown azureuser:azureuser /opt/consul

export CONSUL_HTTP_ADDR=http://127.0.0.1:8500

# Consul
cat << EOF > /lib/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=azureuser
Group=azureuser
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
ExecStop=/usr/local/bin/consul leave
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Consul
cat << EOF > /etc/consul.d/consul.hcl
# Full configuration options can be found at https://www.consul.io/docs/agent/options.html
server = true
bootstrap_expect = 1

data_dir = "/opt/consul"
datacenter = "dc1"

ui = true
client_addr = "0.0.0.0"

# encrypt = "qDOPBEr+/oUVeOFQOnVypxwDaHzLrD+lvjo5vCEBbZ0="
# ca_file = "/etc/consul.d/consul-agent-ca.pem"
# cert_file = "/etc/consul.d/dc1-server-consul-0.pem"
# key_file = "/etc/consul.d/dc1-server-consul-0-key.pem"
# verify_incoming = true
# verify_outgoing = true
# verify_server_hostname = true

acl {
enabled = true
default_policy = "deny"
enable_token_persistence = true
}
EOF

# Consul Service
sudo chmod 0664 /lib/systemd/system/consul.service
systemctl daemon-reload
sudo chown -R consul:consul /etc/consul.d
sudo chmod -R 0644 /etc/consul.d/*

# Consul
systemctl enable consul
systemctl start consul

# # Steps for Consul Storage backend with ACL
# # 1) bootstrap and get master consul token
# consul acl bootstrap -format=json > consul-bootstrap.txt

# # 2) export master consul token
# export CONSUL_HTTP_TOKEN="$(cat consul-bootstrap.txt | jq -r '.SecretID')"
# export CONSUL_MGMT_TOKEN="$(cat consul-bootstrap.txt | jq -r '.SecretID')"

# # 3) create policy for all nodes (consul servers and clients)
# cat << EOF > node-policy.hcl
# agent_prefix "" {
# policy = "write"
# }
# node_prefix "" {
# policy = "write"
# }
# service_prefix "" {
# policy = "read"
# }
# session_prefix "" {
# policy = "read"
# }

# EOF

# # 4) Creation of Policy
# consul acl policy create \
#     -token=${CONSUL_MGMT_TOKEN} \
#     -name node-policy \
#     -rules @node-policy.hcl

# # 5) Creation of Token
# consul acl token create -format=json \
#     -token=${CONSUL_MGMT_TOKEN} \
#     -description "node token" \
#     -policy-name node-policy > node-token.txt

# # 6) Add Node Token to all consul clients/servers
# consul acl set-agent-token \
#     -token=${CONSUL_MGMT_TOKEN} \
#     agent "$(cat node-token.txt | jq -r '.SecretID')"

# # 7) create policy file for vault
# cat << EOF > vault-policy.hcl
# key_prefix "vault/" {
# policy = "write"
# }
# node_prefix "" {
# policy = "write"
# }
# service "vault" {
# policy = "write"
# }
# agent_prefix "" {
# policy = "write"
# }
# session_prefix "" {
# policy = "write"
# }

# EOF

# # 8) create policy for vault
# consul acl policy create \
#     -token=${CONSUL_MGMT_TOKEN} \
#     -name vault-policy \
#     -rules @vault-policy.hcl

# # 9) create token for vault config file
# consul acl token create -format=json \
#     -token=${CONSUL_MGMT_TOKEN} \
#     -description "Token for Vault Service" \
#     -policy-name vault-policy > vault-service-token.txt

# # 10) save vault token in var

# vault_token=$(cat vault-service-token.txt | jq -r '.SecretID')

#------------------------
# Install Vault
#------------------------
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

# Vault
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


# Vault
cat << EOF > /etc/vault.d/config.hcl
storage "consul" {
  address = "127.0.0.1:8500"
  path = "vault/"
  token = "$vault_token"
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

# Vault Service
sudo chmod 0664 /lib/systemd/system/vault.service
systemctl daemon-reload
sudo chown -R vault:vault /etc/vault.d
sudo chmod -R 0644 /etc/vault.d/*



cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

cat << EOF > /etc/profile.d/consul.sh
export CONSUL_HTTP_ADDR=127.0.0.1:8500
EOF

# Vault
# systemctl enable vault
# systemctl start vault



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
