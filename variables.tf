variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "project_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type = string
}

variable "managed_by" {
  type = string
}
