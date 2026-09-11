# Phase 3 Plan Review — Modernização + Conteúdo Prático

**Reviewer:** gsd-plan-checker
**Date:** 2026-09-10
**Plans checked:** 7 (03-01 through 03-07)
**Verdict:** 🟡 **FLAG** — 1 blocker, 5 warnings

---

## Executive Summary

Phase 3 plans are well-structured, cover all 12 modules, implement all 14 decisions, and follow the Tool Card format consistently. The plans will achieve the phase goal **with one critical gap**: the RESEARCH.md has unresolved open questions that could cause execution errors (wrong OpenSCAP profile name, unknown CAI install method). This must be resolved before execution.

---

## Dimension 1: Requirement Coverage

| Requirement | Plans | Status |
|-------------|-------|--------|
| FERR-01 (Replace obsolete tools) | 03, 04, 05, 07 | ✅ COVERED |
| FERR-02 (Install commands for all tools) | 01-07 | ✅ COVERED |
| FERR-03 (Platform URLs functional) | 01-07 | ✅ COVERED |
| PRAT-01 (Expected output for commands) | 01-07 | ✅ COVERED |
| PRAT-02 (Complete tool blocks) | 01-07 | ✅ COVERED |
| PRAT-03 (Real verifiable labs) | 01-07 | ✅ COVERED |

All 6 requirements have explicit coverage in plan `requirements` frontmatter fields and in task actions.

---

## Dimension 2: Task Completeness

All 15 tasks across 7 plans have: `<files>`, `<action>`, `<verify>`, `<done>`.

| Plan | Tasks | Files | Complete? |
|------|-------|-------|-----------|
| 01 | 3 | 4 | ✅ |
| 02 | 2 | 4 | ✅ |
| 03 | 2 | 8 | ✅ |
| 04 | 2 | 12 | ✅ |
| 05 | 2 | 8 | ✅ |
| 06 | 2 | 13 | ✅ |
| 07 | 2 | 7 | ✅ |

Actions are specific with Tool Card references, file paths, and decision references (D-03, D-04, etc.).

---

## Dimension 3: Dependency Correctness

```
Wave 1: Plan 01 (Module 10), Plan 02 (Module 00) — no deps ✅
Wave 2: Plan 03 (Modules 04+05), Plan 04 (Modules 02+03) — depends on 01 ✅
Wave 3: Plan 05 (Modules 01+06), Plan 06 (Modules 07+08+09) — depends on 03,04 ✅
Wave 4: Plan 07 (Module 11) — depends on 05,06 ✅
```

No cycles. All referenced plans exist. Wave assignments consistent with dependencies.

**⚠️ Warning:** Plan 03 and Plan 04 both depend only on Plan 01 (module 10). They could theoretically also depend on Plan 02 (module 00), since module 00 is a prerequisite for all modules. However, this is a content independence issue, not a hard dependency — the plans don't import content from module 00. Acceptable.

---

## Dimension 4: Key Links Planned

| Plan | Key Link | Method | Status |
|------|----------|--------|--------|
| 01 | 01-grc → OpenSCAP | `oscap xccdf eval` | ✅ Planned |
| 01 | 01-grc → Lynis | `lynis audit system` | ✅ Planned |
| 02 | INSTALACAO → Kali | Installation instructions | ✅ Planned |
| 03 | 01-enum → BloodHound | `sharpound + bloodhound-python` | ✅ Planned |
| 03 | 01-reversa → Ghidra | `ghidraRun` | ✅ Planned |
| 04 | 01-brute → Metasploit | `msfconsole commands` | ✅ Planned |
| 04 | 04-api → OWASP API | BOLA, Mass Assignment | ✅ Planned |
| 05 | 02-osint → Subfinder | `subfinder command` | ✅ Planned |
| 05 | 01-sniff → tcpdump/tshark | capture commands | ✅ Planned |
| 06 | 02-siem → Wazuh | docker-compose | ✅ Planned |
| 06 | 01-forense → Volatility 3 | `vol.py commands` | ✅ Planned |
| 07 | 02-ia → CAI | `cai-cli commands` | ✅ Planned |
| 07 | 05-injection → OWASP LLM | LLM01 mapping | ✅ Planned |

All artifacts are wired, not created in isolation.

---

## Dimension 5: Scope Sanity

| Plan | Tasks | Files | Assessment |
|------|-------|-------|------------|
| 01 | 3 | 4 | ✅ Good |
| 02 | 2 | 4 | ✅ Good |
| 03 | 2 | 8 | ⚠️ High (8 files across 2 modules) |
| 04 | 2 | 12 | ⚠️ High (12 files across 2 modules) |
| 05 | 2 | 8 | ⚠️ High (8 files across 2 modules) |
| 06 | 2 | 13 | ⚠️ High (13 files across 3 modules) |
| 07 | 2 | 7 | ✅ Good |

Plans 04 and 06 exceed the 10-file warning threshold. Plan 04's Task 2 modifies 8 files in module 02 alone — this is a large single task. Plan 06 handles 3 modules in 2 tasks.

**Mitigating factor:** These are content authoring tasks (Markdown edits), not code. File count is less dangerous here than in code plans. The task actions are specific enough that execution quality should hold.

---

## Dimension 6: Verification Derivation

All plans have `must_haves` with:
- **Truths:** User-observable ("Leitor consegue rodar auditoria CIS", "Módulo 05 tem tutorial Ghidra")
- **Artifacts:** Paths, providers, min_lines
- **Key_links:** From → To → Via → Pattern

Truths are properly user-focused, not implementation-focused.

---

## Dimension 7: Context Compliance

### Decision Coverage

| Decision | Plan(s) | Status |
|----------|---------|--------|
| D-01 (Module-by-module) | All | ✅ Each plan processes 1-3 modules completely |
| D-02 (IMPROVEMENT-PLAN order) | All | ✅ Order: 10→04/05→00→02/03→01/06→07/08/09→11 |
| D-03 (Real Kali 2026 output) | All | ✅ Every task references "output real do Kali 2026" |
| D-04 (Install+use+output format) | All | ✅ Tool Card format in every task |
| D-05 (Replace LABS.md with 174 labs) | All | ✅ Each plan rewrites LABS.md from lab-matrix.csv |
| D-06 (Labs by platform) | All | ✅ "Labs por Plataforma" format with THM/PTF/OTW/PicoCTF/HTB |
| D-07 (Lab metadata: name, URL, difficulty, topics) | All | ✅ Table format with all columns |
| D-08 (Module 10: compliance practice) | 01 | ✅ OpenSCAP, Lynis, ALE, policy exercises |
| D-09 (Module 11: rewrite with AI tools) | 07 | ✅ 5 new files, CAI, prompt injection |
| D-10 (theHarvester → Subfinder) | 05 | ✅ Plan 05 Task 1 |
| D-11 (MITMf → bettercap) | 06 | ✅ Plan 06 Task 1 (02-proxy-e-anonimato.md) |
| D-12 (Armitage → msfconsole) | 04 | ✅ Plan 04 Task 1 (Metasploit Tool Card) |
| D-13 (Rekall → Volatility 3) | 06 | ✅ Plan 06 Task 1 (01-forense-computacional.md) |
| D-14 (Snort → Suricata) | 06 | ✅ Plan 06 Task 1 (02-monitoramento-e-siem.md) |

All 14 decisions covered. No deferred ideas included (CONTEXT.md says "None").

### Scope Reduction Detection

No scope reduction language found. No "v1", "simplified", "placeholder", "static for now" patterns.

---

## Dimension 7b: Scope Reduction Detection

**No scope reduction detected.** All decisions are delivered fully. No "v1/v2" versioning invented by planner.

---

## Dimension 8: Nyquist Compliance

RESEARCH.md has a `## Validation Architecture` section with automated verify commands.

**Check 8e — VALIDATION.md:** Not checked (no standalone VALIDATION.md file — validation is embedded in RESEARCH.md).

| Task | Plan | Wave | Automated Command | Status |
|------|------|------|-------------------|--------|
| T1 | 01 | 1 | `grep -c "oscap xccdf eval\|lynis audit system..."` | ✅ |
| T2 | 01 | 1 | `grep -c "Output esperado..."` | ✅ |
| T3 | 01 | 1 | `grep -c "TryHackMe\|OverTheWire..."` | ✅ |
| T1 | 02 | 1 | `grep -c "Kali Linux"` | ✅ |
| T2 | 02 | 1 | `grep -c "fail2ban\|ufw..."` + `test -f LABS.md` | ✅ |
| T1 | 03 | 2 | `grep -c "bloodhound\|ligolo..."` | ✅ |
| T2 | 03 | 2 | `grep -c "ghidra\|gdb..."` | ✅ |
| T1 | 04 | 2 | `grep -c "msfconsole\|searchsploit..."` | ✅ |
| T2 | 04 | 2 | `grep -c "BOLA\|Mass Assignment..."` | ✅ |
| T1 | 05 | 3 | `grep -c "subfinder"` | ✅ |
| T2 | 05 | 3 | `grep -c "Output esperado..."` | ✅ |
| T1 | 06 | 3 | `grep -c "Output esperado..."` (both modules) | ✅ |
| T2 | 06 | 3 | `grep -c "trivy\|kube-hunter\|Falco..."` | ✅ |
| T1 | 07 | 4 | `test -f 01-... && test -f 05-...` + `wc -l README` | ✅ |
| T2 | 07 | 4 | `grep -c "PicoCTF\|TryHackMe..."` | ✅ |

**Sampling:** Every wave has ≥2 tasks with automated verify. ✅

---

## Dimension 9: Cross-Plan Data Contracts

No conflicting data transforms detected. All plans operate on independent module directories. The shared data source (lab-matrix.csv) is read-only — no plan transforms it.

---

## Dimension 10: AGENTS.md Compliance

| AGENTS.md Directive | Plan Compliance |
|---------------------|-----------------|
| Kali Linux only | ✅ All commands assume Kali |
| Scope: aprendizado/cyberseguranca/ | ✅ All files in this directory |
| Structure: README.md + numbered + LABS.md | ✅ All plans follow this pattern |
| Core value: install + use + output | ✅ Tool Card format in every task |
| PT-BR language | ✅ All content in Portuguese |

---

## Dimension 11: Research Resolution

**🔴 BLOCKER:** RESEARCH.md `## Open Questions` section does NOT have `(RESOLVED)` suffix.

Three open questions remain:

1. **OpenSCAP profile name on Kali 2026** — Could be `ssg-kali-ds.xml` or `ssg-debian-ds.xml`. Plan 01 Task 1 uses `ssg-kali-ds.xml` — if wrong, the exercise command fails.
2. **CAI installation method** — Plan 07 says `pip install cai-cli` or GitHub. If method changed, the Tool Card is wrong.
3. **Module 00 LABS.md scope** — Partially resolved (plan creates it), but question 4 about INSTALACAO.md rewrite scope is resolved (plan 02 handles it).

These are LOW-MEDIUM risk but could cause execution rework if wrong.

---

## Dimension 12: Pattern Compliance

No standalone PATTERNS.md for this phase. Plans reference RESEARCH.md patterns (Tool Card, Terminal Output Capture, LABS.md Format, GRC Exercise Structure, Module 11 Rewrite). All references are correct.

---

## Issues Summary

### Blockers (must fix before execution)

**1. [research_resolution] RESEARCH.md Open Questions not resolved**
- File: `03-RESEARCH.md`
- Description: `## Open Questions` section lacks `(RESOLVED)` suffix. Three questions unresolved: OpenSCAP profile name, CAI install method, INSTALACAO.md scope.
- Risk: Plan 01 uses `ssg-kali-ds.xml` which may be wrong (could be `ssg-debian-ds.xml`). Plan 07 uses `pip install cai-cli` which may be outdated.
- Fix: Verify OpenSCAP profile on actual Kali 2026 install. Check CAI official docs for current install method. Mark section as `(RESOLVED)` with findings.

### Warnings (should fix)

**1. [scope_sanity] Plan 06 has 13 files across 3 modules**
- Plan: 06
- Files: 13 (module 07: 4, module 08: 4, module 09: 5)
- Risk: Context budget strain during execution
- Fix: Consider splitting into 06a (modules 07+08) and 06b (module 09)

**2. [scope_sanity] Plan 04 has 12 files across 2 modules**
- Plan: 04
- Files: 12 (module 03: 4, module 02: 8)
- Risk: Module 02 alone has 8 files — Task 2 is large
- Fix: Consider splitting module 02 into its own plan

**3. [scope_sanity] Plan 03 has 8 files across 2 modules**
- Plan: 03
- Files: 8 (module 04: 4, module 05: 4)
- Risk: Moderate — two independent modules combined
- Fix: Acceptable if execution quality holds; split if issues arise

**4. [scope_sanity] Plan 05 has 8 files across 2 modules**
- Plan: 05
- Files: 8 (module 01: 4, module 06: 4)
- Risk: Moderate — two independent modules combined
- Fix: Acceptable

**5. [task_completeness] Plan 06 Task 2 has no README update for module 09**
- Plan: 06, Task: 2
- Description: Task 2 modifies `09-ambientes/README.md` but action doesn't mention updating it (only mentions 01/02/03 content files + LABS.md)
- Fix: Add explicit README update instruction to Task 2 action

---

## Module Coverage Matrix

| Module | Plan | Wave | Status |
|--------|------|------|--------|
| 00-pre-requisitos | 02 | 1 | ✅ |
| 01-reconhecimento | 05 | 3 | ✅ |
| 02-web-aplicacoes | 04 | 2 | ✅ |
| 03-exploracao | 04 | 2 | ✅ |
| 04-pos-exploracao | 03 | 2 | ✅ |
| 05-reversing | 03 | 2 | ✅ |
| 06-analise-rede | 05 | 3 | ✅ |
| 07-defesa | 06 | 3 | ✅ |
| 08-resposta | 06 | 3 | ✅ |
| 09-ambientes | 06 | 3 | ✅ |
| 10-governanca | 01 | 1 | ✅ |
| 11-ia-cyberseguranca | 07 | 4 | ✅ |
| INSTALACAO.md | 02 | 1 | ✅ |

All 12 modules + INSTALACAO.md covered.

---

## Verdict

```
🟡 FLAG
```

**1 blocker** must be resolved: RESEARCH.md open questions (OpenSCAP profile name, CAI install method) need verification before execution to prevent wasted rework.

**5 warnings** are quality improvements — plans can execute but may benefit from splitting large plans (04, 06) if context budget becomes tight.

**Recommendation:** Resolve the research questions (verify OpenSCAP profile on Kali, check CAI docs), mark RESEARCH.md as `(RESOLVED)`, then proceed to execution.

---

*Reviewed: 2026-09-10 | Plans: 7 | Tasks: 15 | Modules: 13 | Requirements: 6/6 covered | Decisions: 14/14 covered*
