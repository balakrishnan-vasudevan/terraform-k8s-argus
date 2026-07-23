resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  version          = "~> 7.0"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 300

  values = [
    yamlencode({
      loki = {
        commonConfig = {
          replication_factor = 1
        }
        storage = {
          type = "filesystem"
        }
        limits_config = {
          retention_period = "${var.retention_hours}h"
        }
      }
      singleBinary = {
        replicas = 1
        persistence = {
          enabled          = true
          storageClass     = var.storage_class
          size             = var.storage_size
        }
      }
      monitoring = {
        selfMonitoring = {
          enabled = false
          grafanaAgent = {
            installOperator = false
          }
        }
        lokiCanary = {
          enabled = false
        }
      }
      test = {
        enabled = false
      }
    })
  ]
}
