///////////////////////////////////////////
//            AWS  Provider
///////////////////////////////////////////
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

///////////////////////////////////////////
//         Kubernetes  Provider
///////////////////////////////////////////
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
