#######################################################
### Provider
#######################################################
provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

#######################################################
### Data
#######################################################
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230825.0-kernel-6.1-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "vpc.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}

#######################################################
### Security Group & EC2 Instance For API
#######################################################
resource "aws_security_group" "api_security_group" {
  name   = local.api_security_group.name
  vpc_id = local.vpc_id

  tags = {
    Name = local.api_security_group.tags.name
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.api_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.api_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "all_traffic_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.api_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "api_1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t4g.micro"
  associate_public_ip_address = true
  key_name                    = "feedoong"

  vpc_security_group_ids = [aws_security_group.api_security_group.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_1_id

  tags = {
    Name        = local.api_instance.tags.name
    Environment = local.api_instance.tags.environment
  }
}
