# 🔐 Secrets Management

> Senhas, tokens, chaves API — nada pode ficar hardcoded. Vault, Sealed Secrets, External Secrets.

---

## 📚 O que é Secrets Management?

**Secrets Management** é gerenciar dados sensíveis (senhas, chaves API, certificados) de forma segura. Em vez de hardcodar no código ou no Git, você usa ferramentas especializadas.

### Por que é importante?

- **Git scanning** — GitHub detecta secrets expostos
- **Kubernetes** — Secrets precisam ser gerenciados
- **Vault** — padrão da indústria para secrets
- **Compliance** — regulamentações exigem gestão de chaves
- **Zero Trust** — nenhum segredo em texto claro

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-secrets.md](01-fundamentos-secrets.md) | Tipos de secrets, risco, best practices | 30 min |
| 2 | [02-hashicorp-vault.md](02-hashicorp-vault.md) | Engine, secrets engine, policies, auth | 55 min |
| 3 | [03-sealed-secrets.md](03-sealed-secrets.md) | Bitnami Sealed Secrets para K8s | 40 min |
| 4 | [04-external-secrets.md](04-external-secrets.md) | External Secrets Operator, AWS/Azure/GCP | 45 min |
| 5 | [05-secrets-k8s.md](05-secrets-k8s.md) | K8s Secrets, encrypted etcd, RBAC | 40 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Identificar secrets em código (truffleHog, gitleaks)
- [ ] Instalar e configurar HashiCorp Vault
- [ ] Usar Sealed Secrets no Kubernetes
- [ ] Integrar Vault com K8s
- [ ] Criar políticas de acesso a secrets

---

<div align="center">

**⬅️ [Voltar ao Service Mesh](../service-mesh/)** | **[Próximo: Platform Engineering ➡️](../platform-engineering/)**

</div>
