# Reconhecimento e Documentação de APIs

> Descobrir e mapear endpoints de APIs antes de testar vulnerabilidades.

---

## Instalação das Ferramentas

```bash
# Postman (GUI) - baixe de https://www.postman.com/downloads/
# ou use insomnia, httpie

# Arjun (descobrir parâmetros)
pip3 install arjun

# Kiterunner (descobrir endpoints)
go install github.com/assetnote/kiterunner@latest

# curl (já vem no Linux)
sudo apt install -y curl jq
```

---

## Passo a Passo — Como mapear uma API

### Passo 1: Encontrar a documentação
```bash
# URLs comuns de documentação
curl -s http://target.com/api-docs
curl -s http://target.com/swagger
curl -s http://target.com/swagger.json
curl -s http://target.com/openapi.json
curl -s http://target.com/api/v1/docs
```

### Passo 2: Identificar endpoints
```bash
# Usando Arjun para descobrir parâmetros
arjun -u http://target.com/api/

# Com wordlist
arjun -u http://target.com/api/ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt
```

### Passo 3: Mapear métodos HTTP
```bash
# Para cada endpoint, teste todos os métodos
curl -X GET http://target.com/api/users
curl -X POST http://target.com/api/users
curl -X PUT http://target.com/api/users/1
curl -X DELETE http://target.com/api/users/1
curl -X PATCH http://target.com/api/users/1
curl -X OPTIONS http://target.com/api/users
```

### Passo 4: Analisar responses
```bash
# Ver headers
curl -I http://target.com/api/users

# Ver corpo da resposta formatado
curl -s http://target.com/api/users | jq .

# Verificar se retorna dados sensíveis
curl -s http://target.com/api/users | jq '.[].password'
```

---

## Descoberta de Endpoints

### Kiterunner
```bash
# Scan de endpoints de API
kr scan http://target.com/api/ -w routes-large.kite

# Com métodos HTTP
kr scan http://target.com/api/ -w routes-large.kite -x GET,POST,PUT

# Bruteforce de endpoints
kr bruteforce http://target.com/api/ -w common-api-extensions.txt
```

### ffuf para APIs
```bash
# Descobrir endpoints
ffuf -u http://target.com/api/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt

# Descobrir versão da API
ffuf -u http://target.com/api/vFUZZ/users -w /usr/share/seclists/Discovery/Web-Content/api/versioning.txt

# Descobrir parâmetros
ffuf -u "http://target.com/api/users?FUZZ=1" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt
```

---

## Análise de Swagger/OpenAPI

```bash
# Baixar spec do Swagger
curl -s http://target.com/swagger.json | jq . > swagger.json

# Listar todos os endpoints
jq '.paths | keys[]' swagger.json

# Listar métodos por endpoint
jq '.paths | to_entries[] | .key as $path | .value | keys[] | "\(. ) $path"' swagger.json

# Extrair schemas
jq '.components.schemas | keys[]' swagger.json
```

---

## Autenticação em APIs

```bash
# Token Bearer
curl -H "Authorization: Bearer TOKEN" http://target.com/api/users

# API Key
curl -H "X-API-Key: YOUR_KEY" http://target.com/api/users

# Basic Auth
curl -u user:pass http://target.com/api/users

# Cookie
curl -b "session=abc123" http://target.com/api/users
```

---

## Lab Prático

### Exercício 1: API Discovery
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/apihacking
- **O que vai praticar:** Descobrir endpoints, analisar Swagger
- **Tempo estimado:** 45 min

### Exercício 2: JWT Analysis
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/rooms/joker
- **O que vai praticar:** Tokens JWT, bypass de autenticação
- **Tempo estimado:** 60 min

### Dica de Estudo
> Sempre que encontrar uma API, primeiro tente acessar /swagger.json ou /openapi.json. Isso revela todos os endpoints disponíveis.

---

---

### Resumo da ordem — Por que essa sequência?

API Security segue: **documentar → mapear → autenticar → testar**.

```
PASSO 1: Documentação → Encontrar Swagger/OpenAPI
├── POR QUE: Documentação revela todos os endpoints disponíveis
├── O QUE FAZER: Acessar /swagger.json, /api-docs, /openapi.json
├── COMANDO: curl -s http://target.com/swagger.json | jq .
├── QUANDO AVANÇAR: Quando tiver lista de endpoints
└── SE DER ERRADO: Se não existir, use Arjun/Kiterunner para descobrir

        ↓

PASSO 2: Mapear endpoints → Listar todos os caminhos
├── POR QUE: Endpoints não documentados podem ter bugs
├── O QUE FAZER: Usar Kiterunner ou ffuf
├── COMANDO: kr scan http://target.com/api/ -w routes-large.kite
├── QUANDO AVANÇAR: Quando tiver lista completa
└── DICAS: Teste todos os métodos HTTP (GET, POST, PUT, DELETE)

        ↓

PASSO 3: Analisar autenticação → Ver como protege
├── POR QUE: APIs sem auth = dados expostos
├── O QUE FAZER: Testar sem token, com token inválido, com token de outro user
├── COMANDO: curl http://target.com/api/users (sem header)
├── QUANDO AVANÇAR: Quando entender o mecanismo de auth
└── SE DER ERRADO: Se retornar 401, tente bypass com JWT manipulation

        ↓

PASSO 4: Testar BOLA → Acessar recursos de outros usuários
├── POR QUE: BOLA é a vulnerabilidade #1 em APIs
├── O QUE FAZER: Alterar IDs em endpoints que retornam dados
├── COMANDO: curl http://target.com/api/users/2 (sendo user 1)
├── QUANDO AVANÇAR: Se retornar dados de outro user = BOLA encontrado
└── DICAS: Teste com UUIDs, IDs negativos, 0

        ↓

PASSO 5: Testar rate limiting → Verificar se bloqueia tentativas
├── POR QUE: APIs sensíveis devem limitar tentativas
├── O QUE FAZER: Enviar 100+ requests rápidas
├── COMANDO: for i in $(seq 1 100); do curl -s -o /dev/null -w "%{http_code}\n" http://target.com/api/login; done
├── QUANDO PARAR: Quando tiver resposta de todos os testes
└── SE DER ERRADO: Se não bloquear = vulnerabilidade
```

---

**Próximo:** [02-teste-de-vulnerabilidades.md](02-teste-de-vulnerabilidades.md)
