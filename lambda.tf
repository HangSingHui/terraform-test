# Lambda Functions Only
resource "aws_lambda_function" "updateParcelStatus" {
  function_name = "updateParcelStatus"
  filename      = "lambda/updateParcelStatus.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/updateParcelStatus.zip")
}

resource "aws_lambda_function" "TriggerRouteGeneration" {
  function_name = "TriggerRouteGeneration"
  filename      = "lambda/TriggerRouteGeneration.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/TriggerRouteGeneration.zip")
}

resource "aws_lambda_function" "retrieveRealTimeData" {
  function_name = "retrieveRealTimeData"
  filename      = "lambda/retrieveRealTimeData.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/retrieveRealTimeData.zip")
}

resource "aws_lambda_function" "extractParcelDetails" {
  function_name = "extractParcelDetails"
  filename      = "lambda/extractParcelDetails.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/extractParcelDetails.zip")
}

resource "aws_lambda_function" "retrieveParcelDetails" {
  function_name = "retrieveParcelDetails"
  filename      = "lambda/retrieveParcelDetails.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/retrieveParcelDetails.zip")
}

resource "aws_lambda_function" "activateIoTSimulator" {
  function_name = "activateIoTSimulator"
  filename      = "lambda/activateIoTSimulator.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/activateIoTSimulator.zip")
}

resource "aws_lambda_function" "processFilterGPSData" {
  function_name = "processFilterGPSData"
  filename      = "lambda/processFilterGPSData.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/processFilterGPSData.zip")
}

resource "aws_lambda_function" "iot_simulator" {
  function_name = "iotSimulator"
  filename      = "lambda/iotSimulator.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda/iotSimulator.zip")
}

# Lambda permissions for API Gateway integration
resource "aws_lambda_permission" "activateIoTSimulator_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.activateIoTSimulator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.activateIoTSimulator_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "extractParcelDetails_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.extractParcelDetails.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.extractParcelDetails_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "retrieveRealTimeData_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieveRealTimeData.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.retrieveRealTimeData_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "TriggerRouteGeneration_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.TriggerRouteGeneration.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.TriggerRouteGeneration_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "updateParcelStatus_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updateParcelStatus.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.updateParcelStatus_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "retrieveParcelDetails_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieveParcelDetails.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.extractParcelDetails_api.execution_arn}/*/*"
}
