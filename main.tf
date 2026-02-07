# Este bloco lê as saídas (outputs) do seu repositório de rede
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "s3-bucket-willow"
    key    = "state/network/terraform.tfstate" # O caminho que você acabou de criar
    region = "us-east-2"
  }
}

terraform {
  backend "s3" {
    bucket = "s3-bucket-willow"           # O nome do seu bucket
    key    = "state/db/terraform.tfstate" # O caminho dentro do bucket
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}


