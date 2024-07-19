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
  kafka_version = "3.5.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = ["subnet-0feb19970c6ae1de5", "subnet-0b5f47644dcc2eb49", "subnet-071b83c87fe7f89fd"]
    security_groups = [aws_security_group.msk_sg.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.example.arn
    revision = aws_msk_configuration.example.latest_revision
  }
}

resource "aws_msk_configuration" "example" {
  kafka_versions    = ["3.5.1"]
  name              = "example"
  server_properties = <<-PROPERTIES
    auto.create.topics.enable = true
    delete.topic.enable = true
  PROPERTIES
}
