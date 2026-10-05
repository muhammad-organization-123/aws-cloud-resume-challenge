terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
  backend "s3" {
    bucket       = "muhammad-cloud-challenge-resume"
    region       = "eu-west-2"
    key          = "state/terraform.tfstate"
    use_lockfile = true
  }

  required_version = ">= 1.11.0"
}
