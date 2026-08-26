variable "subscription_id" {
  description = "Azure subscription ID for the target environment"
  type        = string
}

variable "location" {
  description = "Azure region for the deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, test, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used in naming resources"
  type        = string
  default     = "cyber-platform"
}

variable "tags" {
  description = "Tags to apply to Azure resources"
  type        = map(string)
  default = {
    managedBy = "terraform"
    owner     = "security-platform"
    platform  = "cyber-pentest"
  }
}

variable "container_image" {
  description = "Container image for the application workload"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "database_admin_login" {
  description = "Database admin login for the PostgreSQL instance"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "database_admin_password" {
  description = "Database admin password for the PostgreSQL instance"
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}
