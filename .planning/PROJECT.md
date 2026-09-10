# Trilha de Aprendizado em Cybersegurança

## What This Is

Reestruturar e completar a trilha de aprendizado em cybersegurança (`aprendizado/cyberseguranca/`), transformando-a em um curso completo em Markdown que leva uma pessoa **leiga total** do zero ao nível avançado — com foco total em prática aplicada, não teoria solta. A pasta já existe com 12 módulos (00-11), mas precisa de auditoria, atualização e melhoria para atingir qualidade de curso profissional.

## Core Value

**Todo módulo deve deixar a pessoa apta a FAZER, não só a ter lido.** Para cada ferramenta ou técnica: comando de instalação + comando de uso completo (flags explicadas) + output esperado. Uma pessoa leiga tem que conseguir copiar e colar e chegar no resultado.

## Requirements

### Validated

<!-- Nenhum módulo foi validado como curso ainda. Ship para validar. -->

(Nenhum ainda — ship para validar)

### Active

- [ ] Auditar todos os 12 módulos (00-11) — progressão didática, correção técnica, completude de comandos, qualidade dos labs
- [ ] Corrigir divergência entre ROADMAP.md e estrutura real de pastas
- [ ] Pesquisar referências externas (OSCP, CEH, Security+, TryHackMe, HackTheBox, PortSwigger) e validar se a ordem dos módulos e tópicos está atualizada
- [ ] Mapear salas/labs gratuitos e de baixo custo novos por módulo (TryHackMe, HackTheBox Academy, PortSwigger, OverTheWire, PicoCTF)
- [ ] Validar se as ferramentas citadas em cada módulo são as mais atuais e usadas pelo mercado
- [ ] Criar plano de melhoria por módulo (o que mantém, o que reescreve, o que adiciona)
- [ ] Definir critérios de qualidade padrão para todo módulo
- [ ] Estabelecer ordem de execução priorizada
- [ ] Reescrever/criar conteúdo dos módulos seguindo os critérios de qualidade
- [ ] Garantir que `00-pre-requisitos/` orienta instalação/configuração do Kali Linux como ambiente de prática
- [ ] Adicionar navegação avançada (campos de busca, filtros, navegação entre módulos)
- [ ] Atualizar ROADMAP.md para refletir a estrutura atual

### Out of Scope

- Tradução PT/EN — público é brasileiro, conteúdo fica em português
- Exportar offline (PDF/ZIP) — por enquanto só navegação online
- Criação de plataformas próprias — usa apenas TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF
- Conteúdo sobre hardware hacking ou pentester físico

## Context

**Estrutura atual da pasta `aprendizado/cyberseguranca/`:**

```
cyberseguranca/
├── README.md                  # guia principal da trilha (já reflete estrutura atual)
├── ROADMAP.md                 # desatualizado — numeração antiga (10 módulos, não 12)
├── GLOSSARIO.md
├── INSTALACAO.md
├── CHEATSHEET-*.md (3 arquivos)
├── 00-pre-requisitos/         # redes, sistemas, segurança básica, ferramentas
├── 01-reconhecimento/
├── 02-web-aplicacoes/
├── 03-exploracao/
├── 04-pos-exploracao/
├── 05-reversing/
├── 06-analise-rede/
├── 07-defesa/
├── 08-resposta/
├── 09-ambientes/
├── 10-governanca/
└── 11-ia-cyberseguranca/
```

**Cada módulo segue o padrão:** `README.md` (navegação) + 2-3 arquivos de conteúdo + `LABS.md` (exercícios práticos com links).

**ROADMAP.md está desatualizado:** Ele fala em 10 módulos com numeração diferente (ex: `02-analise-rede/` quando a pasta real é `06-analise-rede/`). Precisa ser atualizado ou descartado.

**Sistema operacional fixo:** Todo comando assume Kali Linux. Se ferramenta já vem pré-instalada no Kali, dizer explicitamente.

**Plataformas prioritárias:** Gratuitas (TryHackMe free rooms, HackTheBox free labs, PortSwigger Academy, OverTheWire, PicoCTF). Referências a pagas são permitidas mas com aviso.

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
| ROADMAP.md será atualizado | Usuário prefere atualizar a apagar, pois README.md já cumpre parcialmente esse papel | — Pendente |
| Labs gratuitas + referências pagas | Público-alvo é iniciante e não deve pagar para praticar o essencial | — Pendente |
| Navegação avançada | Busca, filtros e navegação entre módulos para melhorar experiência | — Pendente |
| Tudo igual (corrigir, enriquecer, padronizar) | Nenhum aspecto tem prioridade sobre outro — projeto precisa de qualidade uniforme | — Pendente |

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
*Last updated: 2026-09-10 after initialization*
