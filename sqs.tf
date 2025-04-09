# SQS Queues
resource "aws_sqs_queue" "parcel_events" {
  name                      = "parcel-events"
  visibility_timeout_seconds = 30
  message_retention_seconds = 345600
  delay_seconds             = 0
  max_message_size          = 262144
  receive_wait_time_seconds = 0
  sqs_managed_sse_enabled   = true

  tags = {
    Name        = "ParcelEvents Queue"
    Project     = "SwiftHaul"
    Environment = "Production"
    Service     = "SwiftHaul"
    ManagedBy   = "Terraform"
  }
}

resource "aws_sqs_queue" "parcel_events_dlq" {
  name                      = "parcel-events-dead-letter"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true

  tags = {
    Name        = "ParcelEvents Dead Letter Queue"
    Project     = "SwiftHaul"
    Environment = "Production"
    Service     = "SwiftHaul"
    ManagedBy   = "Terraform"
  }
}

resource "aws_sqs_queue_redrive_policy" "parcel_events_redrive" {
  queue_url = aws_sqs_queue.parcel_events.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.parcel_events_dlq.arn,
    maxReceiveCount     = 5
  })
}

# Queue Policies
resource "aws_sqs_queue_policy" "parcel_events_policy" {
  queue_url = aws_sqs_queue.parcel_events.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "SQSDefaultPolicy",
    Statement = [
      {
        Sid       = "AllowLambdaAccess",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource  = aws_sqs_queue.parcel_events.arn
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "parcel_events_dlq_policy" {
  queue_url = aws_sqs_queue.parcel_events_dlq.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "SQSDLQPolicy",
    Statement = [
      {
        Sid       = "AllowSQSAccess",
        Effect    = "Allow",
        Principal = {
          Service = "sqs.amazonaws.com"
        },
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.parcel_events_dlq.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sqs_queue.parcel_events.arn
          }
        }
      }
    ]
  })
}

# SQS access policy for Lambda
resource "aws_iam_policy" "sqs_access_policy" {
  name        = "sqs-access-policy"
  description = "Allow Lambda functions to access parcel-events SQS and DLQ"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ],
        Resource = aws_sqs_queue.parcel_events.arn
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = aws_sqs_queue.parcel_events_dlq.arn
      }
    ]
  })
}

# Attach policy to shared Lambda role
resource "aws_iam_role_policy_attachment" "attach_sqs_policy_to_lambda_role" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

# Lambda SQS Event Source Mappings
resource "aws_lambda_event_source_mapping" "update_parcel_status_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.updateParcelStatus.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "extract_parcel_details_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.extractParcelDetails.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "retrieve_parcel_details_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.retrieveParcelDetails.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "retrieve_real_time_data_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.retrieveRealTimeData.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "trigger_route_generation_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.TriggerRouteGeneration.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "process_filter_gps_data_sqs_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.processFilterGPSData.arn
  batch_size       = 10
  enabled          = true
}


resource "aws_lambda_event_source_mapping" "activate_iot_simulator_trigger" {
  event_source_arn = aws_sqs_queue.parcel_events.arn
  function_name    = aws_lambda_function.activateIoTSimulator.arn
  batch_size       = 10
  enabled          = true
}
