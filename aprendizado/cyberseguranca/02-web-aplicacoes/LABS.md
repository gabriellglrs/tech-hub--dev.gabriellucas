# 🧪 Labs de Web Aplicações

> 97+ laboratórios práticos organizados por plataforma. Cada arquivo do módulo referencia labs específicos.

---

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Burp Suite, SQLMap, Nuclei |
| Módulo 01 | ⭐⭐ | Reconhecimento concluído |
| Navegador | ⭐ | Firefox com FoxyProxy |
| Conta PortSwigger | ⭐ | Gratuita — necessária para labs |

---

## Labs por Plataforma

### PortSwigger Web Security Academy (97 labs)

| # | Tópico | Labs | Dificuldade | URL |
|---|--------|:----:|:-----------:|:----|
| 1 | SQL Injection | 18 | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/sql-injection |
| 2 | NoSQL Injection | 2 | ⭐⭐ | https://portswigger.net/web-security/nosql-injection |
| 3 | XSS (Reflected, Stored, DOM) | 30 | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/cross-site-scripting |
| 4 | CSRF | 12 | ⭐⭐ | https://portswigger.net/web-security/csrf |
| 5 | SSRF | 7 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/ssrf |
| 6 | XXE | 9 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/xxe |
| 7 | File Upload | 7 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/file-upload |
| 8 | SSTI | 7 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/server-side-template-injection |
| 9 | Insecure Deserialization | 10 | ⭐⭐⭐ | https://portswigger.net/web-security/deserialization |
| 10 | JWT Attacks | 8 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/jwt |
| 11 | OAuth | 6 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/oauth |
| 12 | Access Control / IDOR | 13 | ⭐-⭐⭐ | https://portswigger.net/web-security/access-control |
| 13 | Business Logic | 11 | ⭐-⭐⭐ | https://portswigger.net/web-security/logic-flaws |
| 14 | Race Conditions | 6 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/race-conditions |
| 15 | HTTP Request Smuggling | 22 | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/request-smuggling |
| 16 | Command Injection | 5 | ⭐⭐ | https://portswigger.net/web-security/os-command-injection |
| 17 | Path Traversal | 6 | ⭐-⭐⭐ | https://portswigger.net/web-security/file-path-traversal |
| 18 | GraphQL | 5 | ⭐⭐ | https://portswigger.net/web-security/graphql |
| 19 | Authentication | 14 | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/authentication |

### TryHackMe (10+ labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|:-----------:|:----|
| 1 | DVWA | Web vulnerabilities (SQLi, XSS, CSRF) | ⭐⭐ | https://tryhackme.com/room/dvwa |
| 2 | SQL Injection | SQLi básica e avançada | ⭐⭐ | https://tryhackme.com/room/sqlinjectionlab |
| 3 | OWASP Top 10 | Todas categorias OWASP | ⭐⭐ | https://tryhackme.com/room/owasptop10 |
| 4 | Burp Suite Basics | Proxy, Repeater, Intruder | ⭐⭐ | https://tryhackme.com/room/burpsuitebasics |
| 5 | XSS | Reflected, Stored, DOM-based | ⭐⭐ | https://tryhackme.com/room/xss |
| 6 | SSRF | Server-Side Request Forgery | ⭐⭐ | https://tryhackme.com/room/ssrfme |
| 7 | NoSQL Injection | MongoDB injection | ⭐⭐ | https://tryhackme.com/room/nosqli |
| 8 | Nuclei | Scanner baseado em templates | ⭐⭐ | https://tryhackme.com/room/nuclei |
| 9 | WAF Bypass | Bypass de firewalls | ⭐⭐⭐ | https://tryhackme.com/room/wafbypass |

### OverTheWire

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|:-----------:|:----|
| 1 | Natas (11 levels) | Web security, scripting, bypass | ⭐-⭐⭐⭐ | https://overthewire.org/wargames/natas/ |

### PicoCTF

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|:-----------:|:----|
| 1 | Web Exploitation (30+) | Web exploitation geral | ⭐-⭐⭐⭐ | https://play.picoctf.org/practice |

### HackTheBox

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|:-----------:|:----|
| 1 | Starting Point (Web) | Web exploitation básico | ⭐⭐ | https://app.hackthebox.com/starting-point |

---

## Labs Locais (Prática Autônoma)

| # | Lab | Comando | O que pratica |
|---|-----|---------|---------------|
| 1 | SQLMap scan | `sqlmap -u "http://target.com/?id=1" --batch --dbs` | SQLi detection + extração |
| 2 | ffuf fuzzing | `ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt` | Directory enumeration |
| 3 | Burp intercept | Abrir Burp → Proxy → Intercept → manipular requests | Proxy + Repeater |
| 4 | XSStrike | `xsstrike.py -u "http://target.com/search?q=test"` | XSS detection |
| 5 | Dalfox | `dalfox url "http://target.com/search?q=test"` | XSS scanner |
| 6 | NoSQLMap | `nosqlmap.py -u http://target.com/api/login -d user=admin -p password` | NoSQL injection |
| 7 | Nuclei scan | `nuclei -u http://target.com -severity critical,high` | CVE + misconfig detection |
| 8 | ysoserial | `java -jar ysoserial.jar CommonsCollections1 'id'` | Java deserialization |
| 9 | phpggc | `phpggc monolog/rce1 system 'id'` | PHP deserialization |
| 10 | jwt_tool | `jwt_tool.py TOKEN -X n` | JWT alg:none bypass |

---

## Ordem de Estudo Recomendada

```
Semana 1: Ferramenta Base
├── PortSwigger: Getting Started (Burp Suite)
└── TryHackMe: Burp Suite Basics

Semana 2: Injeção
├── PortSwigger: SQL Injection (18 labs)
├── PortSwigger: NoSQL Injection (2 labs)
├── PortSwigger: XXE (9 labs)
└── PortSwigger: SSTI (7 labs)

Semana 3: Client-Side
├── PortSwigger: XSS (30 labs)
├── PortSwigger: CSRF (12 labs)
└── PortSwigger: HTTP Request Smuggling (22 labs)

Semana 4: Autenticação
├── PortSwigger: JWT (8 labs)
├── PortSwigger: OAuth (6 labs)
├── PortSwigger: Access Control (13 labs)
└── PortSwigger: Authentication (14 labs)

Semana 5: Vulnerabilidades Especiais
├── PortSwigger: SSRF (7 labs)
├── PortSwigger: File Upload (7 labs)
├── PortSwigger: Insecure Deserialization (10 labs)
├── PortSwigger: Business Logic (11 labs)
└── PortSwigger: Race Conditions (6 labs)

Semana 6: Prática Integrada
├── TryHackMe: DVWA (completo)
├── TryHackMe: OWASP Top 10
├── OverTheWire: Natas
└── HackTheBox: Starting Point
```

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| PortSwigger | 97 | Web security academy (19 categorias) |
| TryHackMe | 10+ | Web basics, SQLi, XSS, OWASP, Burp |
| OverTheWire | 1 | Natas (web security) |
| PicoCTF | 1 | Web exploitation |
| HackTheBox | 1 | Starting point web |
| Local | 10 | SQLMap, ffuf, Burp, Nuclei, ysoserial |
| **Total** | **120+** | Cobertura completa OWASP Top 10:2025 |
