variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  default = "ami-01fccab91b456acc2"
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  default = "t2.micro"
}

variable "cidr_block" {
  description = "The CIDR block to use for the security group"
  default = ["0.0.0.0/0"]
}

variable "number_of_instances" {
    description = "The number of EC2 instances to create"
    default = 3
}