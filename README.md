# AWS Windows TestCenter Application Terraform

## Description

Run a Windows Server instance and install the Windows TestCenter application.
After the instance has been started connect using Remote Desktop to use TestCenter.

[TestCenter Virtual](https://github.com/Spirent-terraform-Modules/terraform-aws-stcv)
traffic generator instances can be created via Terraform.

## Prerequisites

- Obtain a copy of the Windows TestCenter Application from [VIAVI support](https://support.viavisolutions.com/en-us/support/customer-support/technical-support).
Be sure to update the `stc_installer` variable to point to this file.

## Connect to Windows Server

After the Windows Server instance is running, you can connect to it over Remote Desktop (RDP).

1. Find the Windows Server instance you provisioned in the AWS dashboard.
2. Select the instance and click _Connect_.
3. Select the _RDP Client_ tab and download the remote desktop file.
4. Click _Get password_ and upload the private key you specified in your Terraform script (i.e. `private_key_file`).
5. Click _Decrypt password_ and copy the auto-generated password.  This will be the password required to login to the Windows Server.
6. Locate and launch the RDP file you downloaded in step 3.
7. Click _Connect_ and provide the password from step 5.  The username is `Administrator`.
8. You may receive a security warning about an insecure certificate due to the instance using a self-signed certificate.  Click _Yes_ to continue.
9. You should now see the Windows desktop with a shortcut to the TestCenter Application.
10. Launch the TestCenter Application.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.65 |
| null | n/a |
| random | n/a |
| template | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) |
| [aws_eip_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| [aws_network_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | The base Windows Server AMI.  When not specified latest Windows Server 2019 AMI will be used. | `string` | `""` | no |
| dest\_dir | Destination directory on the instance where files will be copied | `string` | `"c:/users/administrator/downloads"` | no |
| eips | List of management plane elastic IP IDs.  Leave empty if subnet auto assigns IPs. | `list(string)` | `[]` | no |
| enable\_provisioner | Enable provisioning | `bool` | `true` | no |
| ingress\_cidr\_blocks | List of management interface ingress IPv4/IPv6 CIDR ranges.  Set to empty list when using security\_group\_ids. | `list(string)` | n/a | yes |
| instance\_count | Number of instances to create | `number` | `1` | no |
| instance\_name | Name assigned to the Windows STC GUI instance.  An instance number will be appended to the name. | `string` | `"stcgui-"` | no |
| instance\_type | AWS instance type | `string` | `"m5.large"` | no |
| key\_name | AWS SSH key name to assign to each instance | `string` | n/a | yes |
| private\_key\_file | AWS key private file | `string` | n/a | yes |
| root\_block\_device | Customize details about the root block device of the instance. See Block Devices below for details. | `list(map(string))` | `[]` | no |
| security\_group\_ids | List of management plane security group IDs.  Leave empty to create a default security group using ingress\_cidr\_blocks. | `list(string)` | `[]` | no |
| stc\_installer | File path to 'Spirent TestCenter Application x64.exe' or 'Spirent TestCenter Application.exe' installer. | `string` | n/a | yes |
| subnet\_id | Management public AWS subnet ID | `string` | n/a | yes |
| vpc\_id | AWS VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_ids | List of instance IDs |
| instance\_password\_data | List of instance password data.  This allows additional provisioners to rsadecrypt the password. |
| instance\_private\_ips | List of private IP addresses assigned to the instances, if applicable |
| instance\_public\_ips | List of public IP addresses assigned to the instances, if applicable |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Block Devices

### Root Block Device
The root_block_device mapping supports the following:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| delete_on_termination | Whether the volume should be destroyed on instance termination. | `string` | `true` | no |
| encrypted | Whether to enable volume encryption. Must be configured to perform drift detection. | `bool` | `false` | no |
| iops | Amount of provisioned IOPS. Only valid for volume_type of `io1`, `io2` or `gp3`. | `number` | n/a | no |
| kms_key_id | Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volume. Must be configured to perform drift detection. | `string` | n/a | no |
| tags | A map of tags to assign to the device. | `map(string)` | `{}` | no |
| throughput | Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume_type of `gp3`. | `number` | n/a | no |
| volume_size | Size of the volume in gibibytes (GiB). | `number` | n/a | no |
| volume_type | Type of volume. Valid values include `standard`, `gp2`, `gp3`, `io1`, `io2`, `sc1`, or `st1`. | `string` | `gp2` | no |
