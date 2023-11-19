terraform {
  backend "s3" {
    bucket  = "bigfanoftim-terraform-state-global"
    key     = "s3.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}