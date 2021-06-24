# Monitoring

Estrutura de projeto para manipular os arquivos de monitoria com Prometheus e Grafana.

## Requisitos

Antes de iniciar o processo, é necessário criar o namespace *monitoring*. Para isto, execute:
```shell
kubectl apply -f monitoring-ns.yaml
```

## Provisionando recursos

Durante este processo, será provisionado:
- Prometheus
- Kube State Metrics
- Grafana

---

- Execute:
```shell
helm install prometheus-stack prometheus-community/kube-prometheus-stack --namespace=monitoring
```