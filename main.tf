terraform {
  backend "s3" {
    bucket = "suryatf"
    key    = "network/network.tfitate"
    region = "ap-south-1"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc1" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  
  tags = {
    Name = var.name
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = {
    Name = "pubsubnet"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.vpc1.id

  tags = {
    Name = "ig"
}
}
resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.vpc1.id

  tags = {
    Name = "pubroute"
}
}
resource "aws_route_table_association" "sn" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.public.id
}
