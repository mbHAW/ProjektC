terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.10.0"
    }
  }

  backend "s3" {
    encrypt        = true
    key            = "helloapp-build/terraform.state"
    bucket         = "projektc-dev-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "eu-central-1"
    profile        = "projektc-dev"
  }
}

provider "aws" {
  profile = "projektc-dev"
  region  = "eu-central-1"
}
