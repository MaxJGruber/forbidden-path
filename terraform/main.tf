provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2" {
  ami           = var.AMI_type == "ubuntu" ? "ami-02d7ced41dff52ebc" : "ami-0a411b25a0dc707f3"
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  count         = var.quantity

  tags = {
    Name = "Max-Instance-${count.index + 1}"
  }
}

output "public_ips" {
  value = aws_instance.ec2[*].public_ip
}