variable "service_name" {
  type        = string
  description = "The name of the service this module produces."
}
variable "eks_cluster_name" {
  type        = string
  description = "The name of the cluster this node group is being created for."
}
variable "eks_cluster_version" {
  type        = string
  description = "The name of the cluster this node group is being created for."
}
variable "eks_cluster_endpoint" {
  type = string
}
variable "eks_cluster_ca" {
  type = string
}