#Create AWS VPC
resource "aws_vpc" "customvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "customvpc"
  }
}

# Public Subnets
resource "aws_subnet" "subnet-public-1" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "subnet-public-1"
  }
}
resource "aws_subnet" "subnet-public-2" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-north-1b"

  tags = {
    Name = "subnet-public-2"
  }
}
# Private Subnets 
resource "aws_subnet" "subnet-private-1" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "subnet-private-1"
  }
}
resource "aws_subnet" "subnet-private-2" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-north-1b"

  tags = {
    Name = "subnet-private-2"
  }
}
# Custom internet Gateway
resource "aws_internet_gateway" "custom-gw" {
  vpc_id = aws_vpc.customvpc.id

  tags = {
    Name = "custom-gw"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "routingtable-public" {
  vpc_id = aws_vpc.customvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-gw.id
  }

  tags = {
    Name = "routingtable-public-1"
  }
}

resource "aws_route_table_association" "custom-public-1" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.routingtable-public.id
}
resource "aws_route_table_association" "custom-public-2" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.routingtable-public.id
}