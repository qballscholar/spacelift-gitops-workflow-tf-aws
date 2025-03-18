variable "minikube_ip" {}
variable "minikube_token" {}

provider "kubernetes" {
  config_path = "/mnt/workspace/kubeconfig"
  host                   = "https://${var.minikube_ip}:8443"
  cluster_ca_certificate = filebase64("/mnt/workspace/ca.crt")
  token                  = var.minikube_token
}
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels    = { app = "nginx" }
  }

  spec {
    replicas = 2
    selector { match_labels = { app = "nginx" } }

    template {
      metadata { labels = { app = "nginx" } }
      spec {
        container {
          image = "nginx:1.23.0"
          name  = "nginx"
          port { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = { app = "nginx" }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}