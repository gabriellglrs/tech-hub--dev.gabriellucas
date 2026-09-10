# Phase 3: Modernização + Conteúdo Prático - Context

**Gathered:** 2026-09-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Processar cada módulo (na ordem priorizada da Fase 1): atualizar ferramentas obsoletas, adicionar outputs reais do Kali 2026, substituir LABS.md pelos 174 labs mapeados, e reescrever módulos 10 e 11 conforme decisões específicas.

</domain>

<decisions>
## Implementation Decisions

### Estratégia de Processamento
- **D-01:** Módulo a módulo completo — um módulo inteiro (ferramentas + outputs + labs) antes de ir pro próximo
- **D-02:** Ordem de processamento: segue IMPROVEMENT-PLAN.md da Fase 1 (módulos com maior desvio didático primeiro)

### Formato de Outputs
- **D-03:** Output real do Kali 2026 — trecho copiado de execução atual
- **D-04:** Todo comando deve ter: comando de instalação + comando de uso (flags explicadas) + output esperado

### Integração de Labs
- **D-05:** Substituir LABS.md existente pelos 174 labs mapeados
- **D-06:** Labs organizados por plataforma (TryHackMe, PortSwigger, OverTheWire, PicoCTF, HackTheBox)
- **D-07:** Cada lab deve ter: nome, URL, dificuldade, tópicos cobertos

### Módulos Especiais
- **D-08:** Módulo 10 (GRC): Adicionar prática de compliance (checar contra CIS Benchmarks, revisar políticas reais)
- **D-09:** Módulo 11 (IA): Reescrever com ferramentas atuais (CAI, prompt injection, defensive AI) e adicionar labs práticos

### Ferramentas Obsoletas (da Fase 1)
- **D-10:** theHarvester → Subfinder (ferramenta principal de recon)
- **D-11:** MITMf → bettercap (análise de rede)
- **D-12:** Armitage → msfconsole direto (exploração)
- **D-13:** Rekall → Volatility 3 (forense de memória)
- **D-14:** Snort → Suricata (defesa/monitoramento)

### the agent's Discretion
- Profundidade da atualização por módulo — o agente decide com base no score da Fase 1
- Como balancear profundidade vs velocidade — módulos com nota 1-2 recebem mais atenção
- Quais ferramentas são críticas vs nice-to-have — baseado na prioridade das certificações

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Resultados das Fases Anteriores
- `aprendizado/cyberseguranca/auditoria/AUDIT-REPORT.md` — Resumo executivo da auditoria
- `aprendizado/cyberseguranca/auditoria/SCORING.md` — Tabela de scores (média 3.3/5.0)
- `aprendizado/cyberseguranca/auditoria/GAP-ANALYSIS.md` — Gaps por módulo
- `aprendizado/cyberseguranca/auditoria/IMPROVEMENT-PLAN.md` — Ordem de execução priorizada
- `aprendizado/cyberseguranca/auditoria/PESQUISA-REPORT.md` — 174 labs mapeados, certificações validadas

### Dados de Pesquisa
- `.planning/phases/02-pesquisa-referencias/data/lab-matrix.csv` — Matriz completa de labs (174 entradas)
- `.planning/phases/02-pesquisa-referencias/reports/CONSOLIDATED.md` — Relatório consolidado de pesquisa

### Requisitos
- `.planning/REQUIREMENTS.md` — FERR-01, FERR-02, FERR-03, PRAT-01, PRAT-02, PRAT-03 mapeados para Fase 3

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `aprendizado/cyberseguranca/auditoria/IMPROVEMENT-PLAN.md` — Ordem de execução priorizada já definida
- `.planning/phases/02-pesquisa-referencias/data/lab-matrix.csv` — 174 labs com URLs validadas
- `aprendizado/cyberseguranca/auditoria/PESQUISA-REPORT.md` — Mapeamento módulo × certificações

### Established Patterns
- Padrão por módulo: `README.md` + 2-3 arquivos numerados + `LABS.md`
- Core value: toda ferramenta deve ter instalação + uso + output
- Formato LABS.md: ferramenta + dica + checklist + links

### Integration Points
- Cada módulo processado é entregue completamente antes de ir pro próximo
- Labs do lab-matrix.csv são incorporados aos LABS.md atualizados
- Ferramentas obsoletas são substituídas conforme lista D-10 a D-14

</code_context>

<specifics>
## Specific Ideas

- Output real do Kali é mais confiável para o aprendiz — ele vê exatamente o que vai ver
- Módulo a módulo completo dá controle total — se algo errado, é corrigido antes do próximo
- Substituir LABS.md garante que apenas labs validados apareçam
- Módulo 10 com prática de compliance torna o GRC tangível
- Módulo 11 reescrito com IA atual relevance o conteúdo

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-modernizacao-conteudo*
*Context gathered: 2026-09-10*
