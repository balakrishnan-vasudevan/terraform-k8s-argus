resource "helm_release" "otel_collector" {
  name             = "opentelemetry-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  version          = "~> 0.165"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 300

  values = [
    yamlencode({
      mode = var.mode

      config = {
        receivers = {
          otlp = {
            protocols = {
              grpc = { endpoint = "0.0.0.0:4317" }
              http = { endpoint = "0.0.0.0:4318" }
            }
          }
        }

        processors = {
          batch = {}
          memory_limiter = {
            check_interval         = "1s"
            limit_percentage       = 75
            spike_limit_percentage = 15
          }
        }

        exporters = {
          prometheusremotewrite = {
            endpoint = "${var.prometheus_endpoint}/api/v1/write"
          }
          debug = { verbosity = "basic" }
        }

        service = {
          pipelines = {
            metrics = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["prometheusremotewrite"]
            }
            traces = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["debug"]
            }
          }
        }
      }
    })
  ]
}
