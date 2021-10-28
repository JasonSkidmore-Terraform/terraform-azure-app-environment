# Starting Point

### Requirements

Get Azure credentials
[Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
[Repo with example]https://github.com/JasonSkidmore-Terraform/azure-terraform-setup

### Steps to run:

- First step is to build Packer AMIs for Consul and Vault.
    - Go to the **ansible-azure-vault-image** directory and run the following commands to create Packer AMIs for Azure:

        Quick Command:
        ```
        # Go inside the directory
        cd ansible-azure-vault-image

        # export YOUR Azure Credentials (My example)
        export ARM_CLIENT_ID=c7bc50dc-800f-494a-8311-25674a9acc77 \
        export ARM_SUBSCRIPTION_ID=c4774376-bc4c-48e6-93eb-c0ac26c6345d \
        export ARM_TENANT_ID=c8cd0425-e7b7-4f3d-9215-7e5fa3f439e8 \
        export ARM_CLIENT_SECRET=XxDSNe3v6.p5P5~~B6FPB0jYE66~B_3SI4

        # Then build the packer AMI for Consul
        packer build -var release=latest build/server/consul-azure.json

        # Then build the packer AMI for Vault
        packer build -var release=latest build/server/vault-azure.json

        ```



  - Be sure to have the file **certificate.pfx** inside files directory. If not, create it. (This is needed for tls certs)

        Quick Command:
        ```
        mkdir files
        touch certificate.pfx
        ```

    - Copy and modify **terraform.tfvars.example** file to **terraform.tfvars**

        Quick Command:
        ```
        # Copy .tfvars example
        cp terraform.tfvars.example terraform.tfvars

        # Modify .tfvars
        vim terraform.tfvars
        ```

      Don't forget to fill in the Azure provider credentials as they are variables used by resources

    - Run Terraform:

        Quick Command:
        ```
        terraform init

        terraform validate

        terraform plan

        terraform apply
        ```

    - For further issues, you may want to consult README.md file for examples in [azure-landing-zone](https://github.com/JasonSkidmore-Terraform/azure-landing-zone)



### Extra Info

- Inside [config_templates](config_templates) you will find the config files for consul and vault. In case you want to change them.
