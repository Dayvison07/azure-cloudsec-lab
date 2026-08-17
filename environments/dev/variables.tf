variable "location" {
  type        = string
  description = "Target Azure region for all deployed resources."
  default     = "East US"
}

variable "environment" {
  type        = string
  description = "Deployment target environment name (e.g., dev, staging, prod)."
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project prefix identifier used for resource naming and tagging conventions."
  default     = "ZeroTrustFoundation"
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