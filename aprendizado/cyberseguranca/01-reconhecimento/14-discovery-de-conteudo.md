# 🗂️ 14. Discovery de Conteúdo — Encontrando Diretórios, Arquivos e Endpoints Ocultos

> Todo site tem portas dos trás. Diretórios esquecidos, backups expostos, painéis admin — você só precisa saber onde procurar.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 50min | ⭐⭐⭐ Avançado | `gobuster, ffuf, wordlists` |

</div>

---

## 🎓 Por que isso importa?

Um site parecido pode ter dezenas de caminhos ocultos:
- `/admin` — painel administrativo
- `/backup.zip` — backup do banco de dados
- `/config.php` — configuração com senhas
- `/.git` — repositório Git exposto
- `/api/v1/users` — API interna

Ferramentas de discovery enviam milhares de requests com nomes de diretórios e arquivos. Se o servidor responder com 200 OK, o caminho existe.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP básico (status codes) | Sim | Módulo 02 |
| O que são wordlists | Sim | Este arquivo explica |
| curl básico | Sim | Arquivo 12 |

---

## 🎯 Quando usar Discovery de Conteúdo

- Depois de identificar o servidor web (fingerprinting)
- Para encontrar painéis de administração
- Para descobrir APIs não documentadas
- Para achar backups, configs, arquivos sensíveis
- Para mapear a estrutura completa do site

---

## 📚 Entendendo Wordlists

Wordlists são listas de palavras que as ferramentas usam para adivinhar nomes de diretórios e arquivos. O Kali já vem com várias:

| Wordlist | Caminho | Tamanho | Quando usar |
|----------|---------|---------|-------------|
| `common.txt` | `/usr/share/wordlists/dirb/common.txt` | ~4.600 | **Primeira escolha** — rápido |
| `directory-list-2.3-medium.txt` | `/usr/share/wordlists/dirbuster/directory-list-2-3-medium.txt` | ~220.000 | Mais profundo |
| `raft-large-directories.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt` | ~62.000 | Alternativa boa |
| `common.txt` (SecLists) | `/usr/share/seclists/Discovery/Web-Content/common.txt` | ~4.600 | Mesmo do dirb |

**Dica:** Se o SecLists não estiver instalado:
```bash
sudo apt install seclists
# ou
git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists
```

---

## 🛠️ Gobuster — O Veloz

Gobuster é rápido, simples e faz tudo: diretórios, DNS, vhost, S3, GCS.

### Instalação

```bash
# Pre-installed no Kali
gobuster --version

# Se não estiver:
sudo apt update && sudo apt install gobuster
```

### Modos do Gobuster

```
gobuster [modo] [opções]

Modos disponíveis:
  dir     — Enumerar diretórios e arquivos
  dns     — Enumerar subdomínios via DNS
  vhost   — Enumerar virtual hosts
  fuzz    — Fuzzing customizado
  s3      — Enumerar buckets AWS S3
  gcs     — Enumerar buckets Google Cloud
```

### Flags Principais (Modo dir)

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-u` | URL alvo | `-u https://target.com` |
| `-w` | Caminho da wordlist | `-w /usr/share/wordlists/dirb/common.txt` |
| `-t` | Threads (default 10) | `-t 50` |
| `-x` | Extensões para buscar | `-x php,html,txt,bak` |
| `-b` | Status codes para excluir | `-b 404,403` |
| `-e` | Mostrar URL completa | `-e` |
| `-k` | Ignorar SSL | `-k` |
| `-o` | Salvar em arquivo | `-o resultado.txt` |
| `-s` | Status codes para incluir | `-s 200,301,302` |
| `--delay` | Delay entre requests | `--delay 0.2` |
| `-f` | Adicionar `/` no final | `-f` |

### Exemplos Práticos

**Scan básico — encontrar diretórios:**
```bash
gobuster dir -u http://192.168.1.100 -w /usr/share/wordlists/dirb/common.txt
```

**Output esperado:**
```
===============================================================
Gobuster v3.8
===============================================================
[+] Url:                     http://192.168.1.100
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/admin                 (Status: 301) [Size: 314] [--> http://192.168.1.100/admin/]
/backup                (Status: 403) [Size: 277]
/css                   (Status: 301) [Size: 310]
/images                (Status: 301) [Size: 314]
/index.php             (Status: 200) [Size: 4386]
/login                 (Status: 200) [Size: 1234]
/robots.txt            (Status: 200) [Size: 125]
/server-status         (Status: 403) [Size: 277]
/uploads               (Status: 301) [Size: 314]
===============================================================
Finished
===============================================================
```

**Scan rápido com muitas threads e extensões:**
```bash
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -t 50 -x php,html,txt,bak,zip -b 404,403
```

**Discovery de virtual hosts (subdomínios internos):**
```bash
gobuster vhost -u http://target.com -w /usr/share/wordlists/dirb/common.txt --append-domain
```

**DNS enum de subdomínios:**
```bash
gobuster dns -d target.com -w /usr/share/wordlists/dirb/common.txt -t 50
```

**Output esperado (vhost):**
```
Found: admin.target.com Status: 200 [Size: 1234]
Found: staging.target.com Status: 302 [Size: 0]
Found: dev.target.com Status: 200 [Size: 5678]
```

---

## 🛠️ ffuf — O Mais Flexível

ffuf (Fuzz Faster U Fool) é mais poderoso que Gobuster para cenários complexos: fuzzing de parâmetros, POST data, múltiplas wordlists.

### Instalação

```bash
# Pre-installed no Kali
ffuf -V

# Se não estiver:
sudo apt update && sudo apt install ffuf
# ou
go install github.com/ffuf/ffuf/v2@latest
```

### A Palavra-Chave FUZZ

O ffuf usa a palavra `FUZZ` onde quer injetar valores da wordlist:

```
URL:    https://target.com/FUZZ        → FUZZ no caminho
URL:    https://FUZZ.target.com        → FUZZ no subdomínio
URL:    https://target.com/page?id=FUZZ → FUZZ no parâmetro
POST:   user=admin&password=FUZZ       → FUZZ no POST data
```

### Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-u` | URL com FUZZ | `-u https://target.com/FUZZ` |
| `-w` | Wordlist | `-w /usr/share/wordlists/dirb/common.txt` |
| `-mc` | Match status codes | `-mc 200,301,302` |
| `-fc` | Filter status codes | `-fc 404,403` |
| `-fs` | Filter por tamanho | `-fs 4242` |
| `-fl` | Filter por linhas | `-fl 42` |
| `-fw` | Filter por palavras | `-fw 33` |
| `-t` | Threads (default 40) | `-t 100` |
| `-e` | Extensões | `-e .php,.html,.txt` |
| `-recursion` | Scan recursivo | `-recursion` |
| `-recursion-depth` | Profundidade | `-recursion-depth 2` |
| `-o` | Output file | `-o result.json` |
| `-of` | Output format | `-of json,csv,html` |
| `-s` | Silent (só resultados) | `-s` |
| `-v` | Verbose | `-v` |
| `-r` | Follow redirects | `-r` |
| `-b` | Cookies | `-b "session=abc123"` |
| `-H` | Headers customizados | `-H "Authorization: Bearer token"` |
| `-X` | HTTP method | `-X POST` |
| `-d` | POST data | `-d "user=FUZZ"` |
| `-maxtime` | Tempo máximo (seg) | `-maxtime 60` |

### Exemplos Práticos

**1. Directory Fuzzing (básico):**
```bash
ffuf -u https://target.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -mc 200,301,302 -s
```

**Output esperado:**
```
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

:: Method           : GET
:: URL              : https://target.com/FUZZ
:: Wordlist         : FUZZ: /usr/share/wordlists/dirb/common.txt
:: Follow redirects : false
:: Calibration      : false
:: Timeout          : 10
:: Threads          : 40
:: Matcher         : Response status: 200,301,302
________________________________________________

admin                   [Status: 301, Size: 314, Words: 20, Lines: 10]
backup                  [Status: 200, Size: 1234, Words: 45, Lines: 30]
config                  [Status: 200, Size: 567, Words: 12, Lines: 8]
dashboard               [Status: 302, Size: 0, Words: 1, Lines: 1]
uploads                 [Status: 301, Size: 314, Words: 20, Lines: 10]
```

**2. Directory Fuzzing com extensões:**
```bash
ffuf -u https://target.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -e .php,.html,.txt,.bak,.zip -mc all -fs 0
```

**3. Virtual Host Discovery:**

Primeiro, descubra o tamanho da resposta padrão:
```bash
ffuf -u https://target.com -H "Host: FUZZ.target.com" -w /usr/share/wordlists/dirb/common.txt -mc all -fs 4242
```

O `-fs 4242` filtra responses com tamanho 4242 (o tamanho da página padrão). Se um vhost existir, o tamanho será diferente.

**4. Parameter Discovery:**
```bash
ffuf -u "https://target.com/page?FUZZ=test" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -fs 4242
```

**5. Parameter Value Fuzzing:**
```bash
ffuf -u "https://target.com/page?id=FUZZ" -w /usr/share/seclists/Fuzzing/numbers/1-1000.txt -fc 404
```

**6. POST Data Fuzzing:**
```bash
ffuf -u https://target.com/login -X POST -d "username=admin&password=FUZZ" -w /usr/share/wordlists/rockyou.txt -fc 401
```

**7. JSON POST Fuzzing:**
```bash
ffuf -u https://target.com/api/login -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "FUZZ"}' \
  -w /usr/share/wordlists/rockyou.txt -fc 401
```

**8. Fuzzing com header customizado:**
```bash
ffuf -u https://target.com/ -H "Host: FUZZ.internal.com" -w vhosts.txt -fs 4242
```

**9. Scan recursivo (encontrar subdiretórios):**
```bash
ffuf -u https://target.com/FUZZ -w wordlist.txt -recursion -recursion-depth 2 -mc 200
```

**10. Scan com tempo máximo:**
```bash
ffuf -u https://target.com/FUZZ -w wordlist.txt -maxtime 120
```

---

## 📊 Comparação: Gobuster vs ffuf

| Aspecto | Gobuster | ffuf |
|---------|----------|------|
| **Velocidade** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Facilidade** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Filtros** | Limitados | Muitos (-fc, -fs, -fl, -fw, -fr) |
| **POST fuzzing** | Não | Sim |
| **Múltiplas wordlists** | Não | Sim |
| **Recursão** | Sim | Sim (melhor) |
| **Modo vhost** | Sim (mais simples) | Sim (mais controle) |
| **Output formats** | txt | json, csv, html, md |

**Recomendação:**
- **Gobuster** → para scans rápidos e simples
- **ffuf** → para cenários complexos, filtros precisos, POST fuzzing

---

## 🔗 Pipeline de Discovery Recomendado

```
1. Gobuster dir (scan rápido inicial)
       ↓
2. ffuf (refinar com filtros, buscar extensões)
       ↓
3. ffuf vhost (descobrir hosts internos)
       ↓
4. Analisar resultados → testar cada caminho encontrado
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| Muitos falsos positivos (403, 404) | Sem filtro de status | Use `-b 404,403` (Gobuster) ou `-fc 404,403` (ffuf) |
| Scan muito lento | Poucas threads | Aumente `-t 50` (Gobuster) ou `-t 100` (ffuf) |
| Bloqueado por WAF | Muitas requests sem delay | Use `--delay 0.2` ou diminua threads |
| Scan nunca termina | Sem limite | Use `-maxtime 120` no ffuf |
| ffuf: "FUZZ not found" | FUZZ não está na URL | Verifique se `-u` contém `FUZZ` |
| Wordlist não encontrada | Caminho errado | Use `ls /usr/share/wordlists/` para verificar |

---

## 🎯 Cheat Sheet Rápido

```bash
# === GOBUSTER ===
# Scan básico
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Rápido, com extensões, sem 404
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -t 50 -x php,html,txt -b 404,403

# Vhost discovery
gobuster vhost -u http://target.com -w /usr/share/wordlists/dirb/common.txt --append-domain

# DNS enum
gobuster dns -d target.com -w /usr/share/wordlists/dirb/common.txt

# === FFUF ===
# Directory fuzzing básico
ffuf -u https://target.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -mc 200,301,302

# Com extensões e sem falsos positivos
ffuf -u https://target.com/FUZZ -w wordlist.txt -e .php,.bak,.txt -fc 404,403

# Vhost discovery
ffuf -u https://target.com -H "Host: FUZZ.target.com" -w wordlist.txt -fs 4242

# Parameter discovery
ffuf -u "https://target.com/page?FUZZ=test" -w params.txt -fs 4242

# POST fuzzing
ffuf -u https://target.com/login -X POST -d "user=admin&pass=FUZZ" -w passwords.txt -fc 401

# Recursivo
ffuf -u https://target.com/FUZZ -w wordlist.txt -recursion -recursion-depth 2

# Com tempo máximo
ffuf -u https://target.com/FUZZ -w wordlist.txt -maxtime 60
```

---

## 🧰 Wordlists Customizadas — CeWL e Geração Contextual

### Por que wordlist contextual > wordlist genérica?

Wordlists genéricas (`common.txt`) funcionam para sites genéricos. Mas cada empresa tem:
- **Produtos próprios** (nomes de produtos, versões)
- **Funcionalidades específicas** (nomes de endpoints únicos)
- **Tecnologias próprias** (frameworks internos)
- **Estrutura de pastas** (nomenclatura específica)

Uma wordlist gerada a partir do próprio site do alvo é **muito mais eficiente**.

### CeWL — Gerar Wordlist a partir de um Site

**CeWL (Custom Word List generator)** crawla um site e gera uma wordlist com as palavras encontradas no conteúdo.

```bash
# Instalar CeWL
sudo apt install cewl -y

# Gerar wordlist básica
cewl https://target.com -w wordlist.txt

# Gerar com profundidade maior (mais links)
cewl https://target.com -d 2 -w wordlist.txt

# Gerar com emails
cewl https://target.com --email_file emails.txt -w wordlist.txt

# Gerar com números
cewl https://target.com --with-numbers -w wordlist.txt

# Gerar com comprimento mínimo
cewl https://target.com -m 5 -w wordlist.txt

# OUTPUT ESPERADO (wordlist.txt):
# target
# api
# login
# dashboard
# admin
# products
# users
# ...
```

**Flags explicadas:**
- `-d 2` — Profundidade de crawl (2 níveis de links)
- `--email_file` — Extrai emails encontrados
- `--with-numbers` — Inclui palavras com números
- `-m 5` — Comprimento mínimo de 5 caracteres

### Geração Contextual

```bash
# Gerar wordlist a partir de nomes de produtos da empresa
# Se a empresa vende "ProductA", "ProductB", "ProductC"
echo -e "producta\nproductb\ncustomera\ncustomerb" > custom.txt

# Adicionar termos comuns da empresa
echo -e "admin\nlogin\napi\ndashboard\nportal\ndev\nstaging\ntest" >> custom.txt

# Gerar variações
for word in admin login api; do
  echo "$word"
  echo "${word}1"
  echo "${word}2"
  echo "${word}_old"
  echo "${word}_new"
  echo "dev_$word"
  echo "staging_$word"
done >> custom.txt

# Usar com Gobuster
gobuster dir -u https://target.com -w custom.txt
```

### Combinação: CeWL + Palavras-chave

```bash
# 1. Gerar wordlist do site
cewl https://target.com -d 2 -w cewl_words.txt

# 2. Adicionar palavras-chave específicas
cat >> cewl_words.txt << EOF
admin
login
api
dashboard
portal
internal
staging
dev
test
backup
config
.env
.git
EOF

# 3. Remover duplicatas
sort -u cewl_words.txt > wordlist_final.txt

# 4. Usar
gobuster dir -u https://target.com -w wordlist_final.txt
ffuf -u https://target.com/FUZZ -w wordlist_final.txt
```

### Quando usar cada abordagem

| Situação | Abordagem | Por quê |
|:---------|:----------|:--------|
| **Site genérico** | `common.txt` | Rápido, cobre o básico |
| **Site específico** | CeWL | Palavras relevantes ao site |
| **Empresa conhecida** | CeWL + contextual | Palavras da empresa + do site |
| **API** | Wordlist de API | Endpoints específicos de API |
| **Login** | Wordlist de credenciais | Usuários/senhas comuns |

---

## 📚 Referências

- [Gobuster GitHub](https://github.com/OJ/gobuster)
- [Gobuster Kali](https://www.kali.org/tools/gobuster)
- [ffuf GitHub](https://github.com/ffuf/ffuf)
- [ffuf Kali](https://www.kali.org/tools/ffuf)
- [SecLists](https://github.com/danielmiessler/SecLists)
- [CeWL GitHub](https://github.com/digininja/CeWL)
- [OWASP Content Discovery](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/05-Enumerate_Infrastructure_and_Application_Admin_Interfaces)

---

**Próximo:** [15. Subdomain Enum Avançado](15-subdomain-enum-avancado.md) — Amass para mapeamento profundo de superfície de ataque

**Anterior:** [13. Fingerprinting Web](13-fingerprinting-web.md)
