# Terraform

Esta estrutura do projeto vai conter os arquivos do Terraform, com a responsabilidade de criar e manter as configurações de VPC, Subnet, Route Tables e também o cluster EKS.

Toda a criação de recursos está sendo direcionada para a região `us-east-2` (Ohio).

## Network

É criada uma VPC com 6 subnets simples, ficando divididas em 3 subnets privadas (application_subnet_a-b-c) e 3 públicas (public_subnet_a-b-c). As redes já foram dimensionadas de forma simples para suportar um número alto nodes no cluster.

### VPC
- CIDR: 12.0.0.0/16
- Hosts: 65534

### Application Subnets
|Zone|CIDR|Hosts|Name|
|---|---|---|---|
|A|12.0.8.0/21|2046|application_subnet_challenge_a|
|B|12.0.16.0/21|2046|application_subnet_challenge_b|
|C|12.0.24.0/21|2046|application_subnet_challenge_c|


### Public Subnets
|Zone|CIDR|Hosts|Name|
|---|---|---|---|
|A|12.0.32.0/24|254|public_subnet_challenge_a|
|B|12.0.33.0/24|254|public_subnet_challenge_b|
|C|12.0.34.0/24|254|public_subnet_challenge_c|

### Como criar a estrutura de rede
- Navegue até o diretório `network` e então execute:
```shell
terraform init
terraform plan
terraform apply
```


## K8s
Cria um cluster EKS utilizando uma configuração básica com apenas 1 node, diante da dimensão atual de aplicações.

Em conjunto, também são criadas Roles IAM para permitir a conexão aos recursos, identificados no arquivo: [iam-role.tf](k8s/iam-role.tf)

### Como criar o cluster EKS
- Navegue até o diretório `k8s` e então execute:
```shell
terraform init
terraform plan
terraform apply
```

### Como obter conexão ao cluster
> Requisitos:
> AWS-Cli instalado e configurado adequadamente

- Execute o comando:
```shell
aws eks --region us-east-2 update-kubeconfig --name eks_challenge
```