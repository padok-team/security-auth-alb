resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "../../helm"
  chart      = "grafana"
  version    = "0.1.0"

  values = [
    "${file("../../helm/grafana/values.yaml")}"
  ]
  
  set {
    name  = "ingress.hosts[0].host"
    value = local.grafana_domain_name
  }

  # set {
  #   name  = "image.env[4].value"
  #   value =  "https://${module.cognito.user_pool_endpoint}/.well-known/jwks.json"
  # }

  # set {
  #   name  = "image.env[7].value"
  #   value = "https://${module.cognito.user_pool_domain}.auth.${local.region}.amazoncognito.com/logout?client_id=${module.cognito.user_pool_client_id}&logout_uri=https://grafana.padok.school/login"
  # }
}