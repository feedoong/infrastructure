output "api_security_group_id" {
  value = aws_security_group.api_security_group.id
}

output "api_1_environment_tag_value" {
  value = aws_instance.api_1.tags.Environment
}