# Plano de Melhoria — Ordem de Execução para Fase 3

**Gerado em:** 2026-09-10
**Baseado em:** Notas da auditoria + fatores de priorização (D-09)

---

## Ordem de Execução

### Prioridade 1: URGENTES (Notas 1-2.9)

| # | Módulo | Nota | Justificativa | Tipo de Correção | Esforço Estimado |
|:-:|:-------|:----:|:--------------|:-----------------|:----------------:|
| 1 | **10-governanca** | 2.8 | Conteúdo 100% teórico, zero comandos práticos, viola core value. LABS.md superficial. | Reescrita completa + criação de exercícios práticos | ALTO (4 arquivos, ~1.200 linhas) |

### Prioridade 2: ALTAS (Notas 3.0-3.2)

| # | Módulo | Nota | Justificativa | Tipo de Correção | Esforço Estimado |
|:-:|:-------|:----:|:--------------|:-----------------|:----------------:|
| 2 | **04-pos-exploracao** | 3.0 | Módulo mais fraco dos ofensivos. Falta BloodHound, pivoting superficial, ~70% sem output. Labs genéricos. | Expansão de conteúdo + adição de BloodHound + output esperado | ALTO (4 arquivos, ~1.400 linhas) |
| 3 | **05-reversing** | 3.0 | Ghidra sub-utilizado, falta debuggers (GDB, x64dbg), fuzzing superficial, ~60% sem output. | Expansão + tutorial Ghidra + debuggers + output | ALTO (4 arquivos, ~1.200 linhas) |

### Prioridade 3: MÉDIAS (Notas 3.3-3.4)

| # | Módulo | Nota | Justificativa | Tipo de Correção | Esforço Estimado |
|:-:|:-------|:----:|:--------------|:-----------------|:----------------:|
| 4 | **00-pre-requisitos** | 3.5 | AUD-03: INSTALACAO.md recomenda Ubuntu. 09-conceitos 100% teoria. Falta LABS.md. | Correção INSTALACAO + pratica em 09-conceitos + criar LABS.md | MÉDIO (5 arquivos, ~1.500 linhas) |
| 5 | **02-web-aplicacoes** | 3.3 | API security superficial, XSS/CSP rasos, repetição SQLi, ~50% sem output. | Expansão API + XSS + remover repetição + output | ALTO (10 arquivos, ~3.700 linhas) |
| 6 | **03-exploracao** | 3.2 | Foca em password cracking, falta Metasploit/Searchsploit, ~60% sem output. | Expansão + Metasploit + output | MÉDIO (4 arquivos, ~1.500 linhas) |
| 7 | **01-reconhecimento** | 3.3 | theHarvester como principal (depreciado), ~40% sem output. | Substituir theHarvester por Subfinder + output | MÉDIO (4 arquivos, ~1.600 linhas) |

### Prioridade 4: MENORES (Notas 3.5-3.9)

| # | Módulo | Nota | Justificativa | Tipo de Correção | Esforço Estimado |
|:-:|:-------|:----:|:--------------|:-----------------|:----------------:|
| 8 | **06-analise-rede** | 3.4 | Melhor módulo ofensivo mas falta output em ~30%. | Adicionar output esperado | BAIXO (4 arquivos, ~1.800 linhas) |
| 9 | **07-defesa** | 3.8 | Bom módulo. Falta output em alguns comandos. Wazuh pode estar defasado. | Adicionar output + atualizar Wazuh | BAIXO (4 arquivos, ~1.300 linhas) |
| 10 | **09-ambientes** | 3.9 | Bom módulo. Falta output, Falco rasamente coberto. | Adicionar output + expandir Falco | BAIXO (5 arquivos, ~1.600 linhas) |
| 11 | **08-resposta** | 3.9 | Melhor módulo geral. Falta output em comandos-chave. | Adicionar output | BAIXO (4 arquivos, ~1.400 linhas) |
| 12 | **11-ia-cyberseguranca** | 3.7 | Bom conteúdo mas inconsistência estrutural (só README). | Reestruturar em arquivos numerados + output | MÉDIO (2 arquivos, ~950 linhas) |

---

## Fatores de Priorização Aplicados

### Fator 1: Desvio Didático (assume conhecimento não ensinado)

| Módulo | Problema | Impacto |
|:-------|:---------|:--------|
| 10-governanca | Assume conceitos de compliance sem ensinar | ALTO |
| 04-pos-exploracao | Assume BloodHound sem ensinar | ALTO |
| 05-reversing | Assume debuggers sem ensinar | ALTO |
| 00-pre-requisitos | Assume Kali mas recomenda Ubuntu | ALTO |

### Fator 2: Pré-requisito para outros módulos

| Módulo | É pré-requisito de | Impacto |
|:-------|:-------------------|:--------|
| 00-pre-requisitos | Todos | CRÍTICO |
| 07-defesa | 08-resposta | MÉDIO |
| 06-analise-rede | 07-defesa | MÉDIO |

### Fator 3: Correções técnicas simples (quick wins)

| Módulo | Correção | Esforço |
|:-------|:---------|:--------|
| 01-reconhecimento | Substituir theHarvester por Subfinder | BAIXO |
| 06-analise-rede | Adicionar output esperado | BAIXO |
| 07-defesa | Adicionar output esperado | BAIXO |
| 08-resposta | Adicionar output esperado | BAIXO |

---

## Resumo de Esforço Estimado

| Prioridade | Módulos | Esforço Total |
|:-----------|:--------|:-------------:|
| URGENTE | 10 | ALTO |
| ALTA | 04, 05 | ALTO + ALTO |
| MÉDIA | 00, 02, 03, 01 | MÉDIO + ALTO + MÉDIO + MÉDIO |
| MENOR | 06, 07, 09, 08, 11 | BAIXO + BAIXO + BAIXO + BAIXO + MÉDIO |
| **TOTAL** | **12 módulos** | **~12-15 horas estimadas** |

---

## Recomendações para a Fase 3

1. **Começar pelo módulo 10** — é o mais urgente (nota 2.8, viola core value)
2. **Depois módulos 04 e 05** — são os mais fracos dos ofensivos (nota 3.0)
3. **Corrigir módulo 00** — é pré-requisito de todos, tem AUD-03 pendente
4. **Quick wins em paralelo** — adicionar output esperado em módulos 06, 07, 08, 09
5. **Expandir módulo 02** — é o maior (10 arquivos) e precisa de mais profundidade
6. **Reestruturar módulo 11** — inconsistência estrutural precisa ser corrigida

---

## Nota

Esta ordem é uma **recomendação**. O agente de execução da Fase 3 pode ajustar baseado em dependências e escopo disponível. A prioridade URGENTE (módulo 10) deve ser mantida em qualquer cenário.
