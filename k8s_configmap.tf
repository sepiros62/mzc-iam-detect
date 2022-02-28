///////////////////////////////////////////
//      Kubernetes ConfigMap Object
///////////////////////////////////////////

resource "kubernetes_config_map" "task-configmap" {
  metadata {
    name      = "${var.name}-configmap"
    namespace = var.k8s_namespace
  }

  data = {
    DAYS                  = var.accesskey_unreplaced_day
    AWS_DEFAULT_REGION    = var.region
    AWS_ACCESS_KEY_ID     = var.aws_access_key
    AWS_SECRET_ACCESS_KEY = var.aws_secret_key

    # "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
  }
}
