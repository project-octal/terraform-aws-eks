
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    template = {
      source = "hashicorp/template"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
