data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "opsfleet-test-terraform"
    key    = "vpc/vpc.tfstate"
    region = "us-east-1"
  }
}
