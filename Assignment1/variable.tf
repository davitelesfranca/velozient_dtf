variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "az-tf-test"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "terraform-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_names" {
  description = "Names of the subnets"
  type        = list(string)
  default     = ["web-subnet", "app-subnet", "db-subnet"]
}

variable "subnet_prefixes" {
  description = "Prefixes for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vm_size" {
  description = "Size of the Virtual Machines"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
}

variable "sql_admin_username" {
  description = "Admin username for the Azure SQL Database"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Admin password for the Azure SQL Database"
  type        = string
}
