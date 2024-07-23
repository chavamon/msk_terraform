provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ec2_reactjs_sg_instance" {
  name        = "ec2_react_sg"
  description = "Security group for EC2 ReactJS instances"

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

resource "aws_instance" "reactjs_instance" {
  ami                    = "ami-01fccab91b456acc2" # Replace with the latest Amazon Linux 2 AMI in your region
  instance_type          = "t2.micro"
  key_name               = "FirstJavaEndpointAppKeyPair" # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.ec2_reactjs_sg_instance.id]

  tags = {
    Name = "EC2frontInstance"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      # install nginx
      "sudo amazon-linux-extras install nginx1.12 -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      # overwrite the nginx index.html file
      "echo '<h1>Welcome to the nginx Frontend</h1>' | sudo tee /usr/share/nginx/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/salvador/Desktop/FirstJavaEndpointAppKeyPair.pem") # Update the path to your private key
      host        = self.public_ip
    }
  }
}

output "reactjs_instance_public_ip" {
  value = aws_instance.reactjs_instance.public_ip
}