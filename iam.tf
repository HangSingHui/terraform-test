resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_additional_permissions" {
  name = "lambda_additional_permissions"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # DynamoDB
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:BatchWriteItem",
          "dynamodb:BatchGetItem",
        ],
        Resource = [
          "arn:aws:dynamodb:ap-southeast-1:*:table/ParcelTable",
          "arn:aws:dynamodb:ap-southeast-1:*:table/RouteTable",
          "arn:aws:dynamodb:ap-southeast-1:*:table/WebsocketConnection",
          "arn:aws:dynamodb:ap-southeast-1:*:table/WebsocketConnection/index/*"
        ]
      },

      # AWS IoT
      {
        Effect   = "Allow",
        Action   = [
          "iot:Publish"
        ],
        Resource = "arn:aws:iot:ap-southeast-1:*:topic/vehicle/coordinates"
      },

      # EventBridge
      {
        Effect   = "Allow",
        Action   = [
          "events:PutEvents"
        ],
        Resource = "*"
      },

      # S3 Access
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::swifthaul-logisticsapp-frontend/*"
      },

      # AWS Location Service: Tracker
      {
        Effect = "Allow",
        Action = [
          "geo:GetDevicePosition",
          "geo:BatchUpdateDevicePosition",
          "geo:BatchDeleteDevicePositionHistory",
          "geo:ListDevicePositions",
          "geo:GetDevicePositionHistory",
          "geo:CreateTracker",
          "geo:DescribeTracker",
          "geo:ListTrackers"
        ],
        Resource = "arn:aws:geo:ap-southeast-1:127214179148:tracker/ParcelDeliveryTracker"
      },

      # Route Calculator
      {
        Effect = "Allow",
        Action = [
          "geo:CalculateRoute",
          "geo:CalculateRouteMatrix",
          "geo:CreateRouteCalculator",
          "geo:DescribeRouteCalculator",
          "geo:ListRouteCalculators"
        ],
        Resource = "arn:aws:geo:ap-southeast-1:127214179148:route-calculator/ParcelDeliveryCalculator"
      },

      # Map Access
      {
        Effect = "Allow",
        Action = [
          "geo:CreateMap",
          "geo:DescribeMap",
          "geo:GetMapGlyphs",
          "geo:GetMapSprites",
          "geo:GetMapStyleDescriptor",
          "geo:ListMaps"
        ],
        Resource = "arn:aws:geo:ap-southeast-1:127214179148:map/DeliveryRouteMap"
      },

      # Place Index Search
      {
        Effect = "Allow",
        Action = [
          "geo:SearchPlaceIndexForPosition",
          "geo:SearchPlaceIndexForText",
          "geo:SearchPlaceIndexForSuggestions"
        ],
        Resource = "arn:aws:geo:ap-southeast-1:127214179148:place-index/AddressSearch"
      }
    ]
  })
}

resource "aws_iam_policy" "invoke_iotSimulator" {
  name        = "InvokeIotSimulatorPolicy"
  path        = "/"
  description = "Allow invoking the iotSimulator Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["lambda:InvokeFunction"],
        Resource = "arn:aws:lambda:ap-southeast-1:127214179148:function:iotSimulator"
      }
    ]
  })
}

resource "aws_iam_policy" "invoke_detect_location" {
  name        = "InvokeDetectLocationPolicy"
  path        = "/"
  description = "Allow invoking the DetectLocationUpdates Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["lambda:InvokeFunction"],
        Resource = "arn:aws:lambda:ap-southeast-1:127214179148:function:DetectLocationUpdates"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_detect_location" {
  name        = "LogsForDetectLocation"
  path        = "/"
  description = "Permissions for CloudWatch logs for DetectLocationUpdates"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:log-group:/aws/lambda/DetectLocationUpdates:*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_retrieve_parcel" {
  name        = "LogsForRetrieveParcelDetails"
  path        = "/"
  description = "Permissions for CloudWatch logs for retrieveParcelDetails"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:*"
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:log-group:/aws/lambda/retrieveParcelDetails:*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_send_location" {
  name        = "LogsForSendLocation"
  path        = "/"
  description = "Permissions for CloudWatch logs for SendParcelDeliveryLocationToClient"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:*"
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:log-group:/aws/lambda/SendParcelDeliveryLocationToClient:*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_process_gps" {
  name        = "LogsForProcessGPSData"
  path        = "/"
  description = "Permissions for CloudWatch logs for processGPSData"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:*"
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:ap-southeast-1:127214179148:log-group:/aws/lambda/processGPSData:*"
      }
    ]
  })
}

resource "aws_iam_policy" "invoke_send_location" {
  name        = "InvokeSendLocationPolicy"
  path        = "/"
  description = "Allow invoking the SendParcelDeliveryLocationToClient Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = "arn:aws:lambda:ap-southeast-1:127214179148:function:SendParcelDeliveryLocationToClient*"
      }
    ]
  })
}

resource "aws_iam_policy" "invoke_retrieve_parcel" {
  name        = "InvokeRetrieveParcelPolicy"
  path        = "/"
  description = "Allow invoking the retrieveParcelDetails Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["lambda:InvokeFunction"],
        Resource = "arn:aws:lambda:ap-southeast-1:127214179148:function:retrieveParcelDetails"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_invoke_retrieve_parcel" {
  name       = "AttachInvokeRetrieveParcel"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = aws_iam_policy.invoke_retrieve_parcel.arn
}


resource "aws_iam_policy" "geo_route_calculation" {
  name = "geo-route-permission"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "geo:CalculateRoute"
        ],
        Resource = "arn:aws:geo:ap-southeast-1:799634405839:route-calculator/ParcelDeliveryCalculator"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_geo_route" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.geo_route_calculation.arn
}



resource "aws_iam_policy" "eventbridge_enable_rule" {
  name = "eventbridge-enable-rule"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "events:EnableRule"
        ],
        Resource = "arn:aws:events:ap-southeast-1:799634405839:rule/simulate-gps-movement"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_enable_rule" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.eventbridge_enable_rule.arn
}
