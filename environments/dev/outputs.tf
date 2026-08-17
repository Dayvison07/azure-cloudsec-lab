output "resource_group_name" {
  description = "Name of the provisioned Azure Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "Unique Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "frontend_subnet_id" {
  description = "Unique Resource ID of the frontend subnet."
  value       = azurerm_subnet.frontend.id
}

output "nsg_id" {
  description = "Unique Resource ID of the Network Security Group."
  value       = azurerm_network_security_group.nsg.id
}

output "key_vault_id" {
  description = "Unique Resource ID of the Key Vault instance."
  value       = azurerm_key_vault.kv.id
}

output "log_analytics_workspace_id" {
  description = "Unique Resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.id
}