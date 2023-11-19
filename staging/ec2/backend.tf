terraform {
  backend "s3" {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "ec2.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}