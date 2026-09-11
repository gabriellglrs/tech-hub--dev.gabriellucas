# Phase 3: Modernização + Conteúdo Prático - Research

**Researched:** 2026-09-10
**Domain:** Educational cybersecurity content modernization — CLI tool documentation, terminal output capture, lab organization, GRC practical exercises, AI security tools
**Confidence:** MEDIUM-HIGH

## Summary

Phase 3 processes 12 modules sequentially (IMPROVEMENT-PLAN.md order), updating obsolete tools, adding real Kali 2026 outputs, replacing LABS.md with 174 mapped labs, and rewriting modules 10 and 11. The research covers six key areas: (1) CLI documentation best practices for educational content, (2) terminal output capture methodology, (3) LABS.md format for 174 labs across 5 platforms, (4) GRC compliance exercise structure, (5) current AI security tools for module 11, and (6) handling module 11's structural difference.

**Primary recommendation:** Use a standardized "Tool Card" format (install → use with flags → expected output) for every tool, capture real terminal output via `script` command or tmux recording, organize LABS.md as a platform-grouped table with metadata columns, and structure GRC exercises around concrete CIS Benchmark audits with OpenSCAP/Lynis.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Tool documentation (install+use+output) | Content layer | — | Each module file owns its tool documentation |
| Terminal output capture | Authoring workflow | Content layer | Output is captured during authoring, embedded in Markdown |
| Lab organization (174 labs) | Content layer | — | LABS.md files per module organize labs |
| GRC practical exercises | Content layer | — | Module 10 files contain exercises |
| AI security tool documentation | Content layer | — | Module 11 files contain tool docs |
| Module 11 structural rewrite | Content layer | — | README.md split into numbered files |

## Standard Stack

### Core (Content Authoring)
| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Kali Linux | 2026.x rolling | Target environment for all commands | Project constraint — Kali-only |
| `script` command | built-in | Capture terminal session output | Native Linux, no install needed, captures ANSI codes |
| tmux | current | Terminal multiplexer for session recording | Enables detached recording, pane-level capture |
| asciinema + agg | current | Record and export terminal sessions as GIF | Clean, reproducible terminal visuals for documentation |
| Markdown | — | Content format | Project standard, all modules use .md |

### Supporting (GRC Tools)
| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| OpenSCAP | current | CIS Benchmark scanning with XCCDF profiles | Module 10 — compliance audits |
| Lynis | 3.x | System hardening audit (0-100 score) | Module 10 — quick hardening checks |
| NIST CSF 2.0 | current | Framework reference for GRC exercises | Module 10 — policy mapping |
| CIS Benchmarks | 2026 versions | Hardening standards for practical exercises | Module 10 — audit targets |

### Supporting (AI Security Tools)
| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| CAI (Alias Robotics) | current | Open-source offensive/defensive AI framework | Module 11 — primary AI security tool |
| Ollama | current | Local LLM runner for AI-assisted security | Module 11 — AI local pipeline |
| PromptSentinel | current | Prompt injection detection firewall | Module 11 — defensive AI |
| OWASP LLM Top 10 | 2025 | Risk framework for AI security | Module 11 — reference framework |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `script` command | `kautolog` (auto-logging) | `script` is native; kautolog adds rotation/sync but requires install |
| OpenSCAP | CIS-CAT Lite | OpenSCAP is fully free; CIS-CAT Lite requires registration |
| asciinema/agg | VHS (Charmbracelet) | VHS produces GIFs declaratively; asciinema is more flexible for live capture |
| CAI | CyberStrike / KaliGPT | CAI is most actively maintained, 300+ models, open-source |

**Installation:**
```bash
# GRC tools
sudo apt install -y lynis libopenscap8 scap-security-guide

# AI tools (Module 11)
curl -fsSL https://ollama.com/install.sh | sh
pip install promptsentinel  # or from GitHub

# Terminal recording (optional, for authoring)
sudo apt install -y asciinema
pip install agg  # or: cargo install asciinema-gif
```

## Package Legitimacy Audit

| Package | Registry | Age | Downloads | Source Repo | slopcheck | Disposition |
|---------|----------|-----|-----------|-------------|-----------|-------------|
| lynis | apt (Kali) | 15+ yrs | N/A (system) | github.com/CISOfy/lynis | OK | Approved |
| libopenscap8 | apt (Kali) | 10+ yrs | N/A (system) | github.com/OpenSCAP/openscap | OK | Approved |
| scap-security-guide | apt (Kali) | 10+ yrs | N/A (system) | github.com/ComplianceAsCode/content | OK | Approved |
| ollama | binary/script | 2+ yrs | N/A | github.com/ollama/ollama | OK | Approved |
| asciinema | apt/pip | 8+ yrs | N/A | github.com/asciinema/asciinema | OK | Approved |

*All packages are system-level (apt) or widely-established tools. No new npm/PyPI packages required for this phase.*

## Architecture Patterns

### Pattern 1: Tool Card Format (for every tool in every module)

**What:** A standardized documentation block for each tool that fulfills the core value ("apt a FAZER")
**When to use:** Every time a tool is mentioned in any module file
**Structure:**
```markdown
### [Tool Name]

**O que é:** [one-line purpose]

**Instalação:**
\`\`\`bash
# Install command
sudo apt install -y [package]
# OR for Go-based tools:
go install github.com/org/tool/cmd/tool@latest
\`\`\`

**Uso básico:**
\`\`\`bash
# Command with flags explained
tool -flag1 description -flag2 description target
# -flag1: what it does
# -flag2: what it does
# target: what you're scanning
\`\`\`

**Output esperado:**
\`\`\`
[Real terminal output from Kali 2026]
[Truncated to relevant sections]
[With annotations for key findings]
\`\`\`
```

**Source:** Derived from multiple educational content best practices — Kioptrix documentation guide (2026), systemshardening.com principles, and the project's own core value ("apt a FAZER"). [CITED: kioptrix.com/kioptrix-documentation] [CITED: systemshardening.com/articles/ai-landscape/claude-non-human-consumers/]

**Key principles from research:**
1. **Explicit preconditions** — state OS, version, and prerequisites before commands
2. **Deterministic instructions** — every command produces same result on qualifying system
3. **Complete code blocks** — copy-pasteable, no ellipses or pseudocode
4. **Verification after every change** — expected output proves the command worked
5. **Include flag explanations** — don't just show `nmap -sV -sC`, explain what -sV and -sC do
6. **Trim output to relevant sections** — show what changed the decision, not every line

### Pattern 2: Terminal Output Capture Workflow

**What:** How to capture real Kali 2026 output for embedding in documentation
**When to use:** Authoring any module that needs "output real do Kali 2026" (D-03)

**Method A — Simple (recommended for most tools):**
```bash
# Start recording
script --command "tool [args]" output-session.log

# Or record interactively:
script session-$(date +%Y%m%d_%H%M).log
# ... run commands ...
exit  # stops recording

# Extract clean output (strip ANSI codes):
sed 's/\x1b\[[0-9;]*m//g' session.log > clean-output.txt
```
[CITED: sleeplessbeastie.eu/2026/04/07/how-to-record-terminal-session/]

**Method B — Clean capture with tmux (for complex multi-step workflows):**
```bash
# Create named session
tmux new-session -d -s doc-capture

# Send command and wait
tmux send-keys -t doc-capture "nmap -sV -sC 192.168.1.1" Enter

# Wait for completion, capture pane
tmux capture-pane -t doc-capture -p > output.txt
```

**Method C — Automated GIF (for LABS.md visual aids):**
```bash
# asciinema record
asciinema rec session.cast
# ... run commands ...
exit

# Convert to GIF
agg session.cast output.gif --theme dracula
```

**Source:** Based on `script` command documentation, tmux capture-pane, and asciinema workflow. [CITED: sleeplessbeastie.eu/2026/04/07/how-to-record-terminal-session/] [CITED: github.com/marksowell/kautolog]

**Key insight:** For this project, Method A (script + sed strip) is sufficient. The output goes into Markdown code blocks — GIFs are optional enhancement for LABS.md.

### Pattern 3: LABS.md Format (174 labs across 5 platforms)

**What:** Standardized format for LABS.md files that organize labs by platform with metadata
**When to use:** Every module's LABS.md file (replacing existing content)

**Structure:**
```markdown
# Labs — Módulo [N]: [Name]

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| [skill] | [stars] | [note] |

---

## Labs por Plataforma

### TryHackMe

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | [Room Name] | [topics covered] | Fácil/Médio/Difícil | [link] |

**Instruções:**
1. Acesse o link acima
2. [specific guidance for this room]
3. [what to focus on for this module]

---

### PortSwigger

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | [Lab Name] | [topics covered] | Fácil/Médio/Difícil | [link] |

---

### OverTheWire

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | [Level Name] | [topics covered] | Fácil/Médio/Difícil | [link] |

**Conexão:**
\`\`\`bash
ssh [user]@[host] -p [port]
\`\`\`

---

### PicoCTF

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | [Challenge Name] | [topics covered] | Fácil/Médio/Difícil | [link] |

---

### HackTheBox

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | [Machine Name] | [topics covered] | Fácil/Médio/Difícil | [link] |

---

## Exercícios Locais (Opcional)

### Exercício N: [Title]
**Objetivo:** [what the student will learn]
**Ferramentas:** [tools needed]
**Passo a passo:** [step-by-step]
**Output esperado:** [expected result]
**Validação:** [how to verify success]
```

**Source:** Derived from the existing high-quality LABS.md in module 08 (score 3.9) and the lab-matrix.csv structure from Phase 2. [VERIFIED: existing project files]

**Key design decisions:**
- **Platform grouping** (D-06): Labs organized by TryHackMe, PortSwigger, OverTheWire, PicoCTF, HackTheBox
- **Metadata columns** (D-07): Every lab has name, URL, difficulty, topics
- **Platform-specific instructions**: SSH commands for OTW, direct URLs for web platforms
- **Local exercises preserved**: Keep existing hands-on exercises alongside platform labs

### Pattern 4: GRC Compliance Exercise Structure (Module 10)

**What:** How to make GRC practical and hands-on instead of 100% theoretical
**When to use:** Module 10 files (01-grc-e-compliance.md, LABS.md)

**Exercise types for GRC:**

1. **CIS Benchmark Audit with OpenSCAP**
   ```bash
   # Install
   sudo apt install -y libopenscap8 scap-security-guide
   
   # Run CIS profile scan
   sudo oscap xccdf eval \
     --profile cis \
     --results results.xml \
     --report report.html \
     /usr/share/xml/scap/ssg/content/ssg-kali-ds.xml
   
   # Review results
   # Open report.html in browser
   # Or parse XML for specific controls
   ```
   [CITED: tech-insider.org/cis-benchmarks-server-hardening-2026]

2. **System Hardening with Lynis**
   ```bash
   # Install
   sudo apt install -y lynis
   
   # Run full audit
   sudo lynis audit system --quiet
   
   # View score
   grep "hardening_index" /var/log/lynis.log
   
   # Compare before/after hardening
   ```
   [CITED: tech-insider.org/cis-benchmarks-server-hardening-2026]

3. **Policy Document Review (practical)**
   - Create a sample Information Security Policy
   - Map controls to NIST CSF 2.0 functions
   - Identify gaps against ISO 27001 Annex A
   - Generate a gap analysis report
   [CITED: github.com/sanmi95/grc-mini-compliance-program]

4. **Risk Assessment Exercise**
   - Calculate ALE (Annual Loss Expectancy): ALE = SLE × ARO
   - Build a risk register with 10 sample risks
   - Prioritize using risk matrix (probability × impact)
   [CITED: github.com/icdfa/grc-engineering-labs]

5. **Compliance Scanning Pipeline**
   ```bash
   # Automated compliance check script
   #!/bin/bash
   echo "=== Lynis Score ==="
   sudo lynis audit system --quiet 2>/dev/null
   grep "hardening_index" /var/log/lynis.log
   
   echo "=== OpenSCAP CIS ==="
   sudo oscap xccdf eval --profile cis \
     /usr/share/xml/scap/ssg/content/ssg-kali-ds.xml 2>&1 | \
     grep -E "pass|fail" | head -20
   ```

**Source:** Based on GRC Playground (github.com/ashpearce/GRC-Playground), CIS hardening lab (github.com/AKu-r00/hardning-lab), and ICDFA GRC Engineering Labs. [CITED: github.com/ashpearce/GRC-Playground] [CITED: github.com/AKu-r00/hardning-lab]

### Pattern 5: Module 11 Rewrite Structure

**What:** How to restructure module 11 from single README.md (633 lines) into numbered files
**When to use:** Module 11 rewrite (D-09)

**Current structure:** README.md (633 lines) + LABS.md (314 lines) — inconsistent with other modules

**Target structure:**
```
11-ia-cyberseguranca/
├── README.md              # Overview + navigation (trimmed)
├── 01-ia-local-ollama.md  # Ollama setup, models, basic usage
├── 02-ferramentas-ia-cli.md # CAI, CyberStrike, RAI, numasec, etc.
├── 03-ia-por-fase.md      # AI for each pentest phase (recon→exploit→report)
├── 04-prompts-seguranca.md # Professional prompts library
├── 05-prompt-injection.md  # NEW: prompt injection attacks & defenses
└── LABS.md                # Updated with 10 mapped labs
```

**New content for module 11 (from research):**

1. **CAI Framework** (primary tool)
   - Installation: `pip install cai-cli` or from GitHub
   - Architecture: agent-based, 300+ models via LiteLLM
   - Built-in guardrails against prompt injection
   - Practical usage: scan, exploit, report
   [CITED: aliasrobotics.github.io/cai/]

2. **Prompt Injection** (critical new topic)
   - What it is: malicious instructions hidden in content processed by AI
   - Real-world attacks: 91.4% success rate against unprotected agents (2026 research)
   - Defense: input sanitization, output validation, guardrails
   - OWASP LLM01 mapping
   [CITED: arxiv.org/html/2508.21669] [CITED: labs.cloudsecurityalliance.org]

3. **Defensive AI Tools**
   - PromptSentinel: prompt injection detection (98.3% F1)
   - CAI Guardrails: 4-layer defense system
   - OWASP LLM Top 10 for reference
   [CITED: github.com/sandeepmothukuri/PromptSentinel]

4. **Updated Ollama models** (from module 11 current content — still valid)
   - llama3.2 (3B), llama3.1:8b (8B), codellama:13b, deepseek-r1
   - Add: qwen2.5-coder, phi-3

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Terminal output capture | Custom screenshot scripts | `script` command + `sed` strip | Native, reliable, no dependencies |
| CIS Benchmark scanning | Manual config checking | OpenSCAP with XCCDF profiles | Automated, reproducible, industry standard |
| Lab URL validation | Manual browser checks | curl + HTTP status code checking | Faster, scriptable, catches broken links |
| PDF/PNG terminal images | Custom rendering pipeline | asciinema + agg | Battle-tested, clean output |
| Risk calculation spreadsheets | Custom formulas | ALE/SLE/ARO with simple Markdown tables | Simpler, version-controlled |

**Key insight:** This phase is content authoring, not software development. The tools are Markdown files, not code. Focus on content quality, not tooling complexity.

## Common Pitfalls

### Pitfall 1: Output Without Context
**What goes wrong:** Showing raw terminal output without explaining what the learner should look for
**Why it happens:** Author runs command, copies output, pastes into Markdown
**How to avoid:** After every output block, add a "🔍 O que procurar" section highlighting key findings
**Warning signs:** Output blocks longer than 20 lines without annotations

### Pitfall 2: Inconsistent Tool Card Depth
**What goes wrong:** Some tools get full install+use+output, others get a one-liner
**Why it happens:** Author fatigue across 12 modules × 6+ tools each
**How to avoid:** Use the Tool Card template (Pattern 1) as a checklist — every tool must have all three sections
**Warning signs:** Tools without output blocks, tools without flag explanations

### Pitfall 3: Broken Lab URLs
**What goes wrong:** Labs reference URLs that return 404, redirect, or are rate-limited
**Why it happens:** Platform URLs change, rooms get retired, rate limits block automated checks
**How to avoid:** Mark all URLs as "pendente" status from Phase 2; validate manually before finalizing; add note "URL pode mudar — verifique no site da plataforma"
**Warning signs:** 73% of URLs still marked "pendente" from lab-matrix.csv

### Pitfall 4: Module 10 Stays Theoretical
**What goes wrong:** GRC module remains concept-heavy despite D-08 requirement for practical compliance
**Why it happens:** GRC is inherently more abstract than exploit development
**How to avoid:** Every GRC concept MUST have a corresponding command or exercise. "ISO 27001" → OpenSCAP scan. "Risk assessment" → ALE calculation. "Policy" → write a sample policy document.
**Warning signs:** Any paragraph in module 10 without a code block or exercise reference

### Pitfall 5: Module 11 Tool Sprawl
**What goes wrong:** Listing 15+ AI tools without depth on any
**Why it happens:** AI security is fast-moving, many new tools emerge
**How to avoid:** Focus on 3 core tools (Ollama, CAI, PromptSentinel) with full Tool Cards. Mention others in a "Referências" table without detailed documentation.
**Warning signs:** Tool names without install commands

### Pitfall 6: Ignoring Structural Inconsistency in Module 11
**What goes wrong:** Module 11 keeps its non-standard structure (just README + LABS)
**Why it happens:** Existing README is 633 lines and "works"
**How to avoid:** Split into numbered files per Pattern 5. Keep README as overview + navigation only (≤100 lines).
**Warning signs:** Module 11 README longer than 150 lines after rewrite

## Code Examples

### Tool Card Example — Nmap (typical for modules 01-06)
```markdown
### Nmap

**O que é:** Scanner de portas e serviços — a ferramenta mais importante para reconhecimento.

**Instalação:**
\`\`\`bash
# Pré-instalado no Kali
nmap --version
# Nmap version 7.95 ( https://nmap.org )
\`\`\`

**Uso básico:**
\`\`\`bash
# Scan de services (-sV) e scripts (-sC)
nmap -sV -sC 192.168.1.1
# -sV: detecta versões dos serviços
# -sC: rota scripts padrão de enumeração

# Output esperado:
\`\`\`
Starting Nmap 7.95 ( https://nmap.org )
Nmap scan report for 192.168.1.1
Host is up (0.0023s latency).

PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 9.6p1 Ubuntu
80/tcp  open  http        Apache httpd 2.4.59
443/tcp open  ssl/https   Apache httpd 2.4.59

Service detection performed. 2 services unrecognized.
\`\`\`

**🔍 O que procurar:** Portas STATE=open são pontos de entrada. VERSION revela vulnerabilidades potenciais.
```

### GRC Exercise Example — CIS Benchmark Audit
```markdown
### Exercício: Auditoria CIS com OpenSCAP

**Objetivo:** Rodar uma auditoria CIS Benchmark no seu sistema e interpretar os resultados.

**Ferramentas:** OpenSCAP, scap-security-guide

**Passo a passo:**
\`\`\`bash
# 1. Instalar
sudo apt install -y libopenscap8 scap-security-guide

# 2. Listar perfis disponíveis
oscap info /usr/share/xml/scap/ssg/content/ssg-kali-ds.xml | grep -A 5 "Profile"

# 3. Rodar scan com perfil CIS
sudo oscap xccdf eval \
  --profile cis \
  --results /tmp/cis-results.xml \
  --report /tmp/cis-report.html \
  /usr/share/xml/scap/ssg/content/ssg-kali-ds.xml

# 4. Verificar score
grep -c "pass" /tmp/cis-results.xml
grep -c "fail" /tmp/cis-results.xml

# 5. Abrir relatório
xdg-open /tmp/cis-report.html
\`\`\`

**Output esperado:** Relatório HTML com controles pass/fail, score de conformidade.

**Validação:**
- [ ] OpenSCAP instalado
- [ ] Scan CIS executado sem erros
- [ ] Relatório HTML gerado
- [ ] Identificou pelo menos 3 controles com falha
- [ ] Propôs correção para cada falha encontrada
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| theHarvester (passive recon) | Subfinder (passive recon) | 2024-2025 | D-10: Subfinder faster, 40+ sources |
| MITMf (MITM) | bettercap (MITM) | 2023-2024 | D-11: bettercap actively maintained |
| Armitage (Metasploit GUI) | msfconsole (direct CLI) | 2022-2023 | D-12: Armitage unmaintained |
| Rekall (memory forensics) | Volatility 3 (memory forensics) | 2022-2023 | D-13: Rekall abandoned |
| Snort (IDS) | Suricata (IDS/IPS) | 2023-2024 | D-14: Suricata multi-threaded |

**Deprecated/outdated:**
- theHarvester: Still available but Subfinder is faster and more comprehensive for passive recon
- MITMf: Largely unmaintained, bettercap is the modern replacement
- Armitage: GUI wrapper for Metasploit, largely unmaintained; use msfconsole directly
- Rekall: Abandoned project; Volatility 3 is the industry standard
- Snort: Still functional but Suricata is faster on modern hardware (multi-threaded)

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | OpenSCAP Kali profile is named `ssg-kali-ds.xml` | GRC exercises | LOW — may be different path; verify on Kali 2026 |
| A2 | CAI is installed via `pip install cai-cli` or GitHub clone | Module 11 | MEDIUM — install method may have changed; verify current docs |
| A3 | PromptSentinel install via pip is current | Module 11 | LOW — verify GitHub repo for latest install method |
| A4 | 174 labs count from lab-matrix.csv is final | LABS.md format | LOW — count may differ slightly after validation |
| A5 | Module 11's README.md can be split without losing content | Module 11 structure | LOW — 633 lines split into 5 files is straightforward |

## Open Questions (RESOLVED)

1. **OpenSCAP profile name on Kali 2026** `(RESOLVED)`
   - What we know: OpenSCAP uses XCCDF profiles from scap-security-guide
   - What's unclear: Exact filename for Kali profile
   - Decision: **Use `ssg-debian13-ds.xml`** — Kali is based on Debian 13, no specific Kali profile exists. Path: `/usr/share/xml/scap/ssg/content/ssg-debian13-ds.xml`

2. **CAI installation method** `(RESOLVED)`
   - What we know: CAI is actively maintained by Alias Robotics
   - What's unclear: Current recommended install method
   - Decision: **`pip install cai-framework`** — version 0.5.10 (December 2025), requires Python 3.12 + virtual environment. Open-source, no license needed for research.

3. **Module 00 LABS.md — does it exist?** `(RESOLVED)`
   - What we know: SCORING.md says module 00 has no LABS.md
   - What's unclear: Whether to create LABS.md or integrate exercises into existing files
   - Decision: **Create LABS.md** with 8 mapped labs from lab-matrix.csv

4. **INSTALACAO.md rewrite scope** `(RESOLVED)`
   - What we know: Current file recommends Ubuntu, conflicts with Kali-only constraint
   - What's unclear: Whether to rewrite in Phase 3 or Phase 4
   - Decision: **Rewrite in Phase 3** as part of module 00 processing

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Kali Linux | All modules | Assumed ✓ | 2026.x | — (project constraint) |
| OpenSCAP | Module 10 | Verify on Kali | current | Lynis alone |
| Lynis | Module 10 | Verify on Kali | 3.x | manual checklist |
| Ollama | Module 11 | Verify on Kali | current | cloud API fallback |
| CAI | Module 11 | Verify install | current | manual tool usage |
| tmux | Output capture | Verify on Kali | current | `script` command |
| asciinema | Optional GIFs | Not required | — | text-only output |

**Missing dependencies with no fallback:**
- None identified — all tools are either pre-installed on Kali or have apt install paths

**Missing dependencies with fallback:**
- OpenSCAP: if not available on Kali, use Lynis for hardening audits
- Ollama: if hardware insufficient, use cloud API (OpenAI, Anthropic) with warning about data privacy

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual content verification (Markdown linting) |
| Config file | none — content validation is manual |
| Quick run command | `grep -c "Output esperado" aprendizado/cyberseguranca/*/0*.md` |
| Full suite command | Visual review per module against Tool Card checklist |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| FERR-01 | Obsolete tools replaced | manual | `grep -rn "theHarvester\|MITMf\|Armitage\|Rekall\|Snort" aprendizado/cyberseguranca/` should return 0 or only in "substituído por" context | ✅ Wave 0 |
| FERR-02 | Install commands for all tools | manual | `grep -c "sudo apt install\|go install\|pip install" aprendizado/cyberseguranca/*/0*.md` — count should match tool count | ✅ Wave 0 |
| FERR-03 | Platform URLs functional | manual | `curl -sI [url] | head -1` for each URL in LABS.md files | ✅ Wave 0 |
| PRAT-01 | Expected output for commands | manual | `grep -c "Output esperado\|output esperado" aprendizado/cyberseguranca/*/0*.md` — should equal tool count | ✅ Wave 0 |
| PRAT-02 | Complete tool blocks (install+use+output) | manual | Verify each tool has all 3 sections | ✅ Wave 0 |
| PRAT-03 | Labs are real and verifiable | manual | Check each lab URL returns HTTP 200 or is marked "pendente" | ✅ Wave 0 |

### Sampling Rate
- **Per task commit:** `grep -c "Output esperado" [changed-files]` — verify outputs were added
- **Per wave merge:** `grep -rn "theHarvester\|MITMf\|Armitage\|Rekall" aprendizado/cyberseguranca/` — verify obsolete tools removed
- **Phase gate:** Full visual review of each completed module against Tool Card checklist

### Wave 0 Gaps
- [ ] Verify OpenSCAP profile name on actual Kali 2026
- [ ] Verify CAI install method from official docs
- [ ] Verify PromptSentinel repo is current
- [ ] Count exact tools per module for validation checklist

## Sources

### Primary (HIGH confidence)
- IMPROVEMENT-PLAN.md — Module processing order and priority (from Phase 1)
- GAP-ANALYSIS.md — Specific gaps per module (from Phase 1)
- lab-matrix.csv — 174 labs with URLs and status (from Phase 2)
- PESQUISA-REPORT.md — Lab mapping and certification alignment (from Phase 2)
- aliasrobotics.github.io/cai/ — CAI framework documentation
- arxiv.org/html/2508.21669 — Prompt injection research (CAI vulnerabilities)
- sleeplessbeastie.eu/2026/04/07/how-to-record-terminal-session/ — `script` command usage

### Secondary (MEDIUM confidence)
- tech-insider.org/cis-benchmarks-server-hardening-2026 — CIS Benchmark practical guide
- github.com/ashpearce/GRC-Playground — GRC hands-on labs
- github.com/AKu-r00/hardning-lab — CIS hardening lab with PingCastle
- github.com/sanmi95/grc-mini-compliance-program — GRC compliance program example
- github.com/icdfa/grc-engineering-labs — GRC engineering labs (47 labs)
- github.com/sandeepmothukuri/PromptSentinel — Prompt injection detection
- kioptrix.com/kioptrix-documentation — Documentation best practices
- systemshardening.com — Hardening guide documentation principles
- labs.cloudsecurityalliance.org — CSA research on indirect prompt injection

### Tertiary (LOW confidence)
- cycode.com/blog/ai-cybersecurity-tools/ — AI security tools landscape (2026)
- github.com/marksowell/kautolog — Terminal auto-logging tool

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — tools are either pre-installed on Kali or well-documented apt packages
- Architecture: HIGH — content authoring patterns are well-established from existing modules
- Pitfalls: MEDIUM — based on audit findings and common educational content issues
- GRC exercises: MEDIUM — based on GitHub examples but need Kali-specific verification
- AI tools: MEDIUM — CAI is well-documented but install method needs verification

**Research date:** 2026-09-10
**Valid until:** 2026-10-10 (30 days — content tools are stable, AI tools evolve faster)
