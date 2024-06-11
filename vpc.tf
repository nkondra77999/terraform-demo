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
    Name = "lms-api-nacl"
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
    Name = "lms-db-nacl"
  }
}

# Web Nacl and subnet association
resource "aws_network_acl_association" "lms-web-nacl-asc" {
  network_acl_id = aws_network_acl.lms-web-nacl.id
  subnet_id      = aws_subnet.lms-web-subnet.id
}

# API Nacl and subnet association
resource "aws_network_acl_association" "lms-api-nacl-asc" {
  network_acl_id = aws_network_acl.lms-api-nacl.id
  subnet_id      = aws_subnet.lms-api-subnet.id
}

# DB Nacl and subnet association
resource "aws_network_acl_association" "lms-db-nacl-asc" {
  network_acl_id = aws_network_acl.lms-db-nacl.id
  subnet_id      = aws_subnet.lms-db-subnet.id
}

#create lms-web security group
resource "aws_security_group" "lms-web-sg" {
  name        = "lms-web-sg"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-web-sg"
  }
}

#create lms-web security group - Ingress
resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-ssh" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-http" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#create lms-web security group - Egress
resource "aws_vpc_security_group_egress_rule" "lms-web-sg-egress" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#create lms-api security group
resource "aws_security_group" "lms-api-sg" {
  name        = "lms-web-sg"
  description = "Allow SSH & Node js traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-api-sg"
  }
}

#create lms-api security group - Ingress
resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ingress-ssh" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ingress-Nodejs" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

#create lms-api security group - Egress
resource "aws_vpc_security_group_egress_rule" "lms-api-sg-egress" {
  security_group_id = aws_security_group.lms-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#create lms-db security group
resource "aws_security_group" "lms-db-sg" {
  name        = "lms-db-sg"
  description = "Allow SSH & Postgress traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-db-sg"
  }
}

#create lms-db security group - Ingress
resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ingress-ssh" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ingress-postgres" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

#create lms-db security group - Egress
resource "aws_vpc_security_group_egress_rule" "lms-db-sg-egress" {
  security_group_id = aws_security_group.lms-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}