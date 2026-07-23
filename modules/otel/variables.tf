variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
}

variable "prometheus_endpoint" {
  description = "Prometheus remote write endpoint"
  type        = string
}

variable "mode" {
  description = "Collector deployment mode: deployment, daemonset, or statefulset"
  type        = string
  default     = "deployment"

  validation {
    condition     = contains(["deployment", "daemonset", "statefulset"], var.mode)
    error_message = "mode must be one of: deployment, daemonset, statefulset"
  }
}
