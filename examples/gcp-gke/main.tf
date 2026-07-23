variable "gcp_project"   { type = string }
variable "gcp_region"    { type = string }
variable "cluster_name"  { type = string }

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

data "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.gcp_region
}

data "google_client_config" "this" {}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.this.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.this.access_token
  }
}

# Fetch the Grafana password from GCP Secret Manager.
# Store it with:
#   gcloud secrets create grafana-admin-password --data-file=<(echo -n "yourpassword")
data "google_secret_manager_secret_version" "grafana" {
  secret = "grafana-admin-password"
}

module "argus" {
  source = "../../gcp"

  grafana_admin_password = data.google_secret_manager_secret_version.grafana.secret_data

  # Optional: Workload Identity for Prometheus
  # workload_identity_sa = var.prometheus_workload_identity_sa

  # Optional: wire in Ithildin-generated SLO rules
  # ithildin_rules = file("${path.module}/slo-rules.yaml")
}

output "grafana_service"     { value = module.argus.grafana_service }
output "prometheus_endpoint" { value = module.argus.prometheus_endpoint }
