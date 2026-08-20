variable "location" {
  type        = string
  description = "Target Azure region for all deployed resources."
  # Standardized to lowercase canonical name to ensure consistent API evaluation
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "Deployment target environment name (e.g., dev, staging, prod)."
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project prefix identifier used for resource naming and tagging conventions."
  # Shortened identifier to guarantee Azure Key Vault 24-character naming limit compliance
  default     = "zt-found"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "CIDR address block allocated for the Virtual Network."
  default     = ["10.0.0.0/16"]
}

variable "frontend_subnet_prefix" {
  type        = list(string)
  description = "CIDR block allocated for the frontend subnet tier."
  default     = ["10.0.1.0/24"]
}

variable "endpoints_subnet_prefix" {
  type        = list(string)
  description = "CIDR block allocated for the Private Endpoints subnet tier."
  default     = ["10.0.2.0/24"]
}