variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
}

variable "storage_class" {
  description = "Storage class for persistent volumes"
  type        = string
}

variable "storage_size" {
  description = "Persistent volume size for Loki"
  type        = string
  default     = "50Gi"
}

variable "retention_hours" {
  description = "Log retention period in hours"
  type        = number
  default     = 720
}
