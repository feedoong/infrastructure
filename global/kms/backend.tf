terraform {
  backend "s3" {
    bucket  = "bigfanoftim-terraform-state-global"
    key     = "kms-key.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}
