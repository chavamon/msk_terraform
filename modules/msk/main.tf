# Description: This file contains the terraform code to create one MSK cluster with the configuration described below:
# * The MSK cluster will be created with:
#   ** One security group that allows all traffic.
#   ** One configuration that enables auto topic creation and topic deletion.
#   ** 3 broker nodes of type kafka.t3.small.
#   ** The same VPC as the Jenkins instance.
#   ** The same subnets as the EC2 instances.
#   ** The latest version of MSK.
#   ** The latest version of Kafka.

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "msk_sg" {
  name        = "msk_sg"
  description = "Security group for MSK cluster"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster" "MyMSKCluster" {
  cluster_name = "MyMSKCluster"
  kafka_version = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = ["subnet-0feb19970c6ae1de5", "subnet-0b5f47644dcc2eb49", "subnet-071b83c87fe7f89fd"]
    security_groups = [aws_security_group.msk_sg.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.config.arn
    revision = aws_msk_configuration.config.latest_revision
  }
}

# Create a VPC for the MSK cluster
resource "aws_vpc" "kafka_vpc" {
  cidr_block = "10.0.0.0/16"  # CIDR block for the VPC

  # Tags for the VPC
  tags = {
    Name = "kafka-vpc"
  }
}

resource "aws_msk_configuration" "config" {
  kafka_versions    = [var.kafka_version]
  name              = "example"
  server_properties = <<-PROPERTIES
    auto.create.topics.enable = true
    delete.topic.enable = true
  PROPERTIES
}
