#!/bin/bash

sudo yum update -y
# Git installation command added here
sudo yum install -y git

#Java 21 Installation
sudo wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm
sudo rpm -i amazon-corretto-21-x64-linux-jdk.rpm

# Set JAVA_HOME
echo 'JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto' | sudo tee -a /etc/environment

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker