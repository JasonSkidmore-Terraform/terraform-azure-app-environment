#------------------
# Single Workspace
#------------------
# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "bananahands"

#     workspaces {
#       name = "landing-zone-luish"
#     }
#   }
# }

#-----------------
# Multi Workspace
#-----------------
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "bananahands"

    workspaces {
      prefix = "prima-azure-"
    }
  }
}
