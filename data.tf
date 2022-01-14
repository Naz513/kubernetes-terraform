data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "latest_ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    # values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}