resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "argus"
    }
  }
}

module "prometheus_stack" {
  source = "./modules/prometheus-stack"

  namespace                   = kubernetes_namespace.this.metadata[0].name
  storage_class               = var.storage_class
  retention                   = var.prometheus_retention
  prometheus_storage_size     = var.prometheus_storage_size
  alertmanager_storage_size   = var.alertmanager_storage_size
  grafana_enabled             = var.grafana_enabled
  grafana_admin_password      = var.grafana_admin_password
  grafana_storage_size        = var.grafana_storage_size
  ingress_enabled             = var.ingress_enabled
  ingress_class               = var.ingress_class
  grafana_ingress_host        = var.grafana_ingress_host
  slack_webhook_url           = var.alertmanager_slack_webhook
  pagerduty_key               = var.alertmanager_pagerduty_key
  service_account_annotations = var.service_account_annotations
  ithildin_rules              = var.ithildin_rules
}

module "loki" {
  count  = var.loki_enabled ? 1 : 0
  source = "./modules/loki"

  namespace     = kubernetes_namespace.this.metadata[0].name
  storage_class = var.storage_class
  storage_size  = var.loki_storage_size
}

module "otel" {
  count  = var.otel_enabled ? 1 : 0
  source = "./modules/otel"

  namespace           = kubernetes_namespace.this.metadata[0].name
  prometheus_endpoint = module.prometheus_stack.prometheus_endpoint
}
