##############################
#### Instance Information ####
##############################
variable "organization" {
  type        = string
  description = "The organization this service instance is being created for"
}
variable "project" {
  type        = string
  description = "The project this service instance is being created for"
}
variable "region" {
  type        = string
  description = "The region this service instance is being created in"
}
variable "environment" {
  type        = string
  description = "The environment this service instance is being created in"
}
variable "tags" {
  type        = map(string)
  description = "Extra tags to include with the resources created by this module"
  default     = {}
}