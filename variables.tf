variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

/*variable "instance_type" {
  description = "The instance type of the EC2 instances"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances"
}

variable "key_pair_name" {
  description = "The key pair name to use for the EC2 instances"
}

variable "subnet_ids" {
  description = "The subnet IDs for the MSK and EC2 instances"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security group IDs for the MSK and EC2 instances"
  type        = list(string)
}

 */