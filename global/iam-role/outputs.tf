output "codedeploy_iam_role_arn" {
  value = aws_iam_role.code_deploy.arn
}

output "codedeploy_instance_profile_name" {
  value = aws_iam_instance_profile.codedeploy_instance_profile.name
}