provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

resource "aws_kms_key" "rds" {
  description = "KMS Key for RDS"
}
