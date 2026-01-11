variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "public_subnet_cidr_block" {}  
variable "ec2_sg_name_for_python_api" {}


output "sg_ec2_sg_ssh_http_id" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "rds_mysql_sg_id" {
  value = aws_security_group.rds_mysql_sg.id
}

output "sg_ec2_for_python_api" {
  value = aws_security_group.ec2_sg_for_python_api.id
}

resource "aws_security_group" "ec2_sg_ssh_http" {

  name        = var.ec2_sg_name
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

# http for web access
   ingress {
    cidr_blocks = ["0.0.0.0/0"]

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

#https for secure web access
  ingress {
    cidr_blocks = ["0.0.0.0/0"]

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #Outgoing request

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "to allow ssh and http access"
  }
}

resource "aws_security_group" "rds_mysql_sg" {
  name        = "SG for RDS to allow access from EC2"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_block # replace with your EC2 instance security group CIDR block
  }
}

resource "aws_security_group" "ec2_sg_for_python_api" {
  name        = var.ec2_sg_name_for_python_api
  description = "Security group for Python API on EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_block
  }
    tags = {
    Name = "Security Groups to allow traffic on port 5000"
  }

}
