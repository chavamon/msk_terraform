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
  ami           = "ami-0b72821e2f351e396" # replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "my_key_pair" # replace with your key pair name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "EC2Instance${count.index}"
  }
}
