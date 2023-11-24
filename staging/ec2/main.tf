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
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "vpc.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}

data "terraform_remote_state" "iam_role" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-global"
    key     = "iam-role.state"
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
  from_port         = 8080
  to_port           = 8080
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
  ami                         = "ami-033e7d0a847ade1d8" // amazon linux 2023
  instance_type               = "t4g.micro"
  associate_public_ip_address = true
  key_name                    = "feedoong"
  iam_instance_profile        = data.terraform_remote_state.iam_role.outputs.codedeploy_instance_profile_name

  vpc_security_group_ids = [aws_security_group.api_security_group.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_1_id

  tags = {
    Name        = local.api_instance.tags.name
    Environment = local.api_instance.tags.environment
  }
}
