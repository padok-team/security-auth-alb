################################################################################
# Network Resources
################################################################################

module "my_vpc" {
  source = "git@github.com:padok-team/terraform-aws-network.git"

  vpc_name              = local.name
  vpc_availability_zone = ["eu-west-3a", "eu-west-3b"]

  vpc_cidr            = "10.142.0.0/16"
  public_subnet_cidr  = ["10.142.1.0/24", "10.142.2.0/24"]     # small subnets for natgateway
  private_subnet_cidr = ["10.142.64.0/18", "10.142.128.0/18"] # big subnet for EKS

  single_nat_gateway = true # warning : not for production !

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}_${local.env}" = "shared"
    "kubernetes.io/role/elb"                                   = "1"
  }

  tags = {
    CostCenter = "Network"
  }
}
