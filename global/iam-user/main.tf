#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### IAM User for Github Actions Workflow
#######################################################
resource "aws_iam_user" "github_actions" {
  name = "github-actions-user"
}

resource "aws_iam_user_policy_attachment" "s3_full_access" {
  user       = aws_iam_user.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "codedeploy_full_access" {
  user       = aws_iam_user.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}