#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### IAM Role for CodeDeploy
#######################################################
resource "aws_iam_role" "code_deploy" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attachment" {
  role       = aws_iam_role.code_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}