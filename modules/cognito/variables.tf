variable "name" {
  description = "The name of the Cognito user pool"
  type        = string
}

variable "domain" {
  description = "The name of the Cognito domain"
  type        = string
}

variable "callback_dns" {
  description = "List of consumers DNS names"
  type        = list(string)
}

variable "logout_urls" {
  description = "List of consumers DNS names"
  type        = list(string)
  default     = []
}
