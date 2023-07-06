# To be applied after the main layer
# You must also apply the helm ressource in Kube so the NLB is created

module "alb" {
  source = "../../modules/alb"

  name = local.name
  env  = local.env

  vpc_id         = local.vpc_id
  subnet_ids     = local.vpc_public_subnets_ids

  without_cognito_domains = [local.without_cognito_domain_name]

  acm_certificate_arn = aws_acm_certificate.this.arn

  cognito_user_pool_endpoint      = module.cognito.user_pool_endpoint
  cognito_user_pool_client_id     = module.cognito.user_pool_client_id
  cognito_user_pool_client_secret = module.cognito.user_pool_client_secret
  cognito_user_pool_domain        = module.cognito.user_pool_domain
}
