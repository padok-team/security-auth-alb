locals {
  region  = "eu-west-3"
  project = "padok-lab"
}

module "terraform_backend" {
  source = "github.com/padok-team/terraform-aws-terraformbackend?ref=0c51c6f1bdcab880c2f109d2aca08528e7032d2f"

  bucket_name         = "poc-eks-alb-cognito-terraform-backend"
  dynamodb_table_name = "poc-eks-alb-cognito-terraform-lock"
}