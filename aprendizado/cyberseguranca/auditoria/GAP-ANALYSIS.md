# Análise de Lacunas — Trilha de Aprendizado em Cybersegurança

**Gerado em:** 2026-09-10
**Escopo:** Todos os 12 módulos (00-11)

---

## Análise de Lacunas

### Visão Geral das Lacunas

| Categoria | Módulos Afetados | Severidade |
|:----------|:-----------------|:-----------|
| Falta output esperado em comandos | 00-06, 09-11 | ALTA |
| Ferramentas depreciadas/recomendadas | 01 | MÉDIA |
| Conteúdo 100% teórico (sem pratica) | 00 (09-conceitos), 10 | CRÍTICA |
| Falta LABS.md | 00 | ALTA |
| Inconsistência estrutural | 11 | MÉDIA |
| Progressão didática quebrada | 00 (Kali), 10 | ALTA |
| Repetição de conteúdo | 02 (SQLi) | BAIXA |

---

## Lacunas por Módulo

### Módulo 00: Pre-requisitos

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta LABS.md | Estrutural | ALTA | Módulo não tem exercícios práticos verificáveis |
| 09-conceitos-seguranca.md é 100% teoria | Core Value | CRÍTICA | Zero comandos práticos — viola "apt a FAZER" |
| INSTALACAO.md recomenda Ubuntu | Progressão | ALTA | Conflita com constraint KALI-ONLY |
| Comandos Windows sem justificativa | Consistência | MÉDIA | ipconfig, tracert misturados com comandos Linux |
| 4 READMEs de subdiretórios são só navegação | Completude | BAIXA | Sem valor educacional próprio |

### Módulo 01: Reconhecimento

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| theHarvester como ferramenta principal | Ferramenta | MÉDIA | Subfinder é superior para passive — deveria ser priorizado |
| Falta output esperado | Completude | ALTA | ~40% dos comandos sem output esperado |
| Amass superficial | Completude | BAIXA | Mencionado mas sem detalhes de uso |

### Módulo 02: Web Aplicações

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| API security superficial | Completude | ALTA | Falta BOLA, Mass Assignment, GraphQL |
| Repetição de SQLi | Consistência | BAIXA | Conteúdo duplicado entre 02-injecao e 06-database |
| XSS/CSP rasos | Completude | MÉDIA | Falta DOM-based XSS, stored XSS, bypass de CSP |
| Falta output esperado | Completude | ALTA | ~50% dos comandos sem output |
| Falta Nuclei para CVE scanning | Ferramenta | MÉDIA | Ferramenta importante não detalhada |

### Módulo 03: Exploração

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Foca em password cracking | Completude | ALTA | Falta Metasploit, Searchsploit, exploração de serviços |
| Wordlists superficial | Completude | MÉDIA | Falta CeWL, criação de wordlists customizados |
| Falta output esperado | Completude | ALTA | ~60% dos comandos sem output |
| Falta lockout policy | Segurança | BAIXA | Não menciona proteção contra brute force |

### Módulo 04: Pós-exploração

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta BloodHound para AD | Ferramenta | ALTA | Essential para Active Directory |
| Pivoting superficial | Completude | ALTA | Falta ligolo-ng, exemplos reais de subnets |
| Falta output esperado | Completude | CRÍTICA | ~70% dos comandos sem output |
| Labs genéricos | Labs | MÉDIA | Links sem passo a passo detalhado |
| Falta integração com módulo 03 | Progressão | MÉDIA | Não conecta exploitation→post-exploitation |

### Módulo 05: Reversing

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Ghidra sub-utilizado | Ferramenta | ALTA | Mencionado mas sem tutorial passo a passo |
| Falta debuggers | Ferramenta | ALTA | GDB e x64dbg não cobertos |
| Fuzzing superficial | Completude | MÉDIA | Falta crash analysis real |
| Falta output esperado | Completude | ALTA | ~60% dos comandos sem output |
| Falta integração com módulo 06 | Progressão | MÉDIA | Não conecta reversing↔análise de rede |

### Módulo 06: Análise de Rede

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta output esperado | Completude | MÉDIA | ~30% dos comandos sem output |
| Falta integração com módulo 07 | Progressão | BAIXA | Não conecta detecção↔defesa |

### Módulo 07: Defesa

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta output esperado | Completude | MÉDIA | Alguns comandos sem output (OpenSCAP, sysctl) |
| Wazuh 4.7 pode estar defasado | Versão | BAIXA | Versão atual pode ser superior |

### Módulo 08: Resposta

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta output esperado | Completude | MÉDIA | Comandos-chave sem output (Volatility, Plaso) |
| REMnux sem instalação detalhada | Completude | BAIXA | VM referenciada mas sem guia de setup |

### Módulo 09: Ambientes

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Falta output esperado | Completude | MÉDIA | Trivy, kube-hunter, MobSF sem output |
| Falco mencionado sem comandos | Completude | MÉDIA | Ferramenta importante mas rasamente coberta |
| AWS CLI install pode estar defasado | Versão | BAIXA | Instalação via apt pode não ser a recomendada |

### Módulo 10: Governança

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Conteúdo 100% teórico | Core Value | CRÍTICA | Zero comandos práticos em GRC |
| LABS.md superficial | Labs | ALTA | Exercícios genéricos sem passo a passo |
| Falta exercícios CIS reais | Prática | ALTA | Não ensina a rodar auditoria CIS |
| Criptografia rasamente coberta | Completude | MÉDIA | Falta bcrypt, scrypt, hashing de senhas |

### Módulo 11: IA para Cybersegurança

| Lacuna | Tipo | Severidade | Descrição |
|:-------|:-----|:-----------|:----------|
| Inconsistência estrutural | Estrutura | MÉDIA | Só README + LABS.md, sem arquivos numerados |
| CAI sem instalação detalhada | Completude | MÉDIA | Ferramenta referenciada mas sem guia |
| Labs sem output esperado | Completude | MÉDIA | Exercícios sem output verificável |

---

## Padrões Cross-Módulo

### 1. Falta de Output Esperado (8 de 12 módulos)

**Módulos afetados:** 00, 01, 02, 03, 04, 05, 06, 09, 10, 11

**Impacto:** Alto — o core value do projeto é "apt a FAZER", mas sem output esperado o leigo não sabe se fez certo.

**Recomendação:** Adicionar bloco `Output esperado:` após cada comando principal em todos os módulos.

### 2. Ferramentas Depreciadas

| Ferramenta | Módulo | Substituta | Severidade |
|:-----------|:-------|:-----------|:-----------|
| theHarvester | 01 | Subfinder (passive), Amass (active) | MÉDIA |

### 3. Labs Sem Passo a Passo Detalhado

**Módulos afetados:** 04, 05, 10

**Impacto:** Médio — labs existem mas são links para plataformas externas sem instruções locais.

**Recomendação:** Todos os LABS.md devem ter exercícios locais com comandos verificáveis.

### 4. Progressão Didática Inconsistente

**Problema:** Alguns módulos assumem conhecimento não ensinado anteriormente.

| Módulo | Conhecimento Assumido | Onde deveria ser ensinado |
|:-------|:----------------------|:-------------------------|
| 00 (11-windows-basico) | Windows como ambiente de prática | Deveria rotular como "sistema alvo" |
| 04 | BloodHound para AD | Deveria ter seção dedicada |
| 10 | Conceitos de compliance | Deveria ter exercícios práticos |

### 5. Core Value Violations

| Módulo | Arquivo | Violação |
|:-------|:--------|:---------|
| 00 | 09-conceitos-seguranca.md | 100% teoria, zero comandos |
| 10 | 01-grc-e-compliance.md | 100% teoria, zero comandos |
| 10 | README.md | Guia conceitual sem pratica |

---

## Cobertura de Ferramentas Essenciais (por módulo)

### Verificação: Instalação + Uso + Output

| Módulo | Ferramentas com bloco completo | Ferramentas incompletas | % Completo |
|:-------|:------------------------------:|:-----------------------:|:----------:|
| 00 | 8 | 5 | 62% |
| 01 | 3 | 3 | 50% |
| 02 | 5 | 8 | 38% |
| 03 | 3 | 3 | 50% |
| 04 | 2 | 4 | 33% |
| 05 | 2 | 3 | 40% |
| 06 | 4 | 2 | 67% |
| 07 | 8 | 3 | 73% |
| 08 | 7 | 3 | 70% |
| 09 | 8 | 4 | 67% |
| 10 | 1 | 4 | 20% |
| 11 | 2 | 2 | 50% |
| **TOTAL** | **53** | **44** | **55%** |

**Observação:** Apenas 55% das ferramentas essenciais têm o bloco completo (instalação + uso + output). Módulo 10 é o pior (20%). Módulo 07 é o melhor (73%).
