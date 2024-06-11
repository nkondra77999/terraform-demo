#VPC Creation
resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}
#web Subnet 
resource "aws_subnet" "lms-web-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "lms-web-subnet"
  }
}

#api subnet
resource "aws_subnet" "lms-api-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-api-subnet"
  }
}

#Db subnet

resource "aws_subnet" "lms-db-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.3.0/24"
  #map_public_ip_on_launch = "false"

  tags = {
    Name = "lms-db-subnet"
  }
}

#Internet gateway
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-internet-gateway"
  }
}

#lms public route table
resource "aws_route_table" "lms-pub-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "lms-public-route"
  }
}

#lms private route table
resource "aws_route_table" "lms-pvt-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-private-route"
  }
}