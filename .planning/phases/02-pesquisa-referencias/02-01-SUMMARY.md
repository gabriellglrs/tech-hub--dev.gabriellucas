---
phase: 02-pesquisa-referencias
plan: 01
subsystem: research
tags: [labs, validation, certification-alignment, URL-validation]
dependency_graph:
  requires: []
  provides: [lab-matrix.csv, per-module-reports]
  affects: [03-modernizacao]
tech_stack:
  added: []
  patterns: [URL-validation, CSV-tracking, UMD-reports]
key_files:
  created:
    - ".planning/phases/02-pesquisa-referencias/data/lab-matrix.csv"
    - ".planning/phases/02-pesquisa-referencias/reports/00-pre-requisitos.md"
    - ".planning/phases/02-pesquisa-referencias/reports/01-reconhecimento.md"
    - ".planning/phases/02-pesquisa-referencias/reports/02-web-aplicacoes.md"
    - ".planning/phases/02-pesquisa-referencias/reports/03-exploracao.md"
    - ".planning/phases/02-pesquisa-referencias/reports/04-pos-exploracao.md"
    - ".planning/phases/02-pesquisa-referencias/reports/05-reversing.md"
  modified: []
decisions:
  - "OverTheWire Bandit é a plataforma primária para módulo 00 (Linux basics)"
  - "PortSwigger é a plataforma primária para módulo 02 (web security — 155+ labs)"
  - "OverTheWire Narnia+Behemoth são ideais para módulo 03 (binary exploitation)"
  - "OverTheWire Leviathan é ideal para módulo 05 (RE iniciante)"
  - "Módulo 04 tem os maiores gaps — precisa de AD labs (HTB Academy ou THM premium)"
  - "Corrigido: 'Ustromia' não existe no OverTheWire — removido do CSV"
  - "Corrigido: Leviathan tem 8 níveis (não 15 como informado na pesquisa)"
  - "Corrigido: Narnia tem 10 níveis (não 5 como informado na pesquisa)"
metrics:
  duration: "2026-09-10T21:27:45Z — 2026-09-10T21:45:00Z (~18 min)"
  completed_date: "2026-09-10"
---

# Phase 2 Plan 01: Baseline Labs + Pesquisa Referências Summary

**Objetivo:** Ler estado atual dos LABS.md (módulos 00-05), pesquisar labs gratuitos nas 5 plataformas, validar URLs, e gerar relatórios UMD por módulo.

**Resultado:** 84 entradas no lab-matrix.csv + 6 relatórios UMD gerados com labs candidatos, tópicos ausentes, e status de validação.

---

## O que foi feito

### Task 1: Baseline leitura + pesquisa

1. **Leitura dos LABS.md existentes:**
   - Módulo 00: NÃO tem LABS.md (confirmado)
   - Módulo 01: 6 exercícios, todos THM
   - Módulo 02: 6 exercícios, 5 usam DVWA (monocultura)
   - Módulo 03: 6 exercícios, foco em brute force/cracking
   - Módulo 04: 6 exercícios, foco em Linux privesc + lateral movement
   - Módulo 05: 6 exercícios, 4 usam bufferoverflowprep (monocultura)

2. **Pesquisa de labs nas 5 plataformas:**
   - **TryHackMe:** 29 rooms mapeados (5 por módulo)
   - **PortSwigger:** 16 categorias validadas (155+ labs gratuitos)
   - **OverTheWire:** 6 wargames validados (Bandit, Natas, Narnia, Behemoth, Leviathan)
   - **PicoCTF:** 4 categorias mapeadas (General, Web, Binary, RE)
   - **HackTheBox:** Starting Point mapeado (5 máquinas guiadas)

3. **lab-matrix.csv criado:** 84 linhas de dados com module, platform, topic, url, status

### Task 2: Validação URLs + relatórios UMD

1. **Validação de URLs:**
   - **OverTheWire:** 6 wargames confirmados ativos via webfetch (Bandit, Natas, Narnia, Behemoth, Leviathan, Krypton)
   - **PortSwigger:** 16 categorias confirmadas ativas via webfetch
   - **TryHackMe:** Rate-limited (429) — URLs marcadas como "pendente"
   - **PicoCTF:** Pendente
   - **HackTheBox:** Pendente

2. **Correções identificadas (D-06):**
   - "Ustromia" não existe no OverTheWire — removido
   - Leviathan tem 8 níveis (não 15)
   - Narnia tem 10 níveis (não 5)
   - Behemoth tem 9 níveis (não 5)
   - Bandit/Narnia/Behemoth/Leviathan usam SSH (não URLs web)

3. **6 relatórios UMD gerados** com:
   - Labs existentes validados
   - Labs candidatos novos com URLs
   - Tópicos ausentes categorizados por prioridade (OSCP > Security+ > CEH)
   - Resumo quantitativo

---

## Descobertas Principais

### Cobertura por Módulo

| Módulo | Labs Existentes | Labs Candidatos | Total | Gaps Críticos |
|--------|----------------|-----------------|-------|---------------|
| 00-pre-requisitos | 0 (sem LABS.md) | 8 | 8 | 3 (CIA, intro cybersec, redes) |
| 01-reconhecimento | 6 | 5 | 11 | 3 (vuln scan, enum, OSINT avançado) |
| 02-web-aplicacoes | 6 | 22 | 28 | 5 (XSS, SSRF, XXE, Burp, client-side) |
| 03-exploracao | 6 | 8 | 14 | 6 (SearchSploit, BO, Metasploit, AV evasion) |
| 04-pos-exploracao | 6 | 3 | 9 | 7 (Win privesc, AD, BloodHound, Mimikatz, Rubeus) |
| 05-reversing | 6 | 4 | 10 | 0 (6 importantes) |

### Plataformas com Melhor Cobertura

| Plataforma | Módulos Fortes | Labs Gratuitos |
|------------|---------------|----------------|
| **PortSwigger** | 02-web (155+ labs) | 100% gratuito |
| **OverTheWire** | 00, 02, 03, 05 | SSH-based, sempre gratuito |
| **TryHackMe** | Todos | 650+ free rooms |
| **PicoCTF** | 03, 05 | CTF-based |
| **HackTheBox** | Todos (Starting Point) | Limitado (5-10 ativos) |

### Crítico: Módulos com Maiores Gaps

1. **Módulo 04 (Pós-Exploração):** 7 gaps críticos — Windows privesc, AD, BloodHound, Mimikatz, Rubeus não cobertos
2. **Módulo 03 (Exploração):** 6 gaps críticos — buffer overflow, SearchSploit, Metasploit completo não cobertos
3. **Módulo 02 (Web):** 5 gaps críticos — XSS, SSRF, XXE, Burp Suite não cobertos nos labs existentes

---

## Deviations from Plan

### Auto-fixed Issues

**1. [D-06 - Correção] Ustromia não existe no OverTheWire**
- **Found during:** Task 1 (pesquisa)
- **Issue:** RESEARCH.md listava "Ustromia 5 levels" como wargame de RE
- **Fix:** Removido do CSV — OverTheWire não tem wargame "Ustromia"
- **Files modified:** data/lab-matrix.csv
- **Commit:** N/A (fase de pesquisa)

**2. [D-06 - Correção] Leviathan tem 8 níveis (não 15)**
- **Found during:** Task 1 (pesquisa)
- **Issue:** RESEARCH.md listava "Leviathan 15 levels"
- **Fix:** Atualizado para 8 levels (confirmado via webfetch)
- **Files modified:** data/lab-matrix.csv, reports/05-reversing.md
- **Commit:** N/A

**3. [D-06 - Correção] Narnia tem 10 níveis (não 5)**
- **Found during:** Task 1 (pesquisa)
- **Issue:** RESEARCH.md listava "Narnia 5 levels"
- **Fix:** Atualizado para 10 levels (confirmado via webfetch)
- **Files modified:** data/lab-matrix.csv, reports/03-exploracao.md
- **Commit:** N/A

**4. [D-06 - Correção] URLs OTW corrigidas para SSH**
- **Found during:** Task 2 (validação)
- **Issue:** Bandit/Narnia/Behemoth/Leviathan usam SSH (não URLs web)
- **Fix:** Atualizado para formato SSH (ex: ssh://bandit.labs.overthewire.org:2220)
- **Files modified:** data/lab-matrix.csv
- **Commit:** N/A

---

## Known Stubs

Nenhum — este é um plano de pesquisa, não de implementação.

---

## Threat Flags

Nenhum — dados são públicos (salas gratuitas de plataformas de segurança).

---

## Self-Check: PASSED

- ✅ lab-matrix.csv existe com 85 linhas (84 dados + 1 header)
- ✅ 6 relatórios UMD existem (00-05)
- ✅ Cada relatório tem: labs existentes, labs candidatos, tópicos ausentes, resumo
- ✅ URLs validadas com status (✅/⚠️/❌/⏳)
- ✅ Tópicos ausentes categorizados por prioridade (Crítico/Importante/Opcional)
- ✅ 5 plataformas cobertas (THM, HTB, PortSwigger, OTW, PicoCTF)
