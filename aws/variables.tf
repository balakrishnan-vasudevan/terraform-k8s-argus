variable "namespace" {
  description = "Kubernetes namespace for the observability stack"
  type        = string
  default     = "observability"
}

variable "storage_class" {
  description = "Storage class override (defaults to gp3)"
  type        = string
  default     = "gp3"
}

variable "irsa_role_arn" {
  description = "IAM role ARN for IRSA (allows Prometheus to access AWS services)"
  type        = string
  default     = ""
}

variable "prometheus_retention" {
  type    = string
  default = "15d"
}

variable "prometheus_storage_size" {
  type    = string
  default = "50Gi"
}

variable "alertmanager_storage_size" {
  type    = string
  default = "10Gi"
}

variable "grafana_enabled" {
  type    = bool
  default = true
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_storage_size" {
  type    = string
  default = "10Gi"
}

variable "loki_enabled" {
  type    = bool
  default = false
}

variable "loki_storage_size" {
  type    = string
  default = "50Gi"
}

variable "otel_enabled" {
  type    = bool
  default = false
}

variable "ingress_enabled" {
  type    = bool
  default = false
}

variable "ingress_class" {
  description = "Ingress class override (defaults to alb)"
  type        = string
  default     = "alb"
}

variable "grafana_ingress_host" {
  type    = string
  default = ""
}

variable "alertmanager_slack_webhook" {
  type      = string
  sensitive = true
  default   = ""
}

variable "alertmanager_pagerduty_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ithildin_rules" {
  type    = string
  default = ""
}
