output "prometheus_service" {
  description = "Prometheus service name"
  value       = "kube-prometheus-stack-prometheus"
}

output "alertmanager_service" {
  description = "Alertmanager service name"
  value       = "kube-prometheus-stack-alertmanager"
}

output "grafana_service" {
  description = "Grafana service name"
  value       = "kube-prometheus-stack-grafana"
}

output "prometheus_endpoint" {
  description = "Prometheus in-cluster endpoint"
  value       = "http://kube-prometheus-stack-prometheus.${var.namespace}.svc.cluster.local:9090"
}
