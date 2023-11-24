#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### S3 Bucket
#######################################################
resource "aws_s3_bucket" "tf_state_staging" {
  bucket = "bigfanoftim-terraform-state-staging"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "staging_api_builds" {
  bucket = "feedoong-staging-api-builds"

  lifecycle {
    prevent_destroy = true
  }
}