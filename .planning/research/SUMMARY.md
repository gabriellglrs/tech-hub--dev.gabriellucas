# Research Summary — Trilha de Aprendizado em Cybersegurança

**Project:** Trilha de Aprendizado em Cybersegurança
**Domain:** Educational content — 12-module cybersecurity course (PT-BR)
**Researched:** 2026-09-10
**Confidence:** HIGH

## Executive Summary

This is a **content modernization project**, not a software build. The 12-module cybersecurity learning trail already exists in `aprendizado/cyberseguranca/` but suffers from outdated tool recommendations, broken lab links, thin real-world examples, and an inconsistent command format. The core value — "copy-paste commands that work on current Kali" — is sound but needs rigorous verification against 2025/2026 tool versions. The trail's major differentiator is being the **only comprehensive cybersecurity course in PT-BR** with hands-on, "apt to FAZER" methodology.

The recommended approach is a **module-by-module audit and rewrite** starting with foundations (Module 00), then working through offensive modules (01-04), defensive modules (07-08), and specialty modules (05, 06, 09-11). Every module must follow the standardized Command Block pattern: concept → installation → command with flags → expected output → error handling. Modern Go-based tools (Subfinder, Nuclei, ffuf) need to replace or supplement outdated ones (MITMf, Armitage, theHarvester-only recon).

The primary risks are **content staleness** (tools deprecate, platform links break, Kali versions drift) and **theoretical filler** (especially in Defense and AI modules). Mitigation requires quarterly audits, explicit error guidance in every command block, and focusing the AI module on concepts rather than specific tools. The OSCP+ exam restrictions (no SQLMap, no mass scanners) must be documented per-module to avoid teaching students habits that fail certification exams.

## Key Findings

### Recommended Stack (Teaching Tools)

The course teaches cybersecurity tools, not software libraries. All tools must be verified as **currently maintained, Kali-compatible, and actively used by practitioners in 2026**.

**Core tools by module:**

| Module | Primary Tools | Platform |
|--------|--------------|----------|
| 00 Pre-requisitos | Kali setup, Python 3.11+, Go 1.22+, Docker | TryHackMe Pre-Security |
| 01 Reconhecimento | Nmap 7.95+, Subfinder 2.6+, Shodan CLI, Maltego | TryHackMe Recon rooms |
| 02 Web Aplicações | Burp Suite 2025.x, ffuf 2.x, SQLMap 1.8+, Nuclei 3.x, HTTPX | PortSwigger Academy |
| 03 Exploração | Metasploit 6.x, Hydra 9.x, Hashcat 6.x, CrackMapExec 5.x | TryHackMe + HackTheBox |
| 04 Pós-exploração | LinPEAS/WinPEAS, BloodHound CE 5.x, Impacket 0.12+, evil-winrm | HackTheBox + THM AD rooms |
| 05 Reversing | Ghidra 12.1+, x64dbg/GDB, YARA, CyberChef | OverTheWire + PicoCTF |
| 06 Análise de Rede | Wireshark 4.x, tcpdump, Bettercap, Nmap | TryHackMe Network rooms |
| 07 Defesa | Wazuh 4.14+, Suricata 7.x, Sigma, Fail2Ban | TryHackMe SOC Level 1 |
| 08 Resposta | Volatility 3, Autopsy 4.x, Sleuth Kit, ExifTool | TryHackMe Forensics rooms |
| 09 Ambientes | Docker, Cloud CLIs, Aircrack-ng, MobSF | TryHackMe + HackTheBox |
| 10 Governança | NIST CSF 2.0, MITRE ATT&CK, OWASP Top 10 (2025), CIS | Reference docs + case studies |
| 11 IA | CAI (Alias Robotics), Gideon (Cogensec), HTB AI modules | HTB Academy AI path |

**Critical additions needed:** Subfinder + Nuclei (recon modernization), ffuf (web fuzzing), HTTPX (HTTP probing), BloodHound CE (AD attack paths), Wazuh Docker labs (defense hands-on).

### Expected Features

**Must have (table stakes):**
- Command + flags + expected output per tool — core value proposition
- Verified Kali setup guide (Module 00) — students can't start without it
- Working LABS.md per module with current TryHackMe/PortSwigger links
- Progressive difficulty (00-11 ordering is correct)
- Glossary of terms (GLOSSARIO.md — exists, needs updates)
- Tool installation commands with "✅ Pre-installed" or install command

**Should have (competitive):**
- PT-BR content — only comprehensive Portuguese cybersecurity trail
- Copy-paste-ready commands — "leigo total" can follow without understanding
- OSCP/CEH/Security+ alignment notes per module
- Free-first lab recommendations — no paid tools required for core learning
- Anti-patterns sections — "what NOT to do" per module
- English output annotated in PT-BR — students confused by raw English tool output

**Defer (v2+):**
- Advanced navigation (search, filters) — nice-to-have, not blocking
- Portuguese video supplements — high effort, defer to community
- Certification practice exams — out of scope for course content
- Offline export (PDF/ZIP) — explicitly out of scope in PROJECT.md

### Architecture Approach

The trail follows a **linear progressive structure** with 12 modules (00-11), each containing standardized content files. This is correct for a learning trail — it provides clear progression while allowing students to jump to specific topics. The existing directory structure is sound and should be maintained.

**Standardized module structure:**
- `README.md` — module navigation, learning objectives, tool table, prerequisites
- `XX-topic.md` — conceptual explanation + hands-on command blocks
- `LABS.md` — practice exercises with platform links (TryHackMe, PortSwigger, OverTheWire)
- All commands follow: concept → install → command with flags → expected output → error handling

**Key anti-patterns to enforce:**
1. Theory without commands — every concept gets "how to do it"
2. Outdated tool recommendations — verify maintenance status quarterly
3. No error guidance — every command block needs "Se der erro:" section
4. Skipping Kali pre-installation notes — every tool marked ✅ or ❌
5. Platform links without context — specify room names and difficulty

### Critical Pitfalls

1. **Tool Deprecation Without Detection** — Tools get abandoned, APIs change, commands break. Quarterly tool audit with GitHub last-commit checks. Current risks: theHarvester (data sources closing), MITMf (unmaintained), Armitage (abandoned).

2. **Platform Link Rot** — TryHackMe rooms renamed/moved, PortSwigger URLs change. Monthly automated link checking. Students clicking 404s destroy trust.

3. **Kali Linux Version Drift** — Commands on Kali 2023 fail on Kali 2025/2026. Test all commands on current Kali; note version in each module.

4. **OSCP Exam Changes Breaking Alignment** — OffSec changes exam format periodically. Monitor announcements; update alignment notes after each change. Current restrictions: no SQLMap, no mass scanners (Nessus, OpenVAS), no AI chatbots; Metasploit limited to ONE target.

5. **Defense Module Remains Theoretical** — Module 07 explains concepts but has no hands-on labs. Design Wazuh/Suricata Docker labs; create step-by-step defense scenarios.

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Foundation & Infrastructure
**Rationale:** Module 00 must be correct first — it's the prerequisite for all other modules. ROADMAP.md needs updating. Command block standard must be defined before content rewrite begins.
**Delivers:** Verified Module 00 (Kali setup, networking, Linux, security basics), updated ROADMAP.md, command block template, LABS.md format standard.
**Addresses:** Kali setup guide, tool installation commands, progressive difficulty foundation.
**Avoids:** Pitfall #3 (Kali version drift) — test all commands on current Kali.

### Phase 2: Offensive Core (Modules 01-04)
**Rationale:** Recon → Web → Exploitation → Post-Exploitation is the core learning path. These modules have the highest student engagement and most existing content. Modern tools (Subfinder, Nuclei, ffuf) need integration.
**Delivers:** Updated Modules 01-04 with current tools, working command blocks, working LABS.md links.
**Addresses:** Copy-paste-ready commands, OSCP alignment notes, modern tool recommendations (Subfinder, Nuclei, ffuf, BloodHound).
**Avoids:** Pitfall #1 (tool deprecation) — replace theHarvester-only recon with Subfinder+Shodan; Pitfall #5 (OSCP restrictions) — note SQLMap/Metasploit exam limits.

### Phase 3: Specialty Modules (Modules 05-06, 09-11)
**Rationale:** Reversing, Network Analysis, Special Environments, Governance, and AI modules are more self-contained. AI module (11) needs special handling — focus on concepts, not specific tools.
**Delivers:** Updated Modules 05, 06, 09, 10, 11 with current tools and content.
**Addresses:** Ghidra as primary RE tool (not IDA Free), concept-focused AI module, governance references (NIST CSF 2.0, MITRE ATT&CK).
**Avoids:** Pitfall #7 (AI module becomes stale) — teach concepts not tools; Pitfall #11 (too many tools per module) — limit to 3-5 primary tools.

### Phase 4: Defense & Response (Modules 07-08)
**Rationale:** Defense and Incident Response modules need the most work — they're currently theoretical. Requires Docker lab setup for Wazuh/Suricata. Benefits from offensive modules being done first (understanding attacks enables defense).
**Delivers:** Hands-on defense labs (Wazuh Docker, Suricata), updated forensics content, Volatility 3 + Autopsy workflows.
**Addresses:** Defense module hands-on requirement, Wazuh SIEM labs, forensics tool updates.
**Avoids:** Pitfall #6 (defense module theoretical) — design and test Docker labs before writing content.

### Phase 5: Polish, Navigation & Cross-Cutting
**Rationale:** Final phase ties everything together — glossary updates, cheat sheet sync, cross-module links, advanced navigation, final quality audit.
**Delivers:** Updated GLOSSARIO.md, synchronized CHEATSHEET files, advanced navigation, final LABS.md link audit.
**Addresses:** Glossary missing new terms, cheat sheets out of sync, platform link rot prevention.
**Avoids:** Pitfall #9 (cheat sheets out of sync), Pitfall #10 (glossary missing terms), Pitfall #2 (link rot).

### Phase Ordering Rationale

- **Foundation first:** Module 00 is prerequisite for everything; command standard must exist before content rewrite
- **Offensive before defensive:** Students must understand attacks (01-04) before defending against them (07-08) — this mirrors real cybersecurity learning and the THM/HTB learning paths
- **Specialty modules grouped:** 05-06, 09-11 are self-contained and can be batched
- **Defense last (of content):** Requires most new lab work; benefits from offensive context
- **Polish final:** Cross-cutting concerns need all content to exist first

### Research Flags

**Needs research during planning:**
- **Phase 1:** Verify all Module 00 commands on current Kali 2025/2026 — need fresh install testing
- **Phase 2:** Verify current Subfinder/Nuclei/ffuf installation commands on Kali — Go-based tooling may have changed
- **Phase 4:** Design Wazuh Docker lab — need to verify current Docker compose file works, test SIEM data flow
- **Phase 5:** Automated link checking tool selection — need to evaluate options for quarterly audits

**Standard patterns (skip research-phase):**
- **Phase 3:** Module structure is well-defined; content follows established command block pattern
- **Phase 5:** Glossary/cheat sheet updates are mechanical tasks following existing patterns

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Tools verified against current documentation, pricing, and Kali package status. 360 lines of source references. |
| Features | HIGH | Derived from PROJECT.md requirements, existing content structure, and competitive analysis (THM, HTB, PortSwigger). |
| Architecture | HIGH | Verified against actual filesystem structure. Patterns well-documented from existing modules. |
| Pitfalls | HIGH | Based on OSCP+ exam guide (2026), platform change tracking, and tool maintenance status. |

**Overall confidence:** HIGH

### Gaps to Address

- **Kali 2026 package verification:** Need to test all installation commands on fresh Kali 2025/2026 install — some Go-based tool paths may have changed
- **Wazuh Docker lab design:** No existing lab to reference; need to design from scratch during Phase 4 planning
- **BloodHound CE vs native:** Need to decide between Docker or native install for AD labs — Docker preferred for portability but CE version may have changed
- **PortSwigger lab URLs:** Some labs may have been restructured since research — need live verification during Phase 2
- **Module 09 (Ambientes):** Cloud/wireless/mobile content is the thinnest module — may need significant research during Phase 3

## Sources

### Primary (HIGH confidence)
- PROJECT.md — project requirements, constraints, and current state
- OSCP+ Exam Guide (Apr 2026) — tool restrictions and exam format
- TryHackMe: "Jr Penetration Tester Learning Path Rebuilt for 2026"
- PortSwigger Web Security Academy — lab structure and categories
- PEASS-ng GitHub — LinPEAS/WinPEAS current versions
- Alias Robotics CAI Framework (2025) — AI security tooling

### Secondary (MEDIUM confidence)
- HTB Academy catalog and pricing (Sep 2026)
- SecurityElites certification comparison (Mar 2026)
- Hadrian: "AI Hacking Boom: 70 New Offensive Security Tools" (Apr 2026)
- Breachfolio: "Splunk vs Wazuh vs ELK" (Jul 2026)

### Tertiary (LOW confidence)
- CrowdStrike SafeMind (Sep 2026) — enterprise AI, limited public documentation
- PentestGPT — academic research tool, not production-ready

---
*Research completed: 2026-09-10*
*Ready for roadmap: yes*
