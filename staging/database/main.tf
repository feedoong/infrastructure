provider "aws" {
  region  = "ap-northeast-2"
  profile = "bigfanoftim"
}

data "terraform_remote_state" "kms_key" {
  backend = "s3"
  config = {
    bucket = "bigfanoftim-terraform-state-global"
    key = "kms-key.state"
    region = "ap-northeast-2"
    profile = "bigfanoftim"
  }
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

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config  = {
    bucket  = "bigfanoftim-terraform-state-staging"
    key     = "ec2.state"
    region  = "ap-northeast-2"
    profile = "bigfanoftim"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "staging-db-subnet-group"
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_2_id
  ]

  tags = {
    Name = "Staging DB Subnet Group"
  }
}

resource "aws_security_group" "rds_security_group" {
  name   = "staging-mariadb-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "Staging MariaDB Security Group"
  }
}

resource "aws_security_group_rule" "rds_ingress_from_api" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_security_group.id
  source_security_group_id = data.terraform_remote_state.ec2.outputs.api_security_group_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "staging-1" {
  identifier                    = "staging-mariadb-1"
  allocated_storage             = 10
  db_subnet_group_name          = aws_db_subnet_group.default.name
  vpc_security_group_ids        = [aws_security_group.rds_security_group.id]
  engine                        = "mariadb"
  engine_version                = "10.6"
  instance_class                = "db.t4g.micro"
  manage_master_user_password   = true
  master_user_secret_kms_key_id = data.terraform_remote_state.kms_key.outputs.kms_key_id
  username                      = "feedoong"
  parameter_group_name          = "default.mariadb10.6"
}
