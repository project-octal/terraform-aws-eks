resource "aws_iam_role" "eks_aws_user_role" {
  name_prefix        = "${local.instance_name}-users-"
  assume_role_policy = data.aws_iam_policy_document.eks_aws_users_trust_polcy.json
  tags               = local.resource_tags
}
data "aws_iam_policy_document" "eks_aws_users_trust_polcy" {
  version = "2012-10-17"
  statement {
    sid    = "${var.organization}${upper(var.support_department_code)}EKSTrustPolicy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:role/ReadOnly-Role"]
    }
    actions = ["sts:AssumeRole"]
  }
}