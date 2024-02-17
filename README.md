# Terraform AWS Development environment

## Configure

### Vscode Extensions

1. Install AWS - Toolkit vscode extension (`amazonwebservices.aws-toolkit-vscode`)
2. Install terraform vscode extension (`hashicorp.terraform`)
3. Install Remote SSH extension (`ms-vscode-remote.remote-ssh`)

### AWS Credentials

1. Go to IAM
2. Then Users
3. Add User
4. Add permissions
5. Add policy _AdministratorAccess_
6. Create security credentials and save them in a place you can recover later

### Vscode AWS Toolkit

- Type _CTRL + SHIFT + P_
- Select _AWS: Create credentials profile_

### Terraform usage

- go to `/infrastructure`
- Initialize terraform `terraform init`
- Run the terraform plan `terraform plan`
- Apply the terraform `terraform apply -auto-approve`
- Show applied terraform states `terraform state list`
- Show specific resource state by name `terraform show <resource_name>`
- Format terraform files `terraform fmt` (Format files)
- Get the aws _AMI_ Ex: `ami-0c7217cdde317cfec` - Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
- Get the owner of the _AMI_ going to EC2 > AMIs > Public images > search for the _AMI_ ID `ami-0c7217cdde317cfec`
- The owner id will be used at `datasources.tf` ex: `099720109477`
- Generate a _key value_ pair to access your EC2 by ssh`ssh-keygen -t ed25519` to create an key pair
- Access the machine via ssh via terminal `ssh -i ~/.ssh/ec2devkey ubuntu@<instance_public_ip>`
- Update resource replacing it if needed to `terraform apply -replace <resource_name>`
- Access the terraform console to check variables and stuff `terraform console`
- Run the terraform command with an specific named variable `terraform console -var="host_os=unix"`
- Run the terraform command with an specific variables file `terraform console -var-file="dev.tfvars"`
- Update without destroy everything `terraform apply -refresh-only`
- Update dependencies like new added providers `terraform init -upgrade`

## Resources

- [Learn Terraform (and AWS)](https://www.youtube.com/watch?v=iRaai1IBlB0&list=WL&index=15)
- [Identify the public ip of the terraform execution environment](https://stackoverflow.com/questions/46763287/i-want-to-identify-the-public-ip-of-the-terraform-execution-environment-and-add)
