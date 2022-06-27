##############################
# Cluster Auth Configuration #
##############################
variable "aws_iam_openid_provider_client_id_list" {
  type        = list(string)
  description = "(Required) A list of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. (This is the value that's sent as the client_id parameter on OAuth requests.)"
  default     = ["sts.amazonaws.com"]
}
variable "eks_aws_admin_trust_role_arn" {
  type        = string
  description = "The ARN of the role that will be trusted to assume the admin EKS role"
}