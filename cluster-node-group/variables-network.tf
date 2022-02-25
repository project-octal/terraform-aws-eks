variable "vpc_id" {
  type        = string
  description = "The ID of the active account VPC"
}
variable "subnets" {
  type        = list(string)
  description = "The ID of one or more private subnets in which the lambda function will execute."
}
variable "isolate_node_group_network" {
  type        = bool
  description = "Specifies if this node group should be allowed to communicate with other node groups."
}
variable "cross_node_group_security_group_id" {
  type        = string
  description = "The id of a security group that allows all the cluster node groups to communicate internally"
}
variable "eks_cluster_security_group_id" {
  type = string
}
variable "allowed_ingress_security_group_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, security_groups : list(string), self : bool }))
  description = "A list of security groups that will be allowed to access this service."
}
variable "allowed_ingress_ip_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, cidr_blocks : list(string) }))
  description = "A list of internal ip addresses that will be allowed to access this service. This needs to be specified using CIDR notation."
}
variable "allowed_egress_security_group_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, security_groups : list(string), self : bool }))
  description = "A list of security groups that nodes in this Lambda function will be allowed to communicate with."
}
variable "allowed_egress_ip_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, cidr_blocks : list(string) }))
  description = "A list of internal ip addresses that nodes in this Lambda function will be allowed to communicate with."
}
variable "additional_security_group_ids" {
  type        = list(string)
  description = "A map security groups (name: id) independent of the default security group created within this module."
  default     = []
}