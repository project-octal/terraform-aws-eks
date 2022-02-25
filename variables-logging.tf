####################
## Access Logging ##
####################
variable "access_log_bucket" {
  type        = string
  description = "The ARN of the S3 access log bucket to use for load-balancer logs"
}
