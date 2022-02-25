resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = random_pet.node_group.keepers.cluster_name
  node_group_name = random_pet.node_group.id
  subnet_ids      = jsondecode(random_pet.node_group.keepers.subnet_ids)
  node_role_arn   = "arn:aws:iam::${var.account_id}:role/${aws_iam_role.eks_node_group_iam_role.name}"

  scaling_config {
    desired_size = var.scaling_config.desired_size
    min_size     = var.scaling_config.min_size
    max_size     = var.scaling_config.max_size
  }
  labels = var.labels
  tags   = local.resource_tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly
  ]
}