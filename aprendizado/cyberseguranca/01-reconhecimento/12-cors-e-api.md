# 🌐 12. CORS e Descoberta de APIs — As Portas dos Trás da Web

> CORS mal configurado permite que sites maliciosos acessem dados de usuários. APIs expostas são a nova superfície de ataque.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `curl, ffuf, nuclei` |

</div>

---

## 🎓 O que é CORS?

CORS (Cross-Origin Resource Sharing) é um mecanismo de segurança que controla quais domínios podem acessar recursos de outro domínio. Quando mal configurado, pode permitir:

- **Leitura de dados** de usuários autenticados
- **Roubo de tokens** de sessão
- **Acesso a APIs internas** de empresas

**Exemplo de CORS vulnerável:**
```
Requisição de: https://site-malicioso.com
Para: https://api.evilcorp.com/users

Header de resposta:
Access-Control-Allow-Origin: https://site-malicioso.com
Access-Control-Allow-Credentials: true
```

---

## 🎯 Quando usar CORS e Descoberta de APIs

- Quer testar se um site permite acesso cross-origin indevido
- Precisa encontrar endpoints de API que não estão documentados
- Está fazendo pentest de aplicações web
- Quer descobrir APIs internas de empresas

---

## 🛠️ Como CORS e API te ajudam

### 1. curl — Teste Básico de CORS

```bash
# Testar se o site reflete qualquer origem (VULNERÁVEL)
curl -s -I -H "Origin: https://evil.com" https://api.evilcorp.com/users

# Resultado esperado (VULNERÁVEL):
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true

# Resultado esperado (SEGURO):
Access-Control-Allow-Origin: https://evilcorp.com
```

**Teste completo:**

```bash
# Script de teste CORS completo
DOMAIN="api.evilcorp.com"

echo "=== Teste 1: Origem arbitrária ==="
curl -s -I -H "Origin: https://evil.com" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 2: Subdomínio fake ==="
curl -s -I -H "Origin: https://evilcorp.evil.com" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 3: Null origin ==="
curl -s -I -H "Origin: null" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 4: HTTP (não HTTPS) ==="
curl -s -I -H "Origin: http://evilcorp.com" "https://$DOMAIN/" | grep -i "access-control"
```

**Resultado esperado (VULNERÁVEL):**

```
=== Teste 1: Origem arbitrária ===
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true
=== Teste 2: Subdomínio fake ===
Access-Control-Allow-Origin: https://evilcorp.evil.com
Access-Control-Allow-Credentials: true
=== Teste 3: Null origin ===
Access-Control-Allow-Origin: null
Access-Control-Allow-Credentials: true
=== Teste 4: HTTP (não HTTPS) ===
Access-Control-Allow-Origin: http://evilcorp.com
```

---

### 2. Nuclei — Templates de CORS

O Nuclei possui templates específicos para detectar CORS misconfiguration.

```bash
# Buscar vulnerabilidades de CORS
nuclei -u https://api.evilcorp.com -t http/misconfigurations/cors/

# Resultado esperado:
[cors-misconfiguration] [high] https://api.evilcorp.com
[cors-misconfiguration] [medium] https://api.evilcorp.com/users
```

---

### 3. Descoberta de APIs — Metodologia Completa

#### Por que APIs são críticas em 2026?

APIs são o **vetor de ataque #1** em aplicações web modernas. A maioria dos sites hoje é uma "SPA" (Single Page Application) que consome dados de APIs. Encontrar e mapear essas APIs é essencial.

```
SITE WEB (aparente)
    ↓
SPA (Single Page Application)
    ↓
CONSUME APIs (ocultas)
    ├── /api/v1/users
    ├── /api/v2/admin
    ├── /graphql
    ├── /api/internal
    └── /api/mobile
```

#### Passo 1: Descobrir Documentação Exposta

```bash
# Procurar documentação de API (Swagger/OpenAPI)
for path in \
  swagger.json \
  openapi.json \
  api-docs \
  swagger-ui \
  swagger-ui.html \
  swagger/docs/v1 \
  api/swagger \
  v1/api-docs \
  v2/api-docs \
  api/v1/swagger.json \
  api/v2/swagger.json \
  docs/api \
  redoc \
  graphiql; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "https://evilcorp.com/$path")
    if [ "$status" != "404" ]; then
        echo "$status https://evilcorp.com/$path"
    fi
done

# OUTPUT ESPERADO:
# 200 https://evilcorp.com/swagger.json     ← DOCUMENTAÇÃO EXPOSTA!
# 200 https://evilcorp.com/api-docs         ← DOCUMENTAÇÃO EXPOSTA!
# 200 https://evilcorp.com/graphiql         ← GraphQL EXPOSTO!
```

**O que significa?** Se encontrar `swagger.json` ou `openapi.json`, você tem a **lista completa de endpoints, parâmetros e modelos** da API. Isso é como ter o manual do sistema.

#### Passo 2: Descobrir Versões de API

```bash
# Enumerar versões de API
for version in v1 v2 v3 v4 internal beta alpha; do
    for path in /api/$version /api/$version/ /api/$version/docs; do
        status=$(curl -s -o /dev/null -w "%{http_code}" "https://evilcorp.com$path")
        if [ "$status" != "404" ]; then
            echo "$status https://evilcorp.com$path"
        fi
    done
done

# OUTPUT ESPERADO:
# 200 https://evilcorp.com/api/v1
# 200 https://evilcorp.com/api/v2
# 200 https://evilcorp.com/api/internal
```

**Por que testar versões?** Versões antigas (`/api/v1`) frequentemente:
- Não têm patches de segurança
- Possuem endpoints removidos que ainda funcionam
- Têm autenticação mais fraca

#### Passo 3: Descobrir Endpoints de API

```bash
# Encontrar endpoints de API com wordlists específicas
ffuf -u https://evilcorp.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt \
  -mc 200,201,202,204 \
  -fc 404

# Usar wordlist customizada de APIs
ffuf -u https://evilcorp.com/api/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt \
  -mc 200,201,202,204

# Buscar parâmetros de API
ffuf -u "https://evilcorp.com/api/users?FUZZ=test" \
  -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt \
  -mc 200
```

#### Passo 4: GraphQL Discovery

```bash
# Verificar se GraphQL está exposto
curl -s -X POST https://evilcorp.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { queryType { name } mutationType { name } types { name } } }"}'

# OUTPUT ESPERADO (se introspection habilitada):
# {
#   "data": {
#     "__schema": {
#       "queryType": { "name": "Query" },
#       "mutationType": { "name": "Mutation" },
#       "types": [
#         { "name": "User" },
#         { "name": "Post" },
#         { "name": "Comment" }
#       ]
#     }
#   }
# }

# Listar tipos disponíveis
curl -s -X POST https://evilcorp.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { types { name kind } } }"}' | jq '.data.__schema.types[].name'

# Descobrir campos de um tipo
curl -s -X POST https://evilcorp.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __type(name: \"User\") { fields { name type { name } } } }"}'
```

**O que significa?** Se a introspection GraphQL estiver habilitada, você tem a **estrutura completa da API** — todos os tipos, campos e resolvers.

#### Passo 5: Parâmetros Ocultos

```bash
# Descobrir parâmetros aceitos pela API
curl -s "https://evilcorp.com/api/users" | jq '.'  # Ver estrutura

# Testar parâmetros comuns
for param in id user_id admin debug verbose format type action sort order limit offset page fields select include expand; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "https://evilcorp.com/api/users?$param=1")
    if [ "$status" != "404" ] && [ "$status" != "400" ]; then
        echo "$status ?$param=1"
    fi
done

# OUTPUT ESPERADO:
# 200 ?id=1
# 200 ?user_id=1
# 200 ?admin=1
```

#### Passo 6: Headers de API

```bash
# Headers comuns de API
curl -s -I https://evilcorp.com/api/users \
  -H "Accept: application/json" \
  -H "X-API-Key: test" \
  -H "Authorization: Bearer test"

# Verificar headers de resposta
curl -s -D- https://evilcorp.com/api/users | head -20

# Headers que revelam tecnologia:
# X-Powered-By: Express
# X-Runtime: 0.123
# X-API-Version: 2.1
# X-Rate-Limit: 100
```

#### Passo 7: Ferramentas Automatizadas

```bash
# Arjun — Descobridor de parâmetros
pip3 install arjun
arjun -u https://evilcorp.com/api/users -m GET POST

# Kiterunner — Fuzzing de API
# https://github.com/assetnote/kiterunner
kr scan https://evilcorp.com/ -w routes-large.kite -x 20

# httpx — Probe de endpoints
echo "https://evilcorp.com/api/v1" | httpx -mc 200,201,202,204
```

### Fluxo Completo de API Discovery

```
PASSO 1: Documentação exposta
├── swagger.json → Lista completa de endpoints
├── openapi.json → Schema da API
└── graphiql → GraphQL introspection

        ↓

PASSO 2: Versões de API
├── /api/v1 → Versão antiga (possivelmente vulnerável)
├── /api/v2 → Versão atual
└── /api/internal → API interna (acesso restrito?)

        ↓

PASSO 3: Endpoints
├── /api/users → CRUD de usuários
├── /api/admin → Endpoints administrativos
└── /api/config → Configurações expostas

        ↓

PASSO 4: Parâmetros
├── ?id=1 → IDOR potencial
├── ?debug=true → Informações expostas
└── ?format=json → Data leakage

        ↓

PASSO 5: Autenticação
├── Sem auth → Acesso anônimo
├── Token fraco → Bypass possível
└── API key em header → Key leaking
```

### Interpretação dos Resultados

| Descoberta | Impacto | Ação |
|:-----------|:--------|:-----|
| **swagger.json exposto** | Documentação completa da API | Ler todos os endpoints |
| **GraphQL introspection habilitada** | Estrutura completa da API | Mapear todos os tipos/campos |
| **Versão antiga (/api/v1)** | Possivelmente sem patches | Testar vulnerabilidades conhecidas |
| **Parâmetro debug=true** | Informações internas expostas | Coletar dados |
| **API key em header** | Chave pode ser válida | Verificar (autorizado apenas) |
| **200 em /api/admin** | Acesso administrativo pode ser possível | Investigar autenticação |

---

## 🧠 Exercícios de Raciocínio

### Exercício 1: Análise de Swagger

**Cenário:** Você encontrou `https://api.targetcorp.com/swagger.json`. Ao analisar o arquivo, encontra:

```json
{
  "paths": {
    "/api/v1/users": { "get": {}, "post": {} },
    "/api/v1/users/{id}": { "get": {}, "put": {}, "delete": {} },
    "/api/v1/admin/users": { "get": {}, "delete": {} },
    "/api/v1/internal/config": { "get": {} },
    "/graphql": { "post": {} }
  }
}
```

**Pergunta:** Quais endpoints são mais interessantes? Por quê?

**Raciocínio esperado:**
1. **`/api/v1/admin/users`** → Endpoint administrativo! Pode ter menos proteção
2. **`/api/v1/internal/config`** → API interna! Pode expor configurações sensíveis
3. **`/graphql`** → GraphQL pode ter introspection habilitada
4. **`/api/v1/users/{id}`** → Possível IDOR se não validar permissão

**Próximo passo:**
```bash
# Testar admin endpoint
curl -s https://api.targetcorp.com/api/v1/admin/users | jq '.[0]'

# Testar GraphQL introspection
curl -s -X POST https://api.targetcorp.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { types { name } } }"}'
```

### Exercício 2: CORS Vulnerável

**Cenário:** Você testou CORS em `https://api.targetcorp.com/users` e recebeu:

```
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true
```

**Pergunta:** Isso é vulnerável? Como você provaria o impacto?

**Raciocínio esperado:**
1. **Sim, vulnerável** → Reflete qualquer origem + credenciais
2. **Impacto** → Site malicioso pode ler dados de usuários autenticados
3. **PoC** → Criar página HTML que faça requisição com cookies
4. **Dados expostos** → Informações pessoais, tokens, etc.

### Exercício 3: API Interna

**Cenário:** Ao escanear subdomínios, você encontrou `internal-api.targetcorp.com`. Retorna 404 para `/`, mas `/api/health` retorna 200 com:

```json
{"status": "ok", "version": "2.1.0", "database": "connected"}
```

**Pergunta:** O que você faria? Por quê?

**Raciocínio esperado:**
1. **API interna exposta** → Não deveria ser acessível externamente
2. **Versão exposta** → 2.1.0 pode ter CVEs conhecidos
3. **Status do banco** → Informação sensível (pode indicar tipo de DB)
4. **Próximo passo** → Enumerar mais endpoints, verificar autenticação

---

## ➡️ Depois de usar CORS e API — Próximos passos

1. **Valide cada finding** com PoC (Proof of Concept)
2. **Documente o impacto** (roubo de dados, bypass de autenticação)
3. **Teste as APIs encontradas** com fuzzing (SQLi, XSS, IDOR)
4. **Parabéns!** Você completou o módulo de Reconhecimento! 🎉
5. **Próximo módulo:** [Módulo 02: Web & Aplicações](../02-web-aplicacoes/)

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não testar null origin | Pode perder vulnerabilidade crítica | Sempre teste com `Origin: null` |
| Confiar apenas em Nuclei | Pode perder APIs não documentadas | Use ffuf e swagger discovery também |
| Não verificar credenciais | Falso negativo: CORS aceita qualquer origem mas não envia credenciais | Sempre teste com `Access-Control-Allow-Credentials` |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| OWASP CORS | Guia | [owasp.org](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/11-Client-side_Testing/07-Testing_Cross_Origin_Resource_Sharing) |
| Nuclei CORS Templates | Templates | [github.com/projectdiscovery/nuclei-templates](https://github.com/projectdiscovery/nuclei-templates) |
| API Discovery | Guia | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |
| PortSwigger API | Lab | [portswigger.net](https://portswigger.net/web-security) |

---

<div align="center">

**⬅️ [11-javascript-analysis.md](11-javascript-analysis.md)** | **Parabéns! Módulo 01 Completo! 🎉 ➡️ [Módulo 02: Web](../02-web-aplicacoes/)**

</div>
