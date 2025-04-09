resource "aws_apigatewayv2_api" "activateIoTSimulator_api" {
  name          = "activateIoTSimulator-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "activateIoTSimulator_integration" {
  api_id                  = aws_apigatewayv2_api.activateIoTSimulator_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.activateIoTSimulator.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "activateIoTSimulator_route" {
  api_id    = aws_apigatewayv2_api.activateIoTSimulator_api.id
  route_key = "ANY /activateIoTSimulator"
  target    = "integrations/${aws_apigatewayv2_integration.activateIoTSimulator_integration.id}"
}

resource "aws_apigatewayv2_stage" "activateIoTSimulator_stage" {
  api_id      = aws_apigatewayv2_api.activateIoTSimulator_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "extractParcelDetails_api" {
  name          = "extractParcelDetails-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "extractParcelDetails_integration" {
  api_id                  = aws_apigatewayv2_api.extractParcelDetails_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.extractParcelDetails.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "extractParcelDetails_route" {
  api_id    = aws_apigatewayv2_api.extractParcelDetails_api.id
  route_key = "ANY /extractParcelDetails"
  target    = "integrations/${aws_apigatewayv2_integration.extractParcelDetails_integration.id}"
}

resource "aws_apigatewayv2_route" "parcels_route" {
  api_id    = aws_apigatewayv2_api.extractParcelDetails_api.id
  route_key = "POST /parcels"
  target    = "integrations/${aws_apigatewayv2_integration.extractParcelDetails_integration.id}"
}

resource "aws_apigatewayv2_stage" "extractParcelDetails_stage" {
  api_id      = aws_apigatewayv2_api.extractParcelDetails_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "retrieveRealTimeData_api" {
  name          = "retrieveRealTimeData-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "retrieveRealTimeData_integration" {
  api_id                  = aws_apigatewayv2_api.retrieveRealTimeData_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.retrieveRealTimeData.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "retrieveRealTimeData_route" {
  api_id    = aws_apigatewayv2_api.retrieveRealTimeData_api.id
  route_key = "ANY /retrieveRealTimeData"
  target    = "integrations/${aws_apigatewayv2_integration.retrieveRealTimeData_integration.id}"
}

resource "aws_apigatewayv2_stage" "retrieveRealTimeData_stage" {
  api_id      = aws_apigatewayv2_api.retrieveRealTimeData_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "TriggerRouteGeneration_api" {
  name          = "TriggerRouteGeneration-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "TriggerRouteGeneration_integration" {
  api_id                  = aws_apigatewayv2_api.TriggerRouteGeneration_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.TriggerRouteGeneration.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "TriggerRouteGeneration_route" {
  api_id    = aws_apigatewayv2_api.TriggerRouteGeneration_api.id
  route_key = "POST /TriggerRouteGeneration"
  target    = "integrations/${aws_apigatewayv2_integration.TriggerRouteGeneration_integration.id}"
}

resource "aws_apigatewayv2_stage" "TriggerRouteGeneration_stage" {
  api_id      = aws_apigatewayv2_api.TriggerRouteGeneration_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "updateParcelStatus_api" {
  name          = "updateParcelStatus-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "updateParcelStatus_integration" {
  api_id                  = aws_apigatewayv2_api.updateParcelStatus_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.updateParcelStatus.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "updateParcelStatus_route" {
  api_id    = aws_apigatewayv2_api.updateParcelStatus_api.id
  route_key = "PUT /updateParcelStatus"
  target    = "integrations/${aws_apigatewayv2_integration.updateParcelStatus_integration.id}"
}

resource "aws_apigatewayv2_stage" "updateParcelStatus_stage" {
  api_id      = aws_apigatewayv2_api.updateParcelStatus_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "retrieve_parcel_details" {
  name          = "retrieveParcelDetails-API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "retrieve_parcel_details" {
  api_id                  = aws_apigatewayv2_api.retrieve_parcel_details.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.retrieveParcelDetails.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "retrieve_parcel_details_route1" {
  api_id    = aws_apigatewayv2_api.retrieve_parcel_details.id
  route_key = "GET /retrieveParcelDetails"
  target    = "integrations/${aws_apigatewayv2_integration.retrieve_parcel_details.id}"
}

resource "aws_apigatewayv2_route" "retrieve_parcel_details_route2" {
  api_id    = aws_apigatewayv2_api.retrieve_parcel_details.id
  route_key = "GET /parcels"
  target    = "integrations/${aws_apigatewayv2_integration.retrieve_parcel_details.id}"
}

resource "aws_apigatewayv2_route" "retrieve_parcel_details_route3" {
  api_id    = aws_apigatewayv2_api.retrieve_parcel_details.id
  route_key = "ANY /retrieveParcelDetails"
  target    = "integrations/${aws_apigatewayv2_integration.retrieve_parcel_details.id}"
}

resource "aws_apigatewayv2_stage" "retrieve_parcel_details_stage" {
  api_id      = aws_apigatewayv2_api.retrieve_parcel_details.id
  name        = "$default"
  auto_deploy = true
}
