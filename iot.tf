# IoT Core Rule to send messages to SQS instead of directly to Lambda
resource "aws_iot_topic_rule" "retrieve_gps_data" {
  name        = "RetrieveGPSData"
  description = "Rule to process incoming vehicle GPS coordinates"
  enabled     = true
  sql         = "SELECT * FROM 'vehicle/coordinates'"
  sql_version = "2016-03-23"

  sqs {
    queue_url  = aws_sqs_queue.parcel_events.url
    role_arn   = aws_iam_role.iot_to_sqs_role.arn
    use_base64 = false
  }
}

# IAM role for IoT to publish to SQS
resource "aws_iam_role" "iot_to_sqs_role" {
  name = "iot_to_sqs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "iot.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for the IoT role to access SQS
resource "aws_iam_role_policy" "iot_sqs_policy" {
  name = "iot_sqs_policy"
  role = aws_iam_role.iot_to_sqs_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sqs:SendMessage",
        Effect = "Allow",
        Resource = aws_sqs_queue.parcel_events.arn
      }
    ]
  })
}

# IoT Policy that allows basic MQTT operations
resource "aws_iot_policy" "allow_mqtt_operations" {
  name = "AllowMQTTOperations"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "iot:Connect",
          "iot:Subscribe",
          "iot:Publish",
          "iot:Receive"
        ],
        "Resource": "*"
      }
    ]
  })
}