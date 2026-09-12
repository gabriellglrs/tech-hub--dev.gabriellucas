# 🌐 Módulo 2: Web, API, Database & Frontend Security

> Do Burp Suite ao HTTP Smuggling — todas as técnicas de pentest web, de vulnerabilidades de autenticação a exploração de bancos de dados.

<div align="center">

| ⏱️ Tempo Total | 📊 Nível | 🔧 Ferramentas |
|:--------------:|:--------:|:--------------:|
| ~15h | ⭐⭐→⭐⭐⭐ | `Burp Suite, SQLMap, Nuclei, ysoserial` |

</div>

---

## 🎯 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Usar Burp Suite como profissional (Proxy, Repeater, Intruder, Decoder)
- [ ] Detectar e explorar SQL Injection (error, blind, union, time-based)
- [ ] Explorar NoSQL Injection (MongoDB, CouchDB, Redis)
- [ ] Mapear e atacar APIs (BOLA, BFLA, GraphQL)
- [ ] Executar XSS avançado com bypass de filtros e CSP
- [ ] Explorar CSRF para ações não autorizadas
- [ ] Atacar SSRF para acessar rede interna e cloud metadata
- [ ] Explorar XXE via XML e SVG upload
- [ ] Fazer upload de webshells com bypass de extensão
- [ ] Executar SSTI em múltiplos template engines
- [ ] Usar ysoserial e phpggc para deserialization attacks
- [ ] Forjar JWT tokens e bypassar autenticação OAuth
- [ ] Explorar IDOR e broken access control
- [ ] Detectar business logic vulnerabilities e race conditions
- [ ] Usar Nuclei para scanning automatizado

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP básico (métodos, headers, status codes) | Sim | Módulo 00 |
| HTML/CSS básico | Sim | — |
| Burp Suite básico | Sim | Módulo 00 ou Arquivo 01 |
| SQL básico | Opcional | Este módulo ensina |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│                    FERRAMENTA BASE                       │
│  01 Burp Suite → entenda o proxy antes de qualquer teste │
└─────────────────────┬───────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────┐
│               INJEÇÃO (Server-Side)                      │
│  02 SQL Injection    → 04 NoSQL Injection                │
│  08 XXE              → 10 SSTI                           │
└─────────────────────┬───────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────┐
│               APLICAÇÃO (Client-Side)                    │
│  05 XSS Avançado     → 06 CSRF                           │
│  16 Headers/HTTP Smuggling                               │
└─────────────────────┬───────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────┐
│               APIS E AUTENTICAÇÃO                        │
│  03 API Security     → 12 JWT Attacks                    │
│  13 OAuth Attacks    → 14 Access Control (IDOR)          │
└─────────────────────┬───────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────┐
│               VULNERABILIDADES ESPECIAIS                 │
│  07 SSRF              → 09 File Upload                   │
│  11 Insecure Deser.   → 15 Business Logic                │
└─────────────────────┬───────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────┐
│               INFRAESTRUTURA E AUTOMAÇÃO                 │
│  17 Database Enum     → 18 Nuclei Web                    │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | Tópico | Ferramentas | Tempo |
|:--|:--------|:-------|:------------|:-----:|
| 1 | [01-burp-suite.md](01-burp-suite.md) | Burp Suite completo | Proxy, Repeater, Intruder, Decoder | 90min |
| 2 | [02-injecao-e-fuzzing.md](02-injecao-e-fuzzing.md) | SQL Injection avançado | SQLMap, payloads manuais | 80min |
| 3 | [03-api-security.md](03-api-security.md) | API Security (BOLA, BFLA) | Kiterunner, Arjun, Nuclei | 70min |
| 4 | [04-nosql-injection.md](04-nosql-injection.md) | NoSQL Injection | NoSQLMap, curl, operadores | 50min |
| 5 | [05-xss-avancado.md](05-xss-avancado.md) | XSS avançado + bypass | XSStrike, Dalfox, polyglots | 60min |
| 6 | [06-csrf.md](06-csrf.md) | CSRF dedicado | Burp Repeater, curl | 40min |
| 7 | [07-ssrf.md](07-ssrf.md) | SSRF (cloud metadata, bypass) | curl, Collaborator | 70min |
| 8 | [08-xxe.md](08-xxe.md) | XXE (classic, blind, SVG) | curl, Burp Repeater | 60min |
| 9 | [09-file-upload.md](09-file-upload.md) | File upload bypass | Burp Repeater, webshells | 60min |
| 10 | [10-ssti.md](10-ssti.md) | Server-Side Template Injection | tplmap, payloads por engine | 60min |
| 11 | [11-insecure-deserialization.md](11-insecure-deserialization.md) | Deserialization attacks | ysoserial, phpggc, pickle | 60min |
| 12 | [12-jwt-attacks.md](12-jwt-attacks.md) | JWT attacks | jwt_tool, hashcat | 60min |
| 13 | [13-oauth-attacks.md](13-oauth-attacks.md) | OAuth 2.0 attacks | Burp Repeater, curl | 50min |
| 14 | [14-access-control.md](14-access-control.md) | IDOR, privilege escalation | Burp Repeater, curl | 50min |
| 15 | [15-business-logic.md](15-business-logic.md) | Race conditions, logic flaws | Burp Intruder, curl | 50min |
| 16 | [16-headers-seguranca.md](16-headers-seguranca.md) | CSP, CORS, HTTP Smuggling | curl, Nuclei | 60min |
| 17 | [17-database-enum.md](17-database-enum.md) | DB enumeração e brute force | nmap, hydra, Medusa | 60min |
| 18 | [18-nuclei-web.md](18-nuclei-web.md) | Nuclei scanning | templates, custom templates | 40min |

---

## 🔗 Arquivos Complementares (Módulo 01)

Estes arquivos do módulo 01 são **pré-requisitos** para este módulo:

| Arquivo | Tópico | Relação com Módulo 02 |
|:--------|:-------|:----------------------|
| [01-reconhecimento/01-osint-basico.md](../01-reconhecimento/01-osint-basico.md) | OSINT básico | Encontrar targets |
| [01-reconhecimento/08-enum-de-hosts.md](../01-reconhecimento/08-enum-de-hosts.md) | Nmap, enum hosts | Encontrar portas web |
| [01-reconhecimento/14-discovery-de-conteudo.md](../01-reconhecimento/14-discovery-de-conteudo.md) | Gobuster, ffuf | Encontrar endpoints |

---

## 💡 Dicas de Ouro

> **Burp Suite é a base** — todo teste web começa pelo proxy

> **Manual antes de automático** — sempre teste manualmente antes de usar ferramentas

> **OWASP Top 10:2025** — este módulo cobre A01 (Access Control), A05 (Injection), A07 (Auth), A08 (Deserialization)

> **PortSwigger Academy** — cada arquivo tem labs gratuitos para praticar

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não testar manualmente | Falsos positivos | Sempre confirmar com payloads manuais |
| Usar ferramentas sem entender | Bypass fácil | Estudar cada vulnerabilidade antes |
| Não documentar findings | Trabalho perdido | Salvar requests no Burp Organizer |
| Ignorar encoding | Payloads bloqueados | Testar URL encode, double encode |
| Não atualizar ferramentas | CVEs não detectados | `nuclei -update-templates`, `sqlmap --update` |

---

## 🧪 Laboratório Prático

👉 **[Acessar LABS.md](LABS.md)** — 120+ exercícios práticos (PortSwigger, TryHackMe, HackTheBox)

---

## ✅ Checklist

- [ ] Li todos os 18 arquivos do módulo
- [ ] Instalei Burp Suite e configurei o proxy
- [ ] Completei os labs PortSwigger de cada tópico
- [ ] Consigo testar uma web app completa (recon → exploitation → post-exploitation)
- [ ] Consigo bypassar WAF com tamper scripts
- [ ] Consigo fazer SSRF para cloud metadata
- [ ] Consigo forjar JWT tokens
- [ ] Consigo detectar e explorar IDOR
- [ ] Consigo usar Nuclei para scanning automatizado

---

<div align="center">

**⬅️ [Módulo 1: Reconhecimento](../01-reconhecimento/)** | **[Módulo 3: Exploração] ➡️**

</div>
