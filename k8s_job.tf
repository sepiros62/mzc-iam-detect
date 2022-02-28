///////////////////////////////////////////
//        Kubernetes Job Object
///////////////////////////////////////////

resource "kubernetes_job" "task-job" {
  count = var.create_k8s_job == true ? 1 : 0
  metadata {
    name      = "${var.name}-job"
    namespace = var.k8s_namespace
  }
  spec {
    completions                = 1
    backoff_limit              = 3
    ttl_seconds_after_finished = 120
    template {
      metadata {}
      spec {
        container {
          name    = "${var.name}-job"
          image   = "sepiros62/alpine_awscli:latest"
          command = ["/bin/bash", "/script/aws_iam_detect.sh"]
          args    = ["-d", "$(DAYS)"]

          volume_mount {
            name       = "${var.name}-volume"
            mount_path = "/scrit/result"
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.task-configmap.metadata.0.name
            }
          }
        }

        volume {
          name = "${var.name}-volume"
          host_path {
            path = "/tmp/task-volume"
            type = "DirectoryOrCreate"
          }
        }
        restart_policy = "Never"
      }
    }
  }
  wait_for_completion = true
  timeouts {
    create = "60s"
  }
}
