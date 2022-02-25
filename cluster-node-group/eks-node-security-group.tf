
resource "aws_security_group" "node_group_internal_security_group" {
  name                   = "${random_pet.node_group.id}-internal"
  description            = "Allows instances that are part of the ${random_pet.node_group.id} node group to communicate with one another."
  vpc_id                 = random_pet.node_group.keepers.vpc_id
  revoke_rules_on_delete = true
  lifecycle {
    create_before_destroy = true
  }
  ingress {
    description = "Allows members of the node group to communicate freely"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
  }

  egress {
    description = "Allows members of the node group to communicate freely"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
  }

  tags = merge(
    {
      "Name" = "${random_pet.node_group.id}-internal",
    },
    local.resource_tags,
  )
}


resource "aws_security_group" "node_group_security_group" {
  name                   = random_pet.node_group.id
  description            = "Defines the ingress and egress network rules for endpoints outside the ${random_pet.node_group.keepers.cluster_name} cluster."
  vpc_id                 = random_pet.node_group.keepers.vpc_id
  revoke_rules_on_delete = true
  lifecycle {
    create_before_destroy = true
  }

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

  dynamic "egress" {
    for_each = var.allowed_egress_ip_list
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.allowed_egress_security_group_list
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      security_groups = egress.value.security_groups
      self            = egress.value.self
    }
  }

  tags = merge(
    {
      "Name" = random_pet.node_group.id,
    },
    local.resource_tags,
  )
}