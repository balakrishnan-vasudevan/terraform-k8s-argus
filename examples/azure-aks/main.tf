variable "resource_group_name" { type = string }
variable "cluster_name"        { type = string }
variable "keyvault_name"       { type = string }

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  }
}

# Fetch the Grafana password from Azure Key Vault.
# Store it with:
#   az keyvault secret set --vault-name <keyvault> --name grafana-admin-password --value "yourpassword"
data "azurerm_key_vault" "this" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "grafana" {
  name         = "grafana-admin-password"
  key_vault_id = data.azurerm_key_vault.this.id
}

module "argus" {
  source = "../../azure"

  grafana_admin_password = data.azurerm_key_vault_secret.grafana.value

  # Optional: Managed Identity for Prometheus
  # managed_identity_client_id = var.prometheus_managed_identity_client_id

  # Optional: wire in Ithildin-generated SLO rules
  # ithildin_rules = file("${path.module}/slo-rules.yaml")
}

output "grafana_service"     { value = module.argus.grafana_service }
output "prometheus_endpoint" { value = module.argus.prometheus_endpoint }
