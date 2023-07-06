data "aws_lb" "nlb" {
  tags = {
    "kubernetes.io/cluster/${var.name}" : "owned",
    "kubernetes.io/service-name" : "ingress-nginx/ingress-nginx-controller",
    "Environment" : var.env
  }
}

data "dns_a_record_set" "nlb_records" {
  host = data.aws_lb.nlb.dns_name
}

resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids
}

###
# Security Groups
###

resource "aws_security_group" "this" {
  name_prefix = "${var.env}-sg"
  description = "Allow HTTP inbound traffic to ${var.env} ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


###
# Listeners
###

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint = "https://${var.cognito_user_pool_domain}.auth.${var.cognito_region}.amazoncognito.com/oauth2/authorize"
      client_id              = var.cognito_user_pool_client_id
      client_secret          = var.cognito_user_pool_client_secret
      issuer                 = "https://${var.cognito_user_pool_endpoint}"
      token_endpoint         = "https://${var.cognito_user_pool_domain}.auth.${var.cognito_region}.amazoncognito.com/oauth2/token"
      user_info_endpoint     = "https://${var.cognito_user_pool_domain}.auth.${var.cognito_region}.amazoncognito.com/oauth2/userInfo"
    }
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "auth_oidc" {
  listener_arn = aws_lb_listener.https.arn

  condition {
    host_header {
      values = var.without_cognito_domains
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

###
# Target Group
###

resource "aws_lb_target_group" "this" {
  name_prefix = var.env
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    matcher = "404"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  # The array need to have a static length (terraform limitation)
  for_each         = toset(data.dns_a_record_set.nlb_records.addrs)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
  port             = var.target_group_port
}



