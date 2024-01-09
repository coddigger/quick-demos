terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.64.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">2.3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">2.1.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">2.1.2"
    }
  }
}
    

provider "azurerm" {
  features {}
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

resource "random_string" "password" {
  length      = 10
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

