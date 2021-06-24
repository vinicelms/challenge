# Logs

Estrutura do projeto para construir as configurações de agragações de logs.

## Requisitos

- Antes de iniciar o processo, é necessário criar o namespace *logs*. Para isto, execute:
```shell
kubectl apply -f logs-ns.yaml
```

- Adicionando repositório Helm da Elastic
```shell
helm repo add elastic https://helm.elastic.co
helm repo update
```

- Adicionando repositório Helm da Fluent
```shell
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
```

## Provisionamento dos recursos

- Instale o Helm do Elasticsearch no cluster
```shell
helm install elasticsearch elastic/elasticsearch --namespace=logs --values elastic/elastic_values.yml
```

- Instale o Kibana no cluster
```shell
kubectl apply -f elastic/kibana-deployment.yml
kubectl apply -f elastic/kibana-svc.yml
```

- Instale o Fluent-bit no cluster
```shell
helm install fluent-bit fluent/fluent-bit --namespace=logs --values fluent-bit/fluent-bit_values.yml
```