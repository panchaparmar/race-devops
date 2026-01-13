variable "location" {
  default = "West US 2"
}

variable "resource_group_name" {
  default = "RevaDevOps"
}

variable "vnet_name" {
  default = "revadevops_VNet"
}

variable "vnet_cidr" {
  default = "30.0.0.0/16"
}

variable "subnet_name" {
  default = "Subnet-1"
}

variable "subnet_cidr" {
  default = "30.0.0.0/24"
}

variable "aks_name" {
  default = "racedevops_aks"
}

variable "acr_name" {
  default = "racedevopsacr"
}
