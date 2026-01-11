variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project 1 VPC 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_key" {
  type = string
  description = "public key"
}

variable "ami_id" {
  type =string
  description = "ami_id"
  
}

variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project 1 AMI Id for EC2 instance"
}

variable "ec2_user_data_install_apache" {
  type = string
  description = "Script for installing the Apache2"
}

variable "domain_name" {
  type = string
  description = "Name of the domain"
}

variable "bucket_name" {
  description = "S3 bucket name for terraform state"
  type        = string
}

variable "name" {
  description = "Name tag for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}