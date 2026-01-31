output "rds_resource_id" {
  description = "O ID do recurso RDS para políticas de IAM"
  value       = aws_db_instance.oficina_db.resource_id
}

output "db_name" {
  value = aws_db_instance.oficina_db.db_name
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados para a string de conexão"
  value       = module.rds.db_instance_endpoint
}

output "rds_hostname" {
  value = split(":", aws_db_instance.oficina_db.endpoint)[0]
}