# 🌐 Módulo 2: Web, API, Database & Frontend Security

> Todas as técnicas de segurança em aplicações web: sites, APIs, bancos de dados e frontend.

---

## 🎯 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Identificar tecnologias web (CMS, frameworks)
- [ ] Encontrar diretórios e endpoints ocultos
- [ ] Testar SQL Injection e NoSQL Injection
- [ ] Testar vulnerabilidades em APIs (BOLA, BFLA)
- [ ] Auditar bancos de dados
- [ ] Identificar e explorar XSS e CSRF
- [ ] Implementar CSP e proteções frontend

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? |
|:-------------|:-----------:|
| HTTP básico | Sim |
| HTML/CSS | Sim |
| JavaScript | Opcional |
| SQL básico | Opcional |

---

## 🗺️ Mapa do Módulo

```
Reconhecimento Web
├── 01-descoberta-e-enumeracao.md → WhatWeb, Gobuster, Nikto
└── 02-injecao-e-fuzzing.md → SQLMap, Fuzzing

API Security
├── 03-api-reconhecimento.md → Postman, Kiterunner, endpoints
└── 04-api-vulnerabilidades.md → BOLA, BFLA, JWT

Database Security
├── 05-database-enumeracao.md → MySQL, PostgreSQL, brute force
└── 06-database-injecao.md → SQL injection avançado

Frontend Security
├── 07-frontend-xss.md → XSS, CSRF
└── 08-frontend-csp.md → CSP, CORS, Clickjacking
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas |
|:--|:--------|:------------------------|:------------|
| 1 | [01-descoberta-e-enumeracao.md](01-descoberta-e-enumeracao.md) | Enumeração web | WhatWeb, Gobuster, Nikto |
| 2 | [02-injecao-e-fuzzing.md](02-injecao-e-fuzzing.md) | SQL Injection | SQLMap, ffuf |
| 3 | [03-api-reconhecimento.md](03-api-reconhecimento.md) | API enumeração | Postman, Kiterunner |
| 4 | [04-api-vulnerabilidades.md](04-api-vulnerabilidades.md) | API vulnerabilities | Burp Suite, jwt_tool |
| 5 | [05-database-enumeracao.md](05-database-enumeracao.md) | DB enumeração | sqlmap, Medusa |
| 6 | [06-database-injecao.md](06-database-injecao.md) | DB injection | sqlmap, NoSQLMap |
| 7 | [07-frontend-xss.md](07-frontend-xss.md) | XSS & CSRF | Burp Suite, nuclei |
| 8 | [08-frontend-csp.md](08-frontend-csp.md) | CSP & CORS | curl, Burp Suite |

---

## 💡 Dicas de Ouro

> **Comece pelo reconhecimento** — sempre identifique tecnologias antes de atacar

> **Web e API são similares** — BOLA é o novo SQL Injection

> **Teste tudo** — não confie em scanners automáticos

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não testar WAF | Ataques bloqueados | Verificar com wafw00f primeiro |
| Só usar GET | Perde endpoints POST | Testar todos os métodos |
| Ignorar rate limit | Conta bloqueada | Usar proxies e delays |

---

## 🧪 Laboratório Prático

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos

---

## ✅ Checklist

- [ ] Li todos os 8 arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs
- [ ] Consigo testar uma web app completa

---

<div align="center">

**⬅️ [Módulo 1: Reconhecimento](../01-reconhecimento/)** | **[Módulo 3: Exploração] ➡️**

</div>
