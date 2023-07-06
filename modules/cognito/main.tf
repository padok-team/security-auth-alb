resource "aws_cognito_user_pool" "this" {
  name = "${var.name}-pool"

  alias_attributes = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

}

resource "aws_cognito_user_pool_client" "this" {
  name = "${var.name}-client"

  user_pool_id = aws_cognito_user_pool.this.id

  supported_identity_providers = ["COGNITO"]
  # supported_identity_providers = [aws_cognito_identity_provider.this.provider_name]

  callback_urls                        = [for dns_name in var.callback_dns : "https://${dns_name}/oauth2/idpresponse"]
  logout_urls                          = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  generate_secret                      = true
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.this.id
}

# resource "aws_cognito_identity_provider" "this" {
#   user_pool_id  = aws_cognito_user_pool.this.id
#   provider_name = "GWorkspace"
#   provider_type = "SAML"

#   attribute_mapping = {
#     email = "email"
#   }

#   # provider_details = {
#   #   MetadataFile          = var.saml_metadata
#   #   SSORedirectBindingURI = var.redirect_binding_uri
#   # }
# }
