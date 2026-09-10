# Relatório de Labs e Referências — Módulo 02: Web & Aplicações

**Gerado em:** 2026-09-10
**Módulo:** 02-web-aplicacoes
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| 1 | Enumeração com WhatWeb/Wafw00f | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |
| 2 | Diretórios com Gobuster | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |
| 3 | SQL Injection com SQLMap | TryHackMe | https://tryhackme.com/room/sqlinjectionlm | ⏳ Pendente (rate-limit THM) |
| 4 | Vulnerabilidades com Nikto | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |
| 5 | Fuzzing com ffuf | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |
| 6 | Pentest Web Completo | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |

**Observações:** 5 dos 6 exercícios apontam para DVWA (Damn Vulnerable Web Application) — problema de monocultura. Apenas exercício 3 usa sala diferente (sqlinjectionlm). Falta cobertura de PortSwigger (279+ labs gratuitos), XSS, CSRF, SSRF, Burp Suite, e OWASP Top 10.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | OWASP Top 10 | TryHackMe | https://tryhackme.com/room/owasptop10 | OWASP Top 10 completo | ⏳ Pendente (rate-limit THM) |
| 2 | Burp Suite Basics | TryHackMe | https://tryhackme.com/room/burpsuitebasics | Interceptação HTTP | ⏳ Pendente (rate-limit THM) |
| 3 | Injection | TryHackMe | https://tryhackme.com/room/injection | Injeção (SQL, cmd, LDAP) | ⏳ Pendente (rate-limit THM) |
| 4 | XSS | TryHackMe | https://tryhackme.com/room/xss | Cross-Site Scripting | ⏳ Pendente (rate-limit THM) |
| 5 | SQL Injection (18 labs) | PortSwigger | https://portswigger.net/web-security/sql-injection | SQLi completo | ✅ Ativo |
| 6 | XSS (30 labs) | PortSwigger | https://portswigger.net/web-security/cross-site-scripting | XSS completo | ✅ Ativo |
| 7 | CSRF (12 labs) | PortSwigger | https://portswigger.net/web-security/csrf | Cross-Site Request Forgery | ✅ Ativo |
| 8 | SSRF (7 labs) | PortSwigger | https://portswigger.net/web-security/ssrf | Server-Side Request Forgery | ✅ Ativo |
| 9 | Access Control (13 labs) | PortSwigger | https://portswigger.net/web-security/access-control | Controle de acesso | ✅ Ativo |
| 10 | Authentication (14 labs) | PortSwigger | https://portswigger.net/web-security/authentication | Autenticação | ✅ Ativo |
| 11 | File Upload (7 labs) | PortSwigger | https://portswigger.net/web-security/file-upload | Upload de arquivos | ✅ Ativo |
| 12 | Command Injection (5 labs) | PortSwigger | https://portswigger.net/web-security/os-command-injection | Injeção de comandos | ✅ Ativo |
| 13 | XXE (9 labs) | PortSwigger | https://portswigger.net/web-security/xxe | XML External Entity | ✅ Ativo |
| 14 | Insecure Deserialization (10 labs) | PortSwigger | https://portswigger.net/web-security/deserialization | Deserialização insegura | ✅ Ativo |
| 15 | Path Traversal (6 labs) | PortSwigger | https://portswigger.net/web-security/file-path-traversal | Traversal de diretórios | ✅ Ativo |
| 16 | Business Logic (11 labs) | PortSwigger | https://portswigger.net/web-security/business-logic | Lógica de negócio | ✅ Ativo |
| 17 | JWT (8 labs) | PortSwigger | https://portswigger.net/web-security/jwt | JSON Web Tokens | ✅ Ativo |
| 18 | OAuth (6 labs) | PortSwigger | https://portswigger.net/web-security/oauth | OAuth 2.0 | ✅ Ativo |
| 19 | GraphQL (5 labs) | PortSwigger | https://portswigger.net/web-security/graphql | GraphQL | ✅ Ativo |
| 20 | Natas (11 níveis) | OverTheWire | http://natas0.natas.labs.overthewire.org | Web security (PHP) | ✅ Ativo |
| 21 | Web Exploitation (30+) | PicoCTF | https://play.picoctf.org/practice | Web CTF challenges | ⏳ Pendente |
| 22 | Starting Point (Web) | HackTheBox | https://app.hackthebox.com/starting-point | Pentest web guiado | ⏳ Pendente |

**Nota:** PortSwigger é A MELHOR fonte para este módulo — 155+ labs gratuitos em 19 categorias, todos validados. OverTheWire Natas complementa com web security via PHP.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| Client-Side Attacks (browser exploits) | OSCP PEN-200 | Crítico | Módulo dedicado no OSCP |
| Denial-of-Service | CEH v13 Módulo 10 | Importante | Parcialmente coberto |
| Session Hijacking | CEH v13 Módulo 11 | Importante | Não coberto nos labs |
| Hacking Web Servers | CEH v13 Módulo 13 | Importante | Configuração insegura de servers |
| Hacking Web Applications | CEH v13 Módulo 14 | Importante | Base para web pentesting |
| SQL Injection avançado | CEH v13 Módulo 15 + OSCP | Crítico | Coberto por PortSwigger mas não nos labs existentes |
| XSS avançado (Stored, DOM-based) | OSCP | Crítico | Labs existentes não cobrem XSS |
| Burp Suite profissional | OSCP | Crítico | Ferramenta essencial não coberta nos labs |
| SSRF, XXE, Deserialização | OSCP + Security+ | Crítico | Vulnerabilidades modernas não cobertas |
| JWT/OAuth attacks | OSCP (moderno) | Importante | Autenticação moderna |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 6 (validados: 0, pendentes: 6 — rate-limit THM)
- Labs candidatos novos: 22 (4 THM + 15 PortSwigger + 1 OTW + 1 PicoCTF + 1 HTB)
- Tópicos ausentes: 10 (críticos: 5)
- Plataformas com cobertura: PortSwigger (EXCELENTE — 155+ labs), TryHackMe (6 rooms), OverTheWire (Natas 11 níveis)
- Plataformas com cobertura limitada: PicoCTF (CTF-based), HackTheBox (Starting Point)
- **Recomendação URGENTE:** PortSwigger deve ser a plataforma PRIMÁRIA para este módulo. Os labs existentes dependem apenas de DVWA — PortSwigger oferece cobertura 25x maior com 19 categorias de vulnerabilidades.
