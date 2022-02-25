resource "aws_security_group" "api_server_security_group" {
  name                   = "${local.instance_name}-api-server"
  description            = "Grants access to the api server of the ${local.instance_name} EKS cluster"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true
  dynamic "ingress" {
    for_each = var.allowed_ingress_ip_list
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = var.allowed_ingress_security_group_list
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
      self            = ingress.value.self
    }
  }
  tags = merge(
    {
      "Name" = local.instance_name,
    },
    local.resource_tags,
  )
}

resource "aws_security_group" "cross_node_group_security_group" {
  name                   = "${local.instance_name}-cross-node-group"
  description            = "Internal security group that allow worker nodes to communicate internally and accept traffic from the ${local.instance_name} security group"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allows EKS workers in this group to talk to each other over any port."
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allows EKS workers in this group to talk to each other over any port."
  }

  tags = merge(
    {
      "Name" = local.instance_name,
    },
    local.resource_tags,
  )
}