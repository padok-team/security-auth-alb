data "terraform_remote_state" "main" {
  backend = "s3"

  config = {
    bucket         = "poc-eks-alb-cognito-terraform-backend"
    key            = "backbone"
    region         = local.region
    profile        = local.project
  }
}
