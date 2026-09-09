# 📈 SRE (Site Reliability Engineering)

> Confiabilidade como código. SLIs, SLOs, error budgets — medir e melhorar a confiabilidade dos sistemas.

---

## 📚 O que é SRE?

**SRE** é uma abordagem de engenharia para operações de TI que usa software para gerenciar sistemas, resolver problemas e automatizar tarefas. Criado pelo Google.

### Por que é importante?

- **Confiabilidade** — sistemas disponíveis 99.99%
- **Métricas** — medir o que importa (SLIs, SLOs)
- **Error Budgets** — equilibrar inovação vs estabilidade
- **Incidentes** — processos estruturados de resposta
- **Automatização** — eliminar trabalho manual

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-sre.md](01-fundamentos-sre.md) | O que é SRE, cultura, práticas | 30 min |
| 2 | [02-slis-slos.md](02-slis-slos.md) | SLIs, SLOs, SLAs, error budgets | 40 min |
| 3 | [03-incident-response.md](03-incident-response.md) | Processo de incidentes, post-mortems | 45 min |
| 4 | [04-toil-automacao.md](04-toil-automacao.md) | Identificar toil, automatizar tarefas | 35 min |
| 5 | [05-capacity-planning.md](05-capacity-planning.md) | Planejamento de capacidade, escalabilidade | 40 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Definir SLIs e SLOs para sistemas
- [ ] Calcular error budgets
- [ ] Criar processos de incident response
- [ ] Identificar e automatizar toil
- [ ] Fazer capacity planning

---

## 📊 Métricas Essenciais

```
SLI (Service Level Indicator)
├── Disponibilidade: 99.95%
├── Latência P99: < 200ms
└── Taxa de erro: < 0.1%

SLO (Service Level Objective)
├── Meta de disponibilidade
├── Meta de latência
└── Meta de erro

Error Budget
├── 100% - 99.95% = 0.05% de tolerância
├── = ~22 minutos de downtime por mês
└── Se gastar tudo → parar de entregar features
```

---

<div align="center">

**⬅️ [Voltar ao Platform Engineering](../platform-engineering/)** | **[Próximo: Chaos Engineering ➡️](../chaos-engineering/)**

</div>
