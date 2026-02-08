# Caminho: outputs.tf

output "rds_resource_id" {
  description = "O ID do recurso RDS para políticas de IAM"
  value       = aws_db_instance.oficina_db.resource_id
}

output "db_name" {
  description = "O nome do banco de dados"
  value       = aws_db_instance.oficina_db.db_name
}

# ESSENCIAL: O endereço DNS do banco para a aplicação conectar
output "rds_hostname" {
  description = "O hostname do banco de dados (sem a porta)"
  value       = split(":", aws_db_instance.oficina_db.endpoint)[0]
}

# O ID do Security Group do RDS para referências futuras
output "rds_security_group_id" {
  description = "O ID do Security Group vinculado ao RDS"
  value       = aws_security_group.rds_sg.id
}