resource "aws_instance" "web"{

    ami =                    "ami-00399ec92321828f5"
    instance_type =          "t2.micro"
    key_name      = "${var.tls_generated_key}"
    vpc_security_group_ids = [var.sec_group]

 provisioner "local-exec" {
    command = "echo '${var.tls_private_key}' > ./myKey.pem; chmod 600 ./myKey.pem "
  }
    tags = {
    Role= "web"
    Env = (var.env_name)
    }

 provisioner "remote-exec" {
    inline = ["echo asd"]

    connection {
      host = "${self.public_ip}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.tls_private_key}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ./myKey.pem create.yml"
  }


}
