resource "aws_iam_role" "eks_aws_service_role" {
  name_prefix        = "${local.instance_name}-service-"
  assume_role_policy = data.aws_iam_policy_document.eks_aws_service_trust_polcy.json
  tags               = local.resource_tags
}
data "aws_iam_policy_document" "eks_aws_service_trust_polcy" {
  version = "2012-10-17"
  statement {
    sid    = "AmazonEKSTrustPolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_aws_service_role.name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_aws_service_role.name
}