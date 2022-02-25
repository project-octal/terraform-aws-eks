output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_ca_cert" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_admin_role_name" {
  value = aws_iam_role.eks_aws_admin_role.name
}

output "eks_cluster_admin_role_arn" {
  value = aws_iam_role.eks_aws_admin_role.arn
}

output "eks_cluster_user_role_name" {
  value = aws_iam_role.eks_aws_user_role.name
}

output "eks_cluster_user_role_arn" {
  value = aws_iam_role.eks_aws_user_role.arn
}