# 🌐 Web Application Testing

> Ferramentas para testar aplicações web: enumeração de diretórios, fuzzing, scan de vulnerabilidades e SQL Injection.

## 📚 O que é Web Application Testing?

**Web Application Testing** é testar sites e aplicações web para encontrar vulnerabilidades. É como verificar todas as portas e janelas de uma casa — procurando trancas fracas, janelas abertas, senhas fracas.

### Por que isso é importante?

- **80% dos ataques** hoje são em aplicações web
- Sites são a "porta da frente" de qualquer empresa
- Vulnerabilidades web podem dar acesso ao **banco de dados inteiro**
- Ferramentas automatizadas facilitam o trabalho

### Como funciona na prática?

```
Fase 1: Descobrir o que o site usa
├── WhatWeb → CMS, framework, servidor
├── Wafw00f → Firewall web (WAF)
└── WPScan → Se for WordPress

Fase 2: Mapear o site
├── Gobuster → Diretórios ocultos (/admin, /backup)
├── Nikto → Vulnerabilidades conhecidas
└── ffuf → Parâmetros escondidos

Fase 3: Testar vulnerabilidades
├── SQLMap → SQL Injection
├── XSS → Cross-Site Scripting
└── Burp Suite → Proxy para interceptar requests
```

### Vulnerabilidades mais comuns em web

| Vulnerabilidade | O que faz | Exemplo |
|:---|:---|:---|
| SQL Injection | Acessa o banco de dados | `' OR 1=1 --` |
| XSS | Injeta JavaScript | `<script>alert(1)</script>` |
| CSRF | Faz ações como o usuário | Transferência bancária |
| LFI | Lê arquivos do servidor | `../../etc/passwd` |
| IDOR | Acessa dados de outros | `/user/2` sendo user 1 |

### Sites de prática

| Plataforma | URL | Nível |
|:---|:---|:---|
| DVWA | dvwa.co.za | Iniciante |
| PortSwigger | portswigger.net/web-security | Intermediário |
| HackTheBox | hackthebox.com | Avançado |

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

### Resumo da ordem — Por que essa sequência?

Teste web segue a ordem: **descobrir → mapear → testar → explorar**.

```
PASSO 1: whatweb → Descobrir tecnologias do site
├── POR QUE: Saber o CMS/framework define quais ferramentas usar
├── O QUE PROCURAR: WordPress, Joomla, PHP, Apache, Nginx, Laravel
├── COMANDO: whatweb http://target.com
├── QUANDO AVANÇAR: Quando souber o CMS/framework
└── SE DER ERRADO: Se não detectar nada, use -v (verbose): whatweb -v http://target.com

        ↓

PASSO 2: wafw00f → Verificar se tem WAF (firewall web)
├── POR QUE: Se tem WAF, seus ataques podem ser bloqueados
├── O QUE PROCURAR: Qual WAF (Cloudflare, Akamai, ModSecurity)
├── COMANDO: wafw00f http://target.com
├── QUANDO AVANÇAR: Independentemente do resultado (com ou sem WAF)
└── SE DER ERRADO: Se tiver WAF, use: proxychains4 + rate limit mais baixo

        ↓

PASSO 3: wpscan → Se for WordPress, scan específico
├── POR QUE: WordPress tem vulnerabilidades específicas (plugins, temas)
├── O QUE PROCURAR: Plugins desatualizados, temas vulneráveis, usuários
├── COMANDO: wpscan --url http://target.com -e ap,at,u
├── QUANDO AVANÇAR: Quando tiver lista de plugins/temas
└── SE DER ERRADO: Se não for WordPress, pule este passo

        ↓

PASSO 4: gobuster → Descobrir diretórios ocultos
├── POR QUE: Pastas como /admin, /backup, /config podem ter dados sensíveis
├── O QUE PROCURAR: Status 200 (encontrado), 301/302 (redirecionamento), 403 (proibido)
├── COMANDO: gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/common.txt
├── QUANDO AVANÇAR: Quando tiver lista de diretórios encontrados
└── SE DER ERRADO: Se retornar 200 para tudo, use -b 404 ou --wildcard

        ↓

PASSO 5: nikto → Scan geral de vulnerabilidades
├── POR QUE: Nikto detecta muitas coisas de uma vez (arquivos expostos, headers faltando)
├── O QUE PROCURAR: .git exposto, .env visível, headers de segurança faltando
├── COMANDO: nikto -h http://target.com
├── QUANDO AVANÇAR: Quando tiver lista de vulnerabilidades
└── SE DER ERRADO: Se demorar muito, use -Tuning 123bde (só testes específicos)

        ↓

PASSO 6: ffuf → Fuzzing de parâmetros e endpoints
├── POR QUE: Parâmetros escondidos podem ter SQL injection ou outros bugs
├── O QUE PROCURAR: Parâmetros como ?id=, ?search=, ?file=
├── COMANDO: ffuf -u "http://target.com/page?id=FUZZ" -w burp-parameter-names.txt
├── QUANDO AVANÇAR: Quando encontrar parâmetros funcionais
└── SE DER ERRADO: Se não encontrar nada, tente wordlists maiores

        ↓

PASSO 7: sqlmap → Testar SQL Injection
├── POR QUE: SQLi permite acessar banco de dados inteiro
├── O QUE PROCURAR: Confirmação de injeção, tipos deSQL, bancos de dados
├── COMANDO: sqlmap -u "http://target.com/page?id=1" --batch
├── QUANDO AVANÇAR: Se encontrar SQLi, use --dbs para listar bancos
└── SE DER ERRADO: Se não encontrar, teste com --level=5 --risk=3

        ↓

PASSO 8: sqlmap --dbs → Explorar se encontrou SQLi
├── POR QUE: O objetivo final é extrair dados ou ganhar acesso
├── O QUE PROCURAR: Bancos de dados, tabelas, dados sensíveis
├── COMANDO: sqlmap -u "http://target.com/page?id=1" --dbs --batch
├── QUANDO PARAR: Quando tiver acesso aos dados desejados
└── ÉTICA: Só faça em alvos autorizados!
```

**Dica:** Sempre comece com wordlists pequenas (common.txt) e vá aumentando se não encontrar nada.

---

## Gobuster

Brute force de diretórios, subdomínios e vhosts. Rápido e direto ao ponto.

### 🎯 Quando usar o Gobuster
Depois de descobrir que o alvo tem um site. Use quando:
- Precisar encontrar **diretórios e arquivos ocultos** (/admin, /backup, /.env)
- Precisar fazer **brute force de subdomínios**
- Precisar descobrir **virtual hosts** escondidos
- Quiser uma ferramenta **simples e rápida** para content discovery

### 🛠️ Como o Gobuster te ajuda
- **Diretórios** → /admin, /backup, /uploads (pontos de entrada)
- **Arquivos** → /.env, /config.php, /backup.zip (dados expostos)
- **Subdomínios** → api.empresa.com, dev.empresa.com
- **Vhosts** → Sites diferentes no mesmo IP

### ➡️ Depois de rodar o Gobuster — Próximos passos
1. **Diretórios encontrados?** → Acesse no navegador ou use Nikto
2. **Arquivos encontrados?** → Baixe e analise (pode ter senhas!)
3. **Subdomínios encontrados?** → Escaneie com Nmap
4. **Status 403?** → Pode ser interessante (proibido = tem algo lá)
5. **Salve o output** → `gobuster dir -u URL -w wordlist.txt -o resultados.txt`

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

### 🎯 Quando usar o FFUF
Quando o Gobuster não é suficiente. Use quando:
- Precisar **filtrar respostas** por tamanho/código (excluir falsos positivos)
- Precisar testar **parâmetros** (?id=1, ?page=admin)
- Precisar fazer **POST request** com dados
- Precisar **vhost discovery** via header Host
- Quiser **fuzzing avançado** com filtros múltiplos

### 🛠️ Como o FFUF te ajuda
- **Filtros** → Exclui respostas por tamanho, código, linhas, palavras
- **Flexibilidade** → POST, headers, cookies, autenticação
- **Velocidade** → Mais rápido que Gobuster para fuzzing pesado
- **Recursivo** → Explora diretórios encontrados automaticamente

### ➡️ Depois de rodar o FFUF — Próximos passos
1. **Parâmetros encontrados?** → Teste SQLi com SQLMap
2. **Vhosts encontrados?** → Adicione no /etc/hosts e acesse
3. **Falsos positivos?** → Use `-fs` para filtrar pelo tamanho da resposta
4. **Salve o output** → `ffuf -u URL/FUZZ -w wordlist.txt -o resultados.json`

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

### 🎯 Quando usar o Nikto
Depois de descobrir os diretórios. Use quando:
- Precisar de um **scan geral** de vulnerabilidades
- Precisar encontrar **arquivos sensíveis** (.git, .env, backups)
- Precisar verificar **headers de segurança** faltando
- Precisar detectar **versões desatualizadas**
- Quiser um **relatório** completo em HTML

### 🛠️ Como o Nikto te ajuda
- **Arquivos expostos** → .git, .env, backup.zip, config.php
- **Headers faltando** → X-Frame-Options, CSP, HSTS
- **Versões** → Apache 2.4.49 (vulnerável!)
- **Configurações** → CGI direories, debug mode

### ➡️ Depois de rodar o Nikto — Próximos passos
1. **Arquivos encontrados?** → Acesse e analise o conteúdo
2. **Headers faltando?** → Documente para o relatório
3. **Versão vulnerável?** → Pesquise CVE e tente explorar
4. **Salve o output** → `nikto -h URL -o nikto_report.html -Format htm`

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

### 🎯 Quando usar o WhatWeb
Sempre no início do teste web. Use quando:
- Precisar saber **o que o site usa** (CMS, framework, servidor)
- Precisar descobrir **versões de tecnologias**
- Precisar identificar **linguagens** (PHP, Python, Ruby)
- Quiser um **inventário** completo de tecnologias

### 🛠️ Como o WhatWeb te ajuda
- **CMS** → WordPress 6.4, Joomla 4.3 (vulnerabilidades conhecidas!)
- **Framework** → Laravel, Django (ataques específicos)
- **Servidor** → Apache, Nginx, IIS (configurações inseguras)
- **Plugins** → jQuery, Bootstrap (versões vulneráveis)

### ➡️ Depois de rodar o WhatWeb — Próximos passos
1. **WordPress detectado?** → Rode WPScan
2. **Versão vulnerável?** → Pesquise CVE: "WordPress 6.4 CVE"
3. **Framework detectado?** → Pesquise ataques específicos para esse framework
4. **Salve o output** → `whatweb --log-json=output.json URL`

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

### 🎯 Quando usar o WPScan
Quando o WhatWeb detectou WordPress. Use quando:
- Precisar **enumerar plugins e temas** instalados
- Precisar **buscar vulnerabilidades** conhecidas no WPVulnDB
- Precisar **listar usuários** do WordPress
- Precisar fazer **brute force de senhas** do WP

### 🛠️ Como o WPScan te ajuda
- **Plugins** → Versões exatas + CVEs conhecidos
- **Temas** → Versões exatas + vulnerabilidades
- **Usuários** → admin, joao, maria (para brute force)
- **Configurações** → XML-RPC, debug mode, installs

### ➡️ Depois de rodar o WPScan — Próximos passos
1. **Plugins vulneráveis?** → Pesquise o CVE e tente explorar
2. **Usuários encontrados?** → Brute force com Hydra: `hydra -l admin -P wordlist.txt target.com http-post-form`
3. **XML-RPC habilitado?** → Pode ser usado para brute force ou SSRF
4. **Salve o output** → `wpscan --url URL -o wpscan_results.txt`

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

---

## Lab Prático

### Exercício 1: Content Discovery com Gobuster
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dvwa
- **O que vai praticar:** Brute force de diretórios com Gobuster, enumeração de arquivos ocultos e análise de status codes
- **Tempo estimado:** 45 minutos

### Exercício 2: Fuzzing com FFUF
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/ffuf
- **O que vai praticar:** Fuzzing de parâmetros, vhost discovery, bypass de filtros e uso de wordlists customizadas
- **Tempo estimado:** 40 minutos

### Exercício 3: Vulnerability Scanning com Nikto
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/vulnnetwork
- **O que vai praticar:** Scan completo de vulnerabilidades web, identificação de arquivos expostos e headers inseguros
- **Tempo estimado:** 30 minutos

### Exercício 4: WordPress Scanning com WPScan
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/wpion
- **O que vai praticar:** Enumeração de plugins, temas e vulnerabilidades em WordPress com WPScan
- **Tempo estimado:** 45 minutos

### Dica de Estudo
> Monte um workflow completo: WhatWeb → Gobuster → Nikto → WPScan. Documente cada passo e cruzamento de informações. Use sempre a wordlist `common.txt` primeiro e só evolua para listas maiores se necessário.
