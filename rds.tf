# 2. Grupo de Subnets do RDS
resource "aws_db_subnet_group" "oficina_db_sng" {
  name       = "oficina-db-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = {
    Name = "Oficina DB Subnet Group"
  }
}

# 3. Security Group para o RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-oficina"
  description = "Permite acesso de dentro da VPC ao Postgres"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # Permite tráfego de toda a CIDR da VPC (Garante que o EKS consiga conectar)
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
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

# --- OUTPUTS PARA A ESTEIRA ----
output "rds_endpoint" {
  value = aws_db_instance.oficina_db.endpoint
}

output "rds_hostname" {
  value = split(":", aws_db_instance.oficina_db.endpoint)[0]
}
