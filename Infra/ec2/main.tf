variable "ami_id" {}
variable "instance_type" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "sg_for_python_api" {}
variable "sg_for_rds_access" {}
variable "tag_name" {}  
variable "user_data_install_apache" {}
variable "enable_public_ip_address" {}

#Need to understand this
output "ssh_connection_string_for_ec2" {
    value = format("%s%s", "ssh -i /home/ubuntu/keys/aws_ec2_terraform ubuntu@", aws_instance.dev_proj_1_ec2.public_ip)

}

output "dev_proj_1_ec2_instance_id" {
  value = aws_instance.dev_proj_1_ec2.id
}

resource "aws_instance" "dev_proj_1_ec2" {    
ami                         = var.ami_id
instance_type               = var.instance_type

   tags = {
    Name = var.tag_name

  }
  
  key_name                   = "aws_key"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_enable_ssh_https, var.sg_for_python_api, var.sg_for_rds_access]
  associate_public_ip_address = var.enable_public_ip_address
  user_data                  = var.user_data_install_apache

 

#Need to learn why are we doing this metadata options block
   metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "dev_proj_1_public_key" {
  key_name = "aws_key"
  public_key = var.public_key
}
