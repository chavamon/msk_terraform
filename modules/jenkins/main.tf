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
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
      "sudo yum upgrade -y",
      "sudo yum install -y git", # Git installation command added here
      "sudo wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm",
      "sudo rpm -i amazon-corretto-21-x64-linux-jdk.rpm",
      "sudo yum install -y jenkins",
      "sudo yum install -y fontconfig",
      # Install Maven
      "sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz -P /tmp",
      "sudo tar xf /tmp/apache-maven-*.tar.gz -C /opt",
      "sudo ln -s /opt/apache-maven-3.9.8 /opt/maven",
      "echo 'export M2_HOME=/opt/maven' | sudo tee -a /etc/profile.d/maven.sh",
      "echo 'export PATH=$${M2_HOME}/bin:$${PATH}' | sudo tee -a /etc/profile.d/maven.sh",
      "sudo chmod +x /etc/profile.d/maven.sh",
      "source /etc/profile.d/maven.sh",
      # Set JAVA_HOME for Jenkins
      "echo 'JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto' | sudo tee -a /etc/environment",
      "echo 'JENKINS_JAVA_OPTIONS=\"-Djava.awt.headless=true\"' | sudo tee -a /etc/sysconfig/jenkins",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart jenkins",
      "sudo systemctl enable jenkins",

      # Install Docker
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/salvador/Desktop/FirstJavaEndpointAppKeyPair.pem") # Update the path to your private key
      host        = self.public_ip
    }
  }
}

output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}