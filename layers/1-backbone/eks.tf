module "my_eks" {
  source = "git@github.com:padok-team/terraform-aws-eks?ref=d3a7740"

  env               = local.env
  region            = local.region
  cluster_name      = local.name
  cluster_version   = "1.22"
  service_ipv4_cidr = "10.143.0.0/16"
  vpc_id            = module.my_vpc.vpc_id
  subnet_ids        = module.my_vpc.private_subnets_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  cluster_security_group_additional_rules = {}

  node_groups = {
    app = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3a.medium"]
    }
  }

  tags = {
    CostCenter = "EKS"
  }
}

resource "aws_security_group_rule" "validatingwebhook" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.my_eks.this.node_security_group_id
  description       = "Allow validatingwebhook service to reach cluster"
}

resource "aws_security_group_rule" "nodes_to_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.my_eks.this.node_security_group_id
  description       = "Allow EKS nodes to access Internet in HTTP"
}
