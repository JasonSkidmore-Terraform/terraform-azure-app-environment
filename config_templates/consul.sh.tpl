#!/bin/sh

# Delete last config file
rm /etc/consul.d/consul.json.tmp

#Wait until role assignment resource is completed otherwise it will fail to retrieve NIC info from VMSS
while az login --identity ; [ $? -ne 0 ]; do
  az login --identity
done

# Metadata from Azure
VMSS_NAME=$(curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-06-01" | jq -r '.compute.name')
BIND_ADDR=$(curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-06-01" | jq -r '.network.interface[0].ipv4.ipAddress[0].privateIpAddress')
PRIVATE_IPS=$(az vmss nic list -g ${resource_group_name} --vmss-name ${consul_vmss} | jq '[.[].ipConfigurations[].privateIpAddress]')

# tls
sudo mkdir /etc/tls
sudo chown azureuser:azureuser /etc/tls/
sudo chmod 0755 /etc/tls/


# ca certs
cat << EOF > /etc/tls/consul-agent-ca-key.pem
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIAvh/dWepTaIFZrI8mGOTpNnoQlC+cPAc0ahHGAqkvOHoAoGCCqGSM49
AwEHoUQDQgAEv7BgrO1HRXrZ6qdqRJz8ibWFvFvGWma6OdGp8r44ciUHC0cw5kRU
px03kXS0IFXQFenIHbXrNzk5rUruy6tOyg==
-----END EC PRIVATE KEY-----
EOF

cat << EOF > /etc/tls/consul-agent-ca.pem
-----BEGIN CERTIFICATE-----
MIIC7zCCApSgAwIBAgIRAODOskvN4AtEq/AHVjQTDr4wCgYIKoZIzj0EAwIwgbkx
CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNU2FuIEZyYW5jaXNj
bzEaMBgGA1UECRMRMTAxIFNlY29uZCBTdHJlZXQxDjAMBgNVBBETBTk0MTA1MRcw
FQYDVQQKEw5IYXNoaUNvcnAgSW5jLjFAMD4GA1UEAxM3Q29uc3VsIEFnZW50IENB
IDI5ODgyMDMwMDQ4MzQxNjI0ODE5ODg1OTU4MTExNjkyMTM1MTg3MDAeFw0yMDEx
MjAyMjE4NDFaFw0yNTExMTkyMjE4NDFaMIG5MQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCQ0ExFjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xGjAYBgNVBAkTETEwMSBTZWNv
bmQgU3RyZWV0MQ4wDAYDVQQREwU5NDEwNTEXMBUGA1UEChMOSGFzaGlDb3JwIElu
Yy4xQDA+BgNVBAMTN0NvbnN1bCBBZ2VudCBDQSAyOTg4MjAzMDA0ODM0MTYyNDgx
OTg4NTk1ODExMTY5MjEzNTE4NzAwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAS/
sGCs7UdFetnqp2pEnPyJtYW8W8ZaZro50anyvjhyJQcLRzDmRFSnHTeRdLQgVdAV
6cgdtes3OTmtSu7Lq07Ko3sweTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUw
AwEB/zApBgNVHQ4EIgQg0jwRYaMH93aRMHrNVtjjh8xTqu279m1YA557uNZWlEkw
KwYDVR0jBCQwIoAg0jwRYaMH93aRMHrNVtjjh8xTqu279m1YA557uNZWlEkwCgYI
KoZIzj0EAwIDSQAwRgIhAPZYrK9sI3b/8bmVzWo/Dgo3ZVzDF0YuAhEsaFJbti+y
AiEA6V3W1gbc15y23qrGc5P6XRGWw8pJ7uUAmyXqhaDmJLE=
-----END CERTIFICATE-----
EOF

# server certs
cat << EOF > /etc/tls/dc1-server-consul-0-key.pem
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIOEIIfJ8zhSAZq9Rc9lwhk4lsN7gnGXqXCoETI4X2zzSoAoGCCqGSM49
AwEHoUQDQgAE39lq+m9C1hDcIGFeo6w/DvnX9jwDLj07NqQirBvdvG6koDdgDioT
s/Lb403zj785bBw9t/FRkWGN9c3idnwfxA==
-----END EC PRIVATE KEY-----
EOF

cat << EOF > /etc/tls/dc1-server-consul-0.pem
-----BEGIN CERTIFICATE-----
MIICmzCCAkKgAwIBAgIQaT8er2LIZKfLOQdP4xBoPzAKBggqhkjOPQQDAjCBuTEL
MAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1TYW4gRnJhbmNpc2Nv
MRowGAYDVQQJExExMDEgU2Vjb25kIFN0cmVldDEOMAwGA1UEERMFOTQxMDUxFzAV
BgNVBAoTDkhhc2hpQ29ycCBJbmMuMUAwPgYDVQQDEzdDb25zdWwgQWdlbnQgQ0Eg
Mjk4ODIwMzAwNDgzNDE2MjQ4MTk4ODU5NTgxMTE2OTIxMzUxODcwMB4XDTIwMTEy
MDIyMjE0MloXDTIxMTEyMDIyMjE0MlowHDEaMBgGA1UEAxMRc2VydmVyLmRjMS5j
b25zdWwwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATf2Wr6b0LWENwgYV6jrD8O
+df2PAMuPTs2pCKsG928bqSgN2AOKhOz8tvjTfOPvzlsHD238VGRYY31zeJ2fB/E
o4HHMIHEMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYB
BQUHAwIwDAYDVR0TAQH/BAIwADApBgNVHQ4EIgQgfR5B41xU8WuXzTfk+3xXNsH9
PR8lgvhCkoPH78YFzyIwKwYDVR0jBCQwIoAg0jwRYaMH93aRMHrNVtjjh8xTqu27
9m1YA557uNZWlEkwLQYDVR0RBCYwJIIRc2VydmVyLmRjMS5jb25zdWyCCWxvY2Fs
aG9zdIcEfwAAATAKBggqhkjOPQQDAgNHADBEAiAiodR5gw4ocPElQQlyWt/f191q
fBw+G5ix3AzJLDynIAIgGWMQn+4klyv1KQUcZUkdVTehPExJOlQvSG8cxUirOJA=
-----END CERTIFICATE-----
EOF


# Consul
cat << EOF > /etc/consul.d/consul.json
{
  "node_name": "$VMSS_NAME",

  "ports": {
    "http": 8500,
    "https": 8501
  },
  
  "datacenter": "dc1",
  "data_dir": "/opt/consul/data",
  "encrypt": "${encrypt_key}",

  "ca_file": "/etc/tls/consul-agent-ca.pem",
  "cert_file": "/etc/tls/dc1-server-consul-0.pem",
  "key_file": "/etc/tls/dc1-server-consul-0-key.pem",

  "verify_incoming": true,
  "verify_outgoing": true,
  "verify_server_hostname": true,
  
  "retry_join": $PRIVATE_IPS,

  "acl": {
    "enabled": true,
    "default_policy": "deny",
    "enable_token_persistence": true,
    "tokens": {
      "master": "${acl_master_token}",
      "agent": "${acl_agent_token}",
      "default": "${acl_default_token}"
    }
  },

  "performance": {
    "raft_multiplier": ${consul_bootstrap_expect}
  },

  "server": true,
  "bootstrap_expect": ${consul_bootstrap_expect},
  
  "ui": true,
  "client_addr": "0.0.0.0",

  "primary_datacenter": "dc1",

  "leave_on_terminate": true,
  "skip_leave_on_interrupt": true,

  "autopilot": {
    "cleanup_dead_servers": true
  }
}
EOF

# For TLS in consul

# "ports": {
#     "http": 8500,
#     "https": 8501
#   },

# "ca_file": "/etc/tls/consul-agent-ca.pem",
#   "cert_file": "/etc/tls/dc1-server-consul-0.pem",
#   "key_file": "/etc/tls/dc1-server-consul-0-key.pem",

#   "verify_incoming": true,
#   "verify_outgoing": true,
#   "verify_server_hostname": true,

cat << EOF > /etc/profile.d/consul.sh
export CONSUL_HTTP_ADDR=127.0.0.1:8500
export CONSUL_HTTP_TOKEN=${acl_master_token}
EOF

#certs
sudo chmod 0644 /etc/tls/*

# Consul
# sudo chmod 0664 /etc/systemd/system/consul.service
# systemctl daemon-reload
# sudo chown -R consul:consul /etc/consul.d
# sudo chmod -R 0644 /etc/consul.d/*
systemctl enable consul
systemctl start consul