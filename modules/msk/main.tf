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

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name = "msk_cluster"
  kafka_version = "2.2.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    ebs_volume_size = 1000
    client_subnets  = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
    security_groups = [aws_security_group.msk_sg.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.example.arn
    revision = aws_msk_configuration.example.latest_revision
  }
}

resource "aws_msk_configuration" "example" {
  kafka_versions    = ["2.2.1"]
  name              = "example"
  server_properties = <<-PROPERTIES
    auto.create.topics.enable = true
    delete.topic.enable = true
  PROPERTIES
}
