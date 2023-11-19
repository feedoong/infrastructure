locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  api = {
    description = "Staging API"
    name        = "staging-api"
  }

  api_security_group = {
    name = "${local.api.name}-security-group"

    tags = {
      name = "${local.api.description} Security Group"
    }
  }

  api_instance = {
    tags = {
      name        = "${local.api.description} 1"
      environment = "staging-api"
    }
  }
}