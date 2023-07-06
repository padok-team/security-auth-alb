# To be applied after the main layer
data "aws_route53_zone" "this" {
  name = local.domain_name
}

resource "aws_route53_record" "withcognito" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.with_cognito_domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "withoutcognito" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.without_cognito_domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.grafana_domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}