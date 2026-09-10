# Domain Pitfalls

**Domain:** Cybersecurity learning trail (educational course)
**Researched:** 2026-09-10

## Critical Pitfalls

Mistakes that cause the trail to become outdated or unusable.

### Pitfall 1: Tool Deprecation Without Detection
**What goes wrong:** A tool the trail teaches gets abandoned or its API changes, breaking all command examples
**Why it happens:** Cybersecurity tools have short lifecycles; authors move on; GitHub repos go stale
**Consequences:** Students run commands that fail, lose trust in the trail, abandon learning
**Prevention:** Quarterly tool audit — check GitHub last-commit date, Kali package status, and community usage
**Detection:** Monitor for: GitHub repo archived, no commits in 6+ months, Kali package removed, community forum complaints

**Current risk tools (verify quarterly):**
- theHarvester — many data sources closing APIs
- MITMf — largely unmaintained
- Armitage — abandoned
- SET (Social Engineering Toolkit) — limited updates

### Pitfall 2: Platform Link Rot
**What goes wrong:** TryHackMe rooms get renamed, moved, or removed; PortSwigger labs change URLs
**Why it happens:** Platforms restructure content; rooms get archived; URLs change
**Consequences:** Students click links that 404, lose confidence in the trail
**Prevention:** Automated link checking (quarterly), or manual verification during audits
**Detection:** Monthly link check via automated tool or manual spot-check

### Pitfall 3: Kali Linux Version Drift
**What goes wrong:** Commands that worked on Kali 2023 don't work on Kali 2025/2026 due to package changes
**Why it happens:** Kali rolls updates; package names change; default tools get replaced
**Consequences:** Students on current Kali get errors; trail feels outdated
**Prevention:** Test all commands on current Kali before publishing; note Kali version in each module
**Detection:** Students report errors; test on fresh Kali install quarterly

### Pitfall 4: OSCP Exam Changes Breaking Trail Alignment
**What goes wrong:** OffSec changes OSCP exam format (happened in 2022, 2024, 2026), trail no longer aligns
**Why it happens:** OffSec periodically updates exam structure and restrictions
**Consequences:** Trail claims to prepare for OSCP but doesn't match current exam
**Prevention:** Monitor OffSec announcements; update exam alignment notes after each change
**Detection:** OffSec blog posts, community discussion, exam guide updates

## Moderate Pitfalls

### Pitfall 5: Teaching Tools That Violate Exam Restrictions
**What goes wrong:** Trail teaches SQLMap or Nessus as primary tools, but OSCP+ prohibits them
**Why it happens:** These tools are useful in real pentesting but banned in exams
**Consequences:** Students develop habits that fail them in certification exams
**Prevention:** Explicitly note "OSCP Exam Restriction" next to restricted tools; teach alternatives
**Detection:** Compare tool usage against current OSCP+ exam guide restrictions

### Pitfall 6: Defense Module Remains Theoretical
**What goes wrong:** Module 07 (Defesa) explains concepts but has no hands-on labs
**Why it happens:** Setting up SIEM/IDS labs is harder than offensive labs
**Consequences:** Trail is offense-heavy, defense module feels like filler
**Prevention:** Design Wazuh/Suricata Docker labs; create step-by-step defense scenarios
**Detection:** Student feedback; comparison with THM SOC Level 1 path

### Pitfall 7: AI Module Becomes Stale Immediately
**What goes wrong:** Module 11 (IA) documents tools that change monthly
**Why it happens:** AI cybersecurity is the fastest-moving domain in security
**Consequences:** Content is outdated within months of publication
**Prevention:** Focus on concepts (prompt injection, AI in SOC, AI-powered scanning) rather than tool-specific workflows; link to active research repos
**Detection:** Tool GitHub repos changing rapidly; new papers every month

### Pitfall 8: Portuguese Translation of English-Only Tool Output
**What goes wrong:** Trail tells students to look for specific output, but tool outputs in English
**Why it happens:** Most security tools only output in English
**Consequences:** Brazilian students get confused by English output they don't understand
**Prevention:** Include actual English output screenshots/text with PT-BR annotations
**Detection:** Student confusion reported in labs

## Minor Pitfalls

### Pitfall 9: Cheat Sheets Get Out of Sync
**What goes wrong:** CHEATSHEET files reference tools or commands that changed
**Why it happens:** Cheat sheets are created once and rarely updated
**Consequences:** Quick reference becomes unreliable
**Prevention:** Version-stamp cheat sheets; update during quarterly audits

### Pitfall 10: Glossary Missing New Terms
**What goes wrong:** New modules introduce terms not in GLOSSARIO.md
**Why it happens:** Authors focus on content, forget to update glossary
**Consequences:** Beginners encounter undefined terms
**Prevention:** Review glossary after each module update

### Pitfall 11: Too Many Tools Per Module
**What goes wrong:** Module tries to cover 15 tools instead of 5 essential ones
**Why it happens:** Author wants to be comprehensive
**Consequences:** Beginners get overwhelmed; can't master any tool
**Prevention:** Limit to 3-5 primary tools per module; list alternatives in a table

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Recon (01) | Teaching theHarvester without Subfinder/Nuclei | Add modern Go-based tools |
| Web (02) | Missing CSRF module (OWASP 2025) | Add CSRF content, link to PortSwigger |
| Exploitation (03) | Teaching Metasploit without noting OSCP restrictions | Add exam restriction notes |
| Post-Exploitation (04) | No BloodHound/AD content | Add AD attack chain module |
| Reversing (05) | Teaching IDA Free instead of Ghidra | Ghidra is free and broader |
| Defense (07) | Theoretical only, no labs | Design Wazuh Docker labs |
| AI (11) | Tool-specific content that ages fast | Focus on concepts, link to research |

## Sources

- OSCP+ Exam Guide (Apr 2026) — tool restrictions
- TryHackMe blog — room changes and path rebuilds (2026)
- HTB Academy pricing update (Sep 2026) — platform changes
- Hadrian: "AI Hacking Boom" (Apr 2026) — tool proliferation rate
- PEASS-ng GitHub — active tool maintenance status
- SecurityElites certification comparison (Mar 2026) — exam format changes
