resource "aws_budgets_budget" "monthly" {
  name              = "MonthlyBudget"
  budget_type       = "COST"
  limit_amount      = "1"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon S3", "Amazon CloudFront", "Amazon Route 53"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = ["benita.mai@gmail.com"]
  }
}