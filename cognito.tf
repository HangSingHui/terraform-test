# Amazon Cognito User Pool and App Client
resource "aws_cognito_user_pool" "main" {
  name = "SwiftHaulUserPool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  tags = {
    Name        = "SwiftHaulUserPool"
    Environment = "Production"
  }
}

resource "aws_cognito_user_pool_client" "web_client" {
  name         = "SwiftHaulFrontendClient"
  user_pool_id = aws_cognito_user_pool.main.id
  generate_secret = false

  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["https://swifthaul-logisticsapp.com"]
  logout_urls   = ["https://swifthaul-logisticsapp.com"]

  allowed_oauth_flows_user_pool_client = true
}
