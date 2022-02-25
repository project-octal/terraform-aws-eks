variable "labels" {
  type = map(string)
}
variable "instance_type" {
  type = string
}
variable "image_id" {
  type = string
}
variable "update_default_version" {
  type = bool
}
variable "http_endpoint" {
  type = string
}
variable "http_put_response_hop_limit" {
  type = number
}
variable "scaling_config" {
  type = object({ desired_size : number, min_size : number, max_size : number })
}
variable "instance_profile_policies" {
  type = map(string)
}
variable "assume_role_statements" {
  type = map(object({
    identifiers = list(string)
    type        = string
    condition = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
}