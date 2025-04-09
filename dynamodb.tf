# DynamoDB tables
resource "aws_dynamodb_table" "parcel_table" {
  name         = "ParcelTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "parcelId"

  attribute {
    name = "parcelId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "route_table" {
  name         = "RouteTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "routeId"

  attribute {
    name = "routeId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "websocket_connection" {
  name         = "WebsocketConnection"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }
}
