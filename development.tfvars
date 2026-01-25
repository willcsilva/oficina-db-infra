# --- Configurações do Banco de Dados ---
db_name              = "oficina_db"
db_username          = "dbadmin"
db_port              = 5432
db_engine            = "postgres"
db_engine_version    = "16.3"
db_instance_class    = "db.t3.micro" # Camada gratuita (Free Tier)
db_allocated_storage = 20

# --- Tags e Governança --- 
project_name = "oficina-soat-fase3"
environment  = "Producao"
managed_by   = "Terraform"
