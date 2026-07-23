locals {
  receivers = concat(
    [{ name = "null" }],
    var.slack_webhook_url != "" ? [{
      name = "slack"
      slack_configs = [{
        api_url       = var.slack_webhook_url
        channel       = "#alerts"
        send_resolved = true
        title         = "{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"
        text          = "{{ range .Alerts }}{{ .Annotations.description }}{{ end }}"
      }]
    }] : [],
    var.pagerduty_key != "" ? [{
      name = "pagerduty"
      pagerduty_configs = [{
        routing_key = var.pagerduty_key
      }]
    }] : []
  )

  default_receiver = (
    var.slack_webhook_url != "" ? "slack" :
    var.pagerduty_key != "" ? "pagerduty" :
    "null"
  )
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "~> 87.0"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 600

  values = [
    yamlencode({
      prometheus = {
        serviceAccount = {
          annotations = var.service_account_annotations
        }
        prometheusSpec = {
          retention = var.retention
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = var.storage_class
                resources = {
                  requests = { storage = var.prometheus_storage_size }
                }
              }
            }
          }
          additionalPrometheusRulesMap = var.ithildin_rules != "" ? {
            "ithildin-slo-rules" = yamldecode(var.ithildin_rules)
          } : {}
        }
      }

      alertmanager = {
        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = var.storage_class
                resources = {
                  requests = { storage = var.alertmanager_storage_size }
                }
              }
            }
          }
        }
        config = {
          global = { resolve_timeout = "5m" }
          route = {
            group_by        = ["job", "alertname", "severity"]
            group_wait      = "30s"
            group_interval  = "5m"
            repeat_interval = "12h"
            receiver        = local.default_receiver
          }
          receivers = local.receivers
        }
      }

      grafana = {
        enabled       = var.grafana_enabled
        adminPassword = var.grafana_admin_password
        persistence = {
          enabled          = true
          storageClassName = var.storage_class
          size             = var.grafana_storage_size
        }
        ingress = {
          enabled          = var.ingress_enabled
          ingressClassName = var.ingress_class
          hosts            = var.grafana_ingress_host != "" ? [var.grafana_ingress_host] : []
        }
        datasources = {
          "datasources.yaml" = {
            apiVersion = 1
            datasources = [{
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://kube-prometheus-stack-prometheus:9090"
              isDefault = true
            }]
          }
        }
      }
    })
  ]
}
