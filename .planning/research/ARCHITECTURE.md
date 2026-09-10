# Architecture Patterns

**Domain:** Cybersecurity learning trail (12-module educational course)
**Researched:** 2026-09-10

## Recommended Architecture

The trail follows a **linear progressive structure** with 12 modules (00-11), each containing standardized content files. This is the correct architecture for a learning trail — it provides clear progression while allowing students to jump to specific topics.

### Current Structure (Verified)

```
cyberseguranca/
├── README.md                  # Main trail guide (reflects current 12-module structure)
├── ROADMAP.md                 # OUTDATED — needs update or removal
├── GLOSSARIO.md               # Technical glossary (PT-BR)
├── INSTALACAO.md              # Installation guide
├── CHEATSHEET-*.md (3 files)  # Quick reference sheets
├── 00-pre-requisitos/         # Foundations: networks, systems, security, tools
│   ├── 01-redes/              # Networking fundamentals (6 files)
│   ├── 02-sistemas/           # OS fundamentals (3 files)
│   ├── 03-seguranca/          # Security concepts (3 files)
│   └── 04-ferramentas/        # Practical tools (2 files)
├── 01-reconhecimento/         # Recon & enumeration
│   ├── 01-dns-e-enumeracao.md
│   └── 02-osint-e-subdominios.md
├── 02-web-aplicacoes/         # Web application testing (8 files)
├── 03-exploracao/             # Exploitation
├── 04-pos-exploracao/         # Post-exploitation
├── 05-reversing/              # Reverse engineering
├── 06-analise-rede/           # Network analysis
├── 07-defesa/                 # Defense & hardening
├── 08-resposta/               # Incident response & forensics
├── 09-ambientes/              # Special environments (cloud, wireless, mobile)
├── 10-governanca/             # Governance, risk, compliance
└── 11-ia-cyberseguranca/      # AI in cybersecurity
```

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| **README.md** | Trail navigation, module overview | All modules |
| **MODULE/README.md** | Module navigation, learning objectives | Module content files |
| **MODULE/XX-topic.md** | Conceptual explanation + hands-on commands | LABS.md for practice |
| **MODULE/LABS.md** | Practice exercises with platform links | External platforms (THM, HTB, etc.) |
| **GLOSSARIO.md** | Technical term definitions | Referenced from all content |
| **CHEATSHEET-*.md** | Quick command reference | Used during labs |

### Data Flow (Learning Path)

```
Student reads README.md
  → Selects module (00-11)
    → Reads module README.md (learning objectives)
      → Reads content files (conceptual + commands)
        → Copies commands to Kali terminal
          → Verifies expected output
            → Completes LABS.md exercises
              → Moves to next module
```

## Patterns to Follow

### Pattern 1: Command Block Standard

Every command must follow this structure:

```markdown
### Step N: [Action Description]
```bash
# Comment explaining what this does
command --flag1 --flag2 target
```
**O que procurar:** [Expected output description]
**Se der erro:** [Common error + fix]
```

### Pattern 2: Tool Comparison Table

When multiple tools exist for the same job:

```markdown
| Tool | Best For | When to Use | Kali? |
|------|----------|-------------|-------|
| Tool A | Speed | Quick scans | ✅ Pre-installed |
| Tool B | Depth | Thorough analysis | ❌ Install: ... |
```

### Pattern 3: Module README Standard

```markdown
# 🎯 Module N: [Title]

> [One-line description]

## O que você vai aprender
- [Learning objective 1]
- [Learning objective 2]

## Pré-requisitos
- [Module X must be completed first]

## Ferramentas utilizadas
| Tool | Purpose | Kali? |
|------|---------|-------|

## Arquivos
| # | Arquivo | O que você vai aprender | Tempo |
|---|---------|------------------------|-------|

## Prática
| Plataforma | Sala/Desafio | Link |
|------------|-------------|------|
```

### Pattern 4: LABS.md Structure

```markdown
# 🧪 Laboratórios — Module N

## Plataformas Gratuitas

### TryHackMe
| Sala | Dificuldade | O que pratica | Link |
|------|------------|---------------|------|

### PortSwigger Academy
| Lab | Categoria | Link |
|-----|-----------|------|

### OverTheWire / PicoCTF
| Wargame/Desafio | Habilidade | Link |
|-----------------|-----------|------|

## Labs Locais (Kali)
[Instructions for setting up vulnerable apps locally]
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Theory Without Commands
**What:** Explaining SQL injection without showing `sqlmap` commands
**Why bad:** Core value is "apt to FAZER" — theory alone violates project principle
**Instead:** Every concept gets: concept explanation → tool installation → command with flags → expected output

### Anti-Pattern 2: Outdated Tool Recommendations
**What:** Recommending Armitage, MITMf, or SET as primary tools
**Why bad:** These tools are unmaintained or abandoned; students waste time
**Instead:** Verify tool maintenance status quarterly; use tools with active GitHub repos

### Anti-Pattern 3: No Error Guidance
**What:** Showing commands without explaining common errors
**Why bad:** Beginners get stuck and abandon the trail
**Instead:** Every command block includes "Se der erro:" with common fixes

### Anti-Pattern 4: Skipping Kali Pre-installation
**What:** Assuming students know which tools are pre-installed vs need installation
**Why bad:** Students waste time installing tools that already exist
**Instead:** Every tool entry explicitly states "✅ Pre-installed" or provides install command

### Anti-Pattern 5: Platform Links Without Context
**What:** Listing "TryHackMe" without specifying which rooms
**Why bad:** Students don't know where to start on the platform
**Instead:** Link to specific rooms with difficulty level and description

## Scalability Considerations

| Concern | Current (12 modules) | At 20+ modules | At 50+ modules |
|---------|----------------------|----------------|----------------|
| Navigation | README.md sufficient | Add search/filters | Need subdomain or wiki |
| Content maintenance | Manual quarterly audit | Automated link checking | CI/CD for content validation |
| Lab links | Hardcoded URLs | Link validation script | API integration with platforms |
| Glossary | Single file | Split by domain | Separate glossary module |

## Sources

- Current project structure analysis (verified against filesystem)
- TryHackMe module structure (2026)
- HTB Academy module layout (2026)
- OSCP+ exam structure (2026)
