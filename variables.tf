variable "region" { default = "us-east-2" }
variable "project_name" {}
variable "environment" {}
variable "managed_by" {}
variable "db_password" { sensitive = true }
variable "db_username" {}
variable "db_name" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_allocated_storage" {}
variable "db_port" {
  type    = number
  default = 5432
}