terraform {
  backend "s3" {
    bucket = "bigfanoftim-terraform-state-staging"
    key = "vpc.state"
    region = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}