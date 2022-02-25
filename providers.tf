##############################
# EKS Provider Configuration #
##############################
data "aws_eks_cluster_auth" "eks_cluster_auth_token" {
  name = aws_eks_cluster.eks_cluster.name
}
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth_token.token
  #  load_config_file       = false
}