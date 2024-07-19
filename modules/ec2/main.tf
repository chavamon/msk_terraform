provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "ec2_instance" {
  count         = 3
  ami           = "ami-01fccab91b456acc2" # replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "FirstJavaEndpointAppKeyPair" # replace with your key pair name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-21
              java -version
              EOF

  tags = {
    Name = "EC2Instance${count.index}"
  }
}
