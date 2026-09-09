# 🌐 Service Mesh

> Comunicação entre microserviços de forma segura, observável e controlada. Istio, Linkerd — a camada invisível da rede.

---

## 📚 O que é Service Mesh?

**Service Mesh** é uma camada de infraestrutura que gerencia a comunicação entre microserviços. Oferece: mTLS, load balancing, circuit breaking, tracing — sem mudar o código da aplicação.

### Por que é importante?

- **Microserviços** — comunicação complexa entre dezenas de serviços
- **Segurança** — mTLS automático entre todos os serviços
- **Observabilidade** — ver tráfego entre serviços
- **Controle** — timeouts, retries, circuit breaking
- **Zero Trust** — cada conexão é autenticada e criptografada

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-mesh.md](01-fundamentos-mesh.md) | O que é, sidecar pattern, data plane vs control plane | 35 min |
| 2 | [02-istio-basico.md](02-istio-basico.md) | Instalação, injection, VirtualService, DestinationRule | 55 min |
| 3 | [03-istio-seguranca.md](03-istio-seguranca.md) | mTLS, AuthorizationPolicy, RequestAuthentication | 50 min |
| 4 | [04-linkerd.md](04-linkerd.md) | Alternativa leve ao Istio,profiles, circuits | 40 min |
| 5 | [05-observabilidade-mesh.md](05-observabilidade-mesh.md) | Jaeger, Kiali, tracing, métricas | 45 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Entender sidecar proxy pattern
- [ ] Instalar Istio em um cluster K8s
- [ ] Configurar mTLS entre serviços
- [ ] Criar regras de tráfego (canary, blue-green)
- [ ] Visualizar tráfego com Kiali

---

## 🗺️ Arquitetura

```
┌─────────────────────────────────────────────┐
│              SERVICE MESH                     │
│                                              │
│  ┌─────────┐    ┌─────────┐                │
│  │ Service │←──→│ Service │                │
│  │    A    │    │    B    │                │
│  └────┬────┘    └────┬────┘                │
│       │              │                      │
│  ┌────┴────┐    ┌────┴────┐                │
│  │  Proxy  │←──→│  Proxy  │  ← Data Plane │
│  │ (Envoy) │    │ (Envoy) │                │
│  └─────────┘    └─────────┘                │
│                                              │
│  ┌─────────────────────────────────────┐    │
│  │      Control Plane (Istiod)         │    │
│  │  Configura proxies, gerencia mTLS   │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

---

<div align="center">

**⬅️ [Voltar ao GitOps](../gitops/)** | **[Próximo: Secrets Management ➡️](../secrets-management/)**

</div>
