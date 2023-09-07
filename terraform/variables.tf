variable "aws_access_key" {
  sensitive = true
  type      = string
  nullable  = false
}

variable "aws_secret_key" {
  sensitive = true
  type      = string
  nullable  = false
}

variable "keyname" {
  type = string
}

variable "vpc" {
  type    = string
  default = ""
}

variable "subnetid" {
  type    = string
}

variable "bastion-ingress-cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc-cidr-block" {
  type = string
}

variable "public-subnets-cidrs-blocks" {
  type = list(string)
}

variable "private-subnets-cidrs-blocks" {
  type = list(string)
}

# variable "public-subnet-1-cidr-block" {
#   type = string
# }

variable "private-subnet-1-cidr-block" {
  type = string
}