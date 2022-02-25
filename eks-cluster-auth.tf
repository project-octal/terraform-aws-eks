resource "aws_iam_openid_connect_provider" "eks_openid_connect_provider" {
  client_id_list  = var.aws_iam_openid_provider_client_id_list
  thumbprint_list = var.aws_iam_openid_provider_thumbprint_list
  url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0["issuer"]
  tags            = local.resource_tags
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.eks_admin_roles,
        local.eks_user_roles,
        local.eks_service_roles
      ))
    )
  }
}

locals {
  eks_admin_roles = [
    {
      rolearn  = aws_iam_role.eks_aws_admin_role.arn
      username = "${lower(var.support_department_code)}:admin:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]
  eks_user_roles = [
    {
      rolearn  = aws_iam_role.eks_aws_user_role.arn
      username = "${lower(var.support_department_code)}:user:{{SessionName}}"
      groups   = ["system:authenticated"]
    }
  ]
  eks_service_roles = [
    for cluster_node_group in module.eks_cluster_nodes :
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/${cluster_node_group["node_group_role_name"]}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]
}