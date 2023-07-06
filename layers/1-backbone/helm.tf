resource "helm_release" "with-cognito" {
  name       = "with-cognito"
  repository = "../../helm"
  chart      = "app"
  version    = "0.1.0"

  values = [
    "${file("../../helm/app/values.yaml")}"
  ]

  set {
    name  = "fullnameOverride"
    value = "with-cognito"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = local.with_cognito_domain_name
  }

  depends_on = [helm_release.ingress-nginx]
}

resource "helm_release" "without-cognito" {
  name       = "without-cognito"
  repository = "../../helm"
  chart      = "app"
  version    = "0.1.0"

  values = [
    "${file("../../helm/app/values.yaml")}"
  ]

  set {
    name  = "fullnameOverride"
    value = "without-cognito"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = local.without_cognito_domain_name
  }

  depends_on = [helm_release.ingress-nginx]
}


resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "../../helm"
  chart            = "ingress-nginx"
  version          = "0.1.0"

  values = [
    "${file("../../helm/ingress-nginx/values.yaml")}"
  ]
}