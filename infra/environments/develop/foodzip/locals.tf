locals {
  project     = "foodzip"
  environment = "develop"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
    Owner       = "Dennis"
  }
}
