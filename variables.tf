///////////
/// COMMON
///////////
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "profile" {
  description = "AWS Profile to be used on all the resources as identifier"
  type        = string
  default     = "default"
}
