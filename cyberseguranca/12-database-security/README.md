# 🗄️ Módulo 12 - Database Security

> **Domine a segurança de bancos de dados SQL e NoSQL em ambientes corporativos**

## 📊 Informações do Módulo

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🛠️ Ferramentas |
|-----------|----------|-------------|----------------|
| 5-7 horas | ⭐⭐⭐ Avançado | 2 | 8 |

### 🛠️ Ferramentas Utilizadas

`sqlmap` `Medusa` `NoSQLMap` `Metasploit` `鸿客` `mysql` `psql` `mongosh`

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Enumerar bancos de dados e estruturas internas
- [ ] Realizar brute force eficiente em credenciais de banco
- [ ] Explorar SQL Injection avançado (union, blind, time-based)
- [ ] Realizar exfiltração de dados sem detecção
- [ ] Escalar privilegios para outros bancos de dados
- [ ] TestarNoSQL Injection em MongoDB/CouchDB
- [ ] Identificar configurações inseguras em bancos
- [ ] Utilizar Metasploit para exploração de databases

---

## 📋 Pré-requisitos

| Conhecimento | Nível | Onde Estudar |
|--------------|-------|--------------|
| SQL Básico | Intermediário | SQLBolt, W3Schools |
| Conceitos de Autenticação | Básico | Módulo 11 - API Security |
| Linux Intermediário | Intermediário | Módulo 2 - Linux |
| NoSQL Básico | Básico | MongoDB University |
| Metasploit Básico | Intermediário | Módulo 8 - Metasploit |

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                   DATABASE SECURITY                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ ENUMERATION │───▶│BRUTE FORCE  │───▶│SQL INJECTION│         │
│  │  (1.1-1.4)  │    │  (1.5-1.7)  │    │  (1.8-1.12) │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                  │                  │                 │
│         ▼                  ▼                  ▼                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  EXFILTRATION│───▶│PRIV ESCALATION│──▶│ NO-SQL     │         │
│  │  (1.13-1.15)│    │  (1.16-1.18) │   │ INJECTION  │         │
│  └─────────────┘    └─────────────┘    │  (1.19-1.21)│         │
│                                       └─────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo do Módulo

### 📖 Arquivo 1: `01-database-enumeration.md`
- Descoberta de bancos de dados ativos
- Enumeração de tabelas e colunas
- Coleta de informações de versão
- Identificação de credenciais padrão

### 📖 Arquivo 2: `02-database-exploitation.md`
- SQL Injection avançado
- Brute force em bancos de dados
- Exfiltração de dados
- Escalação de privilégios

---

## 💡 Dicas de Ouro

### 🥇 Dica 1: SQLMap Avançado
```bash
# Scan completo com level e risk
sqlmap -u "https://target.com/?id=1" --level=5 --risk=3

# Extrair todos os bancos
sqlmap -u "https://target.com/?id=1" --dbs

# Extrair tabelas específicas
sqlmap -u "https://target.com/?id=1" -D database_name --tables

# Dump completo com flatten
sqlmap -u "https://target.com/?id=1" --dump-all --flatten

# Usar tamper para bypass WAF
sqlmap -u "https://target.com/?id=1" --tamper=space2comment,between
```

### 🥈 Dica 2: Brute Force com Medusa
```bash
# Scan rápido de credenciais comuns
medusa -h 10.10.10.10 -u admin -P wordlist.txt -M mysql

# Scan com múltiplos usuários
medusa -h 10.10.10.10 -U users.txt -P passwords.txt -M mysql

# Scan paralelo
medusa -h 10.10.10.10 -u admin -P wordlist.txt -M mysql -T 10

# Output para arquivo
medusa -h 10.10.10.10 -u admin -P wordlist.txt -M mysql -O results.log
```

### 🥉 Dica 3: NoSQLMap para MongoDB
```bash
# Scan básico
python3 nosqlmap.py -u https://target.com/api/

# Com autenticação
python3 nosqlmap.py -u https://target.com/api/ --auth=admin:password

# Dump de dados
python3 nosqlmap.py -u https://target.com/api/ --dump

# Verbose para debug
python3 nosqlmap.py -u https://target.com/api/ -v --verbose
```

### 🏅 Dica 4: PostgreSQL Enumeração
```bash
# Conectar ao banco
psql -h 10.10.10.10 -U postgres

# Listar bancos
\l

# Conectar a banco específico
\c database_name

# Listar tabelas
\dt

# Ver estrutura da tabela
\d table_name

# Executar query
SELECT * FROM users;
```

---

## ⚠️ Erros Comuns

| ❌ Erro | ✅ Solução |
|---------|-----------|
| Não testar todos os parâmetros | Testar GET, POST, Headers, Cookies |
| Assumir que é apenas SQL | Testar também NoSQL, LDAP, OS Command |
| Não usar --batch no sqlmap | Usar --batch para respostas automáticas |
| Ignorar WAF/IDS | Usar tamper scripts e delays |
| Não verificar permissões | Sempre testar WITH GRANT OPTION |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🧪 Labs Recomendados

### TryHackMe - SQL Injection
- **URL:** https://tryhackme.com/room/sqlinjectionlm
- **Duração:** 3-4 horas
- **Foco:** SQL Injection básico a avançado
- **Nível:** Intermediário

### HackTheBox - Devel
- **URL:** https://www.hackthebox.com/machine/devel
- **Duração:** 2-3 horas
- **Foco:** Database exploitation via IIS
- **Nível:** Intermediário

### DVWA - SQL Injection
- **URL:** http://www.dvwa.co.uk/
- **Duração:** 2 horas
- **Foco:** SQL Injection manual e automatizado
- **Nível:** Básico/Intermediário

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique se você:

- [ ] Consegue enumerar bancos de dados em menos de 15 minutos
- [ ] Utiliza sqlmap com level e risk adequados
- [ ] Configura brute force com Medusa corretamente
- [ ] Identifica NoSQL Injection em APIs MongoDB
- [ ] Realiza exfiltração de dados sem ser detectado
- [ ] Escala privilégios em bancos de dados
- [ ] Utiliza Metasploit para exploração de databases
- [ ] Configura e utiliza NoSQLMap
- [ ] Documenta todos os achados de forma profissional
- [ ] Completa pelo menos 2 labs práticos

---

## 🔗 Navegação

```
Módulo Anterior                    Próximo Módulo
    │                                   │
    ▼                                   ▼
┌───────────────────┐         ┌───────────────────┐
│  11-API-Security  │────────▶│  13-Frontend-     │
│   (Intermediário) │         │    Security       │
└───────────────────┘         │   (Intermediário) │
                              └───────────────────┘
```

### 📂 Estrutura do Módulo

```
12-database-security/
├── README.md                        # Este arquivo
├── 01-database-enumeration.md      # Enumeração e descoberta
└── 02-database-exploitation.md     # Exploração e exfiltração
```

### 🏠 [Voltar ao Menu Principal](../README.md)

---

> **⏱️ Tempo estimado de estudo:** 5-7 horas
> **🎯 Dificuldade:** ⭐⭐⭐ Avançado
> **✅ Pré-requisitos completos?** Avance para o Módulo 13!

---

*Criado para a trilha de Cybersegurança - Módulo 12: Database Security*
