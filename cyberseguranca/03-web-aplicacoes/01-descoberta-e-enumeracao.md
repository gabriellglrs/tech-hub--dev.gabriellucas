# 🌐 Web Application Testing

> Ferramentas para testar aplicações web: enumeração de diretórios, fuzzing, scan de vulnerabilidades e SQL Injection.

---

## 🚀 Passo a Passo — Como testar uma Aplicação Web

Você já fez o reconhecimento e sabe que o alvo tem um site. Agora vamos descobrir **o que tem por dentro**.

### Passo 1: Descobrir tecnologias (WhatWeb)
```bash
# Primeiro, veja o que o site usa (CMS, framework, servidor)
whatweb http://192.168.1.100
```
**O que procurar:** WordPress, Joomla, PHP, Apache, Nginx, etc.

### Passo 2: Verificar se tem WAF (WAFw00f)
```bash
# Se tem WAF, você precisa adaptar seus ataques
wafw00f http://192.168.1.100
```
**Se tem WAF:** usar tamper no SQLMap, rate limit mais baixo, proxychains.

### Passo 3: Se for WordPress (WPScan)
```bash
# Scan específico para WordPress
wpscan --url http://192.168.1.100 -e ap,at,u
```

### Passo 4: Descobrir diretórios ocultos (Gobuster)
```bash
# Encontre pastas e arquivos que não são visíveis no site
gobuster dir -u http://192.168.1.100 -w /usr/share/seclists/Discovery/Web-Content/common.txt
```
**O que procurar:** Status 200 (encontrado), 301/302 (redirecionamento), 403 (proibido — pode ser interessante).

### Passo 5: Scan de vulnerabilidades geral (Nikto)
```bash
# Scan mais completo para ver se tem algo perigoso
nikto -h http://192.168.1.100
```
**O que procurar:** Arquivos expostos (.git, .env, backups), headers faltando, versões desatualizadas.

### Passo 6: Fuzzing de parâmetros (FFUF)
```bash
# Se encontrou alguma página com parâmetros (ex: ?id=1), teste fuzzing
ffuf -u "http://192.168.1.100/page?id=FUZZ" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt
```

### Passo 7: Testar SQL Injection (SQLMap)
```bash
# Se a página tem parâmetros, teste se tem SQL Injection
sqlmap -u "http://192.168.1.100/page?id=1" --batch
# --batch = responde tudo automaticamente (sem perguntas)
```

### Passo 8: Se encontrou SQLi, explorar
```bash
# Listar bancos de dados
sqlmap -u "http://192.168.1.100/page?id=1" --dbs --batch

# Listar tabelas de um banco
sqlmap -u "http://192.168.1.100/page?id=1" -D nomebanco --tables --batch

# Baixar dados
sqlmap -u "http://192.168.1.100/page?id=1" -D nomebanco -T tabela --dump --batch
```

### Resumo da ordem:
```
1. whatweb   → descobrir tecnologias (CMS, framework)
2. wafw00f   → verificar se tem WAF
3. wpscan    → se for WordPress, scan específico
4. gobuster  → descobrir diretórios e arquivos
5. nikto     → scan de vulnerabilidades
6. ffuf      → fuzzing de parâmetros
7. sqlmap    → testar SQL Injection
8. sqlmap --dbs → explorar se encontrou SQLi
```

---

## Gobuster

Brute force de diretórios, subdomínios e vhosts. Rápido e direto ao ponto.

### Instalação
```bash
sudo apt install -y gobuster
```

### Modos de operação

| Modo | Descrição |
|:---|:---|
| `dir` | Brute force de diretórios e arquivos |
| `dns` | Brute force de subdomínios |
| `vhost` | Brute force de virtual hosts |

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-u` | URL alvo |
| `-w` | Wordlist |
| `-t` | Threads (padrão 10) |
| `-o` | Output para arquivo |
| `-x` | Extensões para buscar (ex: `-x php,html,txt`) |
| `-s` | Status codes para aceitar (ex: `-s 200,301,302`) |
| `-b` | Status codes para ignorar |
| `-r` | Usar URL relativa no output |
| `--wildcard` | Forçar wildcard |

### Exemplos práticos

```bash
# Brute force de diretórios (modo mais comum)
gobuster dir -u http://192.168.1.100 -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Com mais threads e extensões
gobuster dir -u http://192.168.1.100 -w /usr/share/seclists/Discovery/Web-Content/common.txt -t 50 -x php,html,txt,bak

# Ignorar 404
gobuster dir -u http://192.168.1.100 -w wordlist.txt -b 404

# Usando wordlist maior
gobuster dir -u http://192.168.1.100 -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 100

# Brute force de subdomínios
gobuster dns -d example.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t 50

# Brute force de vhosts
gobuster vhost -u http://target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# Output para arquivo
gobuster dir -u http://target.com -w wordlist.txt -o resultados.txt
```

### Dicas
```bash
# Usar em conjunto com proxychains
proxychains4 gobuster dir -u http://target.com -w wordlist.txt

# Se o target retorna 200 para tudo, usar -b para ignorar tamanho específico
gobuster dir -u http://target.com -w wordlist.txt --wildcard --exclude-length 1234
```

---

## FFUF

Fuzzing ultrarrápido de web apps. Mais flexível que Gobuster para fuzzing avançado.

### Instalação
```bash
sudo apt install -y ffuf
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-u` | URL com `FUZZ` onde vai o wordlist |
| `-w` | Wordlist |
| `-mc` | Match status code |
| `-fc` | Filter (excluir) status code |
| `-ms` | Match size |
| `-fs` | Filter size (excluir tamanho) |
| `-fl` | Filter lines |
| `-fw` | Filter words |
| `-t` | Threads |
| `-o` | Output JSON |
| `-r` | Follow redirects |
| `-H` | Header customizado |
| `-X` | Método HTTP |
| `-d` | Data (POST body) |
| `-recursion` | Recursivo |
| `-recursion-depth` | Profundidade máxima |

### Exemplos práticos

```bash
# Brute force de diretórios
ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Filtrar por tamanho (excluir respostas de 404 customizado)
ffuf -u http://target.com/FUZZ -w wordlist.txt -fs 4242

# Filtrar por código de status
ffuf -u http://target.com/FUZZ -w wordlist.txt -fc 403

# Brute force de parâmetros
ffuf -u "http://target.com/page?id=FUZZ" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt

# POST request com dados
ffuf -u http://target.com/login -X POST -d "user=admin&pass=FUZZ" -w passwords.txt -fc 401

# Header injection (vhost discovery)
ffuf -u http://target.com -H "Host: FUZZ.target.com" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fs 0

# Brute force de diretórios com extensão
ffuf -u http://target.com/FUZZ.php -w wordlist.txt

# Recursivo
ffuf -u http://target.com/FUZZ -w wordlist.txt -recursion -recursion-depth 2

# Com autenticação
ffuf -u http://target.com/admin/FUZZ -H "Cookie: session=abc123" -w wordlist.txt
```

### Filtro avançado
```bash
# Descobrir o tamanho da resposta 404
ffuf -u http://target.com/NOTEXIST -w /usr/share/seclists/Discovery/Web-Content/common.txt
# Output: 404  [Size: 1234]
# Agora filtrar esse tamanho:
ffuf -u http://target.com/FUZZ -w wordlist.txt -fs 1234

# Múltiplos filtros
ffuf -u http://target.com/FUZZ -w wordlist.txt -fs 1234 -fc 403,401
```

---

## Nikto

Scanner de vulnerabilidades web completo. Mais lento que os anteriores, mas detecta muitas coisas.

### Instalação
```bash
sudo apt install -y nikto
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-h` | Host alvo |
| `-p` | Porta |
| `-o` | Output |
| `-Format` | Formato do output |
| `-id` | Credenciais (user:pass) |
| `-Tuning` | Filtro de testes |
| `-useragent` | User agent customizado |
| `-timeout` | Timeout |

### Exemplos práticos

```bash
# Scan básico
nikto -h http://target.com

# Scan em porta específica
nikto -h http://target.com -p 8080

# Scan com autenticação
nikto -h http://target.com -id admin:password

# Tuning — só testes específicos
nikto -h http://target.com -Tuning 123bde
# 1 = Interesting File / Seen in logs
# 2 = Misconfiguration / Default File
# 3 = Information Disclosure
# b = Interesting File / Seen in logs
# d = Misconfiguration / Default File
# e = Information Disclosure

# Output para relatório
nikto -h http://target.com -o nikto_report.html -Format htm

# Com user agent customizado
nikto -h http://target.com -useragent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# Scan com proxy
nikto -h http://target.com -useproxy http://127.0.0.1:8080
```

### O que o Nikto detecta
- Arquivos sensíveis expostos (`.git`, `.env`, backups)
- Scripts antigos ou vulneráveis
- Headers de segurança faltando
- Configurações padrão perigosas
- Problemas de permissão de diretórios
- Versões desatualizadas de software

---

## WhatWeb

Fingerprinting de tecnologias web. Descobre CMS, frameworks, servidores, linguagens.

### Instalação
```bash
sudo apt install -y whatweb
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-v` | Verbose |
| `-a` | User agent |
| `--color` | Output colorido |
| `--log-json` | Output JSON |
| `-p` | Profundidade (paths para verificar) |

### Exemplos práticos

```bash
# Scan básico
whatweb example.com

# Verbose (mostra tudo)
whatweb -v example.com

# Output JSON
whatweb --log-json=output.json example.com

# Múltiplos alvos
whatweb -i urls.txt

# Com代理
whatweb --proxy http://127.0.0.1:8080 example.com

# Ignorar redirecionamentos
whatweb --no-follow-redirects example.com
```

### O que o WhatWeb detecta
- CMS (WordPress, Joomla, Drupal, Magento)
- Frameworks (Laravel, Django, Rails, Spring)
- Linguagens (PHP, Python, Ruby, Java)
- Servidores (Apache, Nginx, IIS)
- Analytics (Google Analytics, Matomo)
- Plugins e bibliotecas jQuery, Bootstrap, etc

---

## WPScan

Scanner específico para WordPress. Detecta versão, plugins, temas e vulnerabilidades.

### Instalação
```bash
sudo apt install -y wpscan
# ou
sudo gem install wpscan
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-u` | URL do site |
| `--enumerate` | O que enumerar (p=plugins, t=themes, u=users) |
| `--api-token` | API token do WPVulnDB |
| `-o` | Output |
| `-e` | Enumerar |

### Exemplos práticos

```bash
# Scan básico
wpscan --url http://example.com

# Enumerar plugins
wpscan --url http://example.com -e p

# Enumerar temas
wpscan --url http://example.com -e t

# Enumerar usuários
wpscan --url http://example.com -e u

# Enumerar tudo
wpscan --url http://example.com -e ap,at,u

# Com API token (para ver vulnerabilidades)
wpscan --url http://example.com --api-token SEU_TOKEN

# Brute force de senhas
wpscan --url http://example.com -e u --passwords /usr/share/seclists/Passwords/Top1000.txt

# User agent customizado
wpscan --url http://example.com --user-agent "Mozilla/5.0"

# Proxy
wpscan --url http://example.com --proxy http://127.0.0.1:8080
```

### O que o WPScan detecta
- Versão do WordPress
- Plugins instalados (e vulnerabilidades)
- Temas instalados (e vulnerabilidades)
- Usuários enumeráveis
- Configurações inseguras
- XML-RPC habilitado
- Debug mode habilitado

---

## Fluxo típico de Web App Testing

```
1. WhatWeb → descobrir tecnologias (CMS, framework, servidor)
        ↓
2. WAFw00f → verificar se tem WAF
        ↓
3. Gobuster/FFUF → descobrir diretórios e arquivos ocultos
        ↓
4. Nikto → scan geral de vulnerabilidades
        ↓
5. WPScan → se for WordPress, scan específico
        ↓
6. FFUF → fuzzing de parâmetros e endpoints
        ↓
7. SQLMap → testar parâmetros encontrados para SQLi
        ↓
8. Passar para exploração manual ou brute force
```
