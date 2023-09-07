terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "bastion_key"
  public_key = file("~/.ssh/bastionkey.pub")
}

resource "aws_security_group" "bastion-sg" {
  description = "EC2 Bastion Security Group"
  name        = "bastion-sg"
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion-ingress-cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" //all
    ipv6_cidr_blocks = ["::/0"]
    description      = "IPv6 route Open to Public Internet"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" //all
    cidr_blocks = ["0.0.0.0/0"]
    description = "IPv4 route Open to Public Internet"
  }
}

resource "aws_eip" "bastion-host-eip" {
  tags = {
    Name = "bastion-host-eip"
  }
}

resource "aws_instance" "ec2-bastion-host" {
  ami                         = "ami-024e6efaf93d85776"
  instance_type               = "t3.nano"
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = aws_subnet.vpc-public-subnet-1.id
  associate_public_ip_address = false
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    volume_type           = "gp2"
    encrypted             = true
    tags = {
      Name = "bastion-host-root-volume"
    }
  }
  tags = {
    Name = "bastion-host"
  }
  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
    ]
  }
}

## EC2 Bastion Host Associate Elastic IP
resource "aws_eip_association" "ec2-bastion-host-associate-eip" {
    instance_id = aws_instance.ec2-bastion-host.id
    allocation_id = aws_eip.bastion-host-eip.id
}
