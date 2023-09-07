## MainVPC
resource "aws_vpc" "main-vpc" {
  cidr_block       = var.vpc-cidr-block
  instance_tenancy = "default"
  tags = {
    Name = "MainVPC"
  }
}

## MainVPC Internet Gateway
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "main-IGW"
  }
}

########## Public Subnet 1 #################
############################################
resource "aws_subnet" "vpc-public-subnet-1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnetid
  availability_zone = "us-east-2a"
  tags = {
    Name = "public-subnet-01"
  }
}

## Route Table for Public Subnet 1
resource "aws_route_table" "public-subnet-1-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = {
    Name = "rtb-public-subnet-01"
  }
}

## Route Table Association for Public Subnet 1
resource "aws_route_table_association" "public-subnet-1-rtb-association" {
  subnet_id      = aws_subnet.vpc-public-subnet-1.id
  route_table_id = aws_route_table.public-subnet-1-rtb.id
}

## Elastic IP for NAT Gateway
resource "aws_eip" "nat-gateway-eip" {
  tags = {
    Name = "nat-gateway-eip"
  }
}

## VPC NAT(Network Address Translation) Gateway
resource "aws_nat_gateway" "vpc-nat-gateway" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id     = aws_subnet.vpc-public-subnet-1.id
  tags = {
    Name = "nat-gateway"
  }
}

########## Private Subnet 1 #################
############################################
resource "aws_subnet" "vpc-private-subnet-1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private-subnet-1-cidr-block
  availability_zone = "us-east-2a" #"${var.region}a"
  tags = {
    Name = "private-subnet-01"
  }
}

## Route Table for Private Subnet 1
resource "aws_route_table" "private-subnet-1-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc-nat-gateway.id
  }
  tags = {
    Name = "rtb-private-subnet-01"
  }
}

## Route Table Associate for Private Subnet 1
resource "aws_route_table_association" "private-subnet-1-rtb-association" {
  subnet_id      = aws_subnet.vpc-private-subnet-1.id
  route_table_id = aws_route_table.private-subnet-1-rtb.id
}
