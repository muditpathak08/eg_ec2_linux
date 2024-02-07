# main.tf | Main Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    validation = {
      source = "tlkamp/validation"
      version = "1.0.0"
    }
  }
}
provider "aws" {
  region = var.region
}

provider "validation" {
  
}


