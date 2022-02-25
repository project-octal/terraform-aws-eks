resource "aws_kms_key" "cluster_kms_key" {
  description = "KMS Key for encrypting ${local.instance_name} resources"
  tags        = local.resource_tags
}