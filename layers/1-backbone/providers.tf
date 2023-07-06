provider "aws" {
  region = local.region
  profile = local.project
}

provider "helm" {
    kubernetes {
    config_path = "~/.kube/config"
  }
}