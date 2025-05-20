output "data_factory_id" {
  value       = azurerm_data_factory.adf.id
  description = "The ID of the Azure Data Factory"
}

output "data_factory_principal_id" {
  value       = azurerm_data_factory.adf.identity[0].principal_id
  description = "The Principal ID of the Data Factory's Managed Identity"
}

output "data_factory_name" {
  value       = azurerm_data_factory.adf.name
  description = "The name of the Azure Data Factory"
}