output "rds_resource_id" {
  description = "O ID do recurso RDS para políticas de IAM"
  value       = aws_db_instance.oficina_db.resource_id
}

output "db_name" {
  value = aws_db_instance.oficina_db.db_name
}
