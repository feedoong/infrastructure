terraform {
  backend "s3" {
    bucket  = "bigfanoftim-terraform-state-global"
    key     = "iam-role.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}