## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13 |
| azurerm | >=2.20.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >=2.20.0 |
| random | n/a |
| template | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| landing_zone | ./modules/landing_zone |  |
| load-balancer-vault | ./modules/public-load-balancer |  |
| postgres-DB | ./modules/postgresql |  |
| ssh_keys | ./modules/ssh |  |
| storage-account | ./modules/storage_account |  |
| tls | ./modules/tls-acme |  |
| vmss-consul | ./modules/source-ami-packer-vmss |  |
| vmss-vault | ./modules/source-ami-packer-vmss |  |

## Resources

| Name |
|------|
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/data-sources/client_config) |
| [azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/data-sources/container_registry) |
| [azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/container_registry) |
| [azurerm_dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/dns_a_record) |
| [azurerm_dns_ns_record](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/dns_ns_record) |
| [azurerm_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/dns_zone) |
| [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/key_vault_key) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/key_vault) |
| [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/kubernetes_cluster) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/>=2.20.0/docs/resources/role_assignment) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |
| [template_cloudinit_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate\_password | The PFX certificate password. | `string` | `""` | no |
| certificate\_path | The path on disk that has the PFX certificate. | `string` | `"files/certificate.pfx"` | no |
| client\_id | n/a | `string` | `""` | no |
| client\_secret | n/a | `string` | `""` | no |
| consul\_tokens | The required tokens for consul | <pre>object({<br>    encrypt_key       = string<br>    acl_master_token  = string<br>    acl_agent_token   = string<br>    acl_default_token = string<br>  })</pre> | n/a | yes |
| consul\_vm\_name | n/a | `string` | `"azure-consul-demo-vm"` | no |
| distribution | The images tested for the TFE submodule. (ubuntu or rhel). | `string` | `"ubuntu"` | no |
| domain | The domain you wish to use, this will be subdomained. `example.com` | `any` | n/a | yes |
| environment | n/a | `string` | `"learn"` | no |
| key\_name | Azure Key Vault key name | `string` | `"generated-key"` | no |
| location | Azure location where the Key Vault resource to be created | `string` | `"eastus"` | no |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| public\_ip\_allowlist | List of public IP addresses to allow into the network. This is required for access to the PaaS services (AKV, SA, Postgres) and the bastion. | `list` | <pre>[<br>  "187.188.23.173"<br>]</pre> | no |
| resource\_group\_name | n/a | `string` | `"vault-demo-azure-auth"` | no |
| subdomain | The subdomain you wish to use `mycompany-tfe` | `any` | n/a | yes |
| subscription\_id | n/a | `string` | `""` | no |
| tags | Tags to apply to the resource group/resources. | `map` | `{}` | no |
| tenant\_id | ---------------- Azure Key Vault ---------------- | `string` | `""` | no |
| vault\_download\_url | n/a | `string` | `"https://releases.hashicorp.com/vault/1.5.3+ent/vault_1.5.3+ent_linux_amd64.zip"` | no |
| vault\_vm\_name | n/a | `string` | `"azure-vault-demo-vm"` | no |
| vm\_admin\_username | The username to login to the TFE Virtual Machines. | `string` | `"azureuser"` | no |
| vm\_sku | Number of instances that you want for vmss | `string` | `"Standard_F2"` | no |
| vnet\_address\_space | The virtual network address CIDR. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_certificate | n/a |
| cluster\_id | n/a |
| consul-network | Consul |
| domain\_name\_servers | --------------------- Outputs --------------------- |
| host | n/a |
| key\_vault\_name | n/a |
| login\_server | n/a |
| postgres\_data | n/a |
| public\_ip\_allowlist | n/a |
| sg\_data | netowrking configuration |
| subnet\_id | n/a |
| vault-network | Vault |
| vnet\_data | netowrking configuration |
