# 🐳 Docker e Kubernetes

> Containers e orquestração são a base de DevOps, microserviços e cloud moderno. Docker para empacotar, Kubernetes para gerenciar em escala.

---

## 📚 O que é Docker e Kubernetes?

**Docker** empacota aplicações em **containers** — unidades leves, portáveis e isoladas. **Kubernetes (K8s)** é o orquestrador que gerencia milhares de containers em produção: auto-scaling, load balancing, self-healing, rolling updates.

### Por que é importante?

- **DevOps** — containers são a base
- **Cloud** — AWS EKS, Azure AKS, Google GKE
- **Microserviços** — arquitetura moderna
- **CI/CD** — pipelines usam containers
- **Segurança** — containers e K8s podem ter vulnerabilidades
- **Escalabilidade** — K8s gerencia escala automaticamente

---

## 📁 Trilha de Estudo

### 🐳 Parte 1: Docker

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-docker.md](01-fundamentos-docker.md) | O que é container, imagem, registry | 35 min |
| 2 | [02-dockerfile.md](02-dockerfile.md) | Criar imagens, multi-stage, boas práticas | 45 min |
| 3 | [03-docker-compose.md](03-docker-compose.md) | Multi-container, redes, volumes | 50 min |
| 4 | [04-docker-networking.md](04-docker-networking.md) | Bridge, host, overlay, port mapping | 40 min |
| 5 | [05-docker-seguranca.md](05-docker-seguranca.md) | Rootless, secrets, scanning, namespaces | 45 min |

### ☸️ Parte 2: Kubernetes

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 6 | [06-k8s-fundamentos.md](06-k8s-fundamentos.md) | Pods, Services, Deployments, Namespaces | 50 min |
| 7 | [07-k8s-manifests.md](07-k8s-manifests.md) | YAML, ConfigMaps, Secrets, Ingress | 45 min |
| 8 | [08-k8s-networking.md](08-k8s-networking.md) | Services (ClusterIP, NodePort, LoadBalancer) | 40 min |
| 9 | [09-k8s-storage.md](09-k8s-storage.md) | Volumes, PersistentVolumes, StatefulSets | 40 min |
| 10 | [10-k8s-seguranca.md](10-k8s-seguranca.md) | RBAC, NetworkPolicies, PodSecurity, scanning | 50 min |
| 11 | [11-k8s-monitoramento.md](11-k8s-monitoramento.md) | Metrics Server, Prometheus, Grafana no K8s | 45 min |
| 12 | [12-k8s-helm.md](12-k8s-helm.md) | Helm charts, repositórios, customização | 35 min |

---

## 🎯 O que você vai conseguir fazer

### Docker
- [ ] Criar containers e imagens Docker
- [ ] Escrever Dockerfiles eficientes
- [ ] Usar Docker Compose para multi-container
- [ ] Configurar redes e volumes
- [ ] Escanear imagens para vulnerabilidades

### Kubernetes
- [ ] Criar e gerenciar Pods e Deployments
- [ ] Escrever manifests YAML para K8s
- [ ] Configurar Services e Ingress
- [ ] Gerenciar storage com PersistentVolumes
- [ ] Implementar RBAC e NetworkPolicies
- [ ] Instalar apps com Helm charts
- [ ] Monitorar clusters com Prometheus/Grafana

---

## 🗺️ Visualização

```
DOCKER (empacotar)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dockerfile → Build → Imagem → Container

KUBERNETES (orquestrar)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Cluster
├── Node 1
│   ├── Pod A (Container)
│   └── Pod B (Container)
├── Node 2
│   ├── Pod C (Container)
│   └── Pod D (Container)
└── Load Balancer → Distribui tráfego
```

---

## 🔗 Recursos

- [Docker Docs](https://docs.docker.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Play with Docker](https://labs.play-with-docker.com/) — Docker grátis no browser
- [KillerCoda K8s](https://killercoda.com/playgrounds/scenario/kubernetes) — K8s grátis no browser
- [TryHackMe: Docker](https://tryhackme.com/room/dockerforpentester)
- [TryHackMe: Kubernetes](https://tryhackme.com/room/introtonetworking)

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)**

</div>
