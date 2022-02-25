resource "aws_cloudwatch_log_group" "eks_logging" {
  name              = "/aws/eks/${local.instance_name}/cluster"
  retention_in_days = var.log_retention_in_days
  tags              = local.resource_tags
}