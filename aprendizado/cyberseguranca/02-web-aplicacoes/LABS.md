# Labs de Web Aplicações

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Burp Suite, ffuf, SQLMap |
| Módulo 1 | ⭐⭐ | Reconhecimento concluído |
| Navegador | ⭐ | Firefox com FoxyProxy |

---

## Labs por Plataforma

### TryHackMe (6 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | DVWA | Vulnerabilidades web clássicas (SQLi, XSS, CSRF) | ⭐⭐ | https://tryhackme.com/room/dvwa |
| 2 | SQL Injection | SQLi básica e avançada | ⭐⭐ | https://tryhackme.com/room/sqlinjectionlab |
| 3 | OWASP Top 10 | Todas as categorias OWASP | ⭐⭐ | https://tryhackme.com/room/owasptop10 |
| 4 | Burp Suite Basics | Proxy, Repeater, Intruder | ⭐⭐ | https://tryhackme.com/room/burpsuitebasics |
| 5 | Injection | Command injection, SQLi, XSS | ⭐⭐ | https://tryhackme.com/room/injection |
| 6 | XSS | Reflected, Stored, DOM-based XSS | ⭐⭐ | https://tryhackme.com/room/xss |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### PortSwigger Web Security Academy (15 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 7 | SQL Injection (18 labs) | Labs oficiais PortSwigger | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/sql-injection |
| 8 | XSS (30 labs) | Labs oficiais PortSwigger | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/cross-site-scripting |
| 9 | CSRF (12 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/csrf |
| 10 | SSRF (7 labs) | Labs oficiais PortSwigger | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/ssrf |
| 11 | Access Control (13 labs) | Labs oficiais PortSwigger | ⭐-⭐⭐ | https://portswigger.net/web-security/access-control |
| 12 | Authentication (14 labs) | Labs oficiais PortSwigger | ⭐-⭐⭐⭐ | https://portswigger.net/web-security/authentication |
| 13 | File Upload (7 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/file-upload |
| 14 | Command Injection (5 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/os-command-injection |
| 15 | XXE (9 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/xxe |
| 16 | Insecure Deserialization (10 labs) | Labs oficiais PortSwigger | ⭐⭐⭐ | https://portswigger.net/web-security/deserialization |
| 17 | Path Traversal (6 labs) | Labs oficiais PortSwigger | ⭐-⭐⭐ | https://portswigger.net/web-security/file-path-traversal |
| 18 | Business Logic (11 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/business-logic |
| 19 | JWT (8 labs) | Labs oficiais PortSwigger | ⭐⭐-⭐⭐⭐ | https://portswigger.net/web-security/jwt |
| 20 | OAuth (6 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/oauth |
| 21 | GraphQL (5 labs) | Labs oficiais PortSwigger | ⭐⭐ | https://portswigger.net/web-security/graphql |

### OverTheWire (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 22 | Natas (11 levels) | Web security, scripting, bypass | ⭐-⭐⭐⭐ | ssh://natas.labs.overthewire.org:2221 |

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 23 | Web Exploitation (30+) | Web exploitation geral | ⭐-⭐⭐⭐ | https://play.picoctf.org/practice |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 24 | Starting Point (Web) | Web exploitation básico | ⭐⭐ | https://app.hackthebox.com/starting-point |

### Prática Local (4 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 25 | SQLMap automático | SQLi detection + exploitation | ⭐⭐ | `sqlmap -u "http://target.com/?id=1" --batch --dbs` |
| 26 | ffuf directory fuzzing | Directory enumeration | ⭐⭐ | `ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt` |
| 27 | Burp Suite intercept | Proxy + Repeater manual | ⭐⭐ | Abrir Burp → Proxy → Intercept → manipular requests |
| 28 | XSStrike scan | XSS detection automatizado | ⭐⭐ | `python3 xsstrike.py -u "http://target.com/search?q=test"` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 6 | Web basics, SQLi, XSS, OWASP, Burp |
| PortSwigger | 15 | Web security academy (15 categorias) |
| OverTheWire | 1 | Natas (web security) |
| PicoCTF | 1 | Web exploitation |
| HackTheBox | 1 | Starting point web |
| Local | 4 | SQLMap, ffuf, Burp, XSStrike |
| **Total** | **28** | |
