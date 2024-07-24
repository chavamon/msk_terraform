#####
# This file contains the Terraform configuration to create an EC2 instance with the required software installed.
# The EC2 instance will have the following software installed:
# Git
# Amazon Corretto 21 JDK
# Docker
#####

provider "aws" {
  region = var.aws_region
}

# Security groups for EC2 instances
resource "aws_security_group" "ec2_sg" {
  description = "Security group for EC2 instances, allowing HTTP and SSH access"
  name        = "ec2_sg"

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
  count         = var.number_of_instances
  ami           = var.ami_id
  instance_type = var.instance_type
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

  provisioner "file" {
    source      = "install_software.sh"
    destination = "/tmp/install_software.sh"
  }

  # Provisioner block for remote-exec
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_software.sh",
      "sudo /tmp/install_software.sh"
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

