# 🎯 Módulo 1: Reconhecimento e Enumeração

> Torne-se um detetive digital — descobre tudo sobre um alvo antes de ele saber que você existe.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 8-10 horas | ⭐→⭐⭐⭐ | 12 | 35+ |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Coletar informações passivas sobre um alvo sem ser detectado
- [ ] Enumerar registros DNS e descobrir subdomínios ocultos
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
- [ ] Analisar JavaScript para encontrar endpoints e secrets
- [ ] Testar CORS e descobrir APIs ocultas

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico (terminal, pacotes) | Sim | Módulo 0 do curso |
| Redes (IP, porta, DNS, HTTP) | Sim | Fundamentos de Redes |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                      RECONHECIMENTO                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────────────── NÍVEL BÁSICO ──────────────────┐   │
│   │  01 DNS e Enumeração    →  Whois, Dig, Nmap, Masscan  │   │
│   │  02 OSINT e Subdomínios →  Subfinder, Nuclei, httpx    │   │
│   │  03 Google Dorking      →  Operadores avançados       │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────── NÍVEL INTERMEDIÁRIO ───────────────┐   │
│   │  04 OSINT Frameworks    →  Maltego, Recon-ng, SpiderFoot│  │
│   │  05 Busca Infraestrutura→  Censys, FOFA, ZoomEye      │   │
│   │  06 Certificate Transp. →  crt.sh, openssl, SANs      │   │
│   └────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────────── NÍVEL AVANÇADO ────────────────┐   │
│   │  07 Subdomain Takeover  →  Subzy, Nuclei, dig          │   │
│   │  08 Cloud Storage       →  S3, Azure, GCS buckets     │   │
│   │  09 Wayback Machine     →  waybackurls, gau, waymore   │   │
│   │  10 OSINT Pessoas       →  Sherlock, Maigret, ExifTool │   │
│   │  11 JavaScript Analysis →  LinkFinder, SecretFinder    │   │
│   │  12 CORS e APIs         →  CORS test, API discovery    │   │
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
| 5 | [05-busca-infraestrutura.md](05-busca-infraestrutura.md) | Buscar dispositivos na internet | `Censys, FOFA, ZoomEye` | 1h |
| 6 | [06-certificate-transparency.md](06-certificate-transparency.md) | Subdomínios nos certificados SSL | `crt.sh, openssl` | 30min |

### ⭐⭐⭐ Avançado

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 7 | [07-subdomain-takeover.md](07-subdomain-takeover.md) | Tomar subdomínios abandonados | `Subzy, Nuclei, dig` | 45min |
| 8 | [08-cloud-storage.md](08-cloud-storage.md) | Enumerar buckets S3, Azure, GCS | `aws CLI, cloud_enum, curl` | 45min |
| 9 | [09-wayback-machine.md](09-wayback-machine.md) | Endpoints antigos que ainda existem | `waybackurls, gau, waymore` | 30min |
| 10 | [10-osint-pessoas.md](10-osint-pessoas.md) | Buscar pessoas em redes sociais | `Sherlock, Maigret, ExifTool` | 45min |
| 11 | [11-javascript-analysis.md](11-javascript-analysis.md) | Endpoints e secrets em JavaScript | `LinkFinder, SecretFinder, katana` | 45min |
| 12 | [12-cors-e-api.md](12-cors-e-api.md) | Testar CORS e descobrir APIs | `curl, ffuf, nuclei` | 45min |

---

## 💡 Dicas de Ouro

> **Dica 1:** Comece sempre pelo reconhecimento passivo (arquivos 01-03) antes de escanear ativamente. Quanto menos rastros, melhor.

> **Dica 2:** O Nmap é sua ferramenta mais importante — domine `-sV`, `-sC`, `-O` e scripts antes de partir para outras ferramentas.

> **Dica 3:** Documente tudo em arquivos separados. Um `results/` organizado salva horas de retrabalho depois.

> **Dica 4:** Para bug bounty, foque nos arquivos 06-12 (nível avançado) — são onde estão os findings de maior impacto.

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

- [ ] Li todos os arquivos (básico, intermediário e avançado)
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma
- [ ] Consigo montar um relatório completo de reconhecimento

---

<div align="center">

**⬅️ Módulo 0: Introdução** | **[Módulo 2: Web & Aplicações](../02-web-aplicacoes/) ➡️**

</div>
