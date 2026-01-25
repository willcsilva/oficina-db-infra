# Este bloco lê as saídas (outputs) do seu repositório de rede
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-willow"
    key    = "state/eks/vpc/tf-state" # Certifique-se que este é o caminho do repo oficina-k8s-infra 
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}
