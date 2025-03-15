resource "aws_instance" "web" { 
  ami           = "ami-04823729c75214919"
  instance_type = "t2.micro" 

  tags = {
    Name = "WebServer-${var.env}"
  }
}
