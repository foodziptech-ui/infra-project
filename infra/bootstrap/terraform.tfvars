aws_region          = "us-east-1"
project             = "foodzip"
environment         = "dev"

state_bucket_name   = "foodzip-dev-tfstate-<seu-sufixo-unico>"
dynamodb_table_name = "foodzip-dev-tflock"

common_tags = {
  Owner      = "Dennis"
  CostCenter = "Foodzip"
}
