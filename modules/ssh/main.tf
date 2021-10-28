# (Optional) Could provide your own keys as well
# Generate public/private SSH keys for tfe
# Store them to disk for easy use

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "local_file" "tfe-pem" {
  filename        = var.path_to_pem
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "600"
}

resource "local_file" "tfe-pub" {
  filename        = var.path_to_pub
  content         = tls_private_key.ssh.public_key_openssh
  file_permission = "600"
}
