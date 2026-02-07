# Caminho: rds.tf

# 1. Busca os dados do cluster EKS para obter o SG ID dinamicamente
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-willow"
    key    = "state/eks/terraform.tfstate"
    region = "us-east-2"
  }
}

# NOTA: O bloco data "terraform_remote_state" "network" deve ficar APENAS no main.tf
# para evitar o erro de "Duplicate data" que você recebeu.

# 2. Grupo de Subnets para o banco
resource "aws_db_subnet_group" "oficina_db_sng" {
  name_prefix = "oficina-db-sng-"
  # Referenciando o data source que está declarado no seu main.tf
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnets
}

# 3. Security Group do RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg-oficina"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  # Regra para o range da VPC (Backup de segurança)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }

  # Regra Dinâmica: Permite acesso de ambos os SGs do EKS
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # Agora passamos os dois IDs como uma lista
    security_groups = [
      data.terraform_remote_state.eks.outputs.cluster_primary_security_group_id,
      data.terraform_remote_state.eks.outputs.node_security_group_id
    ]
    description = "Acesso do Control Plane e dos Nodes do EKS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-oficina"
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

output "rds_hostname" {
  value = split(":", aws_db_instance.oficina_db.endpoint)[0]
}