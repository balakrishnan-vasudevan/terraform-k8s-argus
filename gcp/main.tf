module "argus" {
  source = "../"

  namespace                   = var.namespace
  storage_class               = var.storage_class
  prometheus_retention        = var.prometheus_retention
  prometheus_storage_size     = var.prometheus_storage_size
  alertmanager_storage_size   = var.alertmanager_storage_size
  grafana_enabled             = var.grafana_enabled
  grafana_admin_password      = var.grafana_admin_password
  grafana_storage_size        = var.grafana_storage_size
  loki_enabled                = var.loki_enabled
  loki_storage_size           = var.loki_storage_size
  otel_enabled                = var.otel_enabled
  ingress_enabled             = var.ingress_enabled
  ingress_class               = var.ingress_class
  grafana_ingress_host        = var.grafana_ingress_host
  alertmanager_slack_webhook  = var.alertmanager_slack_webhook
  alertmanager_pagerduty_key  = var.alertmanager_pagerduty_key
  ithildin_rules              = var.ithildin_rules

  service_account_annotations = var.workload_identity_sa != "" ? {
    "iam.gke.io/gcp-service-account" = var.workload_identity_sa
  } : {}
}
