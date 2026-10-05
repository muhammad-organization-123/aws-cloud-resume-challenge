variable "domain_name" {
  description = "Primary domain name for the website"
  type        = string
  default     = "muhammad-cloud-resume-challenge.com"
}

variable "bucket_name" {
  description = "Name of the S3 static website bucket"
  type        = string
  default     = "muhammad-cloud-resume-challenge.com"
}

variable "environment_name" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "eu-west-2"
}

variable "tags" {
  description = "Common metadata tags applied across resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "cloud-resume-challenge"
    Name        = "muhammad-cloud-resume-challenge"
  }
}
