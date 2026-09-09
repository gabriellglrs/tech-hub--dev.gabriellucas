# 🚀 CI/CD (Integração e Entrega Contínua)

> CI/CD automatiza testes, builds e deploys. Toda empresa usa — e toda pipeline pode ter falhas de segurança.

---

## 📚 O que é CI/CD?

**CI (Integração Contínua)** = automatizar testes a cada commit
**CD (Entrega Contínua)** = automatizar deploy a cada merge

```
Código → Commit → Testes → Build → Deploy → Produção
         CI                        CD
```

### Por que é importante?

- **DevSecOps** — segurança integrada ao pipeline
- **Secrets em pipelines** — vulnerabilidade comum
- **Dependabot** — dependências desatualizadas
- **Pipeline poisoning** — ataques à infraestrutura
- **Container scanning** — imagens com vulnerabilidades

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-cicd.md](01-fundamentos-cicd.md) | O que é CI/CD, fluxo, benefícios | 30 min |
| 2 | [02-github-actions.md](02-github-actions.md) | Workflows, secrets, matrix, reusable | 50 min |
| 3 | [03-jenkins-basico.md](03-jenkins-basico.md) | Pipeline, stages, agents, plugins | 45 min |
| 4 | [04-seguranca-cicd.md](04-seguranca-cicd.md) | SAST, DAST, secrets scanning, SCA | 40 min |
| 5 | [05-container-scanning.md](05-container-scanning.md) | Trivy, Snyk, Clair, image signing | 35 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Criar pipelines com GitHub Actions
- [ ] Integrar segurança nos pipelines (DevSecOps)
- [ ] Escanear imagens Docker automaticamente
- [ ] Gerenciar secrets de forma segura
- [ ] Configurar Jenkins básico

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)**

</div>