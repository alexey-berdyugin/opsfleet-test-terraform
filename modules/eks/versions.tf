terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    tls = {
      source = "hashicorp/tls"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.3.6"
}