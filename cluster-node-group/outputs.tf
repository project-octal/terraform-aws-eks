output "node_group_id" {
  value = aws_eks_node_group.eks_node_group.id
}
output "node_group_name" {
  value = aws_eks_node_group.eks_node_group.node_group_name
}
output "node_group_role_arn" {
  value = aws_iam_role.eks_node_group_iam_role.arn
}
output "node_group_role_name" {
  value = aws_iam_role.eks_node_group_iam_role.name
}