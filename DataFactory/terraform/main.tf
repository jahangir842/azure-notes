resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_data_factory" "adf" {
  name                = var.data_factory_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags               = var.tags

  identity {
    type = "SystemAssigned"
  }

  dynamic "github_configuration" {
    for_each = var.github_account_name != "" ? [1] : []
    content {
      account_name    = var.github_account_name
      branch_name     = var.github_branch_name
      git_url        = var.github_url
      repository_name = var.github_repository_name
      root_folder    = var.github_root_folder
    }
  }
}