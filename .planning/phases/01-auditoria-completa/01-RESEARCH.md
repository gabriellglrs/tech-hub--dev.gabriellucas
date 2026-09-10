# Phase 1: Auditoria Completa - Research

**Researched:** 2026-09-10
**Domain:** Content auditing for cybersecurity educational materials (Markdown-based)
**Confidence:** HIGH

## Summary

This phase requires auditing 12 modules (00-11) of a cybersecurity learning trail, producing a diagnostic table with scores (1-5) across 5 criteria, and generating a prioritized execution order for Phase 3. The audit is a read-only, analysis-focused phase with no code changes — only documentation artifacts. The content structure is well-defined: 12 module directories, each with README.md + 2-8 content files + LABS.md. Module 00 is unique (4 subdirectories with 13 files), while modules 01-11 follow a consistent pattern (2-3 content files + LABS.md). The existing ROADMAP.md in the content directory is severely outdated (references 10 modules with wrong numbering, not 12), confirming it needs updating or removal per NAVE-01.

**Primary recommendation:** Execute a systematic file-by-file audit using the 5-criteria rubric defined in CONTEXT.md (D-01 through D-08), with module 00 receiving special attention for Kali Linux installation guidance (AUD-03). The audit output should be a structured Markdown table + per-module notes + prioritized execution order.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Escala de nota de 1 a 5 (numérica) para cada critério
- **D-02:** Nota geral é a média dos 5 critérios abaixo
- **D-03:** Critérios de avaliação: Correção Técnica, Completude de Comandos, Qualidade dos Labs, Progressão Didática, Consistência
- **D-04:** Nota 5 — Todos comandos corretos/sintaxe 2026; Instalação+uso+output em toda ferramenta; Labs reais com passo a passo verificável; Não assume nada não ensinado antes; Tom uniforme
- **D-05:** Nota 4 — 1-2 erros menores; 80%+ ferramentas com bloco completo; Labs reais mas faltam outputs; 1-2 módulos com pequeno desvio; Tom quase uniforme
- **D-06:** Nota 3 — Alguns erros mas conteúdo funcional; 50-79% ferramentas completas; Labs existem mas genéricos; Alguns módulos pulam etapas; Tom variado
- **D-07:** Nota 2 — Vários erros técnicos; <50% ferramentas completas; Labs só links sem passo a passo; Vários módulos assume conhecimento avançado; Tom muito diferente
- **D-08:** Nota 1 — Conteúdo desatualizado/incorreto; Zero comandos documentados; Sem labs ou só teoria; Progressão quebrada; Sem padronização
- **D-09:** A ordem de priorização será gerada como parte do output da auditoria (NAVE-04), não definida aqui — o avaliador decide a ordem baseado nas notas e problemas encontrados

### the agent's Discretion
- Profundidade da auditoria (ler tudo ou amostrar) — o agente decide com base no tamanho de cada módulo
- Formato exato da tabela de auditoria — segue o padrão mais útil pra comparação
- Como medir "consistência de tom" — usa a escala de notas como referência

### Deferred Ideas (OUT OF SCOPE)
- Discussão de profundidade da auditoria (ler tudo ou amostrar) — o agente decide
- Discussão de critérios de priorização (desvio didático, pré-requisito, correção simples) — será definido no output da auditoria
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| AUD-01 | Ler todos os 12 módulos (00-11) e avaliar correção técnica, completude de comandos, qualidade dos labs | Full content scan of 12 modules; data paths identified for each file |
| AUD-02 | Gerar tabela de auditoria (módulo | nota geral | principais problemas | prioridade de correção) | Structured output format defined; scoring rubric from CONTEXT.md |
| AUD-03 | Verificar se 00-pre-requisitos orienta instalação/configuração do Kali Linux como ambiente de prática | Module 00 has 4 subdirectories; 08-maquinas-virtuais.md covers VMs/Kali; INSTALACAO.md exists at root |
| AUD-04 | Avaliar progressão didática por módulo (assume conhecimento não ensinado antes? sim/não) e consistência de tom/profundidade com os demais | Cross-module dependency analysis required; tone/depth consistency check |
| NAVE-04 | Gerar ordem de execução priorizada (quais módulos corrigir primeiro — por desvio didático, por ser pré-requisito de outro, ou por correção simples) | Output of AUD-01 through AUD-04 feeds directly into this |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Content reading & analysis | Local filesystem | — | All content is local Markdown files |
| Technical accuracy verification | Research (web search) | — | Need to verify 2026 tool versions, Kali pre-installed status |
| Scoring & diagnostic table | Local computation | — | Arithmetic mean of 5 criteria per module |
| Execution order generation | Analysis | — | Based on scores + dependency analysis |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| No external libraries needed | — | Phase is pure content analysis | All artifacts are Markdown files |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| grep/ripgrep | System | Search for tool references, commands, patterns across modules | During content scanning |
| wc (word count) | System | Measure file sizes for depth assessment | Comparing module completeness |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Manual file reading | Automated script to extract tool names | Manual is more thorough for qualitative assessment |

**Installation:** No installation needed — this is a read-only audit phase.

## Data Sources for Each Requirement

### AUD-01: Read all 12 modules and evaluate

**Data sources (exhaustive list):**

| Module | Files to Read | Count | Notes |
|--------|--------------|-------|-------|
| 00-pre-requisitos | README.md + 01-redes/ (6 files) + 02-sistemas/ (4 files) + 03-seguranca/ (3 files) + 04-ferramentas/ (3 files) | ~17 | Unique structure with subdirectories |
| 01-reconhecimento | README.md, 01-dns-e-enumeracao.md, 02-osint-e-subdominios.md, LABS.md | 4 | Standard pattern |
| 02-web-aplicacoes | README.md, 01-descoberta-e-enumeracao.md through 08-frontend-csp.md, LABS.md | 10 | Largest module (8 content files) |
| 03-exploracao | README.md, 01-brute-force-e-cracking.md, 02-wordlists-e-ferramentas.md, LABS.md | 4 | Standard pattern |
| 04-pos-exploracao | README.md, 01-enum-e-movimentacao.md, 02-pivoting-e-tunneling.md, LABS.md | 4 | Standard pattern |
| 05-reversing | README.md, 01-engenharia-reversa.md, 02-exploit-e-fuzzing.md, LABS.md | 4 | Standard pattern |
| 06-analise-rede | README.md, 01-sniffing-e-captura.md, 02-proxy-e-anonimato.md, LABS.md | 4 | Standard pattern |
| 07-defesa | README.md, 01-hardening-e-firewall.md, 02-monitoramento-e-siem.md, LABS.md | 4 | Standard pattern |
| 08-resposta | README.md, 01-forense-computacional.md, 02-analise-malware.md, LABS.md | 4 | Standard pattern |
| 09-ambientes | README.md, 01-cloud-e-containers.md, 02-wireless.md, 03-mobile.md, LABS.md | 5 | 3 content files |
| 10-governanca | README.md, 01-grc-e-compliance.md, 02-criptografia.md, LABS.md | 4 | Standard pattern |
| 11-ia-cyberseguranca | README.md, LABS.md | 2 | Smallest module — only README + LABS, no content files? |

**Total files to audit:** ~67 files across 12 modules

**Cross-reference files (root level):**
- `README.md` — main trail guide (224 lines)
- `GLOSSARIO.md` — terminology reference (299 lines)
- `INSTALACAO.md` — installation guide (588 lines)
- `ROADMAP.md` — outdated roadmap (406 lines, references 10 modules not 12)
- `prompt-gsd-trilha-cyberseguranca.md` — original project prompt (115 lines)
- `CHEATSHEET-defesa-forense.md`, `CHEATSHEET-exploracao.md`, `CHEATSHEET-recon-web.md` — 3 cheatsheets

**Evaluation criteria per module (from D-03):**
1. **Correção Técnica** — Are commands correct? Syntax valid for 2026? Tool names accurate?
2. **Completude de Comandos** — Does every tool have: installation + usage (flags explained) + expected output?
3. **Qualidade dos Labs** — Are LABS.md exercises real, verifiable, with step-by-step? Not just theory disguised as labs?
4. **Progressão Didática** — Does each module assume knowledge taught in previous modules? No gaps?
5. **Consistência** — Is formatting, tone, depth consistent across all 12 modules?

### AUD-02: Generate audit table

**Output format:** Markdown table with columns:
| Módulo | Nota Geral | Correção Técnica | Completude | Labs | Progressão | Consistência | Principais Problemas | Prioridade |

**Scoring:** Average of 5 criteria (each 1-5), rounded to 1 decimal

### AUD-03: Verify 00-pre-requisitos Kali guidance

**Data sources:**
- `00-pre-requisitos/02-sistemas/08-maquinas-virtuais.md` — covers VMs, mentions Kali Linux setup
- `INSTALACAO.md` — root-level installation guide (mentions Ubuntu, not Kali-specific)
- `prompt-gsd-trilha-cyberseguranca.md` — original prompt explicitly requires Kali-only

**Key question:** Does module 00 explicitly guide the user to install/configure Kali Linux as their practice environment? Or does it assume Ubuntu/generic Linux?

**Preliminary finding:** The 08-maquinas-virtuais.md file mentions "Kali Linux + Metasploitable" as the standard setup, but the INSTALACAO.md at root level says "Ubuntu/Debian recomendado" — this is a potential inconsistency to flag.

### AUD-04: Evaluate didactic progression and tone consistency

**Data sources:** All 12 module READMEs + content files (same as AUD-01)

**Analysis approach:**
1. For each module, identify what knowledge it assumes
2. Check if that knowledge was taught in a previous module
3. Flag any module that assumes knowledge not yet covered
4. Compare tone (beginner-friendly vs. advanced) across modules
5. Compare depth (word count, detail level) across modules

**Cross-module dependency map (from README.md flow chart):**
```
00 (prerequisites) → 01 (recon) → 02 (web) → 03 (exploitation) → 04 (post-exploitation)
                                                              ↓
05 (reversing) ← independent but useful after 04
06 (network analysis) ← independent
07 (defense) ← independent
08 (incident response) ← depends on 07
09 (special environments) ← independent
10 (governance) ← independent
11 (AI) ← independent but should come last
```

### NAVE-04: Generate prioritized execution order

**Data source:** Output of AUD-01 through AUD-04

**Priority factors (from CONTEXT.md D-09):**
1. Modules with highest didactic deviation (assume untaught knowledge)
2. Modules that are prerequisites for others
3. Modules with simple technical corrections (quick wins)

## Research Findings

### Content Structure Analysis

**Module size distribution:**
| Module | Content Files | Unique? | Assessment Difficulty |
|--------|--------------|---------|----------------------|
| 00 | 13 (in 4 subdirs) | YES — subdirectory structure | HIGH — more files to read |
| 01 | 2 | No | Standard |
| 02 | 8 | YES — largest module | HIGH — most content to evaluate |
| 03 | 2 | No | Standard |
| 04 | 2 | No | Standard |
| 05 | 2 | No | Standard |
| 06 | 2 | No | Standard |
| 07 | 2 | No | Standard |
| 08 | 2 | No | Standard |
| 09 | 3 | Slightly (3 files) | Standard |
| 10 | 2 | No | Standard |
| 11 | 0 (only README + LABS) | YES — no content files | LOW — very thin module |

**Key observation:** Module 11 (IA para Cybersegurança) has only README.md and LABS.md — no numbered content files. The README itself is very comprehensive (633 lines) and functions as the content. This is structurally different from all other modules and should be flagged in the audit.

**Key observation:** Module 02 (Web & Aplicações) is the largest with 8 content files covering web, API, database, and frontend security. This is the most complex module to audit.

### Content Quality Patterns (from sample reading)

**Positive patterns observed:**
- Consistent README structure across modules (objectives, prerequisites, map, content table, tips, AI section, errors, labs, checklist, navigation)
- LABS.md files have detailed step-by-step with tools, tips, checklists, and platform links
- Content files use analogies, diagrams, and progressive explanations
- GLOSSARIO.md is comprehensive (299 lines, well-organized by category)

**Potential issues to investigate:**
- INSTALACAO.md mentions "Ubuntu/Debian" as recommended, not Kali-specific — conflicts with project constraint
- ROADMAP.md in content directory is outdated (10 modules, wrong numbering) — needs NAVE-01 decision
- Some modules may have inconsistent depth (module 02 with 8 files vs module 11 with 0 content files)
- Need to verify all tool references are current for 2026 (especially AI tools in module 11)

### Common Gaps in Cybersecurity Education Content

Based on research of educational content quality frameworks:

1. **Missing expected outputs** — Commands shown without output examples (core value violation)
2. **Incomplete flag explanations** — `nmap -sV` without explaining what `-sV` does
3. **Theory-heavy labs** — Labs that describe concepts rather than providing verifiable exercises
4. **Outdated tool references** — Tools that are discontinued or replaced (e.g., MITMf → bettercap)
5. **Missing installation steps** — Assuming tools are installed without showing how
6. **Inconsistent depth** — Some modules very detailed, others thin
7. **No progression checks** — Modules that assume knowledge from later modules
8. **Broken links** — External references to platforms (THM, HTB) that may have changed

### Audit Approach Recommendation

**Approach:** Full read of all modules (not sampling)

**Rationale:**
- Total content is ~67 files, manageable for comprehensive audit
- The project's core value ("todo módulo deve deixar a pessoa apta a FAZER") requires per-file verification
- Module 11's unique structure needs special attention
- Module 02's size (8 files) needs thorough coverage
- AUD-03 specifically requires deep reading of module 00

**Execution order for the auditor:**
1. Read root files first (README.md, GLOSSARIO.md, INSTALACAO.md, ROADMAP.md) for context
2. Audit module 00 first (AUD-03 priority — Kali installation check)
3. Audit modules 01-11 in order (to assess progression sequentially)
4. Generate consolidated table (AUD-02)
5. Cross-reference for progression issues (AUD-04)
6. Generate execution order (NAVE-04)

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Link checking | Manual URL verification | Automated link checker or just flag for human verification | Links may be dynamic; focus on content quality |
| Word count analysis | Custom script | `wc -w` on each file | Simple metric for depth comparison |
| Tool version verification | Manual web search for each tool | Cross-reference with STACK.md in project research | STACK.md already has current tool versions |

## Common Pitfalls

### Pitfall 1: Inconsistent scoring across modules
**What goes wrong:** Evaluator applies criteria differently for module 00 (which has subdirectories) vs module 01 (which has flat files)
**Why it happens:** Different structural complexity creates different evaluation contexts
**How to avoid:** Apply the 5-criteria rubric uniformly; adjust expectations for module 00's unique structure but score against the same standards
**Warning signs:** Module 00 getting significantly higher or lower scores than adjacent modules without clear justification

### Pitfall 2: Confusing "comprehensive README" with "complete module"
**What goes wrong:** Module 11's README is 633 lines and reads like content, but it's structurally different (no separate content files)
**Why it happens:** The module was designed differently from the standard pattern
**How to avoid:** Evaluate whether the module achieves the same learning outcomes regardless of file structure; flag structural inconsistency but don't penalize for it if content quality is equivalent
**Warning signs:** Module 11 getting a high score despite having no LABS.md exercises or numbered content files

### Pitfall 3: Missing Kali-specific guidance in module 00
**What goes wrong:** Module 00 mentions Kali but doesn't provide explicit installation/configuration steps
**Why it happens:** The original content may have been written for generic Linux
**How to avoid:** AUD-03 specifically checks this; read 08-maquinas-virtuais.md thoroughly and cross-reference with INSTALACAO.md
**Warning signs:** Any mention of "Ubuntu" or "Debian" without Kali equivalent

### Pitfall 4: Outdated ROADMAP.md creating confusion
**What goes wrong:** The auditor references the outdated ROADMAP.md (10 modules) instead of the actual structure (12 modules)
**Why it happens:** ROADMAP.md exists in the content directory and looks authoritative
**How to avoid:** Ignore the content ROADMAP.md for audit purposes; use the actual directory structure as ground truth
**Warning signs:** Audit table referencing module numbers that don't match actual directories

## Code Examples

No code examples needed — this is a documentation/analysis phase.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| theHarvester-only for OSINT | Subfinder + httpx + Nuclei combo | 2023-2024 | Module 01 may reference old approach |
| Armitage for Metasploit GUI | msfconsole direct usage | 2022-2023 | Module 03 may reference Armitage |
| MITMf for MITM | bettercap | 2022-2023 | Module 06 may reference MITMf |
| Manual SIEM setup | Wazuh Docker quickstart | 2024-2025 | Module 07 may have outdated SIEM setup |

**Deprecated/outdated tools to check for:**
- MITMf (replaced by bettercap)
- Armitage (replaced by msfconsole direct)
- theHarvester as primary (now complementary to Subfinder)
- Rekall (replaced by Volatility 3)
- Snort (replaced by Suricata for most use cases)

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Module 11 has no separate content files (only README + LABS) | AUD-01 | Low — directory listing confirms this |
| A2 | The 5-criteria scoring rubric from CONTEXT.md is sufficient for this audit | AUD-02 | Low — rubric is well-defined with anchor points |
| A3 | All external links in LABS.md files should be flagged for verification in Phase 2 (FERR-03), not Phase 1 | AUD-01 | Medium — links may be broken but that's Phase 2 scope |
| A4 | The INSTALACAO.md at root level is outdated (mentions Ubuntu, not Kali) | AUD-03 | Medium — needs verification during audit |

**If this table is empty:** Not applicable — assumptions listed above.

## Open Questions (RESOLVED)

1. **Should the auditor read ALL content files or focus on READMEs + LABS.md?** `(RESOLVED)`
   - What we know: The core value requires every tool to have installation + usage + output
   - What's unclear: Whether to verify this at the content file level or just the LABS.md level
   - Decision: **Read all content files** — the auditor needs to verify the "installation + usage + output" pattern exists in the actual teaching content, not just in labs

2. **How to handle module 11's different structure?** `(RESOLVED)`
   - What we know: Module 11 has only README.md (633 lines) + LABS.md, no numbered content files
   - What's unclear: Whether this should be penalized in consistency scoring or treated as a valid alternative structure
   - Decision: **Score content quality independently of structure**; flag structural inconsistency as a note but don't let it artificially lower the score if content is good

3. **Should the audit include the 3 cheatsheets?** `(RESOLVED)`
   - What we know: CHEATSHEET-defesa-forense.md, CHEATSHEET-exploracao.md, CHEATSHEET-recon-web.md exist at root level
   - What's unclear: Whether these are part of the audit scope (they're not in any module directory)
   - Decision: **Read them for context but don't include in per-module scoring**; they may be referenced by modules

4. **What's the relationship between INSTALACAO.md and per-module installation instructions?** `(RESOLVED)`
   - What we know: INSTALACAO.md has installation commands for all tools; modules may also have inline installation
   - What's unclear: Whether modules should duplicate installation info or reference INSTALACAO.md
   - Decision: **Flag any module that assumes tools are installed without either inline installation or reference to INSTALACAO.md**

## Environment Availability

No external dependencies required — this is a pure content analysis phase.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual review (no automated tests for content quality) |
| Config file | N/A |
| Quick run command | N/A |
| Full suite command | N/A |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| AUD-01 | All 12 modules read and evaluated | manual-only | Read all 67 files | ✅ Files exist |
| AUD-02 | Audit table generated | manual-only | Create Markdown table | ❌ Wave 0 |
| AUD-03 | Module 00 Kali guidance verified | manual-only | Read 08-maquinas-virtuais.md | ✅ File exists |
| AUD-04 | Progression and consistency evaluated | manual-only | Cross-module analysis | ✅ Files exist |
| NAVE-04 | Execution order generated | manual-only | Analysis output | ❌ Wave 0 |

### Sampling Rate
- **Per task commit:** N/A (no code changes)
- **Per wave merge:** N/A
- **Phase gate:** Human review of audit table and execution order

### Wave 0 Gaps
- [ ] Audit table template — needs to be created as output artifact
- [ ] Execution order template — needs to be created as output artifact
- No test framework needed — this is a documentation phase

## Security Domain

> Not applicable — this phase involves no code execution, no external services, and no security-sensitive operations. It's a read-only content analysis.

## Sources

### Primary (HIGH confidence)
- Project files: CONTEXT.md, REQUIREMENTS.md, ROADMAP.md, PROJECT.md — all read directly
- Content directory: `aprendizado/cyberseguranca/` — all module structures verified via directory listing
- Original prompt: `prompt-gsd-trilha-cyberseguranca.md` — project requirements confirmed

### Secondary (MEDIUM confidence)
- Web search: content audit methodologies from DojoCodingLabs instructional-design-toolkit, idstack.org quality frameworks, NCSC cybersecurity training criteria
- Web search: cybersecurity tool replacement patterns (MITMf→bettercap, Armitage→msfconsole, etc.)

### Tertiary (LOW confidence)
- None — all findings are based on direct file reading or verified web sources

## Metadata

**Confidence breakdown:**
- Standard Stack: HIGH — no external libraries needed; pure content analysis phase
- Architecture: HIGH — file structure is well-understood; data paths are clear
- Pitfalls: MEDIUM — based on sample reading; full audit may reveal additional issues

**Research date:** 2026-09-10
**Valid until:** 2026-10-10 (30 days — content structure is stable)
