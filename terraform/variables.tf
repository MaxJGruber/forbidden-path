variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "key_pair_name" {
  type    = string
  default = "paris-key-max"
}

variable "quantity" {
  type    = number
  default = 1
}

variable "AMI_type" {
  type    = string
  default = "ubuntu"
}
