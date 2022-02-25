resource "aws_eks_cluster" "eks_cluster" {
  depends_on                = [aws_cloudwatch_log_group.eks_logging]
  name                      = local.instance_name
  version                   = var.k8s_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  role_arn                  = aws_iam_role.eks_aws_service_role.arn
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      vpc_config["subnet_ids"],
      vpc_config["security_group_ids"]
    ]
  }
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.api_server_security_group.id]
    subnet_ids              = var.cluster_subnets
  }
  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_kms_key.arn
    }
    resources = ["secrets"]
  }
  tags = local.resource_tags
}