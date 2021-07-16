provider "aws" {
    region = "us-east-2"
    profile = "aws-master"
}

resource "tls_private_key" "kk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "awskeys"
  public_key = "${tls_private_key.kk.public_key_openssh}"
}

module "test_instance"{
     source = "./module/ec2/"
     tls_generated_key = "${aws_key_pair.generated_key.key_name}"
     tls_private_key = "${tls_private_key.kk.private_key_pem}"
     sec_group = aws_security_group.web_sec.id
     env_name = "test"
}
module "prod_instance"{
     source = "./module/ec2/"
     tls_generated_key = "${aws_key_pair.generated_key.key_name}"
     tls_private_key = "${tls_private_key.kk.private_key_pem}"
     sec_group = aws_security_group.web_sec.id
     env_name = "prod"
}


resource "aws_security_group" "web_sec" {
  name        = "web_sec"
  
  ingress {
    description      = "Nginx"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }  
}


