# List EC2

Estrutura com script para listar instâncias da AWS.

## Requisitos

Este script utiliza uma biblioteca para gerar tabelas mais visuais e diante disso, necessita da biblioteca `prettytable`.

- Instale a dependência (com .venv)
```shell
python3 -m venv .venv
source .venv/bin/activate
pip3 install prettytable
```

## Executando o script

O script utiliza a biblioteca `argparse`, para receber parâmetros, facilitando algumas customizações básicas.

- Para visualizar todas as opções, execute:
```shell
python3 list-ec2.py --help

----------------- SAÍDA DO COMANDO ACIMA -----------------

usage: list-ec2.py [-h] --region REGION [--state STATES [STATES ...]] [-as-json]

optional arguments:
  -h, --help            show this help message and exit
  --region REGION       Informe a região que desta listar as instâncias. Exemplo: us-east-1
  --state STATES [STATES ...]
                        Informe o estado desejado das instâncias. Valores possíveis: pending, running, shutting-down, terminated, stopping, stopped
  -as-json              Caso deseje a saída como JSON, utilize esta flag
```