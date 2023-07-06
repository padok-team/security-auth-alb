variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "env" {
  description = "Environment of the ALB"
  type        = string
}

variable "without_cognito_domains" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "target_group_port" {
  description = "Target Group Port"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Target Group Protocol"
  type        = string
  default     = "HTTP"
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  type        = string
}

variable "cognito_region" {
  description = "Region where congito is created"
  type        = string
  default     = "eu-west-3"
}

variable "cognito_user_pool_endpoint" {
  description = "The Cognito user pool endpoint"
  type        = string
  default     = ""
}

variable "cognito_user_pool_client_id" {
  description = "The Cognito user pool client id"
  type        = string
  default     = ""
}

variable "cognito_user_pool_client_secret" {
  description = "The Cognito user pool client secret"
  type        = string
  default     = ""
}

variable "cognito_user_pool_domain" {
  description = "The Cognito user pool domain"
  type        = string
  default     = ""
}
