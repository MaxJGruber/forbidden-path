# 1. Set region
# 2. Provision instance

provider "aws" {
  region=var.region
}

resource "aws_instance" "ec2" {
    ami = "ami-02d7ced41dff52ebc"
    instance_type = "t2.micro"
    key_name = var.key_pair_name
    count = var.quantity

  tags = {
    Name = "Max-Instance-${count.index + 1}"
  }
}