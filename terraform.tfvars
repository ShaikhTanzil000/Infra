bucket_name = "devops-terraform-state-tanzil-2024"
name = "environment"
environment = "dev-1"

vpc_cidr = "10.0.0.0/16"
vpc_name = "dev-proj-eu-central-vpc-1"
cidr_public_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet = ["10.0.3.0/24", "10.0.4.0/24"]
eu_availability_zone = ["eu-central-1a", "eu-central-1b"]
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvtUE77Ftg0mEru/66zXPWeEy0dRbf9TvbiUT1sMUwIQmep34ngGUnet3fR4AN9Km8JwOGltuA/fwiyvVqUX4gsCegrNwDfaqmESfbQ7t3XRTP/E/g1ITrZKs+rjNhYkkHrJoqvRvblpGpXbntsxhpwz4TMOOYH/90YwycQXwcGaUBIwFVV8i9xn+HO0chWOZgVheu47kzfdG9G6KegIdF3ei30f32j8BewU55QYwJbdtcmGdcQb2gexOd5TJcQqdJh+t0M/PetUgj2Y02bu8jmqH86fRm0VWZ6RLJnHk0Pu4cNeo3G6WuY6IKeb6rHdUazKZf/HKhZ1mbE2wmW4w7"
ami_id = "ami-0e872aee57663ae2d"
ec2_user_data_install_apache = "./template/ec2_install_apache.sh"
domain_name = "tanzilbilal.click"
ec2_ami_id = "ami-0e872aee57663ae2d"
