variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "kafka_version" {
    description = "The version of Kafka to use for the MSK cluster"
    default     = "3.5.1"
}

variable "kafka_instance_type" {
    description = "The instance type of the Kafka broker nodes"
    default     = "kafka.t3.small"
}