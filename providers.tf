# main.tf | Main Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    validation = {
      source = "tlkamp/validation"
      version = "1.0.0"
    }
  }
}
provider "validation" {}