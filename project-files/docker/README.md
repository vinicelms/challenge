# Docker

Esta estrutura do projeto realiza o build de uma imagem Docker, sendo gerado uma artefato do projeto [SimpleApp](https://github.com/tempestsecurity/simpleapp-python).

## Build da imagem
- Execute (estando no diretório `docker`):
```shell
docker build -t simple-app-challenge .
```

## Publicação do artefato no DockerHub:
- Faça login no DockerHub:
```shell
docker login --username vinicelms
```

- Gere uma tag para o artefato gerado e faça o `push` do artefato:
```shell
docker tag simple-app-challenge:latest docker.io/vinicelms/devops-challenge:1
docker push docker.io/vinicelms/devops-challenge:1
```