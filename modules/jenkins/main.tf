provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ec2_jenkins" {
  name        = "jenkins_sg"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-01fccab91b456acc2" # Replace with the latest Amazon Linux 2 AMI in your region
  instance_type          = "t2.micro"
  key_name               = "FirstJavaEndpointAppKeyPair" # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.ec2_jenkins.id]

  tags = {
    Name = "JenkinsInstance"
  }

  provisioner "file" {
    source      = "install_software.sh"
    destination = "/tmp/install_software.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_software.sh",
      "sudo /tmp/install_software.sh"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/salvador/Desktop/FirstJavaEndpointAppKeyPair.pem") # Update the path to your private key
    host        = self.public_ip
  }
}

output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}