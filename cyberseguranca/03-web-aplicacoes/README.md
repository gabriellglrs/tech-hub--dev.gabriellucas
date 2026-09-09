# 🎯 Módulo 3: Web & Aplicações

> Domine a web como campo de batalha — encontre falhas antes dos atacantes.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 6-8 horas | ⭐⭐ Intermediário | 2 | 10 |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Identificar tecnologias e frameworks de sites alvo
- [ ] Descobrir diretórios ocultos e endpoints秘密
- [ ] Testar e explorar vulnerabilidades de SQL Injection
- [ ] Detectar e contornar WAFs (Web Application Firewalls)
- [ ] Fuzzing avançado para encontrar falhas lógicas

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico | Sim | Módulo 0 do curso |
| HTTP (headers, status codes, métodos) | Sim | Fundamentos de HTTP |
| Módulo 1: Reconhecimento | Sim | [Módulo 1](../01-reconhecimento/) |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│              WEB & APLICAÇÕES                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌──────────────┐      ┌──────────────────────────┐   │
│   │  DESCOBERTA  │      │     ENUMERAÇÃO           │   │
│   │              │      │                          │   │
│   │  • WhatWeb   │      │  • Gobuster (diretórios) │   │
│   │  • Wafw00f   │      │  • feroxbuster (rotas)   │   │
│   │  • WPScan    │      │  • ffuf (fuzzing)        │   │
│   └──────┬───────┘      │  • Arjun (parâmetros)    │   │
│          │              └───────────┬──────────────┘   │
│          ▼                          │                   │
│   ┌─────────────────────────────────▼───────────────┐   │
│   │           EXPLORAÇÃO E INJEÇÃO                  │   │
│   │                                                 │   │
│   │  • SQLMap (SQL Injection automatizado)          │   │
│   │  • Nikto (vulnerabilidades conhecidas)          │   │
│   │  • Burp Suite (proxy e interceptação)           │   │
│   └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-descoberta-e-enumeracao.md](01-descoberta-e-enumeracao.md) | Descobrir diretórios, tecnologias e vulnerabilidades | `WhatWeb, Wafw00f, WPScan, Gobuster, feroxbuster, ffuf, Arjun, Nikto` | 4h |
| 2 | [02-injecao-e-fuzzing.md](02-injecao-e-fuzzing.md) | Testar SQL Injection e detectar WAFs | `SQLMap, Burp Suite` | 4h |

---

## 💡 Dicas de Ouro

> **Dica 1:** Sempre teste se existe WAF antes de ataques (use Wafw00f). Se houver, seus scans podem ser bloqueados silenciosamente.

> **Dica 2:** Comece com wordlists pequenas (`common.txt`) e vá aumentando. Listas gigantes geram muito ruído.

> **Dica 3:** Burp Suite é sua central de operações — intercepte, modifique e reenvie requests para entender a aplicação.

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não testar WAF primeiro | Ataques bloqueados sem aviso | Sempre rode `wafw00f` antes de scans |
| Usar wordlists gigantes | Muito falso positivo e lentidão | Comece com listas pequenas e refine |
| Esquecer `-fc 404` no Gobuster | Falsos positivos em dirs inexistentes | Filtre códigos de resposta indesejados |

---

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| OWASP Top 10 | TryHackMe | ⭐⭐ | 2h | [Link](https://tryhackme.com/room/owasptop10) |
| Web Fundamentals | TryHackMe | ⭐⭐ | 1h | [Link](https://tryhackme.com/room/owasptop10) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| OWASP Top 10 | Referência | [owasp.org](https://owasp.org/www-project-top-ten/) |
| TryHackMe - Web Fundamentals | Lab | [tryhackme.com](https://tryhackme.com/room/owasptop10) |
| HackTricks - Web | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma

---

<div align="center">

**⬅️ [Módulo 2: Análise de Rede](../02-analise-rede/)** | **[Módulo 4: Exploração](../04-exploracao/) ➡️**

</div>
