output "otel_grpc_endpoint" {
  description = "OpenTelemetry Collector gRPC endpoint"
  value       = "http://opentelemetry-collector.${var.namespace}.svc.cluster.local:4317"
}

output "otel_http_endpoint" {
  description = "OpenTelemetry Collector HTTP endpoint"
  value       = "http://opentelemetry-collector.${var.namespace}.svc.cluster.local:4318"
}
