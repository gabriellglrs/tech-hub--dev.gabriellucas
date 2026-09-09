# 💥 Chaos Engineering

> Quebrar sistemas de propósito para descobrir vulnerabilidades antes que elas causem problemas reais.

---

## 📚 O que é Chaos Engineering?

**Chaos Engineering** é a prática de injetar falhas controladas em sistemas para descobrir pontos fracos antes que causem incidentes reais. Inspirado no Netflix Chaos Monkey.

### Por que é importante?

- **Resiliência** — sistemas que sobrevivem a falhas
- **Prevenção** — descobrir problemas antes dos usuários
- **Confiança** — saber que o sistema aguenta
- **Compliance** — testes de disaster recovery
- **Cultura** — aceitar que falhas acontecem

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-chaos.md](01-fundamentos-chaos.md) | Princípios, steampunk, Game Days | 30 min |
| 2 | [02-chaos-monkey.md](02-chaos-monkey.md) | Netflix, Simian Army, tipos de falhas | 40 min |
| 3 | [03-litmus-chaos.md](03-litmus-chaos.md) | Litmus no Kubernetes, experiments | 50 min |
| 4 | [04-chaos-mesh.md](04-chaos-mesh.md) | Chaos Mesh, fault injection, network chaos | 45 min |
| 5 | [05-game-days.md](05-game-days.md) | Planejar e executar Game Days | 35 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Entender os princípios de Chaos Engineering
- [ ] Executar experimentos com Litmus no K8s
- [ ] Injetar falhas de rede, CPU, disco
- [ ] Planejar e executar Game Days
- [ ] Medir resiliência do sistema

---

## 🗺️ Processo Chaos

```
1. Definir estado estável
   "O sistema funciona com 99.9% de disponibilidade"

2. Hipótese
   "Se um nó cair, o cluster continua funcionando"

3. Injetar falha
   "Desligar um nó aleatoriamente"

4. Observar
   "O sistema continua respondendo?"

5. Aprender
   "Encontramos um ponto único de falha!"
   → Corrigir e repetir
```

---

## ⚠️ Regras de Segurança

1. **Nunca injete falhas em produção** sem aprovação
2. **Comece em staging** antes de ir para prod
3. **Tenha um plano de rollback** sempre
4. **Notifique a equipe** antes de começar
5. **Limite o blast radius** (impacto máximo)

---

<div align="center">

**⬅️ [Voltar ao SRE](../sre/)** | **[Voltar ao DevOps](../devops/)**

</div>
