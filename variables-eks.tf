#############################
# EKS Cluster Configuration #
#############################
variable "service_name" {
  type        = string
  description = "The name of the service this module produces."
  default     = "eks"
}
variable "k8s_version" {
  type        = string
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.20.7"
}
variable "log_retention_in_days" {
  type        = number
  description = "The number of days to keep the EKS logs"
  default     = 400
}
variable "enable_public_endpoint" {
  type        = bool
  description = "If true, the cluster will be accessible over the internet"
  default     = false
}
variable "allow_http" {
  type        = bool
  description = "If true workers will be allowed to communicate with each other over port 80"
  default     = false
}
variable "node_groups" {
  type = list(
    object({
      instance_type : string,
      labels : map(string),
      update_default_version : bool,
      http_endpoint : string,
      http_put_response_hop_limit : number,
      scaling_config : object({ desired_size : number, min_size : number, max_size : number }),
      instance_profile_policies : map(string),
      assume_role_statements : map(object({ identifiers : list(string), type : string, condition : list(object({ test : string, variable : string, values = list(string) })) })),
      vpc_id : string,
      subnets : list(string),
      isolate_node_group_network : bool,
      allowed_ingress_security_group_list : list(object({ description : string, protocol : string, from_port : number, to_port : number, security_groups : list(string), self : bool }))
      allowed_egress_security_group_list : list(object({ description : string, protocol : string, from_port : number, to_port : number, security_groups : list(string), self : bool })),
      allowed_ingress_ip_list : list(object({ description : string, protocol : string, from_port : number, to_port : number, cidr_blocks : list(string) })),
      allowed_egress_ip_list : list(object({ description : string, protocol : string, from_port : number, to_port : number, cidr_blocks : list(string) }))
    })
  )
  description = "A list of node groups to provision in this cluster."
  default     = []
}
