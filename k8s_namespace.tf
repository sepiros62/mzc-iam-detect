/////////////////////////////////////////////
//        Kubernetes Namespace Object
/////////////////////////////////////////////

resource "kubernetes_namespace" "task-namespace" {
  metadata {
    name = var.k8s_namespace

    labels = {
      mylabel = "task"
    }
  }
}
