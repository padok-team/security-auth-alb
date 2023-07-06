output "user_pool_endpoint" {
  value = aws_cognito_user_pool.this.endpoint
}
output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.this.id
}
output "user_pool_client_secret" {
  value = aws_cognito_user_pool_client.this.client_secret
}
output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.this.domain
}
