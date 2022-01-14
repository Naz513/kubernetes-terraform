terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"

  default_tags {
    tags = {
      Owner   = "Mohd Saquib"
      Project = "Kubernetes Cluster"
      Env     = "Test"
    }

  }
}