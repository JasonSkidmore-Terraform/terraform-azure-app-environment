variable "path_to_pem" {
  description = "Path to the ssh key .pem"
  default     = "./tfe_rsa.pem"
}

variable "path_to_pub" {
  description = "Path to the ssh key .pub"
  default     = "./tfe_rsa.pub"
}