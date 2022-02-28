########################
# Common Variables
########################
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""

  validation {
    condition     = length(var.name) < 20 && can(regex("(?m:^[0-9A-Za-z-]+$)", var.name))
    error_message = "ERROR - Name cannot have more than 20 characters or Name can include only letters, numbers(0-9), and dashes(-) ~!"
  }
}

variable "region" {
  type        = string
  description = "AWS Region Name"
  default     = "ap-notheast-2"
}

variable "profile" {
  description = "AWS Profile to be used on all the resources as identifier"
  type        = string
  default     = "default"
}

variable "accesskey_unreplaced_day" {
  description = "AWS "
  type        = string
  default     = "AWS IAM Unused Accesskey Days"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes Namespace Name"
  default     = "ap-notheast-2"
}

########################
# Environment Variables
########################
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true

  validation {
    condition     = length(var.aws_access_key) == 20
    error_message = "ERROR - The Access Key has 20 characters in length ~!"
    // https://alestic.com/2009/11/ec2-credentials/
  }
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true

  validation {
    condition     = length(var.aws_secret_key) == 40
    error_message = "ERROR - The Access Key has 40 characters in length ~!"
    // https://alestic.com/2009/11/ec2-credentials/
  }
}


########################
# Create Resource Type
########################
variable "create_k8s_job" {
  description = "Select object type for Kubernetes job."
  type        = bool
  default     = true
}

variable "create_k8s_cronjob" {
  description = "Select object type for Kubernetes Cronjob."
  type        = bool
  default     = true
}
