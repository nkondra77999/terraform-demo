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

#lms public route table association
resource "aws_route_table_association" "lms-web-asc" {
  subnet_id      = aws_subnet.lms-web-subnet.id
  route_table_id = aws_route_table.lms-pub-rt.id
}


#lms public route table association
resource "aws_route_table_association" "lms-api-asc" {
  subnet_id      = aws_subnet.lms-api-subnet.id
  route_table_id = aws_route_table.lms-pub-rt.id
}

#lms private route table association
resource "aws_route_table_association" "lms-db-asc" {
  subnet_id      = aws_subnet.lms-db-subnet.id
  route_table_id = aws_route_table.lms-pvt-rt.id
}

#create lms-web nacl
resource "aws_network_acl" "lms-web-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}

#create lms-api nacl
resource "aws_network_acl" "lms-api-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}

#create lms-db nacl
resource "aws_network_acl" "lms-db-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}