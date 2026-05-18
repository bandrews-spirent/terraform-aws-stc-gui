## Run Windows TestCenter Application

Run a Windows Server 2019 instance and install the TestCenter Application.

## Usage

To run this example you need to execute:

    $ terraform init
    $ terraform plan
    $ terraform apply

This example will create resources that will incur a cost. Run `terraform destroy` when you don't need these resources.

The `terraform apply` will take approximately 30 minutes to complete in order to provision the Windows Server instance.

[Connect](../../README.md#connect-to-windows-server) to the Windows Server instance via Remote Desktop and launch the TestCenter Application.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| stc_gui | ../.. |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance\_count | Number of instances to create | `number` | `1` | no |
| instance\_type | AWS instance type | `string` | `"m5.large"` | no |
| key\_name | AWS SSH key name to assign to each instance | `string` | `"bootstrap_key"` | no |
| private\_key\_file | AWS key private file | `string` | `"bootstrap_private_key_file"` | no |
| region | AWS region | `string` | `"us-west-2"` | no |
| stc\_installer | File path to 'Spirent TestCenter Application x64.exe' or 'Spirent TestCenter Application.exe' installer. | `string` | `"../../Spirent TestCenter Application x64.exe"` | no |
| subnet\_id | Management plane subnet ID | `string` | `"subnet-123456789"` | no |
| vpc\_id | VPC ID | `string` | `"vpc-123456789"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_public\_ips | List of public IP addresses assigned to the instances, if applicable |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
