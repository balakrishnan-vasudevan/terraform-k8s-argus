variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
}

variable "storage_class" {
  description = "Storage class for persistent volumes"
  type        = string
}

variable "retention" {
  description = "Prometheus data retention period"
  type        = string
  default     = "15d"
}

variable "prometheus_storage_size" {
  description = "Persistent volume size for Prometheus"
  type        = string
  default     = "50Gi"
}

variable "alertmanager_storage_size" {
  description = "Persistent volume size for Alertmanager"
  type        = string
  default     = "10Gi"
}

variable "grafana_enabled" {
  description = "Deploy Grafana"
  type        = bool
  default     = true
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "grafana_storage_size" {
  description = "Persistent volume size for Grafana"
  type        = string
  default     = "10Gi"
}

variable "ingress_enabled" {
  description = "Enable ingress for Grafana"
  type        = bool
  default     = false
}

variable "ingress_class" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "grafana_ingress_host" {
  description = "Hostname for Grafana ingress"
  type        = string
  default     = ""
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for alerts"
  type        = string
  sensitive   = true
  default     = ""
}

variable "pagerduty_key" {
  description = "PagerDuty routing key for alerts"
  type        = string
  sensitive   = true
  default     = ""
}

variable "service_account_annotations" {
  description = "Annotations for the Prometheus service account"
  type        = map(string)
  default     = {}
}

variable "ithildin_rules" {
  description = "Prometheus rules YAML from Ithildin"
  type        = string
  default     = ""
}
