# 🎯 GitOps

> Git como única fonte de verdade para infraestrutura e aplicações. Tudo que muda, muda via Git.

---

## 📚 O que é GitOps?

**GitOps** é um modelo operacional onde Git é a fonte única de verdade para infraestrutura e aplicações. Mudanças são feitas via pull request, revisadas e aplicadas automaticamente.

### Por que é importante?

- **Auditoria** — toda mudança fica registrada no Git
- **Rollback** — reverter é só um `git revert`
- **Revisão** — pull requests garantem quality
- **Automação** — ArgoCD/Flux aplicam mudanças automaticamente
- **Consistência** — sempre igual ao que está no Git

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-gitops.md](01-fundamentos-gitops.md) | O que é, fluxo, benefícios vs CI/CD tradicional | 30 min |
| 2 | [02-argocd-basico.md](02-argocd-basico.md) | Instalação, Apps, Sync, Health | 50 min |
| 3 | [03-argocd-avancado.md](03-argocd-avancado.md) | Projects, SSO, RBAC, Rollbacks | 45 min |
| 4 | [04-flux-basico.md](04-flux-basico.md) | Kustomize, Helm, Reconcilation | 45 min |
| 5 | [05-gitops-patterns.md](05-gitops-patterns.md) | Multi-cluster, secrets, progressive delivery | 40 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Entender o fluxo GitOps vs CI/CD tradicional
- [ ] Instalar e configurar ArgoCD
- [ ] Criar aplicações GitOps com ArgoCD
- [ ] Usar Flux para reconciliação contínua
- [ ] Implementar rollback automático

---

## 🗺️ Fluxo GitOps

```
Desenvolvedor
     │
     ↓
Git Push (mudança no manifesto)
     │
     ↓
ArgoCD/Flux detecta mudança
     │
     ↓
Sincroniza com cluster Kubernetes
     │
     ↓
Aplicação atualizada automaticamente
```

---

<div align="center">

**⬅️ [Voltar ao DevOps](../devops/)** | **[Próximo: Service Mesh ➡️](../service-mesh/)**

</div>
