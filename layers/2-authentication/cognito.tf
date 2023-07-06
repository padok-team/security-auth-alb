module "cognito" {
  source = "../../modules/cognito"

  name   = local.name
  domain = local.name

  logout_urls = ["https://${local.grafana_domain_name}/login"]
  callback_dns = [local.with_cognito_domain_name, local.grafana_domain_name]
}
