# 2. Usa os IDs dinâmicos nos recursos
resource "aws_db_subnet_group" "oficina_db_sng" {
  name_prefix       = "oficina-db-sng-"
  # Aqui ele pega a lista de subnets que apareceu no seu log!
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-oficina"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # Permite apenas tráfego vindo de dentro da sua VPC (segurança!)
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Instância RDS PostgreSQL
resource "aws_db_instance" "oficina_db" {
  identifier        = "db-oficina-api-13-soat"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "db_oficina"
  username          = "postgres"
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.oficina_db_sng.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  auto_minor_version_upgrade = true
  skip_final_snapshot        = true
  publicly_accessible        = false
  multi_az                   = false

  tags = {
    Project = "Oficina-api-13-soat"
  }
}

# output "rds_endpoint" {
#   description = "Endpoint do banco de dados para a string de conexão"
#   value       = module.rds.db_instance_endpoint
# }

output "rds_hostname" {
  value = split(":", aws_db_instance.oficina_db.endpoint)[0]
}
