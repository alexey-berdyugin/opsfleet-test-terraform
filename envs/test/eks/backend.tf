terraform {
  backend "s3" {
    bucket         = "opsfleet-test-terraform"
    key            = "eks/eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}