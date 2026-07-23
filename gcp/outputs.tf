output "namespace"            { value = module.argus.namespace }
output "grafana_service"      { value = module.argus.grafana_service }
output "prometheus_service"   { value = module.argus.prometheus_service }
output "alertmanager_service" { value = module.argus.alertmanager_service }
output "prometheus_endpoint"  { value = module.argus.prometheus_endpoint }
output "loki_endpoint"        { value = module.argus.loki_endpoint }
