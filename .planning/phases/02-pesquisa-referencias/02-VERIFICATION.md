---
phase: 02-pesquisa-referencias
verified: 2026-09-10T23:15:00Z
status: human_needed
score: 3/3 must-haves verified
overrides_applied: 0
re_verification:
  previous_status: null
  previous_score: null
  gaps_closed: []
  gaps_remaining: []
  regressions: []
human_verification:
  - test: "Manually validate TryHackMe room URLs (73% of URLs are pending due to rate-limit 429)"
    expected: "THM rooms exist and are free (not premium)"
    why_human: "TryHackMe blocks automated requests with HTTP 429 rate-limit — requires browser access"
  - test: "Manually validate PicoCTF challenge URLs (bot detection returns 403)"
    expected: "PicoCTF challenges exist in picoGym practice mode"
    why_human: "PicoCTF blocks bot access with 403 — requires browser access"
---

# Phase 2: Pesquisa e Referências — Verification Report

**Phase Goal:** Ter um mapeamento completo de labs gratuitos por módulo e validação de que a ordem dos tópicos reflete o que certificações e plataformas consideram essencial em 2026
**Verified:** 2026-09-10T23:15:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| #   | Truth                                                                                     | Status     | Evidence                                                                                                            |
| --- | ----------------------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------- |
| 1   | Para cada módulo, existe lista de salas/labs gratuitos candidatos nas 5 plataformas       | ✓ VERIFIED | 12 per-module reports exist (00-11), lab-matrix.csv has 146 entries across THM/HTB/PortSwigger/OTW/PicoCTF          |
| 2   | A ordem e tópicos dos 12 módulos foram comparados com OSCP, Security+ SY0-701 e CEH v13  | ✓ VERIFIED | PESQUISA-REPORT.md has certification alignment tables (OSCP 71%, Security+ 60%, CEH 50%)                            |
| 3   | Módulos ou tópicos totalmente ausentes foram apontados com justificativa                  | ✓ VERIFIED | CONSOLIDATED.md "Tópicos Ausentes" section with Critical/Important/Optional categorization and justification        |

**Score:** 3/3 truths verified

### Required Artifacts

| Artifact                              | Expected                                    | Status     | Details                                                            |
| ------------------------------------- | ------------------------------------------- | ---------- | ------------------------------------------------------------------ |
| `reports/00-11` (12 files)            | Per-module UMD reports with labs + gaps     | ✓ VERIFIED | All 12 exist, 52-81 lines each, substantive content               |
| `reports/CONSOLIDATED.md`             | Consolidated report with full summary       | ✓ VERIFIED | 239 lines, all required sections present                           |
| `auditoria/PESQUISA-REPORT.md`        | Final report in audit directory             | ✓ VERIFIED | 165 lines, consistent format with AUDIT-REPORT.md from Phase 1     |
| `data/lab-matrix.csv`                 | Module × Platform × Topic × URL × Status   | ✓ VERIFIED | 147 lines (146 data + 1 header), all 12 modules represented       |

### Key Link Verification

| From              | To                  | Via                         | Status     | Details                                    |
| ----------------- | ------------------- | --------------------------- | ---------- | ------------------------------------------ |
| lab-matrix.csv    | reports/*.md        | CSV data → report sections  | ✓ WIRED    | Reports reference CSV data                 |
| reports/*.md      | existing LABS.md    | Read existing labs          | ✓ WIRED    | Each report validates existing LABS.md     |
| CONSOLIDATED.md   | reports/00-11       | Reads all 12 reports        | ✓ WIRED    | Consolidation references all per-module    |
| PESQUISA-REPORT   | CONSOLIDATED.md     | Summary of consolidated     | ✓ WIRED    | Final report references consolidated       |
| CONSOLIDATED.md   | Phase 3             | Recommendations for next    | ✓ WIRED    | 10 recommendations for Phase 3             |

### Data-Flow Trace (Level 4)

| Artifact         | Data Variable        | Source                          | Produces Real Data | Status    |
| ---------------- | -------------------- | ------------------------------- | ------------------ | --------- |
| Per-module reports | Labs candidatos    | Web research + platform pages   | Yes — real room names, URLs, platforms | ✓ FLOWING |
| CONSOLIDATED.md  | Certification %      | Per-module reports aggregation  | Yes — OSCP 71%, Sec+ 60%, CEH 50% | ✓ FLOWING |
| lab-matrix.csv   | URL status           | HTTP HEAD validation            | Yes — validated status per URL | ✓ FLOWING |

### Behavioral Spot-Checks

| Behavior                              | Command                                              | Result                           | Status     |
| -------------------------------------- | ---------------------------------------------------- | -------------------------------- | ---------- |
| All 12 module reports exist           | `ls reports/*.md \| wc -l`                           | 13 files (12 modules + CONSOL)   | ✓ PASS     |
| lab-matrix.csv has data for all modules| `cut -d, -f1 data/lab-matrix.csv \| sort -u \| wc -l` | 12 unique modules              | ✓ PASS     |
| PESQUISA-REPORT has certification tables| `grep -c "OSCP\|Security+\|CEH" auditoria/PESQUISA-REPORT.md` | 15+ matches              | ✓ PASS     |
| No stub/placeholder content           | `grep -ri "placeholder\|TODO\|FIXME\|TBD" reports/`  | 0 matches                       | ✓ PASS     |

### Probe Execution

N/A — This is a research/documentation phase with no runnable probes.

### Requirements Coverage

| Requirement | Source Plan | Description                                                                 | Status     | Evidence                                                                 |
| ----------- | ---------- | --------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------ |
| PESQ-01     | 02-01, 02-02, 02-03 | Search 5 platforms for free labs per module, list candidates not in LABS.md | ✓ SATISFIED | 12 reports list candidate labs, lab-matrix.csv has 146 entries, all 5 platforms covered |
| PESQ-02     | 02-01, 02-02, 02-03 | Verify module order/topics against OSCP, CEH v13, Security+ SY0-701, identify absent topics | ✓ SATISFIED | CONSOLIDATED.md + PESQUISA-REPORT.md have detailed certification alignment tables |

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
| ---- | ---- | ------- | -------- | ------ |
| (none) | — | — | — | No anti-patterns detected in any deliverable |

### Decision Coverage

| Decision | Description                                                              | Addressed | Evidence                                                                 |
| -------- | ------------------------------------------------------------------------ | --------- | ------------------------------------------------------------------------ |
| D-01     | Incluir todas as 5 plataformas                                           | ✅ Yes    | All 5 platforms in lab-matrix.csv and per-module reports                 |
| D-02     | Validar existência de cada sala/exercício                                 | ✅ Yes    | URL validation performed (THM rate-limited, PicoCTF bot detected, PortSwigger/OTW/HTB validated) |
| D-03     | Prioridade: OSCP > Security+ > CEH                                       | ✅ Yes    | Priority ordering applied throughout reports (Crítico/Importante/Opcional)|
| D-04     | Comparação por módulo contra tópicos dos exames                          | ✅ Yes    | Each report has "Tópicos Ausentes (vs Certificações)" section            |
| D-05     | Validar labs existentes no LABS.md + buscar novos onde faltar            | ✅ Yes    | Existing labs read, new candidates listed per module                     |
| D-06     | Salas removidas/mudaram de nome: marcar + sugerir alternativa            | ✅ Yes    | Ustromia removed, level counts corrected, 4 broken links identified      |
| D-07     | Relatório por módulo (UMD): labs candidatos + tópicos ausentes + status  | ✅ Yes    | 12 UMD reports generated with all required sections                      |
| D-08     | Relatório consolidado no final com resumo geral                           | ✅ Yes    | CONSOLIDATED.md + PESQUISA-REPORT.md                                     |

### Human Verification Required

### 1. TryHackMe URL Validation

**Test:** Manually visit 5-10 TryHackMe room URLs from lab-matrix.csv in a browser and verify the rooms exist and are free (not premium)
**Expected:** Rooms should be accessible without subscription
**Why human:** TryHackMe blocks automated HTTP requests with 429 rate-limit — 73% of all URLs in the CSV are THM URLs marked as "pendente"

### 2. PicoCTF Challenge Validation

**Test:** Visit PicoCTF practice page (https://play.picoctf.org/practice) and verify that the challenge categories listed in the reports exist
**Expected:** General Skills, Cryptography, Web Exploitation, RE, Binary, Forensics, AI categories should be present
**Why human:** PicoCTF returns 403 to automated requests (bot detection)

### Gaps Summary

No blocking gaps found. All 3 success criteria are met, all 8 decisions addressed, all artifacts substantive and wired.

**Known limitation (not a gap):** 73% of URLs in lab-matrix.csv are pending manual validation due to TryHackMe rate-limiting (HTTP 429) and PicoCTF bot detection (HTTP 403). This is documented in the reports and is an operational constraint, not a phase failure. The labs are mapped and listed; validation requires browser access.

**Quality observations:**
- Module 04 (Pós-Exploração) has the largest gaps (7 critical) — OSCP 2026 AD emphasis not covered
- Module 02 (Web) benefits most from PortSwigger (155+ labs replacing DVWA monoculture)
- Module 00 has no LABS.md — needs creation in Phase 3
- 4 broken links identified in LABS.md (3 in module 06, 1 in module 10) — documented for Phase 3 correction

---

_Verified: 2026-09-10T23:15:00Z_
_Verifier: the agent (gsd-verifier)_
