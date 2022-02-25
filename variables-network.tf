############################
## Network Access Control ##
############################
variable "allowed_ingress_security_group_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, security_groups : list(string), self : bool }))
  description = "A list of security groups that will be allowed to access this service."
}
variable "allowed_ingress_ip_list" {
  type        = list(object({ description : string, protocol : string, from_port : number, to_port : number, cidr_blocks : list(string) }))
  description = "A list of internal ip addresses that will be allowed to access this service. This needs to be specified using CIDR notation."
}