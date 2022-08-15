terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 3.63.0"
    }
  }
}