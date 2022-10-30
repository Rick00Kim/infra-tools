terraform {
  required_providers {
    aws = {
      version = "> 4.00.0"
    }
  }
  backend "s3" {
    bucket = "<BUCKENT_NAME>"
    key    = "<KEY>/${RESOURCE_NAME}.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}
