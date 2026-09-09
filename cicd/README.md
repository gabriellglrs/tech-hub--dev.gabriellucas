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

## 📁 Estrutura

```
cicd/
├── 01-fundamentos/       # Conceitos de CI/CD
├── 02-github-actions/    # GitHub Actions
├── 03-jenkins/           # Jenkins
├── 04-seguranca/         # Segurança em pipelines
└── 05-containers/        # Container scanning
```

## 📚 Trilha de Estudo

| # | Módulo | O que você vai aprender |
|:--|:-------|:------------------------|
| 1 | [01-fundamentos](01-fundamentos/) | O que é CI/CD, fluxo, benefícios |
| 2 | [02-github-actions](02-github-actions/) | Workflows, secrets, matrix |
| 3 | [03-jenkins](03-jenkins/) | Pipeline, stages, plugins |
| 4 | [04-seguranca](04-seguranca/) | SAST, DAST, secrets scanning |
| 5 | [05-containers](05-containers/) | Trivy, Snyk, image signing |

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