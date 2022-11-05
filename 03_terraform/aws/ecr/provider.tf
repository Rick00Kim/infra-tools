terraform {
  required_providers {
    aws = {
      version = "> 4.00.0"
    }
  }
  # For using, Update manually "<RESOURCE_NAME>" because Backend config cannot set dynamically.
  backend "s3" {
    bucket = "${BUCKET_NAME}"
    key    = "ecr/private/${RESOURCE_NAME}.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}
