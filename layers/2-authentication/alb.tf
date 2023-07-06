# To be applied after the main layer
# You must also apply the helm ressource in Kube so the NLB is created

module "alb" {
  source = "../../modules/alb"

  name = local.name
  env  = local.env

  vpc_id         = data.terraform_remote_state.main.outputs.vpc.vpc_id
  vpc_cidr_block = data.terraform_remote_state.main.outputs.vpc.this.vpc_cidr_block
  subnet_ids     = data.terraform_remote_state.main.outputs.vpc.public_subnets_ids

  acm_certificate_arn = aws_acm_certificate.this.arn

  cognito_user_pool_endpoint      = module.cognito.user_pool_endpoint
  cognito_user_pool_client_id     = module.cognito.user_pool_client_id
  cognito_user_pool_client_secret = module.cognito.user_pool_client_secret
  cognito_user_pool_domain        = module.cognito.user_pool_domain
}
