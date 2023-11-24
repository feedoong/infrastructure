terraform {
  backend "s3" {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "code-deploy.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}