#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### Terraform Remote State
#######################################################
data "terraform_remote_state" "iam_role" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-global"
    key     = "iam-role.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "ec2.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}

#######################################################
### CodeDeploy
#######################################################
resource "aws_codedeploy_app" "ec2" {
  name = "feedoong"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "group" {
  app_name               = aws_codedeploy_app.ec2.name
  deployment_group_name  = "FeedoongStagingAPIDeploymentGroup"
  service_role_arn       = data.terraform_remote_state.iam_role.outputs.code_deploy_iam_role_arn

  ec2_tag_filter {
    key   = "Environment"
    type  = "KEY_AND_VALUE"
    value = data.terraform_remote_state.ec2.outputs.api_1_environment_tag_value
  }
}