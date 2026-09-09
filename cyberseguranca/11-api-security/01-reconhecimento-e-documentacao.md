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

**Próximo:** [02-teste-de-vulnerabilidades.md](02-teste-de-vulnerabilidades.md)
