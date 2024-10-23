terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }

    # time = {
    #   source  = "hashicorp/time"
    #   version = ">= 0.9"
    # }
  }

  backend "s3" {
    bucket = "xcite-terraform-state"
    region = "us-east-1"
    key    = "dev/mimeo-karpenter-1-31-0/terraform.tfstate"

    # dynamodb_table = "xcite-terraform"
  }
}
