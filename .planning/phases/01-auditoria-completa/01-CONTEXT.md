# Phase 1: Auditoria Completa - Context

**Gathered:** 2026-09-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Ler e avaliar todos os 12 módulos (00-11) da trilha de cybersegurança, gerar tabela de diagnóstico com nota geral e problemas por módulo, e definir a ordem exata em que os módulos devem ser processados na Fase 3.

</domain>

<decisions>
## Implementation Decisions

### Critérios de Avaliação
- **D-01:** Escala de nota de 1 a 5 (numérica) para cada critério
- **D-02:** Nota geral é a média dos 5 critérios abaixo
- **D-03:** Critérios de avaliação: Correção Técnica, Completude de Comandos, Qualidade dos Labs, Progressão Didática, Consistência

### Âncoras de Nota (1-5)
- **D-04:** Nota 5 — Todos comandos corretos/sintaxe 2026; Instalação+uso+output em toda ferramenta; Labs reais com passo a passo verificável; Não assume nada não ensinado antes; Tom uniforme
- **D-05:** Nota 4 — 1-2 erros menores; 80%+ ferramentas com bloco completo; Labs reais mas faltam outputs; 1-2 módulos com pequeno desvio; Tom quase uniforme
- **D-06:** Nota 3 — Alguns erros mas conteúdo funcional; 50-79% ferramentas completas; Labs existem mas genéricos; Alguns módulos pulam etapas; Tom variado
- **D-07:** Nota 2 — Vários erros técnicos; <50% ferramentas completas; Labs só links sem passo a passo; Vários módulos assume conhecimento avançado; Tom muito diferente
- **D-08:** Nota 1 — Conteúdo desatualizado/incorreto; Zero comandos documentados; Sem labs ou só teoria; Progressão quebrada; Sem padronização

### Ordem de Execução
- **D-09:** A ordem de priorização será gerada como parte do output da auditoria (NAVE-04), não definida aqui — o avaliador decide a ordem baseado nas notas e problemas encontrados

### the agent's Discretion
- Profundidade da auditoria (ler tudo ou amostrar) — o agente decide com base no tamanho de cada módulo
- Formato exato da tabela de auditoria — segue o padrão mais útil pra comparação
- Como medir "consistência de tom" — usa a escala de notas como referência

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Estrutura do Projeto
- `aprendizado/cyberseguranca/README.md` — Guia principal da trilha com estrutura atual de 12 módulos
- `aprendizado/cyberseguranca/ROADMAP.md` — Roadmap desatualizado (precisa ser decidido: atualizar ou remover)
- `.planning/REQUIREMENTS.md` — Requisitos v1 com AUD-01, AUD-02, AUD-03, AUD-04, NAVE-04 mapeados pra Fase 1

### Referências de Certificação
- `aprendizado/cyberseguranca/prompt-gsd-trilha-cyberseguranca.md` — Documento original com contexto e restrições do projeto

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `aprendizado/cyberseguranca/README.md` — Já contém tabela de módulos com tempos estimados e contagem de arquivos
- `aprendizado/cyberseguranca/GLOSSARIO.md` — Termos técnicos existentes para referência de consistência
- `aprendizado/cyberseguranca/INSTALACAO.md` — Guia de instalação existente para referência

### Established Patterns
- Padrão por módulo: `README.md` + 2-3 arquivos numerados + `LABS.md`
- Todo módulo deve ter: instalação + uso com flags + output esperado (core value do projeto)

### Integration Points
- A tabela de auditoria deve ser compatível com a estrutura existente de pastas
- A ordem de execução alimenta diretamente a Fase 3 (módulo a módulo)

</code_context>

<specifics>
## Specific Ideas

- Nota 5 em Correção Técnica significa que TODOS os comandos estão corretos e com sintaxe 2026 — nenhum comando quebrado ou desatualizado
- A escala 1-5 permite comparar módulos entre si e identificar rapidamente quais precisam de mais trabalho
- A nota geral ajuda a priorizar: módulos com nota 1-2 vão pra frente da fila na Fase 3

</specifics>

<deferred>
## Deferred Ideas

- Discussão de profundidade da auditoria (ler tudo ou amostrar) — o agente decide
- Discussão de critérios de priorização (desvio didático, pré-requisito, correção simples) — será definido no output da auditoria

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-auditoria-completa*
*Context gathered: 2026-09-10*
