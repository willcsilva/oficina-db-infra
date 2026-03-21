# FIAP - Post Tech: Software Architecture (SOAT)
## Projeto Oficina Mecânica - Fase 3 (SOAT/FIAP)

**Autor:** William Crispin da Silva  
**Contato:** [willcsilva15@gmail.com] | Discord: `@Crispin - RM369067` | `will1515` 
**Grupo:** Grupo 40

---

# Oficina Mecânica - Infraestrutura de Banco de Dados (RDS)

[cite_start]Este repositório é responsável pelo provisionamento e gerenciamento do banco de dados relacional da solução, utilizando Infraestrutura como Código (IaC) com Terraform[cite: 30, 42].

## 📋 Propósito
[cite_start]Garantir a persistência de dados de forma segura, escalável e resiliente, utilizando um serviço gerenciado (Amazon RDS) para suportar a operação corporativa da oficina[cite: 7, 14, 40].

## 🛠️ Tecnologias Utilizadas
* [cite_start]**Terraform**: Provisionamento da infraestrutura[cite: 42].
* [cite_start]**AWS RDS (PostgreSQL)**: Banco de dados relacional gerenciado[cite: 40].
* **S3 (Remote State)**: Armazenamento do estado do Terraform para colaboração.
* [cite_start]**GitHub Actions**: Pipeline de CI/CD para deploy automatizado[cite: 27].

## 📐 Arquitetura do Componente
[cite_start]O banco de dados é implantado em subnets privadas, garantindo que não haja acesso direto pela internet, apenas pela aplicação autorizada dentro do cluster EKS[cite: 16].

```mermaid
graph LR
    subgraph AWS_Cloud [AWS Cloud]
        subgraph Private_Subnet [Private Subnet]
            RDS[(RDS PostgreSQL)]
        end
    end
    App[Aplicação EKS] -->|Conexão Porta 5432| RDS
    
