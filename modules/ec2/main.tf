# This file contains the Terraform configuration to create an EC2 instance with the required software installed.
# The EC2 instance will be created in the same VPC as the Jenkins instance.
# The EC2 instance will have the following software installed:
# Git
# Amazon Corretto 21 JDK
# Docker

# Terraform configuration for creating an EC2 instance with required software installed
provider "aws" {
  region = var.aws_region
}

# Security groups for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance with required software installed
resource "aws_instance" "ec2_instance" {
  count         = 3
  ami           = "ami-01fccab91b456acc2" # replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "FirstJavaEndpointAppKeyPair" # replace with your key pair name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 2
    delete_on_termination = true
  }

  # Tags for EC2 instances
  tags = {
    Name = "EC2Instance${count.index}"
  }

  # Provisioner block for remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      # Git installation command added here
      "sudo yum install -y git",
      "sudo wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm",
      "sudo rpm -i amazon-corretto-21-x64-linux-jdk.rpm",

      # Set JAVA_HOME for Jenkins
      "echo 'JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto' | sudo tee -a /etc/environment",

      # Install Docker
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }

  # Connection block for SSH
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/salvador/Desktop/FirstJavaEndpointAppKeyPair.pem") # Update the path to your private key
    host        = self.public_ip
  }

}

