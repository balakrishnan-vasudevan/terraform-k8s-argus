output "namespace" {
  description = "Kubernetes namespace where the stack is deployed"
  value       = kubernetes_namespace.this.metadata[0].name
}

output "grafana_service" {
  description = "Grafana service name"
  value       = module.prometheus_stack.grafana_service
}

output "prometheus_service" {
  description = "Prometheus service name"
  value       = module.prometheus_stack.prometheus_service
}

output "alertmanager_service" {
  description = "Alertmanager service name"
  value       = module.prometheus_stack.alertmanager_service
}

output "prometheus_endpoint" {
  description = "Prometheus in-cluster endpoint"
  value       = module.prometheus_stack.prometheus_endpoint
}

output "loki_endpoint" {
  description = "Loki in-cluster endpoint (empty if loki_enabled is false)"
  value       = var.loki_enabled ? module.loki[0].loki_endpoint : ""
}
