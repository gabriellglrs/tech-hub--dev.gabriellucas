# Fase 2: Reconhecimento e Enumeração da Superfície de Ataque Web

**Tempo estimado:** 60-90 minutos
**Objetivo:** Mapear TODA a superfície de ataque da aplicação web — endpoints, métodos HTTP, parâmetros, tecnologias e conteúdos ocultos. Antes de testar qualquer vulnerabilidade, você precisa saber ONDE testar.
**Por quê:** Testar vulnerabilidades sem mapear a aplicação é como procurar uma agulha num palheiro no escuro. Este passo transforma o "site inteiro" em uma lista organizada de alvos específicos.

---

### Passo 2.1 — Spider/Crawl Automatizado do Site

**O que você vai fazer:** Usar o Burp Spider para rastrear automaticamente todo o site, descobrindo páginas, links, formulários e endpoints que você não encontraria manualmente.

**Passo 2.1.1 — Iniciar o Spider**

1. No Burp Suite, vá para **Target → Site map**
2. Clique com botão direito no domínio do alvo (ex: `https://target.com`)
3. Selecione **Spider this host**
4. Quando perguntado sobre escopo, confirme: **Yes**

**Aguardar crawl completar:**
- A barra de progresso aparece em **Target → Control**
- Tempo varia de 5-30 minutos dependendo do tamanho do site
- **NÃO pare manualmente** — deixe completar

**✅ Output esperado no Site map:**
```
https://target.com/
├── /login
├── /register
├── /api/
│   ├── /api/users
│   ├── /api/products
│   ├── /api/admin
│   └── /api/config
├── /static/
├── /robots.txt
├── /sitemap.xml
└── /dashboard
```

**O que procurar no output:**
- **Endpoints admin** → `/api/admin`, `/dashboard` → alvos prioritários
- **Endpoints de API** → `/api/` → testar injection, auth bypass
- **Formulários** → `/login`, `/register` → testar brute force, SQLi
- **Arquivos sensíveis** → `/robots.txt`, `/config` → informações vazadas

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Spider não encontra páginas | Login necessário | Configure Session Handling: **Project Options → Sessions → Session Handling Rules → Add** |
| Spider muito lento | Site muito grande | Configure limites: **Options → Spider → Max depth: 5** |
| Spider para em 403 | Permissão negada | Adicione cookies manualmente: **Options → Sessions → Cookies** |
| Muitas páginas irrelevantes | Crawl inclui CDN/assets | Filtre: **Options → Spider → Crawl Optimization →选括itemap** |

---

### Passo 2.2 — Enumeração de Conteúdo Oculto com ffuf

**O que você vai fazer:** Usar força bruta para descobrir diretórios, arquivos e endpoints que o Spider não encontrou (por não terem links apontando para eles).

**Passo 2.2.1 — Fuzzing de Diretórios**

```bash
ffuf -u https://target.com/FUZZ \
  -w /usr/share/wordlists/dirb/common.txt \
  -mc 200,301,302,403 \
  -o relatorio/ffuf-dirs.json \
  -of json
```

**Explicação das flags:**
- `-u https://target.com/FUZZ`: URL alvo com `FUZZ` como marcador de posição
- `-w`: wordlist a usar (common.txt tem ~4600 palavras)
- `-mc 200,301,302,403`: filtrar por status codes (200=encontrado, 301/302=redirecionado, 403=proibido mas existe)
- `-o`: salvar output em arquivo
- `-of json`: formato JSON para análise posterior

**✅ Output esperado:**
``        /[ Status: 200, Size: 1234, Words: 89, Lines: 32, Duration: 45ms]|
admin                   [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 12ms]
api                     [Status: 200, Size: 456, Words: 23, Lines: 8, Duration: 23ms]
config                  [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 11ms]
dashboard               [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 15ms]
robots.txt              [Status: 200, Size: 89, Words: 6, Lines: 4, Duration: 8ms]
server-status           [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 9ms]
phpinfo                 [Status: 200, Size: 67890, Words: 1234, Lines: 567, Duration: 34ms]
.git                    [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 10ms]
.env                    [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 11ms]
```

**O que procurar no output:**
- **Status 200 com tamanho grande** → página real com conteúdo
- **Status 302** → redirecionamento (pode ser login required)
- **Status 403** → existe mas bloqueado → testar bypass depois
- **`/phpinfo`** → informações do PHP expostas (perigoso)
- **`/.git`** → repositório git exposto (vazamento de código)
- **`/.env`** → variáveis de ambiente expostas (credenciais)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Site retorna 404 para tudo que não existe | Use `-fc 404` para filtrar falsos positivos |
| Muitos falsos positivos | Status 200 para páginas de erro | Use `-fs 0` para filtrar por tamanho |
| Rate limiting | WAF bloqueando | Reduza threads: `-t 10` e adicione delay: `-delay 100ms` |
| `ffuf: command not found` | Não instalado | `go install github.com/ffuf/ffuf/v2@latest` |

**Passo 2.2.2 — Fuzzing de Parâmetros**

```bash
ffuf -u https://target.com/page?id=FUZZ \
  -w /usr/share/wordlists/dirb/common.txt \
  -mc 200 \
  -o relatorio/ffuf-params.json \
  -of json
```

**✅ Output esperado:**
``        /[ Status: 200, Size: 5678, Words: 234, Lines: 67, Duration: 34ms]|
id                      [Status: 200, Size: 5678, Words: 234, Lines: 67, Duration: 12ms]
page                    [Status: 200, Size: 4567, Words: 198, Lines: 56, Duration: 15ms]
search                  [Status: 200, Size: 3456, Words: 156, Lines: 45, Duration: 18ms]
```

---

### Passo 2.3 — Enumeração de Subdomínios

**O que você vai fazer:** Descobrir subdomínios adicionais que podem pertencer à mesma organização e ter menos segurança.

```bash
subfinder -d target.com -silent > relatorio/subdomains.txt
```

**✅ Output esperado:**
``api.target.com
admin.target.com
staging.target.com
dev.target.com
mail.target.com
vpn.target.com
```

**Verificar quais respondem HTTP:**
```bash
cat relatorio/subdomains.txt | httpx -silent -status-code -title
```

**✅ Output esperado:**
``http://api.target.com [200] [API Gateway]
http://admin.target.com [403] [Admin Panel]
http://dev.target.com [200] [Development Server]
http://mail.target.com [200] [Webmail]
```

**O que procurar no output:**
- **Status 200** → site acessível → verificar se está no escopo
- **Status 403** → existe mas bloqueado → candidato a bypass
- **`[Development Server]`** → ambiente de dev → geralmente menos seguro
- **`[Admin Panel]`** → painel administrativo → alvo prioritário

---

### Passo 2.4 — Identificar Tecnologias com WhatWeb

**O que você vai fazer:** Identificar o servidor web, frameworks, linguagens e CMS usados. Isso ajuda a escolher os payloads corretos nas fases seguintes.

```bash
whatweb https://target.com -v > relatorio/whatweb.txt
```

**✅ Output esperado:**
``http://target.com [200 OK] Apache[2.4.41], PHP[7.4.3], jQuery[3.5.1], WordPress[6.4.2], Bootstrap[5.3.2], Font-Awesome[6.5.1], MetaGenerator[WordPress 6.4.2], X-Powered-By[PHP/7.4.3], country[US], email[admin@target.com], ip[104.21.33.15]
```

**O que procurar no output:**
- **Apache[2.4.41]** → versão do servidor → buscar CVEs conhecidas
- **PHP[7.4.3]** → linguagem e versão → PHP 7.4 é antigo (EOL)
- **WordPress[6.4.2]** → CMS → usar WPScan depois
- **jQuery[3.5.1]** → versão do jQuery → pode ter XSS conhecido
- **MetaGenerator[WordPress]** → confirma WordPress
- **email[admin@target.com]** → email encontrado → usar para OSINT

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `whatweb: command not found` | Não instalado | `sudo apt install whatweb` |
| Output muito genérico | Site usa CDN/proxy | Use `curl -I` para ver headers reais |
| Timeout | Site bloqueando | Use `whatweb --timeout=10` |

---

### Passo 2.5 — Analisar Headers HTTP

**O que você vai fazer:** Verificar headers de resposta para identificar tecnologias, versões e falhas de configuração.

```bash
curl -I -s https://target.com > relatorio/headers.txt
```

**✅ Output esperado:**
```
HTTP/1.1 200 OK
Date: Sat, 12 Sep 2026 14:30:00 GMT
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
Referrer-Policy: strict-origin-when-cross-origin
Connection: close
Content-Type: text/html; charset=UTF-8
```

**O que procurar no output:**

| Header | Presente? | Significado |
|--------|-----------|-------------|
| `Server: Apache/2.4.41` | ✅ | Versão do servidor exposta → buscar CVEs |
| `X-Powered-By: PHP/7.4.3` | ✅ | Linguagem e versão expostas → PHP 7.4 é EOL |
| `X-Frame-Options` | ✅ | Proteção contra clickjacking |
| `X-Content-Type-Options` | ✅ | Proteção contra MIME sniffing |
| `Strict-Transport-Security` | ✅ | Força HTTPS |
| `Content-Security-Policy` | ✅ | Proteção contra XSS |
| **Ausência de qualquer um** | ⚠️ | Falta de proteção → documentar |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `curl: (60) SSL certificate problem` | Certificado auto-assinado | Use `curl -k -I` (não recomendado em produção) |
| Timeout | Site bloqueando | Use `curl -I --connect-timeout 10` |
| Output vazio | Site não responde | Verifique se o site está online |

---

### Passo 2.6 — Identificar Métodos HTTP Suportados

**O que você vai fazer:** Verificar quais métodos HTTP cada endpoint aceita. Métodos como PUT, DELETE, PATCH podem indicar APIs RESTful com menos proteção.

**Passo 2.6.1 — Testar OPTIONS no endpoint principal**

No Burp Repeater, envie:
```http
OPTIONS /api/users HTTP/1.1
Host: target.com
```

**✅ Output esperado (vulnerável):**
```
HTTP/1.1 200 OK
Allow: GET, POST, PUT, DELETE, PATCH
```

**O que procurar:**
- **PUT/DELETE/PATCH** → API RESTful → testar auth bypass
- **TRACE** → possível XST (Cross-Site Tracing)
- **CONNECT** → possível proxy aberto

**Passo 2.6.2 — Testar em múltiplos endpoints**

```bash
for endpoint in /api/users /api/products /api/admin /api/config; do
  echo "=== $endpoint ===" >> relatorio/methods.txt
  curl -X OPTIONS -s -I https://target.com$endpoint | grep -i "allow" >> relatorio/methods.txt
done
```

**✅ Output esperado:**
```
=== /api/users ===
Allow: GET, POST, PUT, DELETE

=== /api/products ===
Allow: GET, POST

=== /api/admin ===
Allow: GET, POST, PUT, DELETE

=== /api/config ===
Allow: GET
```

---

### Passo 2.7 — Mapear Endpoints de API

**O que você vai fazer:** Verificar se a API documentada está exposta publicamente (Swagger/OpenAPI) e se aceita queries GraphQL.

**Passo 2.7.1 — Procurar documentação da API**

```bash
# Testar URLs comuns de documentação
for url in /api/swagger.json /api/openapi.json /swagger-ui.html /api/docs /api/v1/docs; do
  status=$(curl -s -o /dev/null -w "%{http_code}" https://target.com$url)
  if [ "$status" != "404" ]; then
    echo "[+] $url → HTTP $status" >> relatorio/api-docs.txt
    curl -s https://target.com$url >> relatorio/api-docs-$url.txt 2>/dev/null
  fi
done
```

**✅ Output esperado:**
```
[+] /api/swagger.json → HTTP 200
[+] /api/docs → HTTP 200
```

**O que procurar:**
- **Swagger/OpenAPI exposto** → lista TODOS os endpoints, parâmetros e modelos → mapa completo da API
- **Documentação interna** → pode conter endpoints não documentados

**Passo 2.7.2 — Testar GraphQL**

```bash
curl -s -X POST https://target.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { queryType { name } mutationType { name } types { name } } }"}' \
  | python3 -m json.tool > relatorio/graphql-schema.json 2>/dev/null
```

**✅ Output esperado (se GraphQL existe):**
```json
{
  "data": {
    "__schema": {
      "queryType": { "name": "Query" },
      "mutationType": { "name": "Mutation" },
      "types": [
        { "name": "User" },
        { "name": "Product" },
        { "name": "Order" }
      ]
    }
  }
}
```

**O que procurar:**
- **QueryType/MutationType** → tipos de operações disponíveis
- **Tipos como User, Order** → entidades que podem ser acessadas
- **Se retornar erro** → GraphQL não existe ou não está exposto

---

### Passo 2.8 — Identificar Parâmetros de Entrada

**O que você vai fazer:** Catalogar TODOS os parâmetros de entrada da aplicação. Cada parâmetro é um candidato a injeção.

**Passo 2.8.1 — Extrair parâmetros do HTTP History do Burp**

1. No Burp, vá para **Proxy → HTTP history**
2. Filtre pelo domínio do alvo
3. Clique na aba **Params** para cada request
4. Anote todos os parâmetros encontrados

**Exemplo de parâmetros a documentar:**
```
GET /api/users?id=1&role=admin          → parâmetros: id, role
POST /api/login                          → parâmetros: username, password
PUT /api/users/1                         → body JSON: name, email
GET /api/search?q=test&page=1            → parâmetros: q, page
POST /api/upload                         → multipart: file
```

**Salve manualmente em `relatorio/parametros.txt`** (não há comando automatizado para isso no Burp Community).

**O que procurar:**
- **Parâmetros numéricos** (`id=1`) → candidatos a SQLi
- **Parâmetros de busca** (`q=test`) → candidatos a XSS
- **Parâmetros de URL** (`url=http://...`) → candidatos a SSRF
- **Parâmetros de arquivo** (`file=...`) → candidatos a upload malicioso
- **Parâmetros JSON** → candidatos a NoSQLi e SSTI

---

### Passo 2.9 — Salvar e Organizar Resultados

**O que você vai fazer:** Exportar todos os dados do Burp e organizar em arquivos para referência nas próximas fases.

```bash
# Criar diretório de relatório se não existir
mkdir -p relatorio

# Exportar Site map do Burp (manual):
# Target → Site map → Clique direito → Save selected items
# Salvar como: relatorio/sitemap.xml

# Exportar HTTP history do Burp (manual):
# Proxy → HTTP history → Clique direito → Save items
# Salvar como: relatorio/http-history.xml
```

---

### Checklist da Fase 2

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Spider/Crawl concluído | `relatorio/sitemap.xml` | [ ] |
| 2 | Diretórios enumerados | `relatorio/ffuf-dirs.json` | [ ] |
| 3 | Parâmetros enumerados | `relatorio/ffuf-params.json` | [ ] |
| 4 | Subdomínios descobertos | `relatorio/subdomains.txt` | [ ] |
| 5 | Tecnologias identificadas | `relatorio/whatweb.txt` | [ ] |
| 6 | Headers HTTP analisados | `relatorio/headers.txt` | [ ] |
| 7 | Métodos HTTP documentados | `relatorio/methods.txt` | [ ] |
| 8 | Documentação API encontrada | `relatorio/api-docs.txt` | [ ] |
| 9 | GraphQL schema extraído | `relatorio/graphql-schema.json` | [ ] |
| 10 | Parâmetros catalogados | `relatorio/parametros.txt` | [ ] |
| 11 | HTTP history exportado | `relatorio/http-history.xml` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 2:

```
relatorio/
├── sitemap.xml              ← árvore de URLs do Burp Spider
├── http-history.xml         ← todos os requests HTTP capturados
├── ffuf-dirs.json           ← diretórios e arquivos encontrados
├── ffuf-params.json         ← parâmetros de entrada encontrados
├── subdomains.txt           ← subdomínios adicionais
├── whatweb.txt              ← tecnologias identificadas
├── headers.txt              ← headers HTTP do site principal
├── methods.txt              ← métodos HTTP suportados por endpoint
├── api-docs.txt             ← endpoints de documentação da API
├── api-docs-swagger.json    ← conteúdo do Swagger (se encontrado)
├── graphql-schema.json      ← schema GraphQL (se encontrado)
└── parametros.txt           ← lista de todos os parâmetros de entrada
```

### ✅ Sinal de sucesso:
- Você tem **pelo menos 10 endpoints** documentados no sitemap
- Você sabe **quais tecnologias** o site usa (servidor, framework, CMS)
- Você tem **uma lista de parâmetros** para testar nas próximas fases
- Você sabe **quais métodos HTTP** são aceitos em cada endpoint

### ❌ Se falhou:
- Se Spider não encontrou nada → provavelmente precisa de autenticação → configure Session Handling
- Se ffuf retornou vazio → o site pode estar usando SPA (Single Page Application) → foque em API discovery
- O mínimo para avançar: ter `parametros.txt` com pelo menos 3 parâmetros identificados

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 2 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `parametros.txt` | Fase 3 (Injeção) | Saber quais parâmetros testar com SQLi/XSS/SSRF |
| `whatweb.txt` | Fase 3, 5 | Escolher payloads corretos (PHP vs Python vs Java) |
| `headers.txt` | Fase 4 (Cliente) | Verificar headers de segurança ausentes |
| `subdomains.txt` | Fase 5 (Auth) | Encontrar alvos adicionais para brute force |
| `api-docs.txt` | Fase 3, 6 | Mapear endpoints de API para testar |
| `ffuf-dirs.json` | Fase 3, 7 | Encontrar endpoints ocultos para testar |
| `methods.txt` | Fase 7 (Business) | Saber quais métodos testar para bypass |

**Se completou tudo → Avance para Fase 3**

---
