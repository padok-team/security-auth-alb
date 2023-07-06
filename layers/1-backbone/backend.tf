terraform {
  backend "s3" {
    profile        = "padok-lab"
    dynamodb_table = "poc-eks-alb-cognito-terraform-lock"
    bucket         = "poc-eks-alb-cognito-terraform-backend"
    key            = "backbone"
    region         = "eu-west-3"
  }
}