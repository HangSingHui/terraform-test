# EventBridge rule to trigger iotSimulator Lambda every 1 minute
resource "aws_cloudwatch_event_rule" "simulate_gps_movement" {
  name                = "simulate-gps-movement"
  schedule_expression = "rate(1 minute)"
  description         = "Trigger the IoT simulator Lambda every 1 minute"
}

resource "aws_cloudwatch_event_target" "simulate_gps_target" {
  rule      = aws_cloudwatch_event_rule.simulate_gps_movement.name
  target_id = "simulateGpsLambda"
  arn       = aws_lambda_function.iot_simulator.arn
}

resource "aws_lambda_permission" "allow_eventbridge_to_invoke_iot_simulator" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iot_simulator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.simulate_gps_movement.arn
}
