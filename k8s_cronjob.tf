///////////////////////////////////////////
//       Kubernetes CronJob Object
///////////////////////////////////////////

resource "kubernetes_cron_job_v1" "task-cronjob" {
  count = var.create_k8s_cronjob == true ? 1 : 0

  metadata {
    name      = "${var.name}-cronjob"
    namespace = var.k8s_namespace
  }
  spec {
    failed_jobs_history_limit     = 5
    starting_deadline_seconds     = 5
    successful_jobs_history_limit = 5
    schedule                      = "1 0 * * *"

    job_template {
      metadata {}
      spec {
        completions                = 1
        backoff_limit              = 3
        ttl_seconds_after_finished = 300
        template {
          metadata {}
          spec {
            container {
              name    = "${var.name}-cronjob"
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
    }
  }
}
