# Technology Stack — Cybersecurity Learning Trail

**Domain:** Cybersecurity education (12-module learning trail)
**Researched:** 2026-09-10
**Overall confidence:** HIGH (tools verified against current documentation, pricing, and platform status)

---

## Executive Summary

This stack defines the **current 2025/2026 best-in-class tools** for each cybersecurity domain covered in the trail. Every tool is either pre-installed in Kali Linux or freely available. The trail assumes Kali Linux as the single operating system, so tools that ship with Kali get priority.

**Key principle:** Use tools that are (1) currently maintained, (2) widely adopted by practitioners, (3) aligned with OSCP/CEH/Security+ exam objectives, and (4) available on Kali Linux.

---

## Recommended Stack

### 0. Base Environment

| Technology | Version/Status | Purpose | Why | Kali? |
|------------|---------------|---------|-----|-------|
| **Kali Linux** | 2025.x rolling | Offensive security distro | Industry standard, ships with 600+ security tools, pre-configured for pentesting | ✅ IS the environment |
| **VirtualBox** or **VMware Workstation Pro** | Current | VM hypervisor | Free, cross-platform, supports snapshots for lab recovery | — |
| **Python 3** | 3.11+ | Scripting/automation | Required for most tool customizations, exploit development, and tool chains | ✅ Pre-installed |
| **Go (golang)** | 1.22+ | Build modern tools | Many new-gen tools (Subfinder, Nuclei, Sliver) are written in Go | ❌ Install: `apt install golang` |
| **Docker** | Current | Isolated lab environments | Run vulnerable apps (DVWA, Juice Shop, WebGoat) without host contamination | ✅ Pre-installed |

---

### 1. Reconnaissance & Enumeration

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Nmap** | 7.95+ | Port scanning, service detection, OS fingerprinting, NSE scripts | ✅ Pre-installed | HIGH — undisputed industry standard |
| **theHarvester** | 4.x | Email, subdomain, IP harvest from public sources | ✅ Pre-installed | HIGH — but modern alternatives eat into its lunch |
| **Recon-ng** | 5.x | Modular OSINT framework with workspace tracking | ✅ Pre-installed | HIGH — best for structured, repeatable recon |
| **Subfinder** | 2.6+ | Passive subdomain enumeration (40+ sources) | ❌ `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` | HIGH — replaces Amass for most use cases |
| **Amass** | 4.x | Attack-surface mapping, subdomain discovery | ✅ Pre-installed | MEDIUM — Subfinder is faster for passive; Amass better for active |
| **Shodan CLI** | Current | Internet-wide device/service search | ❌ `pip install shodan` | HIGH — essential for passive recon |
| **Maltego** | Community Ed. | Visual link analysis, relationship graphs | ✅ Pre-installed | HIGH — best for visualizing OSINT relationships |
| **SpiderFoot** | 3.x | Automated OSINT collection with web UI | ❌ `pip install spiderfoot` | MEDIUM — good alternative to Recon-ng for web-UI preference |
| **DNSRecon** | Current | DNS enumeration, zone transfers, cache snooping | ✅ Pre-installed | HIGH — lightweight DNS-specific tool |
| **WhatWeb** | Current | Web fingerprinting (CMS, frameworks, WAFs) | ✅ Pre-installed | HIGH — fast technology identification |
| **Wappalyzer** | Browser ext. | Technology stack identification | Browser extension | MEDIUM — complementary to WhatWeb |
| **Crt.sh** | Web/API | Certificate transparency log search | Web-based | HIGH — free, no API key needed |
| **Wayback Machine** | Web | Historical web page snapshots | Web-based | HIGH —发现old admin paths, retired hosts |

**Anti-pattern: theHarvester alone is insufficient in 2026.** Many data sources have restricted their APIs. Use it for breadth, but layer with Subfinder for subdomain depth and Shodan/Censys for service exposure.

---

### 2. Web Application Testing

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Burp Suite Community** | 2025.x | HTTP proxy, repeater, intruder, spider | ✅ Pre-installed | HIGH — industry standard for web testing |
| **OWASP ZAP** | 2.x | Free/open-source web proxy, active scanner | ✅ Pre-installed | HIGH — Burp alternative, fully free |
| **ffuf** | 2.x | Fast web fuzzer (directories, parameters, vhosts) | ❌ `go install github.com/ffuf/ffuf/v2@latest` | HIGH — replaces Gobuster for speed |
| **Gobuster** | 3.x | Directory/DNS/vhost brute-forcer | ✅ Pre-installed | HIGH — still widely used, simpler than ffuf |
| **Nuclei** | 3.x | Template-based vulnerability scanner (9000+ templates) | ❌ `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` | HIGH — massive community template library |
| **SQLMap** | 1.8+ | Automated SQL injection detection and exploitation | ✅ Pre-installed | HIGH — unmatched for SQLi |
| **Nikto** | 2.x | Web server vulnerability scanner | ✅ Pre-installed | MEDIUM — older, but still useful for quick scans |
| **WPScan** | Current | WordPress-specific vulnerability scanner | ✅ Pre-installed | HIGH — essential for WP targets |
| **Wafw00f** | Current | WAF detection fingerprinting | ✅ Pre-installed | HIGH — know your WAF before testing |
| **Curl** | Current | HTTP requests, header inspection, API testing | ✅ Pre-installed | HIGH — fundamental tool |
| **HTTPX** | Current | HTTP probing, tech detection, status codes | ❌ `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` | HIGH — modern replacement for curl-based probing |

**PortSwigger Web Security Academy** (portswigger.net/web-security): **100% free**, the single best resource for web security learning. Labs are current, constantly updated, and cover the full OWASP Top 10 (2025). Use alongside Burp Suite.

---

### 3. Exploitation & Vulnerability Validation

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Metasploit Framework** | 6.x | Exploit development, payload generation, post-exploitation | ✅ Pre-installed | HIGH — 2,300+ modules, industry standard for cert prep |
| **Searchsploit** | Current | Offline Exploit-DB search (companion to Metasploit) | ✅ Pre-installed | HIGH — fast CVE exploit lookup |
| **Nmap NSE Scripts** | Current | Vulnerability scanning via Lua scripts | ✅ Pre-installed | HIGH — `--script vuln` for quick checks |
| **Nuclei** | 3.x | Template-based CVE detection (see Web section) | ❌ | HIGH — 9000+ community templates |
| **CrackMapExec** | 5.x | Network service exploitation (SMB, SSH, WinRM, LDAP) | ✅ Pre-installed | HIGH — essential for AD environments |
| **Impacket** | 0.12+ | Python network protocol toolkit (SMB, DCOM, Kerberos, etc.) | ✅ Pre-installed | HIGH — required for OSCP AD attacks |
| **Responder** | Current | LLMNR/NBT-NS/MDNS poisoning, credential capture | ✅ Pre-installed | HIGH — critical for AD poisoning attacks |
| **Hydra** | 9.x | Online password brute-forcing (SSH, FTP, HTTP, etc.) | ✅ Pre-installed | HIGH — fast, multi-protocol |
| **Medusa** | Current | Parallel network login brute-forcer | ✅ Pre-installed | MEDIUM — Hydra alternative |
| **John the Ripper** | Current | Offline password hash cracking | ✅ Pre-installed | HIGH — broad hash format support |
| **Hashcat** | 6.x | GPU-accelerated password hash cracking | ✅ Pre-installed | HIGH — fastest hash cracker, 300+ hash types |

**OSCP Exam Restrictions (2026):** No SQLMap (automatic exploitation), no mass scanners (Nessus, OpenVAS), no AI chatbots. Metasploit limited to ONE target machine. Allowed: BloodHound, Impacket, CrackMapExec, Mimikatz, evil-winrm, Responder.

---

### 4. Post-Exploitation & Privilege Escalation

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **LinPEAS** | Latest | Linux privilege escalation enumeration | ❌ `curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh \| sh` | HIGH — colorized, comprehensive, auto-detects vectors |
| **WinPEAS** | Latest | Windows privilege escalation enumeration | ❌ Download from PEASS-ng releases | HIGH — companion to LinPEAS for Windows |
| **BloodHound** | CE 5.x | Active Directory attack path visualization | ❌ Docker or native install | HIGH — THE tool for AD enumeration and attack planning |
| **SharpHound** | Current | BloodHound data collector (C#) | ❌ Download from BloodHound releases | HIGH — standard collector for AD environments |
| **evil-winrm** | Current | WinRM shell for Windows remote management | ✅ Pre-installed | HIGH — preferred shell for Windows post-exploitation |
| **Mimikatz** | 2.x | Windows credential extraction (SAM, NTLM, Kerberos) | ✅ Pre-installed | HIGH — essential for AD attacks |
| **PowerView** | Current | PowerShell AD enumeration (part of PowerShell Empire) | ❌ | MEDIUM — SharpHound largely replaces this |
| **Rubeus** | Current | Kerberos attack toolkit (AS-REP, Kerberoasting) | ❌ | HIGH — required for Kerberos attacks |
| **Seatbelt** | Current | Windows security audit/enumeration | ❌ | MEDIUM — complements WinPEAS |
| **Chisel** | Current | TCP/UDP tunnel over HTTP (pivoting) | ❌ | HIGH — modern pivoting tool |
| **ligolo-ng** | Current | Tunneling/pivoting proxy | ❌ | HIGH — Chisel alternative, simpler setup |
| **GTFOBins** | Web | Unix binary escalation reference | Web-based | HIGH — essential reference for SUID/sudo abuse |
| **LOLBAS** | Web | Windows binary escalation reference | Web-based | HIGH — Windows equivalent of GTFOBins |

---

### 5. Reverse Engineering & Malware Analysis

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Ghidra** | 12.1+ | NSA's open-source RE framework (disassembly, decompilation) | ✅ Pre-installed | HIGH — free, 50+ architectures, strong decompiler |
| **IDA Free** | 9.x | Limited free disassembler (x86/x64 only) | ❌ Download | MEDIUM — Ghidra is broader and fully free |
| **Radare2/Rizin** | Current | CLI-based RE framework, scriptable | ✅ Pre-installed | MEDIUM — steep learning curve, powerful for automation |
| **Cutter** | Current | Qt GUI for Rizin (alternative to Ghidra) | ❌ | MEDIUM — lighter than Ghidra, good for quick analysis |
| **x64dbg** | Current | Windows user-mode debugger | ❌ (Windows-only) | HIGH — essential for dynamic analysis on Windows |
| **GDB** | Current | GNU debugger for Linux | ✅ Pre-installed | HIGH — essential for Linux dynamic analysis |
| **Frida** | Current | Dynamic instrumentation toolkit | ❌ `pip install frida-tools` | HIGH — inject JavaScript into processes for runtime analysis |
| **JADX** | Current | Android APK decompiler (Java/Kotlin → source) | ❌ | HIGH — essential for Android reverse engineering |
| **apktool** | Current | Android APK resource extraction | ✅ Pre-installed | HIGH — pairs with JADX |
| **YARA** | Current | Pattern matching for malware identification | ✅ Pre-installed | HIGH — industry standard for malware signatures |
| **Detect It Easy** | Current | Binary type identification (compiler, packer) | ❌ | MEDIUM — useful for initial triage |
| **CyberChef** | Web/GitHub | Data encoding/decoding/analysis ("Swiss Army Knife") | ✅ Pre-installed (as web app) | HIGH — essential for CTF and data analysis |

**Ghidra is the default RE tool for this trail.** It's free, pre-installed in Kali, supports 50+ architectures, and its decompiler quality is competitive with IDA Pro for most use cases. IDA Pro ($1,099/yr) is only justified for high-volume professional malware shops.

---

### 6. Network Analysis & Sniffing

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Wireshark** | 4.x | GUI packet analyzer, protocol dissection | ✅ Pre-installed | HIGH — undisputed standard for packet analysis |
| **tcpdump** | Current | CLI packet capture | ✅ Pre-installed | HIGH — lightweight, scriptable, headless-friendly |
| **tshark** | Current | CLI version of Wireshark | ✅ Pre-installed | HIGH — scripting-friendly packet analysis |
| **Netcat/ncat** | Current | TCP/UDP connections, port scanning, file transfer | ✅ Pre-installed | HIGH — "Swiss Army knife" of networking |
| **Zeek (Bro)** | Current | Network security monitoring, traffic analysis | ❌ | MEDIUM — enterprise-focused, overkill for learning |
| **Suricata** | Current | Network IDS/IPS with signature-based detection | ❌ | MEDIUM — pairs with Wazuh for defense labs |
| **MITMf** | Current | Man-in-the-middle framework | ✅ Pre-installed | LOW — largely unmaintained, use bettercap instead |
| **Bettercap** | Current | Network attack and monitoring framework | ✅ Pre-installed | HIGH — modern MITM, ARP spoofing, sniffing |
| **Nmap** | 7.95+ | Network discovery (also in Recon) | ✅ Pre-installed | HIGH — `nmap -sn` for host discovery |

---

### 7. Defense, Hardening & SIEM

| Tool | Version | Purpose | Cost | Confidence |
|------|---------|---------|------|------------|
| **Wazuh** | 4.14+ | Open-source SIEM/XDR (agent-based, compliance) | Free (self-hosted) | HIGH — best free SIEM, built-in compliance dashboards |
| **Elastic Security (ELK)** | 9.x | SIEM with EQL/KQL, detection rules, ML analytics | Free (Basic), paid tiers for advanced | HIGH — if team has Elasticsearch skills |
| **Suricata** | 7.x | Network IDS/IPS with ET Open rules | Free | HIGH — network-layer detection |
| **CrowdSec** | Current | Community-driven behavioral IPS | Free engine | HIGH — lightweight, crowdsourced blocklists |
| **OSSEC** | 3.x | Host-based IDS (parent of Wazuh) | Free | MEDIUM — Wazuh is the modern fork |
| **Fail2Ban** | Current | Intrusion prevention via log scanning | ✅ Pre-installed | HIGH — simple, effective SSH/web protection |
| **UFW** | Current | Uncomplicated Firewall (iptables wrapper) | ✅ Pre-installed | HIGH — simplified firewall management |
| **Nessus** | Current | Vulnerability scanner | Paid (Essentials: free for 16 IPs) | MEDIUM — useful for learning, not for pentesting |
| **OpenVAS** | Current | Open-source vulnerability scanner | Free | MEDIUM — Nessus alternative, slower |
| **Sigma Rules** | Current | Generic SIEM detection rule format | Free | HIGH — community detection rules for any SIEM |
| **YARA** | Current | Malware pattern matching | ✅ Pre-installed | HIGH — pairs with Sigma for defense |

**For learning SIEM:** Start with **Wazuh** — it's free, all-in-one (SIEM + HIDS + FIM + compliance), and the 3,000+ built-in rules map to MITRE ATT&CK. Splunk Free is crippled at 500 MB/day. Elastic is powerful but requires operational expertise.

---

### 8. Incident Response & Forensics

| Tool | Version | Purpose | Kali? | Confidence |
|------|---------|---------|-------|------------|
| **Volatility 3** | 3.x | Memory forensics framework | ✅ Pre-installed | HIGH — industry standard for RAM analysis |
| **Autopsy** | 4.x | Digital forensics platform (GUI) | ❌ | HIGH — comprehensive disk forensics |
| **Sleuth Kit** | Current | CLI forensic analysis tools | ✅ Pre-installed | HIGH — Autopsy's backend, scriptable |
| **Bulk Extractor** | Current | Extract emails, URLs, credit cards from disk images | ✅ Pre-installed | MEDIUM — specialized extraction |
| **Binwalk** | Current | Firmware analysis, file extraction | ✅ Pre-installed | HIGH — essential for firmware/IoT analysis |
| **Foremost** | Current | File carving tool | ✅ Pre-installed | MEDIUM — recover deleted files |
| **ClamAV** | Current | Open-source antivirus scanner | ✅ Pre-installed | MEDIUM — useful for malware triage |
| **Strings** | Current | Extract printable strings from binaries | ✅ Pre-installed | HIGH — fundamental triage tool |
| **File** | Current | File type identification | ✅ Pre-installed | HIGH — always first step in triage |
| **ExifTool** | Current | Metadata extraction from files | ✅ Pre-installed | HIGH — steganography, image forensics |
| **Steghide** | Current | Steganography tool (hide/extract data in images) | ✅ Pre-installed | HIGH — CTF stego standard |
| **Zsteg** | Current | PNG/BMP steganography analysis | ✅ Pre-installed | MEDIUM — automated stego detection |

---

### 9. Governance, Risk & Compliance (GRC)

| Resource | Purpose | Cost | Confidence |
|----------|---------|------|------------|
| **NIST CSF 2.0** | Cybersecurity Framework (identify, protect, detect, respond, recover) | Free | HIGH — primary framework reference |
| **MITRE ATT&CK** | Adversary tactics and techniques knowledge base | Free | HIGH — maps to every tool and technique |
| **OWASP Top 10 (2025)** | Web application security risks | Free | HIGH — essential for web module |
| **OWASP ASVS** | Application Security Verification Standard | Free | MEDIUM — detailed web security checklist |
| **CIS Benchmarks** | System hardening guides | Free (registration) | HIGH — practical hardening checklists |
| **ISO 27001/27002** | Information security management standards | Paid (overview free) | MEDIUM — governance reference |
| **CompTIA Security+ SY0-701** | Entry-level security certification | $392 exam | HIGH — DoD 8570 approved, corporate standard |
| **PCI DSS 4.0** | Payment card security standard | Free (overview) | MEDIUM — compliance reference |

**For the governance module:** Focus on NIST CSF 2.0, MITRE ATT&CK, and OWASP Top 10 as primary references. These are free, universally recognized, and directly applicable to the hands-on modules.

---

### 10. AI in Cybersecurity

| Tool/Platform | Purpose | Cost | Confidence |
|---------------|---------|------|------------|
| **CAI (Alias Robotics)** | Open-source offensive/defensive AI framework | Free | HIGH — 3,600× faster than humans, 156× cheaper |
| **Gideon (Cogensec)** | Autonomous security operations agent (red+blue) | Open-source | HIGH — CVE research, IOC analysis, red teaming |
| **HTB Academy AI Modules** | AI security training (Red Teaming AI, AI Evasion) | Paid ($10-$30/mo) | HIGH — structured learning paths |
| **PentestGPT** | LLM-guided penetration testing | Research tool | MEDIUM — academic, not production-ready |
| **Nuclei + AI** | Template-based scanning with AI triage | Free | HIGH — practical AI-augmented scanning |
| **Copilot for Security** | Microsoft's AI security assistant | Paid (enterprise) | MEDIUM — enterprise-focused |
| **CrowdStrike SafeMind** | Agentic AI for defenders (Red Tempest + Blue Solano) | Enterprise paid | HIGH — purpose-built cyber AI models |
| **Trend Cybertron** | Proactive cybersecurity AI (predict, detect, respond) | Enterprise paid | MEDIUM — integrated with Vision One |

**For the AI module:** Focus on CAI (open-source, practical) and HTB Academy's AI Red Teamer path. The field is young — most tools are research-grade, not production-ready. Teach concepts (prompt injection, AI-powered scanning, AI in SOC) rather than tool-specific workflows.

---

## Platforms for Practice Labs

### Free Platforms (Priority)

| Platform | URL | Labs | Best For | Current Status |
|----------|-----|------|----------|----------------|
| **TryHackMe** | tryhackme.com | 500+ rooms | Beginner→Intermediate, guided learning | ✅ Active, Jr Pentest path rebuilt for 2026 |
| **PortSwigger Academy** | portswigger.net/web-security | 100+ labs | Web security (SQLi, XSS, SSRF, CSRF) | ✅ Active, constantly updated |
| **OverTheWire** | overthewire.org | 34 Bandit levels + 7 wargames | Linux fundamentals, web, crypto, binary | ✅ Active, Bandit fully current |
| **PicoCTF / CyLab** | play.picoctf.org | 300+ challenges | CTF fundamentals, reversing, crypto, web | ✅ Active, rebranded to CyLab Security Academy (2026) |
| **HackTheBox** | hackthebox.com | 200+ machines | Intermediate→Advanced pentesting | ✅ Active, Starting Point for beginners |

### Paid Platforms (Reference Only)

| Platform | URL | Cost | Best For |
|----------|-----|------|----------|
| **HackTheBox Academy** | academy.hackthebox.com | $10-$125/mo | Structured modules, certifications (CPTS, CDSA) |
| **TryHackMe Premium** | tryhackme.com | $14/mo | Full path access, premium rooms |
| **PentesterLab** | pentesterlab.com | $20/mo | Web pentesting, exercises |
| **VulnHub** | vulnhub.com | Free | Downloadable vulnerable VMs |

---

## Tool Decision Matrix by Module

| Module | Primary Tools | Practice Platform |
|--------|--------------|-------------------|
| **00 Pre-requisitos** | Kali setup, Python, Linux basics, networking | TryHackMe Pre-Security |
| **01 Reconhecimento** | Nmap, theHarvester, Subfinder, Shodan, Maltego | TryHackMe Recon rooms |
| **02 Web Aplicações** | Burp Suite, ffuf, SQLMap, Nuclei, WhatWeb | PortSwigger Academy |
| **03 Exploração** | Metasploit, Hydra, Hashcat, John, CrackMapExec | TryHackMe + HackTheBox |
| **04 Pós-exploração** | LinPEAS/WinPEAS, BloodHound, Impacket, evil-winrm | HackTheBox + TryHackMe AD rooms |
| **05 Reversing** | Ghidra, x64dbg/GDB, YARA, CyberChef | OverTheWire + PicoCTF |
| **06 Análise de Rede** | Wireshark, tcpdump, Bettercap, Nmap | TryHackMe Network rooms |
| **07 Defesa** | Wazuh, Suricata, Sigma, Fail2Ban | TryHackMe SOC Level 1 |
| **08 Resposta** | Volatility 3, Autopsy, Sleuth Kit, YARA | TryHackMe Forensics rooms |
| **09 Ambientes** | Docker, Cloud CLIs, Aircrack-ng, MobSF | TryHackMe + HackTheBox |
| **10 Governança** | NIST CSF, MITRE ATT&CK, OWASP, CIS | Reference docs + case studies |
| **11 IA** | CAI, Nuclei+AI, HTB AI modules | HTB Academy AI path |

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not Alternative |
|----------|-------------|-------------|---------------------|
| **Subdomain enum** | Subfinder | Amass | Amass is slower, heavier; Subfinder wins on speed and simplicity |
| **Web fuzzer** | ffuf | Gobuster | ffuf is 10x faster, more flexible; Gobuster is simpler for beginners |
| **C2 Framework** | Metasploit | Cobalt Strike | CS costs $5,900/yr, heavily signatured by EDR; Metasploit sufficient for learning |
| **C2 (advanced)** | Sliver | Havoc | Havoc is newer, less documented; Sliver has better community and Bishop Fox support |
| **SIEM** | Wazuh | Splunk Free | Splunk Free capped at 500 MB/day, useless for real labs |
| **RE (free)** | Ghidra | IDA Free | IDA Free limited to x86, no IDAPython; Ghidra is broader and fully scriptable |
| **RE (paid)** | Binary Ninja | IDA Pro | Binary Ninja $299 one-time vs IDA Pro $1,099/yr; comparable for most use cases |
| **Password cracking** | Hashcat | John the Ripper | Hashcat is GPU-accelerated, faster; JtR supports more exotic formats |
| **Memory forensics** | Volatility 3 | Rekall | Rekall is abandoned; Volatility is the standard |
| **Network IDS** | Suricata | Snort | Suricata is multi-threaded, faster on modern hardware |

---

## Installation Quick Reference

```bash
# === Core Environment Update ===
sudo apt update && sudo apt full-upgrade -y

# === Modern Recon Tools (Go-based) ===
sudo apt install golang -y
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/ffuf/ffuf/v2@latest

# === Nuclei Templates ===
nuclei -update-templates

# === Python Tools ===
pip install theHarvester shodan impacket frida-tools

# === BloodHound (Docker) ===
docker pull bloodhound/bloodhound:latest

# === Wazuh (Docker - for defense labs) ===
curl -sO https://packages.wazuh.com/4.7/wazuh-docker-compose.yml
docker-compose up -d

# === Kali Tools (pre-installed, verify) ===
kali-tools-top10  # meta-package for essential tools
sudo apt install kali-linux-default -y  # standard tool set

# === Verify Key Tools ===
nmap --version
msfconsole --version
burpsuite --version  # or launch from menu
ghidra --version
```

---

## What NOT to Use

| Tool | Why Avoid | Replacement |
|------|-----------|-------------|
| **Nessus** (full) | Commercial, limited free tier (16 IPs) | OpenVAS for learning, Nmap NSE for quick checks |
| **Cobalt Strike** | $5,900/yr, heavily detected by EDR | Metasploit for learning, Sliver for advanced |
| **Kali Purple** | Blue team distro, not the standard | Use Wazuh + Suricata on standard Kali |
| **Parrot OS** | Alternative to Kali, not industry standard | Stick with Kali for OSCP/CEH alignment |
| **Aircrack-ng** (attacks) | Only for WiFi module; avoid wireless attacks on non-owned networks | Use in controlled lab only |
| **SET (Social Engineering Toolkit)** | Outdated, limited practical value | Teach phishing concepts with GoPhish instead |
| **Armitage** | GUI for Metasploit, largely unmaintained | Use msfconsole directly |
| **Zenmap** | GUI for Nmap, limited functionality | Use nmap CLI directly |

---

## Sources

- TryHackMe Blog: "Free TryHackMe Training to Learn Cyber Security in 2026" (Aug 2026)
- TryHackMe: "Jr Penetration Tester Learning Path Rebuilt for 2026" (2026)
- HTB Academy catalog and pricing update (Sep 2026)
- PortSwigger Web Security Academy: All Labs page (current)
- OverTheWire Wargames: Bandit, Natas (active, current levels)
- picoCTF / CyLab Security Academy (rebranded May 2026)
- OffSec OSCP+ Exam Guide (Apr 2026)
- SecurityElites: "Ethical Hacking Certifications Comparison 2026" (Mar 2026)
- RingSafe: "theHarvester Recon-ng OSINT Toolchain" (Apr 2026)
- ScanSearch: "Network Reconnaissance Methodology 2026" (May 2026)
- PhantomRed: "Reconnaissance Automation for Bug Bounty" (May 2026)
- Bishop Fox: Sliver C2 Framework (current)
- Vectra AI: "What is Metasploit?" (Feb 2026)
- Decryption Digest: "Penetration Testing Framework Methodology Guide 2026" (Mar 2026)
- DeepResearch Ninja: "Reverse Engineering Tools Comprehensive Guide" (Jun 2026)
- Guideflow: "8 Best Reverse Engineering Software Tools for 2026" (Aug 2026)
- Breachfolio: "Splunk vs Wazuh vs ELK" (Jul 2026)
- DEV Community: "Wazuh vs Elastic SIEM vs Splunk Free" (Jun 2026)
- PEASS-ng GitHub: LinPEAS/WinPEAS (current, active development)
- Hadrian: "The AI Hacking Boom: 70 New Offensive Security Tools" (Apr 2026)
- Alias Robotics: CAI Framework (2025)
- Cogensec: Gideon Autonomous Security Agent (2026)
- CrowdStrike: SafeMind Frontier Models (Sep 2026)
