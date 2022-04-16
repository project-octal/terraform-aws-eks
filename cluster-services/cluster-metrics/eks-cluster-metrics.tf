resource "kubernetes_cluster_role" "metrics_reader_cluster_role" {
  metadata {
    name = "system:aggregated-metrics-reader"
    labels = {
      "rbac.authorization.k8s.io/aggregate-to-view" : "true"
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" : "true"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "metrics_delegator_cluster_role_binding" {
  metadata {
    name = "metrics-server:system:auth-delegator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "metrics_auth_reader_role_binding" {
  metadata {
    name      = "metrics-server-auth-reader"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
}

resource "kubernetes_api_service" "metrics_api_service" {
  metadata {
    name = "v1beta1.metrics.k8s.io"
  }
  spec {
    service {
      name      = "metrics-server"
      namespace = "kube-system"
    }
    group                  = "metrics.k8s.io"
    group_priority_minimum = 100
    version                = "v1beta1"
    version_priority       = 100
    # TODO: Make sure we really need this.....
    insecure_skip_tls_verify = true
  }
}

resource "kubernetes_service_account" "metrics_service_account" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "metrics_deployment" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      k8s-app : "metrics-server"
    }
  }
  spec {
    selector {
      match_labels = {
        k8s-app : "metrics-server"
      }
    }
    template {
      metadata {
        name = "metrics-server"
        labels = {
          k8s-app : "metrics-server"
        }
      }
      spec {
        service_account_name = "metrics-server"
        volume {
          name = "tmp-dir"
          empty_dir {
          }
        }
        container {
          name              = "metrics-server"
          image             = "k8s.gcr.io/metrics-server-amd64:v0.6.1"
          image_pull_policy = "IfNotPresent"
          args = [
            "--cert-dir=/tmp",
            "--secure-port=4443"
          ]
          port {
            name           = "main-port"
            container_port = 4443
            protocol       = "TCP"
          }
          security_context {
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 1000
          }
          volume_mount {
            name       = "tmp-dir"
            mount_path = "/tmp"
          }
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.metrics_service_account.default_secret_name
            read_only  = true
          }
        }
        volume {
          name = kubernetes_service_account.metrics_service_account.default_secret_name
          secret {
            secret_name = kubernetes_service_account.metrics_service_account.default_secret_name
          }
        }
        node_selector = {
          "kubernetes.io/os" : "linux",
          "kubernetes.io/arch" : "amd64"
        }
      }
    }
  }
}

resource "kubernetes_service" "metrics_service" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      "kubernetes.io/name" : "Metrics-server"
      "kubernetes.io/cluster-service" : "true"
    }
  }
  spec {
    selector = {
      k8s-app : "metrics-server"
    }
    port {
      port        = 443
      protocol    = "TCP"
      target_port = "main-port"
    }
  }
}

resource "kubernetes_cluster_role" "metrics_cluster_role" {
  metadata {
    name = "system:metrics-server"
  }
  rule {
    api_groups = [""]
    resources = [
      "pods",
      "nodes",
      "nodes/stats",
      "namespaces",
      "configmaps"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "metrics_cluster_role_binding" {
  metadata {
    name = "system:metrics-server"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:metrics-server"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }
}