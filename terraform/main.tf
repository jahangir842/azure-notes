terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.29.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "xxxxx"
  client_id       = "xxxxx"
  client_secret   = "xxxxx"
  tenant_id       = "xxxxx"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}