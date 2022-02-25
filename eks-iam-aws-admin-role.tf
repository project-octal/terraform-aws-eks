resource "aws_iam_role" "eks_aws_admin_role" {
  name_prefix        = "${local.instance_name}-admin-"
  assume_role_policy = data.aws_iam_policy_document.eks_aws_admin_trust_polcy.json
  tags               = local.resource_tags
}
data "aws_iam_policy_document" "eks_aws_admin_trust_polcy" {
  version = "2012-10-17"
  statement {
    sid    = "${var.organization}${upper(var.support_department_code)}EKSTrustPolicy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.eks_aws_admin_trust_role_arn]
    }
    actions = ["sts:AssumeRole"]
  }
}