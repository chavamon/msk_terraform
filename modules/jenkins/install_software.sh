#!/bin/bash

# Update the system for Jenkins repository
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y

# Git installation
sudo yum install -y git

# Install Java 21
sudo wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm
sudo rpm -i amazon-corretto-21-x64-linux-jdk.rpm

# Install Jenkins
sudo yum install -y jenkins

# fontconfig library is required for Jenkins to work
sudo yum install -y fontconfig

# Install Maven
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz -P /tmp
sudo tar xf /tmp/apache-maven-*.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.9.8/opt/maven

# Set Maven environment variables
echo 'export M2_HOME = /opt/maven' | sudo tee -a/etc/profile.d/maven.sh
echo "export PATH = $${M2_HOME}/bin:$${PATH}" | sudo tee -a /etc/profile.d/maven.sh
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Set JAVA_HOME for Jenkins
echo 'JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto' | sudo tee -a /etc/environment
echo 'JENKINS_JAVA_OPTIONS=-Djava.awt.headless=true' | sudo tee -a /etc/sysconfig/jenkins

# Start Jenkins
sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo systemctl enable jenkins

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
