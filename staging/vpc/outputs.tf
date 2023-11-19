output "vpc_id" {
  value = aws_vpc.staging.id
}

output "public_subnet_1_id" {
  value = aws_subnet.staging_public_availability_zone1.id
}

output "public_subnet_1_az" {
  value = aws_subnet.staging_public_availability_zone1.availability_zone
}

output "public_subnet_2_id" {
  value = aws_subnet.staging_public_availability_zone2.id
}

output "public_subnet_2_az" {
  value = aws_subnet.staging_public_availability_zone2.availability_zone
}
