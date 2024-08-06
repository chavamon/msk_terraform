# write the code to create a Beanstalk environment with the following configuration:
# * The Beanstalk environment will be
# * created with:
# * One security group that allows all traffic.
# * The latest version of the Beanstalk platform.
# * The latest version of the Beanstalk solution stack.
# * The same VPC as the Jenkins instance.
# * The same subnets as the EC2 instances.
# * The Beanstalk environment will use the following configuration:

provider "aws" {
    region = var.aws_region
}

resource "aws_security_group" "beanstalk_sg" {
    name        = "beanstalk_sg"
    description = "Security group for Beanstalk environment"
    version     = "latest"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = var.development_cidr
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = var.development_cidr
    }

    tags = {
        Name = "beanstalk-sg"
    }
}




