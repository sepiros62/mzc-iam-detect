///////////////////////////////////////////
//         Terraform  Version
///////////////////////////////////////////
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
