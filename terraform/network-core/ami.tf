data "aws_ami" "ubuntu_24_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Official Canonical (Ubuntu) owner ID

  tags = {
    Name = "Ubuntu 24.04 AMI"
  }
}

output "ubuntu_24_04_ami_id" {
  value       = data.aws_ami.ubuntu_24_04.id
  description = "ID of AWS AMI for ubuntu 24.04"
}
