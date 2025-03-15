resource "aws_instance" "web" { 
  ami           = "ami-04823729c75214919"
  instance_type = "t2.micro" 

  tags = {
    Name = "WebServer-${var.env}"
  }
}

terraform {
  backend "s3" {
    bucket         = "tf-jenkins-bkt"
    key            = "tfstate/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
