
resource "aws_cloudwatch_log_group" "lambda_logs" {
  for_each = toset([
    "updateParcelStatus",
    "TriggerRouteGeneration",
    "retrieveRealTimeData",
    "retrieveParcelDetails",
    "extractParcelDetails",
    "activateIoTSimulator",
    "processFilterGPSData",
    "iotSimulator"
  ])

  name              = "/aws/lambda/${each.key}"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
    # Handle the case where the log group already exists
    prevent_destroy = false
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}
