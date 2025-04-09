resource "aws_route53_zone" "this" {
  name = "swifthaul-logisticsapp.com"
  comment = "Managed by Terraform for SwiftHaul application"
  
  tags = {
    Name = "SwiftHaul Domain"
    Environment = "Production"
  }
}

