## FASE 2 — Descoberta e Superfície de Ataque

**Tempo estimado:** 60-90 minutos
**Objetivo:** Mapear TODA a superfície de ataque da aplicação — endpoints, métodos HTTP, parâmetros, tecnologias e conteúdos ocultos. Antes de testar vulnerabilidades, você precisa saber ONDE testar.
**Por quê:** Testar vulnerabilidade sem mapear a aplicação é procurar agulha num palheiro no escuro. Este passo transforma "site inteiro" em uma lista organizada de alvos específicos.

> **📡 Herança da Fase 1 (dados do MANUAL-RECON):** o escopo (`escopo-web.txt` ← `02-enum/vivos-filtrados.txt`), os diretórios já descobertos (`dirs-web.txt` ← `04-discovery/gobuster-basico.txt`), parâmetros (`params-web.txt` ← `04-discovery/urls-com-parametros.txt`) e o WAF (`waf-web.txt` ← `03-fingerprint/waf-principal.txt`) já estão em `08-alimentacao/`. Não refaça o que o recon já fez.

---

### Passo 2.1 — Importar escopo no Burp e iniciar o Crawl

**O que você vai fazer:** Carregar as URLs do escopo no Burp e deixar o Spider rastrear o site automaticamente.

1. **Target → Scope → Add:** adicione cada URL de `08-alimentacao/escopo-web.txt` (ou use o regex `https?://.*evilcorp\.com:.*` do [03-setup-ferramentas.md](03-setup-ferramentas.md))
2. **Target → Site map** → clique direito no domínio → **Spider this host** → confirme **Yes**
3. Aguarde completar (5-30 min) — **NÃO pare manualmente**

**✅ Output esperado no Site map:**
```
https://evilcorp.com/
├── /login
├── /register
├── /api/
│   ├── /api/users
│   ├── /api/products
│   └── /api/admin
├── /robots.txt
├── /sitemap.xml
└── /dashboard
```

**O que procurar:**
- **Endpoints admin** → `/api/admin`, `/dashboard` → alvos prioritários
- **Endpoints de API** → `/api/` → testar injeção e auth bypass (Fases 3 e 4)
- **Formulários** → `/login`, `/register` → DOCUMENTE em `logins-formularios.txt` (abaixo)
- **Arquivos** → `/robots.txt`, `/config` → informações vazadas

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Spider não encontra páginas | Login necessário | Configure Session Handling: **Project Options → Sessions → Add** |
| Spider muito lento | Site grande | **Options → Spider → Max depth: 5** |
| Spider para em 403 | Permissão negada | Adicione cookies: **Options → Sessions → Cookies** |
| Muitas páginas irrelevantes | Crawl pegou CDN | Confirme que o Scope está correto (só domínio do alvo) |

---

### Passo 2.2 — Enumeração de Conteúdo Oculto com ffuf

**O que você vai fazer:** Fuzzing de diretórios e parâmetros — complementando (NÃO repetindo) o que o recon já achou.

**Passo 2.2.1 — Fuzzing de Diretórios**

```bash
mkdir -p 09-descoberta

ffuf -u https://evilcorp.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -mc 200,301,302,403 \
  -t 5 -p 0.5 \
  -o 09-descoberta/ffuf-dirs.json \
  -of json
```

**Explicação das flags:**
- `-u https://evilcorp.com/FUZZ` → URL alvo com `FUZZ` como marcador
- `-w common.txt` → wordlist padrão (~4600 palavras — veja 05-wordlists.md)
- `-mc 200,301,302,403` → só reporta esses status (200=encontrado, 403=existe mas bloqueado)
- `-t 5 -p 0.5` → 5 threads com 0.5s de delay (WAF-safe — **remova só se o recon disse que não tem WAF e for lab**)

**📡 Diretórios do Reconhecimento (Módulo 01):** antes de rodar, teste no Burp Repeater os caminhos de `08-alimentacao/dirs-web.txt` (ex: `https://evilcorp.com/.env`, `/config.bak`) — se ainda respondem conteúdo, é achado CRÍTICO sem precisar de fuzzing.

**✅ Output esperado:**
```
admin       [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 12ms]
api         [Status: 200, Size: 456, Words: 23, Lines: 8, Duration: 23ms]
config      [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 11ms]
dashboard   [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 15ms]
robots.txt  [Status: 200, Size: 89, Words: 6, Lines: 4, Duration: 8ms]
phpinfo     [Status: 200, Size: 67890, Words: 1234, Lines: 567, Duration: 34ms]
.env        [Status: 403, Size: 123, Words: 5, Lines: 3, Duration: 10ms]
```

**O que procurar no output:**
- **200 com tamanho grande** → página real com conteúdo
- **302** → redirecionamento (provável login required → documentar form)
- **403** → existe mas bloqueado → candidato a bypass (Fase 4)
- **`/phpinfo`** → info do PHP exposta (achado)
- **`/.git`, `/.env`** → vazamento de código/credenciais (CRÍTICO)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | 404 para tudo | `-fc 404` para filtrar falsos positivos |
| Muitos falsos positivos | Página de erro devolve 200 | `-fs 0` filtra por tamanho |
| 429/403 em tudo | WAF bloqueou | `-t 2 -p 2` (mais lento) — ver 06-opsec.md |
| `ffuf: command not found` | Não instalado | `go install github.com/ffuf/ffuf/v2@latest` |

**Passo 2.2.2 — Fuzzing de Parâmetros**

```bash
# Descobrir nome de parâmetros em uma URL que já tem parâmetro
ffuf -u "https://evilcorp.com/busca?FUZZ=teste" \
  -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt \
  -mc 200 -t 5 -p 0.5 \
  -o 09-descoberta/ffuf-params.json -of json

# Anexar descobertas à lista da Fase 1
# (renomeie manualmente: ffuf-params.json → params-web.txt)
```

---

### Passo 2.3 — Verificar Subdomínios (do Módulo 01, complementar)

**O que você vai fazer:** Conferir os subdomínios do recon e descobrir novos que respondem HTTP.

```bash
# Lista do recon (Módulo 01) já existe — conferir status
httpx -l 02-enum/vivos-filtrados.txt -silent -status-code -title > 09-descoberta/subdomains-http.txt

# Só se precisar descobrir NOVOS (opcional):
subfinder -d evilcorp.com -silent >> 08-alimentacao/escopo-web.txt 2>/dev/null
```

**✅ Output esperado:**
```
http://api.evilcorp.com [200] [API Gateway]
http://admin.evilcorp.com [403] [Admin Panel]
http://dev.evilcorp.com [200] [Development Server]
```

**O que procurar:** `[Development Server]` = ambiente dev (geralmente menos seguro); `[403]` = candidato a bypass; confirme que estão no escopo antes de testar.

---

### Passo 2.4 — Confirmar Tecnologias (WhatWeb) e decidir payloads

**O que você vai fazer:** Confirmar o fingerprint — é ele que diz QUAL payload usar nas fases seguintes.

```bash
whatweb https://evilcorp.com -v > 09-descoberta/whatweb.txt
```

**✅ Output esperado:**
```
http://evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], jQuery[3.5.1], WordPress[6.4.2], X-Powered-By[PHP/7.4.3]
```

**📡 Fingerprint do Reconhecimento (Módulo 01):** o recon já gerou `08-alimentacao/fingerprint-web.txt`. Rode o WhatWeb só para confirmar/atualizar.

**Decisão de payloads:**
| Detectado | Ação |
|-----------|------|
| **WordPress** | WPScan com plugins de `05-vulns/wpscan.txt` (Módulo 01) |
| **PHP** | payloads PHP, SQLi, SSTI Jinja2 se Flask |
| **Python/Jinja2** | SSTI: `{{7*7}}`, `{{config.items()}}` |
| **jQuery < 3.5.0** | `searchsploit jquery <versão>` (XSS conhecido) |
| **Apache/versão antiga** | CVEs do servidor (Fase 6 — Nuclei) |

**❌ Se der errado:** `whatweb: command not found` → `sudo apt install whatweb`; output genérico (CDN) → use `curl -I`.

---

### Passo 2.5 — Analisar Headers HTTP

**O que você vai fazer:** Verificar headers de resposta — versões expostas e proteções ausentes (base dos testes da Fase 4).

```bash
curl -I -s https://evilcorp.com > 09-descoberta/headers.txt
```

**✅ Output esperado:**
```
HTTP/1.1 200 OK
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000
Content-Security-Policy: default-src 'self'
```

**O que procurar:**

| Header | Significado |
|--------|-------------|
| `Server:` / `X-Powered-By:` | Versões expostas → CVEs (Fase 6) |
| `X-Frame-Options` ausente | clickjacking possível (Fase 4) |
| `X-Content-Type-Options` ausente | MIME sniffing (Fase 4) |
| `Content-Security-Policy` ausente | XSS mais fácil (Fase 4) |
| `Strict-Transport-Security` ausente | sem força HTTPS (achado) |

**❌ Se der errado:** SSL error → `curl -k -I`; timeout → `--connect-timeout 10`.

---

### Passo 2.6 — Identificar Métodos HTTP Suportados

**O que você vai fazer:** Verificar quais métodos cada endpoint aceita — PUT/DELETE/PATCH sem auth = API mal protegida.

**No Burp Repeater:**
```http
OPTIONS /api/users HTTP/1.1
Host: evilcorp.com
```

**✅ Output esperado (vulnerável):**
```
HTTP/1.1 200 OK
Allow: GET, POST, PUT, DELETE, PATCH
```

**Ou em lote:**
```bash
for endpoint in /api/users /api/products /api/admin /api/config; do
  echo "=== $endpoint ===" >> 09-descoberta/methods.txt
  curl -X OPTIONS -s -I https://evilcorp.com$endpoint | grep -i "allow" >> 09-descoberta/methods.txt
done
cat 09-descoberta/methods.txt
```

**O que procurar:**
- **PUT/DELETE/PATCH** → testar auth bypass (Fase 4) e lógica (Fase 5)
- **TRACE** → possível XST
- **Métodos não listados em endpoints de API** → testar manualmente (Fase 5)

---

### Passo 2.7 — Mapear Endpoints de API (Swagger/GraphQL)

**O que você vai fazer:** Verificar se a documentação da API está exposta (mapa completo!) e se existe GraphQL.

```bash
# Documentação da API
for url in /api/swagger.json /api/openapi.json /swagger-ui.html /api/docs /api/v1/docs; do
  status=$(curl -s -o /dev/null -w "%{http_code}" https://evilcorp.com$url)
  if [ "$status" != "404" ]; then
    echo "[+] $url → HTTP $status" >> 09-descoberta/api-docs.txt
    curl -s https://evilcorp.com$url > 09-descoberta/api-docs-$(echo $url | tr '/' '_').json 2>/dev/null
  fi
done

# GraphQL
curl -s -X POST https://evilcorp.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { queryType { name } mutationType { name } types { name } } }"}' \
  | python3 -m json.tool > 09-descoberta/graphql-schema.json 2>/dev/null
```

**✅ Output esperado:**
```
[+] /api/swagger.json → HTTP 200
```

**O que procurar:**
- **Swagger exposto** → lista TODOS os endpoints e parâmetros — mapa completo da API (use em todas as fases)
- **GraphQL com `__schema`** → tipos `User`, `Order` etc. → testar introspecção e auth (Fases 4 e 5)

**📡 Endpoints de API do Reconhecimento (Módulo 01):** teste primeiro os de `08-alimentacao/endpoints-web.txt` no Repeater — eles já existem.

---

### Passo 2.8 — Catalogar Parâmetros de Entrada

**O que você vai fazer:** Reunir TODOS os parâmetros de entrada — cada um é candidato a injeção na Fase 3.

1. No Burp: **Proxy → HTTP history** → filtre pelo alvo → aba **Params** de cada request
2. Anote em `09-descoberta/parametros.txt`:

```
GET /api/users?id=1&role=admin        → id, role
POST /api/login                        → username, password
PUT /api/users/1                       → JSON: name, email
GET /api/search?q=test&page=1          → q, page
POST /api/upload                       → multipart: file
```

**O que procurar:**
- **`id=1` (numérico)** → SQLi (Fase 3)
- **`q=test` (busca)** → XSS (Fase 4)
- **`url=` / `file=`** → SSRF/arquivo (Fase 5)
- **JSON body** → NoSQLi/SSTI (Fase 3)
- **`file` em multipart** → upload (Fase 5)

---

### Passo 2.9 — Documentar Logins e Formulários (alimenta o Módulo 03)

**O que você vai fazer:** Registrar cada formulário encontrado no formato que o MANUAL-EXPLOR (Módulo 03) vai importar.

```bash
cat > 09-descoberta/logins-formularios.txt << 'EOF'
https://evilcorp.com/login;username;password;Invalid credentials
https://evilcorp.com/wp-login.php;log;pwd;ERROR: The password you entered
https://evilcorp.com/admin/;user;pass;Login failed
EOF

# Caminhos de login/painel (para brute force no Módulo 03, se autorizado)
grep -iE "login|signin|admin|wp-login|auth|panel|dashboard" 08-alimentacao/dirs-web.txt \
  > 09-descoberta/logins-web.txt 2>/dev/null

cat 09-descoberta/logins-formularios.txt
```

**Formato:** `URL;campo_usuario;campo_senha;mensagem_de_erro`

**O que procurar:**
- **Mensagem de erro exata** (`Invalid credentials`) → essencial para detectar falha em brute force
- **`/wp-login.php`** → campos `log`/`pwd` (formato diferente do padrão)

> 💡 **Sem `logins-formularios.txt`, o Módulo 03 não consegue testar logins HTTP.** Descubra os campos pelo navegador: F12 → Network → envie um login errado → veja o POST.

---

### Passo 2.10 — Salvar e Organizar Resultados

```bash
# Exportar do Burp (manual):
# Target → Site map → clique direito → Save selected items → 09-descoberta/sitemap.xml
# Proxy → HTTP history → clique direito → Save items → 09-descoberta/http-history.xml
```

---

### Checklist da Fase 2

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Crawl/Burp concluído | `09-descoberta/sitemap.xml` | [ ] |
| 2 | Diretórios enumerados | `09-descoberta/ffuf-dirs.json` | [ ] |
| 3 | Parâmetros enumerados | `09-descoberta/ffuf-params.json` | [ ] |
| 4 | Subdomínios verificados | `09-descoberta/subdomains-http.txt` | [ ] |
| 5 | Tecnologias confirmadas | `09-descoberta/whatweb.txt` | [ ] |
| 6 | Headers analisados | `09-descoberta/headers.txt` | [ ] |
| 7 | Métodos HTTP documentados | `09-descoberta/methods.txt` | [ ] |
| 8 | API/GraphQL mapeada | `09-descoberta/api-docs.txt` | [ ] |
| 9 | Parâmetros catalogados | `09-descoberta/parametros.txt` | [ ] |
| 10 | Logins/forms documentados (Módulo 03) | `09-descoberta/logins-formularios.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 2:

```
09-descoberta/
├── sitemap.xml              ← árvore de URLs do Burp
├── http-history.xml         ← todos os requests capturados
├── ffuf-dirs.json           ← diretórios encontrados
├── ffuf-params.json         ← parâmetros descobertos
├── subdomains-http.txt      ← subdomínios com status HTTP
├── whatweb.txt              ← tecnologias confirmadas
├── headers.txt              ← headers de resposta
├── methods.txt              ← métodos HTTP por endpoint
├── api-docs.txt             ← documentação da API exposta
├── graphql-schema.json      ← schema GraphQL (se houver)
├── parametros.txt           ← CATALOGO de parâmetros (Fase 3)
├── logins-formularios.txt   ← forms para o Módulo 03
└── logins-web.txt           ← caminhos de login/painel
```

### ✅ Sinal de sucesso:
- **≥ 10 endpoints** documentados no sitemap
- **≥ 3 parâmetros** em `parametros.txt`
- Você sabe **quais tecnologias** o site usa e **se tem WAF**
- `logins-formularios.txt` com pelo menos **1 form** (ou você sabe que não tem login)

### ❌ Se falhou:
- Spider sem resultado → precisa de login → configure Session Handling
- ffuf vazio → SPA (Single Page Application) → foque em API discovery (Passo 2.7)
- Sem forms → verifique `/login`, `/admin`, `/wp-login.php` manualmente no navegador

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 2 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `parametros.txt` | Fase 3 | Quais parâmetros testar com SQLi/NoSQLi/SSTI |
| `whatweb.txt` | Fases 3 e 5 | Escolher payloads (PHP vs Python vs Java vs WP) |
| `headers.txt` | Fase 4 | Detectar headers de segurança ausentes |
| `methods.txt` | Fases 4 e 5 | Bypass de auth e lógica de negócio |
| `api-docs.txt` / `graphql-schema.json` | Fases 3, 4, 5 | Endpoints de API para todos os testes |
| `logins-formularios.txt` | Fase 4 e **Módulo 03** | Brute force HTTP (Módulo 03) |
| `ffuf-dirs.json` | Fases 5 e 6 | Caminhos ocultos para testar/validar |

**Se completou tudo → Avance para [Fase 3 — Testes de Injeção](09-fase3-injecao.md)**
