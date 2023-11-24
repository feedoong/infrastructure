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

#######################################################
### IAM Role for EC2
#######################################################
resource "aws_iam_role" "codedeploy_ec2_instance_role" {
  name = "codedeploy_ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "codedeploy_ec2_instance_policy" {
  name        = "codedeploy_policy"
  description = "A policy for CodeDeploy permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:*",
        ],
        Effect = "Allow",
        Resource = "*"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attach" {
  role       = aws_iam_role.codedeploy_ec2_instance_role.name
  policy_arn = aws_iam_policy.codedeploy_ec2_instance_policy.arn
}

resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
  name = "codedeploy_instance_profile"
  role = aws_iam_role.codedeploy_ec2_instance_role.name
}