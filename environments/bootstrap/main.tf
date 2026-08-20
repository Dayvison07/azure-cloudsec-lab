terraform {
    required_version = ">= 1.8.0"
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.90"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.5"
      }
    }
}

provider "azurerm" {
    features {}
}

terraform {
  required_version = ">= 1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "state_rg" {
  name     = "rg-terraform-state"
  location = "eastus2"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Storage Account Endurecida (Criptografia, TLS 1.2, Sem Acesso Público)
resource "azurerm_storage_account" "state_sa" {
  # checkov:skip=CKV_AZURE_59: "Public access is required for GitHub-hosted runners to reach backend via OIDC authentication."
  # checkov:skip=CKV_AZURE_33: "Queue service is not used for Terraform state storage."
  # checkov:skip=CKV2_AZURE_33: "Private endpoint cannot be reached by public GitHub Actions runners without a self-hosted runner."
  # checkov:skip=CKV2_AZURE_1: "Microsoft-managed keys (MMK) are used to prevent circular state dependencies during bootstrap."

  name                     = "tfstatedaysec${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.state_rg.name
  location                 = azurerm_resource_group.state_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS" 
  min_tls_version          = "TLS1_2"

  shared_access_key_enabled       = false 
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  sas_policy {
    expiration_period = "01.00:00:00"
    expiration_action = "Log"
  }

  tags = {
    Environment = "Management"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state_sa.name
  container_access_type = "private"
}

# Concede permissão de Leitura/Escrita no Blob para o Service Principal do GitHub Actions
resource "azurerm_role_assignment" "github_blob_contributor" {
  scope                = azurerm_storage_account.state_sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = "0e90f1b7-a0cb-4ac8-8328-5a8f4ff89be4" # Seu App/SP ID
}

output "storage_account_name" {
  value       = azurerm_storage_account.state_sa.name
  description = "Copie este nome para colar no backend do environments/dev/providers.tf"
}