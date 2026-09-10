# Phase 2: Pesquisa e Referências - Context

**Gathered:** 2026-09-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Mapear labs gratuitos por módulo em 5 plataformas (TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF), validar existência de cada sala, e comparar tópicos dos 12 módulos com certificações (OSCP > Security+ > CEH) para identificar ausências.

</domain>

<decisions>
## Implementation Decisions

### Plataformas e Validação
- **D-01:** Incluir todas as 5 plataformas: TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF
- **D-02:** Validar existência de cada sala/exercício — verificar se ainda existe e está acessível gratuitamente

### Certificações e Priorização
- **D-03:** Prioridade: OSCP > Security+ > CEH
- **D-04:** Comparação por módulo: mapear tópicos de cada módulo contra tópicos dos exames, listando ausências

### Labs Existentes vs Novos
- **D-05:** Validar labs existentes no LABS.md + buscar novos onde faltar cobertura
- **D-06:** Salas removidas ou mudaram de nome: marcar como indisponível + sugerir alternativa equivalente

### Formato do Output
- **D-07:** Relatório por módulo (UMD): labs candidatos + tópicos ausentes + status de validação
- **D-08:** Relatório consolidado no final com resumo geral

### the agent's Discretion
- Profundidade da pesquisa por plataforma — o agente decide com base na relevância para cada módulo
- Como categorizar tópicos ausentes (crítico vs importante vs opcional) — segue a escala de prioridade das certificações
- Número mínimo de labs por módulo — o agente define baseado na complexidade do módulo

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Resultados da Fase 1
- `aprendizado/cyberseguranca/auditoria/AUDIT-REPORT.md` — Resumo executivo da auditoria (12 módulos avaliados)
- `aprendizado/cyberseguranca/auditoria/SCORING.md` — Tabela de scores com média 3.3/5.0
- `aprendizado/cyberseguranca/auditoria/GAP-ANALYSIS.md` — Gaps identificados por módulo
- `aprendizado/cyberseguranca/auditoria/IMPROVEMENT-PLAN.md` — Ordem de execução priorizada

### Estrutura do Projeto
- `aprendizado/cyberseguranca/README.md` — Guia principal com estrutura de 12 módulos
- `aprendizado/cyberseguranca/LABS.md` — Labs existentes por módulo (precisam validação)

### Requisitos
- `.planning/REQUIREMENTS.md` — PESQ-01 e PESQ-02 mapeados para Fase 2

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `aprendizado/cyberseguranca/auditoria/IMPROVEMENT-PLAN.md` — Ordem de execução priorizada já definida (prioriza módulos com maior desvio didático)
- `aprendizado/cyberseguranca/auditoria/GAP-ANALYSIS.md` — Gaps por módulo que podem indicar onde faltam labs

### Established Patterns
- Padrão por módulo: `README.md` + 2-3 arquivos numerados + `LABS.md`
- LABS.md existente tem formato: ferramenta + dica + checklist + links para plataformas
- Core value: toda ferramenta deve ter instalação + uso + output

### Integration Points
- Resultado da Fase 2 alimenta diretamente a Fase 3 (modernização módulo a módulo)
- Labs validados são incorporados aos LABS.md atualizados na Fase 3
- Tópicos ausentes podem justificar reordenação ou criação de novos conteúdos

</code_context>

<specifics>
## Specific Ideas

- OSCP é a certificação mais requisitada pelo mercado para pentesters — prioridade máxima
- Security+ é entrada na área — importante para fundamentos
- CEH é mais teórico — menos prioridade mas ainda relevante para vocabulário
- Labs gratuitos são essenciais — público-alvo é iniciante e não deve pagar para praticar o essencial
- Validação de existência é crítica — links quebrados frustram o aprendiz

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-pesquisa-referencias*
*Context gathered: 2026-09-10*
