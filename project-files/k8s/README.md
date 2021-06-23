# K8s

Esta estrutura do projeto conterá os arquivos responsáveis por criar o provisionamento da aplicação, como *Namespace*, *ConfigMap*, *Deployment*, *Service* e *Ingress*.

## Criando os recursos no cluster Kubernetes:
- Execute:
```shell
kubectl apply -f ns.yaml
kubectl apply -f simpleapp-cm.yaml
kubectl apply -f simpleapp.yaml
kubectl apply -f simpleapp-svc.yaml
kubectl apply -f challenge-ingress.yaml
```

> Este processo tem como pré-requisito que o binário do `kubectl` está instalado e com comunicação pré-estabelecida com o cluster Kubernetes.
> - - -
> Caso não compreenda como configurar o uso do `kubectl`, veja a seção [Como obter conexão ao cluster](../terraform/README.md)