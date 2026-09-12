# 🛡️ 01. Burp Suite — O Cento de Comando do Web Hacking

> Todo hacker web começa pelo proxy. Burp Suite é onde você intercepta, modifica e entende cada byte que sai do seu navegador.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 90min | ⭐⭐ Intermediário | `burpsuite` |

</div>

---

## 🎓 Por que isso importa?

Burp Suite é o **Nmap do mundo web**. Sem ele, você está no escuro — mandando requests cegos e rezando pra achar vulnerabilidade. Com ele, você vê TUDO que sai do navegador: headers, cookies, tokens JWT, parâmetros ocultos, JS minificado.

**Analogia:** Imagine que toda conversa entre seu navegador e o servidor passa por um tradutor. Burp Suite é esse tradutor — mas ao invés de só traduzir, ele permite que você **reescreva a mensagem** antes de entregar.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP básico (métodos, headers, status codes) | Sim | Módulo 00 |
| O que é um proxy | Sim | Este arquivo explica |
| Navegador (Firefox ou Chromium) | Sim | — |

---

## 🎯 Quando usar Burp Suite

- **Sempre** que estiver testando uma web application
- Para interceptar login e estudar como a autenticação funciona
- Para modificar parâmetros (ex: trocar `user_id=5` por `user_id=1`)
- Para fuzzar inputs com Intruder (SQLi, XSS, command injection)
- Para decodificar tokens JWT, Base64, URL encoding
- Para comparar respostas ( username enumeration via timing/size)

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Navegador  │ ◄─────► │   Burp Proxy     │ ◄─────► │   Servidor   │
│  (127.0.0.1  │  :8080  │  Intercepta e    │         │   (target)   │
│   :8080)     │         │  modifica        │         │              │
└──────────────┘         └──────────────────┘         └──────────────┘
        │                         │
        │                    ┌────┴─────┐
        │                    │ Repeater │──► Enviar request manual
        │                    │ Intruder │──► Fuzzing automatizado
        │                    │ Decoder  │──► Encode/Decode
        │                    │ Comparer │──► Comparar respostas
        │                    └──────────┘
        ▼
  Configuração:
  Firefox → Proxy → 127.0.0.1:8080
  Instalar CA certificate (http://burpsuite)
```

---

## 🛠️ Instalação

```bash
# Pre-installed no Kali
burpsuite --version

# Se não estiver:
sudo apt update && sudo apt install burpsuite

# Verificar instalação
which burpsuite
```

---

## 🔧 Componentes Principais

### 1. Proxy — O Coração

O Proxy intercepta todo tráfego HTTP/HTTPS entre o navegador e o servidor.

**Configurar o navegador (método manual):**

```
1. Abrir Firefox → Settings → Network Settings → Manual proxy
2. HTTP Proxy: 127.0.0.1  Port: 8080
3. ✅ Proxy also for HTTPS
4. OK

5. Instalar CA certificate:
   - Visitar http://burpsuite no Firefox
   - Baixar CA Certificate (DER format)
   - Firefox → Settings → Privacy → Certificates → View Certificates
   - Authorities → Import → Selecionar o arquivo .der
   - ✅ Trust this CA to identify websites → OK
```

**Configurar o navegador (método rápido — Burp Browser):**

```
1. Burp Suite → Proxy → Intercept
2. Clicar "Open Browser" → Abre Chromium pré-configurado
3. Pronto! Tudo já passa pelo proxy
```

**Usar o Intercept:**

```
Proxy → Intercept → Intercept is ON

1. Navegar para qualquer site no navegador
2. O request aparece no Burp → Intercept
3. Editar o request (mudar parâmetros, headers, body)
4. Click "Forward" para enviar ao servidor
5. Click "Forward" novamente para receber a resposta
6. Para navegar normal: "Intercept is off"
```

### 2. HTTP History — Log Completo

```
Proxy → HTTP History

- Lista todos os requests que passaram pelo proxy
- Clicar em qualquer request → vê request completo + response
- Colunas: #, Host, Method, URL, Params, Cookie, Status, Length
- Filtros: por host, status code, MIME type, extensão
```

### 3. Repeater — Request Manual

O Repeater permite enviar requests individuais, modificar e reenviar quantas vezes quiser.

**Como usar:**

```
1. Em qualquer lugar do Burp → clique com botão direito no request
2. "Send to Repeater" (ou Ctrl+R)
3. Ir para aba "Repeater"
4. Modificar o request no painel esquerdo
5. Click "Send" (ou Ctrl+Enter)
6. Resposta aparece no painel direito
7. Cada request fica em uma aba separada
```

**Casos de uso do Repeater:**

```
- Testar SQL injection: alterar parâmetro para ' OR 1=1--
- Testar XSS: alterar parâmetro para <script>alert(1)</script>
- Testar IDOR: trocar user_id=5 por user_id=1
- Testar header injection: adicionar X-Forwarded-For: 127.0.0.1
- Testar auth bypass: remover cookie de sessão
```

### 4. Intruder — Fuzzing Automatizado

O Intruder envia o mesmo request milhares de vezes com payloads diferentes.

**Attack Types (Modos de Payload):**

| Tipo | Descrição | Quando usar |
|------|-----------|-------------|
| **Sniper** | Testa cada posição separadamente | Brute force de um parâmetro |
| **Battering Ram** | Mesmo payload em todas as posições | Testar o mesmo valor em múltiplos campos |
| **Pitchfork** | Payloads paralelos (1:1 mapping) | User+Password em pares |
| **Cluster Bomb** | Combinação de todos (cartesiano) | Testar todas as combinações user×pass |

**Como usar:**

```
1. Em qualquer request → "Send to Intruder" (Ctrl+I)
2. Ir para aba "Intruder"
3. Na aba "Positions":
   - O payload é marcado com § (ex: username=§admin§)
   - Adicionar/remover marcações com "Add §" e "Clear §"
4. Na aba "Payloads":
   - Payload set: selecionar qual posição
   - Payload type: Simple list / Runtime file / Numbers
   - Adicionar valores manualmente ou carregar de arquivo
5. Click "Start attack"
6. Analisar resultados por tamanho da resposta ou status code
```

**Payloads úteis para brute force:**

```bash
# Wordlist de usernames
/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt

# Wordlist de passwords
/usr/share/wordlists/rockyou.txt

# Para SQL injection
/usr/share/wordlists/seclists/Fuzzing/special-chars.txt

# Para directories
/usr/share/wordlists/dirb/common.txt
```

### 5. Decoder — Encode/Decode

Transforma dados entre formatos comuns.

```
Envio para Decoder:
  - Clique com botão direito em qualquer dado → "Send to Decoder"
  - Ou selecione texto → Ctrl+E

Operações disponíveis:
  - Decode as: URL, HTML, Base64, ASCII hex, Hex, Octal, Binary, GZIP
  - Encode as: os mesmos formatos
  - Hash: MD5, SHA-1, SHA-256, SHA-512
  - Smart decode: detecta e decodifica automaticamente

Exemplo prático:
  Input:  YWRtaW46cGFzc3dvcmQ=
  Decode as Base64 → admin:password
```

### 6. Comparer — Comparar Duas Respostas

Compara dois dados para identificar diferenças sutis (útil para username enumeration).

```
1. Enviar dois requests para Comparer (botão direito → "Send to Comparer")
2. Ir para aba "Comparer"
3. Selecionar um item de cada tabela
4. Clicar "Words" ou "Bytes"
5. Resultado mostra diferenças destacadas em cores
```

### 7. Target — Mapa do Site

```
Target → Site map

- Mostra árvore completa do site
- URL view: estrutura de pastas/arquivos
- Crawl paths: caminhos de navegação
- Scope: definir quais URLs estão no escopo
- Issue definitions: lista de vulnerabilidades
```

---

## 📋 Tabela de Flags / Opções do Burp

### Proxy Settings

| Opção | Descrição | Exemplo |
|-------|-----------|---------|
| `Proxy listener` | Porta do proxy | Default: 127.0.0.1:8080 |
| `Intercept` | Toggle intercept on/off | Intercept is on / off |
| `Match and Replace` | Auto-modificar requests/responses | Regex para trocar headers |
| `CA Certificate` | Exportar certificado para navegador | Salvar DER format |

### Intruder Payload Options

| Opção | Descrição | Exemplo |
|-------|-----------|---------|
| `Payload set` | Qual posição está sendo fuzzada | 1, 2, 3... |
| `Payload type` | Tipo de payload | Simple list, Numbers, Brute forcer |
| `Add` | Adicionar item à lista | Adicionar "admin", "root"... |
| `Load` | Carregar de arquivo | Carregar rockyou.txt |
| `Payload Options` | Configurar range (números) | From: 1 To: 10000 Step: 1 |
| `Payload Processing` | Regras de transformação | Hash MD5, prefix, suffix, match/replace |

### Intruder Resource Pool

| Opção | Descrição | Exemplo |
|-------|-----------|---------|
| `Max concurrent requests` | Requests simultâneos | 10 (Community é limitado) |
| `Delay between requests` | Delay em ms | 0 (máximo speed) |

---

## 📝 Exemplos Práticos

### Exemplo 1: Capturar Login via Proxy

```bash
# 1. Configurar Firefox para usar proxy 127.0.0.1:8080
# 2. Instalar CA certificate (http://burpsuite)
# 3. Abrir Burp → Proxy → Intercept → Intercept is ON
# 4. Navegar para http://target.com/login
# 5. Preencher username e password no formulário
# 6. Clicar "Login"
# 7. Request aparece no Burp Intercept:

POST /login HTTP/1.1
Host: target.com
Content-Type: application/x-www-form-urlencoded
Cookie: session=abc123def456
Content-Length: 45

username=admin&password=123456

# 8. Modificar parâmetros e Forward
# 9. Observar a resposta (302 redirect = sucesso, 200 = erro)
```

### Exemplo 2: SQL Injection via Repeater

```bash
# 1. Encontrar request com parâmetro (ex: GET /api/users?id=5)
# 2. Botão direito → Send to Repeater (Ctrl+R)
# 3. Modificar o parâmetro:

GET /api/users?id=5' OR 1=1-- HTTP/1.1
Host: target.com
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

# 4. Click Send
# 5. Se retornar lista de todos os usuários → SQLi confirmado
# 6. Para UNION-based:

GET /api/users?id=-1' UNION SELECT username,password FROM users-- HTTP/1.1
```

### Exemplo 3: Brute Force via Intruder

```bash
# 1. Capturar request de login via Proxy
# 2. Botão direito → Send to Intruder (Ctrl+I)
# 3. Na aba Positions:
#    POST /login HTTP/1.1
#    Host: target.com
#    Content-Type: application/x-www-form-urlencoded
#
#    username=§admin§&password=§password§

# 4. Payload set 1 (username): Simple list → carregar usernames
# 5. Payload set 2 (password): Simple list → carregar rockyou.txt
# 6. Attack type: Sniper (testar cada um separadamente)
# 7. Start attack
# 8. Ordenar por "Length" da resposta
# 9. Responses com tamanho diferente = credenciais válidas
```

### Exemplo 4: Decode JWT Token

```bash
# 1. Capturar request com header Authorization
# 2. Copiar o token JWT: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4ifQ.abc123
# 3. No Burp Decoder:
#    - Colar o token
#    - Decode as: Base64 (o payload do JWT)
#    - Primeira parte: {"alg":"HS256"}
#    - Segunda parte: {"user":"admin"}
# 4. Identificar se aceita alg: none → vulnerabilidade
```

### Exemplo 5: Comparer para Username Enumeration

```bash
# 1. Capturar request de login
# 2. Enviar request para Repeater
# 3. Testar username inexistente: username=nonexistent&password=any
# 4. Copiar response → Send to Comparer
# 5. Testar username existente: username=admin&password=any
# 6. Copiar response → Send to Comparer
# 7. Comparar por "Words" → diferenças indicam enumeração
#    Response 1: "Invalid username" (15 words)
#    Response 2: "Invalid password" (15 words) → username existe!
```

---

## ➡️ Depois de rodar — Próximos passos

Depois de dominar Burp Suite, você está pronto para:

1. **02-sqli-avancado.md** — Usar Burp Repeater + SQLMap para SQL injection
2. **04-xss-avancado.md** — Capturar XSS via Proxy, testar payloads no Repeater
3. **06-ssrf.md** — Intercept requests com SSRF, modificar parâmetros de URL
4. **11-jwt-attacks.md** — Decodificar e manipular JWT tokens no Decoder
5. **12-oauth-attacks.md** — Intercept fluxos OAuth no Proxy
6. **Qualquer outro módulo** — Burp Suite é a base para tudo

---

## 🔄 Fluxo de Teste Web com Burp Suite

```
┌─────────────────────────────────────────────────────────┐
│  1. MAPEAR (Target → Site Map)                           │
│     - Navegar pelo site com Proxy ON                     │
│     - Identificar páginas, parâmetros, funcionalidades   │
│     - Definir Scope                                      │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. INTERCEPTAR (Proxy → HTTP History)                   │
│     - Encontrar requests interessantes                   │
│     - Estudar como dados são enviados                    │
│     - Identificar parâmetros para fuzzing                │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR (Repeater)                                    │
│     - Modificar requests manualmente                     │
│     - Testar vulnerabilidades (SQLi, XSS, IDOR)         │
│     - Validar cada hipótese                              │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. FUZZAR (Intruder)                                    │
│     - Brute force de credenciais                         │
│     - Discovery de endpoints                             │
│     - Bypass de controles                                │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. DOCUMENTAR                                           │
│     - Salvar requests relevantes no Organizer            │
│     - Usar Comparer para documentar diferenças           │
│     - Exportar resultados para relatório                 │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Não consigo ver HTTPS" | CA certificate não instalado → visitar http://burpsuite e instalar |
| "Proxy refusa conexão" | Outro programa na porta 8080 → mudar porta em Proxy → Proxy Listeners |
| "Site não carrega com Proxy ON" | Verificar se browser aponta para 127.0.0.1:8080 |
| "Intruder muito lento" | Community Edition tem throttle → reduzir threads ou usar Repeater manual |
| "Não acho o request de login" | Usar filtro no HTTP History → filtrar por POST + Status 302 |
| "Response não mostra HTML" | Filtro MIME type no HTTP History → selecionar "text/html" |
| "CA certificate expirado" | Gerar novo em Proxy → Options → Regenerate CA certificate |

---

## 📋 Cheat Sheet Rápido

### Setup Inicial (30 segundos)
```bash
# Iniciar Burp
burpsuite &
# Firefox → Proxy → 127.0.0.1:8080
# Visitar http://burpsuite → baixar CA → instalar
```

### Atalhos Essenciais

| Atalho | Ação |
|--------|------|
| `Ctrl+R` | Enviar request para Repeater |
| `Ctrl+I` | Enviar request para Intruder |
| `Ctrl+E` | Enviar seleção para Decoder |
| `Ctrl+Shift+R` | Re-render request no Repeater |
| `Ctrl+Enter` | Enviar request no Repeater |
| `Ctrl+F` | Buscar em qualquer aba |
| `Ctrl+L` | Limpar filtros |

### Comandos de Decodificação (Decoder)

```
Input: YWRtaW46cGFzc3dvcmQ=
→ Decode as Base64 → admin:password

Input: %3Cscript%3Ealert(1)%3C%2Fscript%3E
→ Decode as URL → <script>alert(1)</script>

Input: 61646d696e
→ Decode as Hex → admin
```

### Intercept Regex (Match and Replace)

```
# Forçar IP específico
Match: X-Forwarded-For:.*
Replace: X-Forwarded-For: 127.0.0.1

# Remover token CSRF
Match: X-CSRF-Token:.*
Replace: X-CSRF-Token: (empty)

# Trocar user-agent
Match: User-Agent:.*
Replace: User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1)
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Web Security Academy — Getting Started](https://portswigger.net/burp/documentation/desktop/getting-started) | Setup, Proxy, Repeater | 30min |
| 2 | PortSwigger | [All Labs](https://portswigger.net/web-security/all-labs) | Praticar com qualquer lab usando Burp | Variável |

---

## 📚 Referências

- [Burp Suite Documentation](https://portswigger.net/burp/documentation/desktop)
- [Burp Suite Getting Started](https://portswigger.net/burp/documentation/desktop/getting-started)
- [Burp Suite Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy)
- [Burp Suite Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater)
- [Burp Suite Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder)
- [Burp Suite Decoder](https://portswigger.net/burp/documentation/desktop/tools/decoder)
- [Burp Suite Comparer](https://portswigger.net/burp/documentation/desktop/tools/comparer)
- [HackTricks — Burp Suite](https://book.hacktricks.xyz/pentesting-web/burp-suite)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Instalar e configurar Burp Suite no Kali
- [ ] Configurar o navegador para usar o proxy (manual ou Burp Browser)
- [ ] Instalar o CA certificate para HTTPS interception
- [ ] Usar o Proxy Intercept para capturar e modificar requests
- [ ] Navegar pelo HTTP History e filtrar requests relevantes
- [ ] Enviar requests para o Repeater e testar vulnerabilidades manualmente
- [ ] Configurar e rodar um Intruder attack (Sniper, Cluster Bomb)
- [ ] Usar o Decoder para encode/decode Base64, URL, hex
- [ ] Usar o Comparer para identificar diferenças em responses
- [ ] Mapear um site inteiro usando Target Site Map
- [ ] Usar Match and Replace para automatizar modificações
- [ ] Completar o workflow completo: Mapear → Interceptar → Testar → Fuzzar → Documentar
