locals {
  # Do not use word "cognito" in local.name
  name                        = "poc-eks-alb-oidc"
  env                         = "test"
  region                      = "eu-west-3"
  domain_name                 = "padok.school"
  with_cognito_domain_name    = "with-cognito.${local.domain_name}"
  without_cognito_domain_name = "without-cognito.${local.domain_name}"
  project                     = "padok-lab"
  grafana_domain_name         = "grafana.${local.domain_name}"
  vpc_id                      = "vpc-xxxxxx"
  vpc_public_subnets_ids      = ["subnet-xxxxxx","subnet-xxxxxx"]
}
