///////////////////////////////////////////
//              Provider
///////////////////////////////////////////
// AWS Provider
provider "aws" {
  profile = var.profile
  region  = "ap-northeast-2"

  default_tags {
    tags = {
      Environment = "common"
      Service     = "all-in-one"
    }
  }
}

// Kubernetes Provider
provider "kubernetes" {
  alias                  = "minikube"
  config_path            = "~/.kube/config"
  config_context_cluster = "minikube"
}
