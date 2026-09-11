# 🎯 Módulo 1: Reconhecimento e Enumeração

> Torne-se um detetive digital — descobre tudo sobre um alvo antes de ele saber que você existe.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 14-16 horas | ⭐→⭐⭐⭐ | 21 | 55+ |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Coletar informações passivas sobre um alvo sem ser detectado
- [ ] Enumerar registros DNS e descobrir subdomínios ocultos
- [ ] Mapear a infraestrutura completa via ASN/BGP
- [ ] Mapear portas abertas e serviços em execução
- [ ] Identificar tecnologias e stacks utilizadas pelo alvo
- [ ] Usar Google Dorking para encontrar informações expostas
- [ ] Automatizar OSINT com frameworks (Maltego, Recon-ng, SpiderFoot)
- [ ] Buscar dispositivos e vulnerabilidades na internet inteira
- [ ] Descobrir subdomínios via Certificate Transparency
- [ ] Detectar subdomain takeover em subdomínios abandonados
- [ ] Enumerar buckets S3, Azure e GCS
- [ ] Extrair endpoints históricos via Wayback Machine
- [ ] Fazer OSINT de pessoas com Sherlock e Maigret
- [ ] Analisar repositórios GitHub/GitLab para encontrar secrets e endpoints
- [ ] Analisar JavaScript para encontrar endpoints e secrets
- [ ] Testar CORS e descobrir APIs ocultas (Swagger, GraphQL, versionamento)
- [ ] Identificar tecnologias web com fingerprinting (WhatWeb, Wappalyzer)
- [ ] Encontrar diretórios e endpoints ocultos (Gobuster, ffuf)
- [ ] Enumerar subdomínios profundamente com Amass
- [ ] Detectar WAFs antes de escanear (Wafw00f)
- [ ] Realizar banner grabbing de serviços (Netcat/Ncat)
- [ ] Manter anonimato durante reconhecimento (ProxyChains, Tor)
- [ ] Escrever relatórios profissionais de reconhecimento

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico (terminal, pacotes) | Sim | Módulo 0 do curso |
| Redes (IP, porta, DNS, HTTP) | Sim | Fundamentos de Redes |

---

## 📋 Checklist Operacional

> **Novo no módulo!** Acesse o **[MANUAL-RECON.md](MANUAL-RECON.md)** — checklist completo e passo a passo de TODO o reconhecimento. Siga cada fase na ordem.

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                      RECONHECIMENTO                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────────────── PREPARAÇÃO ─────────────────────┐   │
│   │  00 Mini-Guia Setup    →  Go, jq, pipelines, curl      │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────────── NÍVEL BÁSICO ──────────────────┐   │
│   │  01 DNS e Enumeração    →  Whois, Dig, Nmap, Masscan  │   │
│   │  02 OSINT e Subdomínios →  Subfinder, Nuclei, httpx    │   │
│   │  03 Google Dorking      →  Operadores avançados       │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────── NÍVEL INTERMEDIÁRIO ───────────────┐   │
│   │  04 OSINT Frameworks    →  Maltego, Recon-ng, SpiderFoot│  │
│   │  05 Busca Infraestrutura→  ASN/BGP, Censys, FOFA      │   │
│   │  06 Certificate Transp. →  crt.sh, openssl, SANs      │   │
│   │  13 Fingerprinting Web  →  WhatWeb, Wappalyzer, httpx  │   │
│   │  17 Banner Grabbing     →  Netcat, Ncat, curl          │   │
│   │  18 OPSEC e Anonimato   →  ProxyChains, Tor            │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────────── NÍVEL AVANÇADO ────────────────┐   │
│   │  07 Subdomain Takeover  →  Subzy, Nuclei, dig          │   │
│   │  08 Cloud Storage       →  S3, Azure, GCS buckets     │   │
│   │  09 Wayback Machine     →  waybackurls, gau, waymore   │   │
│   │  10 OSINT Pessoas       →  Sherlock, Maigret, ExifTool │   │
│   │  11 JavaScript Analysis →  LinkFinder, SecretFinder    │   │
│   │  12 CORS e APIs         →  CORS, Swagger, GraphQL      │   │
│   │  14 Discovery Conteúdo  →  Gobuster, ffuf              │   │
│   │  15 Subdomain Enum Adv. →  Amass                       │   │
│   │  16 Detecção de WAF     →  Wafw00f, Nikto, WPScan     │   │
│   │  19 Relatório           →  Template e boas práticas    │   │
│   │  20 GitHub/GitLab OSINT →  Dorking, Secrets, Code      │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│                    ┌──────────────────┐                        │
│                    │  RELATÓRIO FINAL │                        │
│                    └──────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

### 🧰 Preparação

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 00 | [00-mini-guia-setup.md](00-mini-guia-setup.md) | Instalar Go, jq, pipelines, curl avançado | `Go, jq, curl` | 20min |

### ⭐ Básico

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-dns-e-enumeracao.md](01-dns-e-enumeracao.md) | Consultar DNS, descobrir portas e serviços | `Whois, Dig, Nmap, Masscan` | 2h |
| 2 | [02-osint-e-subdominios.md](02-osint-e-subdominios.md) | Coletar informações públicas e subdomínios | `Subfinder, theHarvester, httpx, Nuclei` | 2h |
| 3 | [03-google-dorking.md](03-google-dorking.md) | Operadores avançados do Google para OSINT | `Google Dorks` | 1h |

### ⭐⭐ Intermediário

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 4 | [04-osint-frameworks.md](04-osint-frameworks.md) | Automatizar coleta com frameworks | `Maltego, Recon-ng, SpiderFoot` | 1h |
| 5 | [05-busca-infraestrutura.md](05-busca-infraestrutura.md) | ASN/BGP, buscar dispositivos na internet | `BGPView, Amass, Censys, FOFA, ZoomEye` | 1h30min |
| 6 | [06-certificate-transparency.md](06-certificate-transparency.md) | Subdomínios nos certificados SSL | `crt.sh, openssl` | 30min |
| 13 | [13-fingerprinting-web.md](13-fingerprinting-web.md) | Identificar tecnologias do alvo | `WhatWeb, Wappalyzer, httpx` | 40min |
| 17 | [17-banner-grabbing-e-servidores.md](17-banner-grabbing-e-servidores.md) | Identificar versões de serviços | `Netcat, Ncat, curl, Nmap` | 35min |
| 18 | [18-opsec-e-anonimato.md](18-opsec-e-anonimato.md) | Proteger identidade durante recon | `ProxyChains, Tor, VPN` | 35min |

### ⭐⭐⭐ Avançado

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 7 | [07-subdomain-takeover.md](07-subdomain-takeover.md) | Tomar subdomínios abandonados | `Subzy, Nuclei, dig` | 45min |
| 8 | [08-cloud-storage.md](08-cloud-storage.md) | Enumerar buckets S3, Azure, GCS | `aws CLI, cloud_enum, curl` | 45min |
| 9 | [09-wayback-machine.md](09-wayback-machine.md) | Endpoints antigos que ainda existem | `waybackurls, gau, waymore` | 30min |
| 10 | [10-osint-pessoas.md](10-osint-pessoas.md) | Buscar pessoas em redes sociais | `Sherlock, Maigret, ExifTool` | 45min |
| 11 | [11-javascript-analysis.md](11-javascript-analysis.md) | Endpoints e secrets em JavaScript | `LinkFinder, SecretFinder, katana` | 45min |
| 12 | [12-cors-e-api.md](12-cors-e-api.md) | Testar CORS, descobrir APIs (Swagger, GraphQL) | `curl, ffuf, nuclei, Arjun` | 1h |
| 14 | [14-discovery-de-conteudo.md](14-discovery-de-conteudo.md) | Encontrar diretórios e endpoints ocultos | `Gobuster, ffuf, wordlists` | 50min |
| 15 | [15-subdomain-enum-avancado.md](15-subdomain-enum-avancado.md) | Enumeração DNS profunda com Amass | `Amass` | 45min |
| 16 | [16-deteccao-waf.md](16-deteccao-waf.md) | Detectar WAFs e scanner vulnerabilidades | `Wafw00f, Nikto, WPScan` | 40min |
| 19 | [19-relatorio-de-reconhecimento.md](19-relatorio-de-reconhecimento.md) | Documentar descobertas profissionalmente | `Markdown, Pandoc` | 30min |
| 20 | [20-github-gitlab-osint.md](20-github-gitlab-osint.md) | GitHub/GitLab OSINT, secrets, endpoints | `GitDorker, truffleHog` | 45min |

---

## 💡 Dicas de Ouro

> **Dica 1:** Comece sempre pelo reconhecimento passivo (arquivos 01-03) antes de escanear ativamente. Quanto menos rastros, melhor.

> **Dica 2:** O Nmap é sua ferramenta mais importante — domine `-sV`, `-sC`, `-O` e scripts antes de partir para outras ferramentas.

> **Dica 3:** Documente tudo em arquivos separados. Um `results/` organizado salva horas de retrabalho depois.

> **Dica 4:** Para bug bounty, foque nos arquivos 06-12 e 14-16 (nível avançado) — são onde estão os findings de maior impacto.

> **Dica 5:** Sempre rode WhatWeb antes de qualquer scan web — saber o que o alvo usa define suas próximas ferramentas.

> **Dica 6:** Use Gobuster para scan rápido e ffuf para cenários complexos (POST fuzzing, filtros, recursão).

> **Dica 7:** Em pentest autorizado, use ProxyChains+Tor para manter anonimato. O Nmap SYN scan (`-sS`) NÃO funciona via proxy — use `-sT`.

---

## 🤖 IA para Este Módulo

Use IA para acelerar sua análise de reconhecimento:

```bash
# Analisar resultado do Nmap com IA
nmap -sV -sC target.txt
ollama run llama3.1:8b "Analise este scan Nmap e identifique serviços vulneráveis: $(cat target.txt)"

# Descobrir subdomínios com IA
ollama run llama3.2 "Liste técnicas de enumeração de subdomínios para example.com com comandos exatos"

# Interpretar Whois
whois example.com | ollama run llama3.2 "Analise este Whois e extraia informações úteis para pentest"
```

**Ferramentas de IA para reconhecimento:** NFGuard (`nfguard> Encontre subdomínios de target.com`), CyberStrike, RAI

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Esquecer o `-Pn` no Nmap | Alvos que bloqueiam ping aparecem como offline | Use `-Pn` sempre que o host não responder a ping |
| Usar `-T5` (timing agressivo) | Detecção por IDS/IPS ou DoS acidental | Comece com `-T3` e aumente gradualmente |
| Não atualizar scripts do Nmap | Vulnerabilidades não detectadas | Rode `sudo nmap --script-updatedb` periodicamente |
| Pular Certificate Transparency | Perde subdomínios internos (staging, dev) | Sempre consulte `crt.sh` |
| Não testar subdomain takeover | Perde findings de alto impacto | Teste todo subdomínio com CNAME externo |
| Analisar apenas JS principals | Perde endpoints em chunks e bundles | Use `katana -jc` para crawling completo |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 18+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

---

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| OHSINT | TryHackMe | ⭐ | 30min | [Link](https://tryhackme.com/room/ohsint) |
| Recon Enumeration | HackTricks | ⭐⭐ | 1h | [Link](https://book.hacktricks.wiki/) |
| OSINT | TryHackMe | ⭐⭐ | 1h | [Link](https://tryhackme.com/room/osticket) |
| Subdomain Takeover | PortSwigger | ⭐⭐⭐ | 2h | [Link](https://portswigger.net/web-security) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Nmap Official Guide | Guia | [nmap.org/book](https://nmap.org/book/) |
| TryHackMe - Recon Module | Lab | [tryhackme.com](https://tryhackme.com/room/ohsint) |
| HackTricks - Recon | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |
| OSINT Framework | Referência | [osintframework.com](https://osintframework.com/) |
| PortSwigger Web Security | Lab | [portswigger.net](https://portswigger.net/web-security) |

---

## ✅ Checklist do Módulo

- [ ] Li o **[00-mini-guia-setup.md](00-mini-guia-setup.md)** e instalei Go, jq
- [ ] Li todos os arquivos (básico, intermediário e avançado)
- [ ] Li o **[MANUAL-RECON.md](MANUAL-RECON.md)** (checklist operacional)
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar ASN/BGP e mapear infraestrutura de uma organização
- [ ] Consigo fazer GitHub/GitLab OSINT e encontrar secrets
- [ ] Consigo descobrir APIs (Swagger, GraphQL, versionamento)
- [ ] Consigo interpretar resultados e decidir próximos passos
- [ ] Consigo montar um relatório completo de reconhecimento
- [ ] Consigo seguir o fluxo completo: ASN → DNS → Subdomínios → Portas → Serviços → APIs → Relatório

---

<div align="center">

**⬅️ Módulo 0: Introdução** | **[Módulo 2: Web & Aplicações](../02-web-aplicacoes/) ➡️**

</div>
