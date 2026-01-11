# Temporarily commented for migration

terraform {
  backend "s3" {
    bucket = "devops-terraform-state-tanzil-2024"
    key    = "devops-project-1/terraform.tfstate"
    region = "eu-central-1"
  }
}
  