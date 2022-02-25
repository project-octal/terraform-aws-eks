resource "aws_iam_role" "eks_node_group_iam_role" {
  name               = random_pet.node_group.id
  path               = "/${random_pet.node_group.keepers.cluster_name}/nodes/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  lifecycle {
    create_before_destroy = true
  }
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.assume_role_statements

    content {
      actions = ["sts:AssumeRole"]
      effect  = "Allow"

      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }

      dynamic "condition" {
        for_each = statement.value.condition

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
resource "aws_iam_role_policy_attachment" "external_policy_attachments" {
  for_each   = var.instance_profile_policies
  policy_arn = each.value
  role       = aws_iam_role.eks_node_group_iam_role.name
}
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_iam_role.name
}
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_iam_role.name
}
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_iam_role.name
}