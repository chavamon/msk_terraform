output "instance_ip_address" {
  value = aws_instance.ec2_instance.public_ip
  description = "The public IP address of the instance."
}

output "instance_id" {
  value = aws_instance.ec2_instance.id
  description = "The ID of the instance."
}