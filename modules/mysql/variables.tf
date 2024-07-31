#write a variable for mysql port
variable "mysql_port" {
  description = "The port on which MySQL is running"
  type        = number
  default     = 3306
}

variable "region" {
    description = "The region in which the MySQL database is running"
    type        = string
    default     = "us-east-1"
}