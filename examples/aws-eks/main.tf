variable "aws_region"    { type = string }
variable "cluster_name"  { type = string }

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Fetch secrets from AWS Secrets Manager.
# Store them with:
#   aws secretsmanager create-secret --name "observability/grafana-admin-password" --secret-string "yourpassword"
#   aws secretsmanager create-secret --name "observability/slack-webhook-url" --secret-string "https://hooks.slack.com/..."
data "aws_secretsmanager_secret_version" "grafana" {
  secret_id = "observability/grafana-admin-password"
}

data "aws_secretsmanager_secret_version" "slack" {
  secret_id = "observability/slack-webhook-url"
}

module "argus" {
  source = "../../aws"

  grafana_admin_password     = data.aws_secretsmanager_secret_version.grafana.secret_string
  alertmanager_slack_webhook = data.aws_secretsmanager_secret_version.slack.secret_string

  # Optional: enable Loki and OTel
  loki_enabled = true
  otel_enabled = true

  # Optional: IRSA role for Prometheus to access AWS services
  # irsa_role_arn = var.prometheus_irsa_role_arn

  # Optional: wire in Ithildin-generated SLO rules
  # ithildin_rules = file("${path.module}/slo-rules.yaml")
}

output "grafana_service"     { value = module.argus.grafana_service }
output "prometheus_endpoint" { value = module.argus.prometheus_endpoint }
