output "loki_service" {
  description = "Loki service name"
  value       = "loki"
}

output "loki_endpoint" {
  description = "Loki in-cluster endpoint"
  value       = "http://loki.${var.namespace}.svc.cluster.local:3100"
}
