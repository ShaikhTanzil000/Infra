module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    cidr_public_subnet = var.cidr_public_subnet
    cidr_private_subnet = var.cidr_private_subnet
    eu_availability_zone = var.eu_availability_zone

}

module "security_group" {
  source = "./security_group"
  ec2_sg_name = "SG for EC2 to enable SSH(22) and HTTP(80)"
  vpc_id = module.networking.vpc_id
  public_subnet_cidr_block = tolist(module.networking.public_subnet_cidr_block)
  ec2_sg_name_for_python_api = "SG for EC2 to enable port 5000"

}

module "ec2" {
  source = "./ec2"
  ami_id = var.ami_id
  instance_type = "t2.micro"
  tag_name = "Ubuntu Linux EC2"
  public_key = var.public_key
  subnet_id = module.networking.dev_proj_1_public_subnet[0].id
  sg_enable_ssh_https = module.security_group.sg_ec2_sg_ssh_http_id
  sg_for_python_api = module.security_group.sg_ec2_for_python_api
  sg_for_rds_access = module.security_group.rds_mysql_sg_id
  user_data_install_apache = templatefile("./template/ec2_install_apache.sh", {})
  enable_public_ip_address = true
}

module "lb_target_group" {
  source = "./load_balancer_target_group"
  lb_target_group_name = "dev-proj-1-lb-target-group"
  lb_target_group_port = 5000
  lb_target_group_protocol = "HTTP"
  vpc_id = module.networking.vpc_id
  ec2_instance_id = module.ec2.dev_proj_1_ec2_instance_id
}

module "alb" {
  source                    = "./load-balancer"
  lb_name                   = "dev-proj-1-alb"
  is_external               = false
  lb_type                   = "application"
  sg_enable_ssh_https       = module.security_group.sg_ec2_sg_ssh_http_id
  subnet_ids                = tolist(module.networking.dev_proj_1_public_subnets)
  tag_name                  = "dev-proj-1-alb"
  lb_target_group_arn       = module.lb_target_group.dev_proj_1_lb_target_group_arn
  ec2_instance_id           = module.ec2.dev_proj_1_ec2_instance_id
  lb_listner_port           = 5000
  lb_listner_protocol       = "HTTP"
  lb_listner_default_action = "forward"
  lb_https_listner_port     = 443
  lb_https_listner_protocol = "HTTPS"
  dev_proj_1_acm_arn        = module.aws_ceritification_manager.dev_proj_1_acm_arn
  lb_target_group_attachment_port = 5000
}

module "hosted_zone" {
  source          = "./hosted-zone"
  domain_name     = var.domain_name
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "aws_ceritification_manager" {
  source         = "./certificate-manager"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}


module "rds_db_instance" {
  source               = "./rds"
  db_subnet_group_name = "dev_proj_1_rds_subnet_group"
  subnet_groups        = tolist(module.networking.dev_proj_1_public_subnets)
  rds_mysql_sg_id      = module.security_group.rds_mysql_sg_id
  mysql_db_identifier  = "mydb"
  mysql_username       = "dbuser"
  mysql_password       = "dbpassword"
  mysql_dbname         = "devprojdb"
}