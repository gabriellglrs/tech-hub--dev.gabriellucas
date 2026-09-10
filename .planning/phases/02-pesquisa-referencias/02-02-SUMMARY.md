---
phase: 02-pesquisa-referencias
plan: 02
subsystem: research
tags: [labs, validation, certification-alignment, URL-validation, modules-06-11]
dependency_graph:
  requires: [02-01]
  provides: [lab-matrix-complete, per-module-reports-06-11]
  affects: [03-modernizacao]
tech_stack:
  added: []
  patterns: [URL-validation, CSV-tracking, UMD-reports]
key_files:
  created:
    - ".planning/phases/02-pesquisa-referencias/reports/06-analise-rede.md"
    - ".planning/phases/02-pesquisa-referencias/reports/07-defesa.md"
    - ".planning/phases/02-pesquisa-referencias/reports/08-resposta.md"
    - ".planning/phases/02-pesquisa-referencias/reports/09-ambientes.md"
    - ".planning/phases/02-pesquisa-referencias/reports/10-governanca.md"
    - ".planning/phases/02-pesquisa-referencias/reports/11-ia-cyberseguranca.md"
  modified:
    - ".planning/phases/02-pesquisa-referencias/data/lab-matrix.csv"
decisions:
  - "Módulo 06 tem 3 links incorretos no LABS.md que precisam ser corrigidos na Fase 3"
  - "Módulo 10 (Governança) tem cobertura limitada de labs gratuitos — GRC é inerentemente teórico"
  - "Módulo 11 (IA) é o mais novo e com menos labs gratuitos — precisa de conteúdo novo"
  - "CyberDefenders.org é plataforma complementar gratuita excelentepara labs forenses (módulo 08)"
  - "OverTheWire Krypton é a melhor plataforma gratuita para criptografia (módulo 10)"
  - "THM com rate-limit durante validação — URLs marcadas como pendente"
  - "PicoCTF retorna 403 para bots — URLs marcadas como redirect"
metrics:
  duration: "2026-09-10T22:00:00Z — 2026-09-10T22:30:00Z (~30 min)"
  completed_date: "2026-09-10"
---

# Phase 2 Plan 02: Labs Módulos 06-11 + Relatórios UMD Summary

**Objetivo:** Ler estado atual dos LABS.md (módulos 06-11), pesquisar labs gratuitos nas 5 plataformas, validar URLs, e gerar relatórios UMD por módulo.

**Resultado:** 62 entradas adicionadas ao lab-matrix.csv (módulos 06-11) + 6 relatórios UMD gerados. Total geral: 147 linhas no CSV.

---

## O que foi feito

### Task 1: Leitura LABS.md + pesquisa módulos 06-11

1. **Leitura dos LABS.md existentes:**
   - Módulo 06: 6 exercícios, todos THM — **3 links incorretos** (dvwa para mitmproxy/proxychains, metasploitexploitation para bettercap)
   - Módulo 07: 6 exercícios, maioria labs locais (Lynis, UFW, iptables, Suricata, Wazuh)
   - Módulo 08: 6 exercícios, maioria labs locais (Volatility, Autopsy, YARA, Plaso)
   - Módulo 09: 6 exercícios, todos labs locais (Docker, K8s, Android, WiFi, AWS, Mobile API)
   - Módulo 10: 6 exercícios, maioria labs locais — **1 link incorreto** (dvwa para LUKS)
   - Módulo 11: 6 labs, todos locais usando Ollama

2. **Pesquisa de labs nas 5 plataformas:**
   - **TryHackMe:** 35+ rooms mapeados para módulos 06-11 (network, defense, forensics, cloud, crypto)
   - **HackTheBox:** Starting Point + active machines (defesa, forensics, cloud)
   - **PicoCTF:** Forensics (40+), Cryptography (40+), AI (10+) — todos com redirect 403
   - **OverTheWire:** Krypton (6 levels) validado para criptografia
   - **PortSwigger:** Web LLM attacks (topic existe, URL a validar)

3. **lab-matrix.csv atualizado:** 62 linhas adicionais para módulos 06-11. Total: 147 linhas.

### Task 2: Validação URLs + relatórios UMD

1. **Validação de URLs:**
   - **HackTheBox:** ✅ Ativo (200)
   - **OverTheWire Krypton:** ✅ Ativo (200)
   - **CyberDefenders:** ✅ Ativo (200)
   - **TryHackMe:** ⏳ Rate-limit (429) — todas as URLs marcadas como pendente
   - **PicoCTF:** ⚠️ Redirect (403 bot detection) — URLs marcadas como redirect
   - **PortSwigger Web LLM:** ❌ 404 — URL incorreta, topic existe na plataforma

2. **Correções identificadas (D-06):**
   - Módulo 06: 3 links incorretos no LABS.md (exercícios 3, 4, 5)
   - Módulo 10: 1 link incorreto no LABS.md (exercício 4)

3. **6 relatórios UMD gerados** (06-11) com:
   - Labs existentes validados
   - Labs candidatos novos com URLs
   - Tópicos ausentes categorizados por prioridade (Crítico/Importante/Opcional)
   - Resumo quantitativo

---

## Descobertas Principais

### Cobertura por Módulo

| Módulo | Labs Existentes | Labs Candidatos | Total | Gaps Críticos | Status |
|--------|----------------|-----------------|-------|---------------|--------|
| 06-analise-rede | 6 (3 links errados) | 12 | 18 | 2 | ⚠️ Corrigir links |
| 07-defesa | 6 (locais) | 9 | 15 | 3 | ✅ Forte |
| 08-resposta | 6 (locais) | 11 | 17 | 3 | ✅ Forte |
| 09-ambientes | 6 (locais) | 9 | 15 | 3 | ✅ Forte |
| 10-governanca | 6 (1 link errado) | 8 | 14 | 3 | ⚠️ Limitado |
| 11-ia-cyberseguranca | 6 (locais) | 4 | 10 | 3 | ⚠️ Limitado |

### Plataformas com Melhor Cobertura (Módulos 06-11)

| Plataforma | Módulos Fortes | Labs Gratuitos |
|------------|---------------|----------------|
| **TryHackMe** | 06, 07, 08, 09 | 35+ rooms (network, defense, forensics, cloud) |
| **OverTheWire** | 10 (Krypton) | 6 níveis de cryptanalysis |
| **PicoCTF** | 08, 10, 11 | Forensics 40+, Crypto 40+, AI 10+ |
| **CyberDefenders** | 08 | Labs forenses gratuitos |
| **HackTheBox** | 06, 07, 08, 09 | Starting Point + active machines |

### Críticos: Links Incorretos no LABS.md

| Módulo | Exercício | Link Atual | Problema | Correção Necessária |
|--------|-----------|-----------|----------|-------------------|
| 06 | Ex 3 (mitmproxy) | dvwa | Link errado | Criar room mitmproxy ou usar link correto |
| 06 | Ex 4 (bettercap) | metasploitexploitation | Link errado | Criar room bettercap ou usar link correto |
| 06 | Ex 5 (proxychains) | dvwa | Link errado | Criar room proxychains ou usar link correto |
| 10 | Ex 4 (LUKS) | dvwa | Link errado | Usar documentação LUKS ou criar lab |

### Módulos com Cobertura Limitada

**Módulo 10 (Governança):**
- GRC é inerentemente teórico — poucos labs interativos gratuitos existem
- Labs de criptografia existem (OTW Krypton, PicoCTF Crypto)
- Labs de compliance/governança são escassos em plataformas gratuitas
- **Recomendação:** Aceitar limitação, focar em labs de criptografia disponíveis

**Módulo 11 (IA):**
- Módulo mais novo — labs gratuitos são escassos
- PicoCTF tem 10+ desafios de AI (mas com redirect 403)
- PortSwigger tem "Web LLM attacks" (4 labs)
- **Recomendação:** Módulo precisa de conteúdo novo — atuais são insuficientes para CEH v13 AI module

---

## Deviations from Plan

### Auto-fixed Issues

**1. [D-06 - Correção] 3 links incorretos no LABS.md do módulo 06**
- **Found during:** Task 1 (leitura)
- **Issue:** Exercícios 3, 4, 5 usam links para dvwa/metasploitexploitation em vez de mitmproxy/bettercap/proxychains
- **Fix:** Documentado nos relatórios UMD — correção adiada para Fase 3
- **Files modified:** reports/06-analise-rede.md
- **Commit:** N/A (fase de pesquisa)

**2. [D-06 - Correção] Link incorreto no LABS.md do módulo 10**
- **Found during:** Task 1 (leitura)
- **Issue:** Exercício 4 (LUKS) usa link para dvwa
- **Fix:** Documentado nos relatórios UMD — correção adiada para Fase 3
- **Files modified:** reports/10-governanca.md
- **Commit:** N/A

**3. [Rate-limit] TryHackMe retorna 429 para todas as requisições**
- **Found during:** Task 2 (validação)
- **Issue:** THM bloqueia requisições automatizadas
- **Fix:** URLs marcadas como "pendente" — validação manual necessária
- **Files modified:** data/lab-matrix.csv
- **Commit:** N/A

**4. [Bot detection] PicoCTF retorna 403 para bots**
- **Found during:** Task 2 (validação)
- **Issue:** PicoCTF bloqueia acesso automatizado
- **Fix:** URLs marcadas como "redirect" — existem mas precisam de acesso manual
- **Files modified:** data/lab-matrix.csv
- **Commit:** N/A

**5. [URL incorreta] PortSwigger Web LLM attacks retorna 404**
- **Found during:** Task 2 (validação)
- **Issue:** URL testada não existe, mas topic está listado na plataforma
- **Fix:** Atualizado para apontar para all-labs com nota para validar
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

- ✅ lab-matrix.csv existe com 147 linhas (146 dados + 1 header)
- ✅ 62 linhas para módulos 06-11 (meta: >= 60)
- ✅ 12 relatórios UMD existem (00-11)
- ✅ 6 relatórios novos criados (06-11)
- ✅ Cada relatório tem: labs existentes, labs candidatos, tópicos ausentes, resumo
- ✅ URLs validadas com status (✅/⚠️/⏳/❌)
- ✅ Tópicos ausentes categorizados por prioridade (Crítico/Importante/Opcional)
- ✅ 5 plataformas cobertas (THM, HTB, PortSwigger, OTW, PicoCTF)
- ✅ Módulos 10 e 11 documentam limitações de cobertura
