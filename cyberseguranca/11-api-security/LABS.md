# 🔌 Módulo 11: Labs de API Security

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| REST APIs | ⭐⭐ | Conceitos básicos |
| HTTP methods | ⭐⭐ | GET, POST, PUT, DELETE |
| Burp Suite | ⭐⭐⭐ | Para interceptação |
| Autenticação | ⭐⭐ | JWT, OAuth, API Keys |

---

## 📋 Exercício 1: Documentação de API com Postman

**Objetivo:** Importar e analisar documentação Swagger/OpenAPI

**Conhecimentos necessários:**
- REST (Representational State Transfer)
- Endpoints e métodos HTTP
- Authentication mechanisms

**Ferramentas:**
- Postman
- curl

**Passo a passo:**

1. Instale Postman ou use a versão web

2. Importe uma API Swagger:
```
File → Import → Link → https://petstore.swagger.io/v2/swagger.json
```

3. Explore a collection gerada

4. Teste um GET request:
```bash
curl https://petstore.swagger.io/v2/pet/1
```

5. Teste autenticação com API Key:
```bash
curl -H "api_key: teste123" https://petstore.swagger.io/v2/pet/1
```

6. Documente cada endpoint encontrado

**Macetes:**
- Importar `swagger.json` para mapeamento automático
- Testar cada endpoint individualmente
- Verificar headers de autenticação
- Usar Ambientes no Postman para variáveis

**Checklist:**
- [ ] Postman instalado/configurado
- [ ] API Swagger importada
- [ ] Endpoints documentados
- [ ] Autenticação testada
- [ ] Requests salvos na collection
- [ ] Relatório de endpoints criado

**Link:** https://portswigger.net/web-security/all-labs
**Tempo estimado:** 30 min

---

## 📋 Exercício 2: Enumeração de Endpoints com Kiterunner

**Objetivo:** Descobrir endpoints não documentados

**Conhecimentos necessários:**
- API routes
- Brute forcing de paths
- Wordlists para APIs

**Ferramentas:**
- Kiterunner

**Passo a passo:**

1. Instale o Kiterunner:
```bash
sudo apt install kiterunner
```

2. Scan básico:
```bash
kr scan http://target/api/ -w routes-large.kite
```

3. Scan com methodos específicos:
```bash
kr scan http://target/api/ -w routes-large.kite -X POST
```

4. Brute force de endpoints:
```bash
kr scan http://target/api/ -w api-endpoints.txt -x 10
```

5. Analise os resultados encontrados

6. Documente endpoints descobertos vs documentados

**Macetes:**
- `kr scan http://target/api/ -w routes-large.kite` para scan inicial
- `-X POST` para testar apenas POST requests
- Use `-x` para threads (cuidado com rate limiting)
- Compare com documentação oficial

**Checklist:**
- [ ] Kiterunner instalado
- [ ] Scan inicial executado
- [ ] Endpoints descobertos listados
- [ ] Não-documentados identificados
- [ ] Métodos HTTP verificados
- [ ] Resultados documentados

**Link:** https://portswigger.net/web-security/all-labs
**Tempo estimado:** 35 min

---

## 📋 Exercício 3: Teste BOLA (IDOR)

**Objetivo:** Acessar dados de outros usuários alterando IDs

**Conhecimentos necessários:**
- Broken Object Level Authorization (BOLA)
- IDOR (Insecure Direct Object Reference)
- Teste de autorização

**Ferramentas:**
- curl
- Burp Suite

**Passo a passo:**

1. Identifique endpoints com IDs:
```
GET /api/users/123
GET /api/orders/456
```

2. Teste variações de ID:
```bash
curl http://target/api/users/1
curl http://target/api/users/2
curl http://target/api/users/0
curl http://target/api/users/-1
```

3. Teste UUIDs se aplicável:
```bash
curl http://target/api/users/550e8400-e29b-41d4-a716-446655440000
```

4. Use Burp Intruder para automatizar:
- Position: `/users/§1§`
- Payloads: Numbers 1-1000

5. Analise respostas diferentes (200 vs 403/404)

6. Documente vulnerabilidades encontradas

**Macetes:**
- Testar `/users/1`, `/users/2`, `/users/0`, `/users/-1`
- UUIDs podem ser mais difíceis de枚举
- Verificar se retorna dados completos ou parciais
- Testar sem autenticação também

**Checklist:**
- [ ] Endpoints com IDs identificados
- [ ] Variações de ID testadas
- [ ] UUIDs testados (se aplicável)
- [ ] Burp Intruder configurado
- [ ] Vulnerabilidades BOLA documentadas
- [ ] Evidências coletadas

**Link:** https://portswigger.net/web-security/all-labs
**Tempo estimado:** 25 min

---

## 📋 Exercício 4: JWT Token Manipulation

**Objetivo:** Manipular tokens JWT para bypass de autenticação

**Conhecimentos necessários:**
- JWT structure (Header, Payload, Signature)
- alg:none attack
- Key confusion attacks

**Ferramentas:**
- jwt_tool
- Burp Suite

**Passo a passo:**

1. Instale jwt_tool:
```bash
git clone https://github.com/ticarpi/jwt_tool
```

2. Capture um JWT válido via Burp

3. Decodifique o JWT:
```bash
python3 jwt_tool.py TOKEN_AQUI
```

4. Teste alg:none attack:
```bash
python3 jwt_tool.py TOKEN_AQUI -X k -pk public_key.pem
```

5. Modifique claims:
```bash
python3 jwt_tool.py TOKEN_AQUI -T -pc role -pv admin
```

6. Gere novo token manipulado e teste

**Macetes:**
- `jwt_tool` para decodificar e manipular
- Mudar `alg` para `none` para bypass
- Testar `HS256` vs `RS256` (key confusion)
- Usar Burp para capturar tokens

**Checklist:**
- [ ] jwt_tool instalado
- [ ] JWT capturado
- [ ] Token decodificado
- [ ] alg:none testado
- [ ] Claims modificados
- [ ] Token manipulado testado

**Link:** https://portswigger.net/web-security/jwt
**Tempo estimado:** 40 min

---

## 📋 Exercício 5: Rate Limiting Bypass

**Objetivo:** Testar e bypassar proteções de rate limiting

**Conhecimentos necessários:**
- Rate limiting techniques
- Bypass methods
- Headers HTTP

**Ferramentas:**
- curl
- Turbo Intruder

**Passo a passo:**

1. Identifique endpoints com rate limiting:
```bash
for i in {1..100}; do curl -s -o /dev/null -w "%{http_code}\n" http://target/api/login; done
```

2. Teste bypass com headers:
```bash
curl -H "X-Forwarded-For: 1.2.3.4" http://target/api/login
curl -H "X-Real-IP: 5.6.7.8" http://target/api/login
```

3. Varie User-Agents:
```bash
curl -H "User-Agent: Mozilla/5.0..." http://target/api/login
```

4. Use Turbo Intruder para ataques rápidos:
- Script Python para requests paralelos

5. Documente quais bypasses funcionaram

6. Sugira correções para o desenvolvedor

**Macetes:**
- Headers `X-Forwarded-For` e `X-Real-IP` podem bypassar
- Diferentes `User-Agents` podem ser tratados separadamente
- Rate limiting pode ser por IP, session ou API key
- Documente o padrão de rate limiting antes de bypassar

**Checklist:**
- [ ] Rate limiting identificado
- [ ] Bypass com headers testado
- [ ] User-Agent rotation testada
- [ ] Turbo Intruder configurado
- [ ] Bypasses documentados
- [ ] Recomendações de correção

**Link:** https://portswigger.net/web-security/rate-limiting
**Tempo estimado:** 30 min

---

## 📋 Exercício 6: Pentest API Completo (Final Challenge)

**Objetivo:** Testar API completa usando OWASP API Top 10

**Conhecimentos necessários:**
- Todas as técnicas do módulo
- OWASP API Security Top 10
- Metodologia de teste

**Ferramentas:**
- Burp Suite
- Kiterunner
- jwt_tool

**Passo a passo:**

1. Mapeie a API completamente:
```bash
kr scan http://target/api/ -w routes-large.kite
```

2. Teste cada item do OWASP API Top 10:
- API1: Broken Object Level Authorization
- API2: Broken Authentication
- API3: Excessive Data Exposure
- API4: Lack of Resources & Rate Limiting
- API5: Broken Function Level Authorization
- API6: Mass Assignment
- API7: Security Misconfiguration
- API8: Injection
- API9: Improper Assets Management
- API10: Insufficient Logging & Monitoring

3. Documente cada vulnerabilidade encontrada

4. Priorize por severidade (CVSS)

5. Gere relatório consolidado

6. Apresente findings com evidências

**Macetes:**
- Seguir OWASP API Security Top 10 como checklist
- Documentar cada vulnerabilidade com PoC
- Usar Burp Suite para interceptação e replay
- Classificar por severidade para o cliente

**Checklist:**
- [ ] API mapeada completamente
- [ ] OWASP API Top 10 testado item por item
- [ ] Vulnerabilidades documentadas
- [ ] Evidências coletadas
- [ ] Relatório consolidado gerado
- [ ] Priorização por severidade feita

**Link:** https://portswigger.net/web-security/all-labs
**Tempo estimado:** 90 min

---

## 📊 Resumo do Módulo

| Exercício | Habilidade | Tempo |
|-----------|-----------|-------|
| 1. Documentação Postman | Análise de API | 30 min |
| 2. Kiterunner | Enumeração | 35 min |
| 3. BOLA/IDOR | Autorização | 25 min |
| 4. JWT Manipulation | Autenticação | 40 min |
| 5. Rate Limiting Bypass | Proteção | 30 min |
| 6. Pentest API Completo | Integração | 90 min |
