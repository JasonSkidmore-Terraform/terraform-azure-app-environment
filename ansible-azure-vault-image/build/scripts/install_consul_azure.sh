#!/bin/bash

consul_download_url="https://releases.hashicorp.com/consul/1.8.4+ent/consul_1.8.4+ent_linux_amd64.zip"

# Update and Upgrade
sudo apt-get update && sudo apt-get upgrade -y

# Install unzip and jq
sudo apt-get install -y unzip jq

# Install AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#------------------------
# Create Users
#------------------------
sudo useradd --system --home /etc/consul.d --shell /bin/false consul

useradd -m azureuser
usermod -a -G sudo azureuser

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
ConditionFileNotEmpty=/etc/consul.d/consul.json

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

# # Consul
# cat << EOF > /etc/consul.d/consul.hcl
# # Full configuration options can be found at https://www.consul.io/docs/agent/options.html

# server = true
# bootstrap_expect = 1

# ui = true
# client_addr = "0.0.0.0"

# EOF

# Consul Service
sudo chmod 0664 /lib/systemd/system/consul.service
systemctl daemon-reload
sudo chown -R consul:consul /etc/consul.d
#sudo chmod -R 0644 /etc/consul.d/*

cat << EOF > /etc/profile.d/consul.sh
export CONSUL_HTTP_ADDR=127.0.0.1:8500
EOF

# # Consul
# systemctl enable consul
# systemctl start consul
