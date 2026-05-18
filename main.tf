
# find latest public Windows Server AMI
data "aws_ami" "windows_server" {
  owners           = ["amazon"]
  most_recent      = true
  executable_users = ["all"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }
}

resource "aws_security_group" "stc_gui" {
  count       = length(var.security_group_ids) > 0 ? 0 : 1
  name        = "stc-gui-${random_id.uid.id}"
  description = "TestCenter Security Group"

  vpc_id = var.vpc_id

  # RDP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
}

resource "random_id" "uid" {
  byte_length = 8
}

# create Windows TestCenter
resource "aws_instance" "stc_gui" {
  count         = var.instance_count
  ami           = var.ami != "" ? var.ami : data.aws_ami.windows_server.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data         = data.template_file.user_data.rendered
  get_password_data = true

  dynamic "root_block_device" {
    for_each = length(var.root_block_device) > 0 ? var.root_block_device : [{}]
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", true)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }


  network_interface {
    network_interface_id = aws_network_interface.mgmt_plane[count.index].id
    device_index         = 0
  }

  tags = {
    Name = format("%s%d", var.instance_name, 1 + count.index)
  }
}

resource "aws_network_interface" "mgmt_plane" {
  count           = var.instance_count
  subnet_id       = var.subnet_id
  security_groups = length(var.security_group_ids) > 0 ? var.security_group_ids : [aws_security_group.stc_gui[0].id]
}

resource "aws_eip_association" "public_ip" {
  count                = length(var.eips)
  network_interface_id = aws_network_interface.mgmt_plane[count.index].id
  allocation_id        = var.eips[count.index]
}

# provison the windows VM
resource "null_resource" "provisioner" {
  count = var.enable_provisioner ? var.instance_count : 0
  connection {
    host     = aws_instance.stc_gui[count.index].public_ip
    type     = "ssh"
    user     = "Administrator"
    password = rsadecrypt(aws_instance.stc_gui[count.index].password_data, file(var.private_key_file))
    # work around terraform bug #25634 windows server 2019 ssh server
    # set script_path
    script_path = "/Windows/Temp/terraform_%RAND%.bat"
  }

  # force provisioners to rerun
  # triggers = {
  #   always_run = "${timestamp()}"
  # }

  # copy install script
  provisioner "file" {
    source      = "${path.module}/install-testcenter.ps1"
    destination = "${var.dest_dir}/install-testcenter.ps1"
  }

  # copy TestCenter installer
  provisioner "file" {
    source      = var.stc_installer
    destination = "${var.dest_dir}/${basename(var.stc_installer)}"
  }

  # run install
  provisioner "remote-exec" {
    inline = [
      "powershell -File \"${var.dest_dir}/install-testcenter.ps1\" -Dir \"${var.dest_dir}\" -ExtraDownload 1",
    ]
  }
}
