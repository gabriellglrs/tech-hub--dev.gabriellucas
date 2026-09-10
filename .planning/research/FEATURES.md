# Feature Landscape

**Domain:** Cybersecurity learning trail (12-module educational course)
**Researched:** 2026-09-10

## Table Stakes

Features users expect in a cybersecurity learning trail. Missing = course feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| **Command + flags + expected output** | Core value proposition of the trail | Low | Already in PROJECT.md as non-negotiable |
| **Kali Linux setup guide** | Students need a working environment | Low | Module 00 exists but needs verification |
| **Progressive difficulty** | Learning theory requires scaffolding | Medium | Current 00-11 order is correct |
| **Hands-on labs per module** | Theory without practice is worthless | Medium | LABS.md exists but needs current links |
| **Glossary of terms** | Beginners encounter constant new vocabulary | Low | GLOSSARIO.md exists |
| **Tool installation commands** | Students can't use tools they can't install | Low | Need to verify all install commands work on current Kali |
| **Real-world examples** | Abstract concepts need concrete context | Medium | Currently thin in most modules |
| **Practice platform links** | Students need places to practice | Low | TryHackMe, PortSwigger, HTB links needed per module |
| **Cheat sheets** | Quick reference during practice | Low | 3 CHEATSHEET files exist, need updates |

## Differentiators

Features that set this trail apart from free content online. Not expected, but valued.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| **PT-BR content** | Only comprehensive cybersecurity trail in Portuguese | High | Major differentiator for Brazilian audience |
| **Copy-paste-ready commands** | "Leigo total" can follow along without understanding | Medium | Core value — every command must work as-is |
| **OSCP/CEH/Security+ alignment** | Course prepares for industry certifications | Medium | Need explicit mapping per module |
| **Free-first lab recommendations** | Students don't need to pay to practice | Low | TryHackMe free rooms, PortSwigger, OverTheWire |
| **Tool comparison tables** | Students know which tool to use when | Low | Already partially in content |
| **Anti-patterns sections** | Students know what NOT to do | Low | Currently missing from most modules |
| **Career guidance per module** | Students know which jobs use these skills | Medium | Currently absent |

## Anti-Features

Features to explicitly NOT build.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| **Video content** | Out of scope, markdown-only course | Link to YouTube tutorials where relevant |
| **Offline export (PDF/ZIP)** | Explicitly out of scope in PROJECT.md | Keep web-only navigation |
| **Custom lab environments** | Out of scope — use existing platforms | Link to TryHackMe, HTB, PortSwigger labs |
| **Hardware hacking** | Explicitly out of scope | Mention in glossary only |
| **Paid tool recommendations as primary** | Target audience is beginners who can't pay | Free tools first, paid references with warnings |
| **English content** | Public is Brazilian, content stays PT-BR | All content in Portuguese |

## Feature Dependencies

```
Kali Setup (00) → All other modules (must have working environment)
Linux Basics (00) → Recon (01), Exploitation (03), Reversing (05)
Networking Basics (00) → Web (02), Network Analysis (06), Defense (07)
Web Basics (00) → Web Applications (02)
Recon (01) → Web (02), Exploitation (03)
Exploitation (03) → Post-Exploitation (04)
Post-Exploitation (04) → Defense (07), Incident Response (08)
All offensive modules → Defense (07) (understanding attacks enables defense)
Defense (07) → Incident Response (08)
```

## MVP Recommendation

**Must have for first release:**
1. All 12 modules with verified, working commands
2. Current tool versions (Subfinder, Nuclei, ffuf added to recon/web)
3. LABS.md with working TryHackMe/PortSwigger links
4. Module 00 with verified Kali setup instructions
5. Module 07 with Wazuh lab (currently theoretical)

**Should have:**
6. OSCP/CEH/Security+ alignment notes per module
7. BloodHound AD lab for Modules 03-04
8. Updated AI module (Module 11) with CAI and current tools

**Defer:**
9. Advanced navigation (search, filters) — nice-to-have, not blocking
10. Portuguese video supplements — high effort, defer to community
11. Certification practice exams — out of scope for course content

## Sources

- PROJECT.md requirements analysis
- TryHackMe learning path structure (2026)
- HTB Academy module catalog (2026)
- PortSwigger Academy lab categories (current)
- OSCP+ exam guide (2026)
