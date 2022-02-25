##########################
#### Account VPC Info ####
##########################
variable "account_name" {
  type        = string
  description = "The name of this account"
}
variable "account_id" {
  type        = string
  description = "The ID of this account"
}
variable "vpc_id" {
  type        = string
  description = "The ID of the active account VPC"
}
variable "cluster_subnets" {
  type        = map(string)
  description = "A list of the subnets to use for the EKS control plane"
}