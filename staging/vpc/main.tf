#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### VPC
#######################################################
resource "aws_vpc" "staging" {
  cidr_block = local.vpc.cidr

  tags = { Name = "Staging VPC" }
}

#######################################################
### Availability Zones
#######################################################
resource "aws_subnet" "staging_public_availability_zone1" {
  vpc_id            = aws_vpc.staging.id
  cidr_block        = local.vpc.public_zone1_cidr
  availability_zone = "ap-northeast-2a"

  tags = { Name = "Staging VPC Public Availability Zone 1" }
}

resource "aws_subnet" "staging_public_availability_zone2" {
  vpc_id            = aws_vpc.staging.id
  cidr_block        = local.vpc.public_zone2_cidr
  availability_zone = "ap-northeast-2b"

  tags = { Name = "Staging VPC Public Availability Zone 2" }
}

#######################################################
### Internet Gateway
#######################################################
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.staging.id

  tags = { Name = "Staging VPC Internet Gateway" }
}

#######################################################
### Route Table
#######################################################
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.staging.default_route_table_id

  tags = { Name = "Staging VPC Default Route Table" }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.staging.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = { Name = "Staging VPC Public Route Table" }
}

#######################################################
### Route Table Association with Availability Zone
#######################################################
resource "aws_route_table_association" "zone1_public" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.staging_public_availability_zone1.id
}

resource "aws_route_table_association" "zone2_public" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.staging_public_availability_zone2.id
}
