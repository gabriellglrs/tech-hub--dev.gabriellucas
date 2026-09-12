# 🔐 12. OAuth Attacks — Ataques a OAuth 2.0

> "Login com Google" parece seguro. Mas o fluxo OAuth tem pontos cegos que permitem account takeover.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 50min | ⭐⭐⭐ Avançado | `Burp Repeater, curl` |

</div>

---

## 🎓 Por que isso importa?

OAuth 2.0 é o protocolo padrão para "Login com Google/Facebook/Microsoft". Se o fluxo não valida corretamente o `redirect_uri`, `state`, ou tokens, o atacante pode **sequestrar contas**, **roubar tokens** e **bypass de autenticação**.

**Analogia:** Imagine que você pede uma chave de reserva de hotel. O hotel te envia por email, mas o email vai para o endereço errado porque o formulário não verifica o destinatário.

**Impacto real:**
- **Account takeover** via redirect_uri manipulation
- **Token leakage** via referer header
- **CSRF no fluxo OAuth** (state parameter ausente)
- **SSRF via OpenID dynamic registration**

**PortSwigger:** 6 labs dedicados (Apprentice → Expert)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 deste módulo |
| O que é OAuth 2.0 | Sim | Este arquivo explica |

---

## 🎯 Quando testar OAuth

- Quando a app oferece **"Login com Google/Facebook"**
- Para testar **redirect_uri** validation
- Para testar **CSRF** no fluxo OAuth
- Para testar **token leakage** via referer

---

## 🔄 Fluxo OAuth 2.0 (Authorization Code)

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Usuário  │     │  App     │     │ Provider │
│          │     │ (Client) │     │ (Google) │
└────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │
     │  1. Clicar "Login com Google"   │
     │ ──────────────►│                │
     │                │                │
     │                │  2. Redirect para
     │                │     Google OAuth
     │                │ ──────────────►
     │                │                │
     │  3. Login no Google + consentir │
     │ ◄──────────────────────────────┤
     │                │                │
     │  4. Google redireciona com
     │     authorization code
     │ ◄──────────────────────────────┤
     │                │                │
     │  5. Code enviado para App       │
     │ ──────────────►│                │
     │                │                │
     │                │  6. App troca
     │                │     code por
     │                │     token
     │                │ ──────────────►
     │                │                │
     │  7. Acesso liberado             │
     │ ◄─────────────│                │
```

---

## 📝 Tipos de Ataques OAuth

### 1. Redirect URI Manipulation

```bash
# Se a app não valida redirect_uri:
# URL original:
https://oauth.google.com/auth?redirect_uri=https://target.com/callback

# Modificado:
https://oauth.google.com/auth?redirect_uri=https://attacker.com/callback

# Se aceita → token vai para attacker.com
```

### 2. Token Leakage via Referer

```bash
# Se a página contém links externos:
# O token pode vazar via header Referer

# Exemplo:
# Página: https://target.com/dashboard?code=ABC123
# Link na página: https://external-site.com
# Ao clicar: Referer: https://target.com/dashboard?code=ABC123

# Prevenção: Referrer-Policy: no-referrer
```

### 3. CSRF no Fluxo OAuth (state ausente)

```bash
# Se o parâmetro state não é usado:
# 1. Atacante inicia fluxo OAuth com sua conta
# 2. Captura o code
# 3. Envia link para vítima: https://target.com/callback?code=ATTACKER_CODE
# 4. Vítima clica → conta do atacante vinculada à vítima

# Prevenção: Usar state parameter criptográfico
```

### 4. Bypass de Redirect URI

```bash
# Técnicas de bypass:
# Subdomain: https://target.com.attacker.com
# Path traversal: https://target.com/callback/../attacker
# Open redirect: https://target.com/redirect?url=https://attacker.com
# URL parsing: https://target.com@attacker.com
# Porta: https://target.com:443@attacker.com
```

### 5. SSRF via OpenID Dynamic Registration

```bash
# Se a app aceita registro dinâmico de clientes OpenID:
# registrar cliente com redirect_uri malicioso

POST /openid/client/register HTTP/1.1
Content-Type: application/json

{
  "redirect_uris": ["https://attacker.com/callback"],
  "client_name": "evil"
}
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Testar Redirect URI

```bash
# 1. Iniciar fluxo OAuth normalmente
# 2. Interceptar redirect para Google
# 3. Modificar redirect_uri no Burp Repeater:

GET /o/authorize/?response_type=code&client_id=123&redirect_uri=https://attacker.com/callback HTTP/1.1

# 4. Se aceita → token vai para attacker.com
# 5. Completar fluxo → token capturado
```

### Exemplo 2: Testar State Parameter

```bash
# 1. Observar se o fluxo usa state
GET /oauth/authorize/?response_type=code&client_id=123&redirect_uri=... HTTP/1.1

# 2. Se NÃO tem state → CSRF possível
# 3. Criar link malicioso:
# https://target.com/oauth/authorize/?response_type=code&client_id=123&redirect_uri=VICTIM_CALLBACK

# 4. Vítima clica → code vinculado à conta do atacante
```

### Exemplo 3: Token Leakage via Referer

```bash
# 1. Após login OAuth, verificar se URL contém code
# https://target.com/dashboard?code=ABC123

# 2. Verificar se há links externos na página
# 3. Se há link para external-site.com:
#    Referer: https://target.com/dashboard?code=ABC123
#    → Token vaza para external-site.com

# 4. Verificar headers de segurança:
# Referrer-Policy: no-referrer (protege)
# Referrer-Policy: unsafe-url (vulnerável)
```

### Exemplo 4: Bypass com Open Redirect

```bash
# 1. Encontrar open redirect na app:
# https://target.com/redirect?url=https://google.com

# 2. Usar no redirect_uri:
# https://oauth.google.com/auth?redirect_uri=https://target.com/redirect?url=https://attacker.com

# 3. Fluxo: Google → target.com/redirect → attacker.com (com code)
```

---

## 🔄 Fluxo de Teste OAuth

```
┌─────────────────────────────────────────────────────────┐
│  1. MAPEAR FLUXO OAUTH                                   │
│     - Identificar Provider (Google, Facebook, etc.)      │
│     - Capturar redirect_uri original                     │
│     - Verificar se usa state parameter                   │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR REDIRECT_URI                                  │
│     - Modificar para attacker.com                        │
│     - Testar subdomains e path traversal                 │
│     - Testar open redirects                              │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR STATE                                         │
│     - Remover state → CSRF possível                      │
│     - Fixar state → Session fixation                     │
│     - Predictable state → bypass                         │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. TESTAR TOKEN LEAKAGE                                 │
│     - Verificar Referer headers                          │
│     - Testar em páginas com links externos               │
│     - Verificar Referrer-Policy                          │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Não acho o fluxo OAuth" | Procurar botões "Login com Google/Facebook" |
| "redirect_uri não modifica" | App pode ter whitelist → tentar bypass |
| "State é obrigatório" | Testar se state é fixo/preditivo |
| "Token não vaza" | Verificar links externos na página pós-login |

---

## 📋 Cheat Sheet Rápido

### Payloads de Redirect_uri

```
https://attacker.com/callback
https://target.com.attacker.com/callback
https://target.com/callback/../attacker
https://target.com@attacker.com
https://target.com:443@attacker.com
```

### Bypass de State

```
# State fixo (session fixation)
# State ausente (CSRF)
# State preditivo (timestamp, sequential)
# State não validado (qualquer valor aceito)
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Authentication bypass via OAuth implicit flow](https://portswigger.net/web-security/oauth/lab-oauth-authentication-bypass-via-oauth-implicit-flow) | Implicit flow | 15min |
| 2 | PortSwigger | [Forced OAuth profile linking](https://portswigger.net/web-security/oauth/lab-oauth-forced-oauth-profile-linking) | Profile linking | 20min |
| 3 | PortSwigger | [OAuth account hijacking via redirect_uri](https://portswigger.net/web-security/oauth/lab-oauth-account-hijacking-via-redirect-uri) | Redirect URI | 20min |
| 4 | PortSwigger | [Stealing OAuth access tokens via open redirect](https://portswigger.net/web-security/oauth/lab-oauth-stealing-oauth-access-tokens-via-an-open-redirect) | Token theft | 25min |
| 5 | PortSwigger | [Stealing OAuth access tokens via proxy page](https://portswigger.net/web-security/oauth/lab-oauth-stealing-oauth-access-tokens-via-a-proxy-page) | Proxy page | 30min |

---

## 📚 Referências

- [PortSwigger — OAuth](https://portswigger.net/web-security/oauth)
- [PortSwigger — OAuth Labs](https://portswigger.net/web-security/oauth)
- [OWASP — OAuth Security](https://cheatsheetseries.owasp.org/cheatsheets/OAuth_Cheat_Sheet.html)
- [HackTricks — OAuth](https://book.hacktricks.xyz/pentesting-web/oauth-weaknesses)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Mapear fluxo OAuth de uma aplicação
- [ ] Testar redirect_uri validation
- [ ] Identificar CSRF via state parameter
- [ ] Detectar token leakage via Referer
- [ ] Bypassar redirect_uri com open redirect
- [ ] Completar os labs PortSwigger de OAuth
