#Spinup EC2 Web Server
resource "aws_instance" "lms-web-server" {
  ami           = "ami-04b70fa74e45c3917" # us-west-2
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.lms-web-subnet.id
  key_name = "Virginia"
  vpc_security_group_ids = aws_security_group.lms-web-sg.id
  user_data = file("setup.sh")
  tags = {
    Name = "lms-web-server"
  }
}  