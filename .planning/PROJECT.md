# Trilha de Aprendizado em Cybersegurança

## What This Is

Reestruturar e completar a trilha de aprendizado em cybersegurança (`aprendizado/cyberseguranca/`), transformando-a em um curso completo em Markdown que leva uma pessoa **leiga total** do zero ao nível avançado — com foco total em prática aplicada, não teoria solta. A pasta já existe com 12 módulos (00-11), mas precisa de auditoria, atualização e melhoria para atingir qualidade de curso profissional.

## Core Value

**Todo módulo deve deixar a pessoa apta a FAZER, não só a ter lido.** Para cada ferramenta ou técnica: comando de instalação + comando de uso completo (flags explicadas) + output esperado. Uma pessoa leiga tem que conseguir copiar e colar e chegar no resultado.

## Requirements

### Validated

- ✓ Auditar todos os 12 módulos (00-11) — v1.0 Fase 1
- ✓ Gerar tabela de auditoria com diagnóstico — v1.0 Fase 1
- ✓ Verificar orientação Kali no módulo 00 — v1.0 Fase 1 (parcial)
- ✓ Avaliar progressão didática e consistência — v1.0 Fase 1
- ✓ Gerar ordem de execução priorizada — v1.0 Fase 1

### Active

- [ ] Mapear salas/labs gratuitos por módulo (TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF)
- [ ] Validar ordem dos módulos contra certificações (OSCP, CEH, Security+) e trilhas de referência
- [ ] Substituir ferramentas obsoletas (MITMf, Armitage, theHarvester-only) por equivalentes atuais
- [ ] Validar instalação de ferramentas no Kali 2026
- [ ] Verificar links de plataformas estão funcionando
- [ ] Adicionar output esperado para cada comando
- [ ] Garantir bloco completo (instalação + uso + output) em toda ferramenta
- [ ] Verificar que LABS.md tem exercícios reais e verificáveis
- [ ] Decidir sobre ROADMAP.md (atualizar ou remover)
- [ ] Atualizar GLOSSARIO.md com termos novos
- [ ] Adicionar navegação avançada no README.md

### Out of Scope

- Tradução PT/EN — público é brasileiro, conteúdo fica em português
- Exportar offline (PDF/ZIP) — por enquanto só navegação online
- Criação de plataformas próprias — usa apenas TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF
- Conteúdo sobre hardware hacking ou pentester físico

## Context

**Estado atual (após Fase 1 — Auditoria Completa):**

- **67 files auditados** em 12 módulos (00-11)
- **Score médio geral:** 3.3/5.0
- **Melhor módulo:** 08-resposta (3.9) — excelentes labs
- **Pior módulo:** 10-governança (2.8) — 100% teórico, precisa reescrita completa
- **Módulos que precisam trabalho maior:** 04 (3.0), 05 (3.0), 10 (2.8)
- **Core value compliance:** 55% das ferramentas com bloco completo (instalação + uso + output)
- **AUD-03 (Kali):** PARCIALMENTE ATENDIDO — 08-maquinas-virtuais.md tem passos, mas INSTALACAO.md recomenda Ubuntu
- **Fraqueza geral:** Labs (score 2.6-3.4), ~60% dos comandos sem output esperado

**Relatórios de auditoria:**
- `aprendizado/cyberseguranca/auditoria/AUDIT-REPORT.md` — resumo executivo
- `aprendizado/cyberseguranca/auditoria/FILE-MAP.md` — inventário completo
- `aprendizado/cyberseguranca/auditoria/SCORING.md` — tabela de scores
- `aprendizado/cyberseguranca/auditoria/GAP-ANALYSIS.md` — gaps por módulo
- `aprendizado/cyberseguranca/auditoria/IMPROVEMENT-PLAN.md` — ordem priorizada

**Estrutura da pasta `aprendizado/cyberseguranca/`:**

```
cyberseguranca/
├── README.md                  # guia principal da trilha
├── ROADMAP.md                 # desatualizado — numeração antiga (10 módulos)
├── GLOSSARIO.md
├── INSTALACAO.md              # precisa reescrita para Kali
├── CHEATSHEET-*.md (3 arquivos)
├── auditoria/                 # ← NOVO: relatórios da Fase 1
├── 00-pre-requisitos/         # 13 files, score 3.5, sem LABS.md
├── 01-reconhecimento/         # 4 files, score 3.3
├── 02-web-aplicacoes/         # 10 files, score 3.26
├── 03-exploracao/             # 4 files, score 3.2
├── 04-pos-exploracao/         # 4 files, score 3.0
├── 05-reversing/              # 4 files, score 3.0
├── 06-analise-rede/           # 4 files, score 3.4
├── 07-defesa/                 # 4 files
├── 08-resposta/               # 4 files, score 3.9
├── 09-ambientes/              # 5 files
├── 10-governanca/             # 4 files, score 2.8
└── 11-ia-cyberseguranca/      # 2 files (estrutura inconsistente)
```

**Sistema operacional fixo:** Todo comando assume Kali Linux.

**Plataformas prioritárias:** Gratuitas (TryHackMe free rooms, HackTheBox free labs, PortSwigger Academy, OverTheWire, PicoCTF).

**Certificações que a trilha prepara:** OSCP, CEH, CompTIA Security+, PTX (eLearnSecurity).

## Constraints

- **Sistema operacional único:** Kali Linux — todo comando, instalação e ambiente assume Kali
- **Escopo:** Trabalhar somente dentro de `aprendizado/cyberseguranca/`
- **Estrutura:** Manter padrão README.md por módulo + arquivos numerados + LABS.md (a menos que auditoria justifique mudança)
- **Público:** Leigo total até avançado — todo termo técnico novo aparece no GLOSSARIO.md
- **Não-negociável:** Nada de teoria sem o "como fazer" — toda ferramenta vem com comando de instalação + comando de uso (flags explicadas) + output esperado

## Key Decisions

| Decisão | Racional | Resultado |
|---------|----------|-----------|
| Score 1-5 com 5 dimensões | Critérios definidos em D-01 a D-08 para padronizar avaliação | ✓ Definido |
| Leitura completa (não amostragem) | Core value exige verificação arquivo por arquivo | ✓ Executado |
| Módulo 11: avaliar conteúdo, não estrutura | README.md 633 linhas funciona como conteúdo; consistência anotada mas não penaliza score | ✓ Decidido |
| INSTALACAO.md: precisa reescrita para Kali | AUD-03 encontrou "Ubuntu/Debian recomendado" — conflita com constraint Kali-only | ✓ Identificado |
| theHarvester → Subfinder | Ferramenta principal de recon mudou; theHarvester agora é complementar | ✓ Identificado |
| Labs são fraqueza geral | Score médio de Labs: 2.6-3.4; ~60% dos comandos sem output esperado | ✓ Identificado |
| 10-governança é 100% teórico | Viola core value — precisa reescrita completa | ✓ Identificado |
| ROADMAP.md será atualizado | Usuário prefere atualizar a apagar | — Pendente |
| Labs gratuitas + referências pagas | Público-alvo é iniciante | — Pendente |
| Navegação avançada | Busca, filtros e navegação entre módulos | — Pendente |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-09-10 after Fase 1 (Auditoria Completa)*
