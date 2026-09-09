# 🔑 Brute Force e Cracking

> Ferramentas para quebrar senhas, hashes e fazer força bruta em serviços.

---

## 🚀 Passo a Passo — Como fazer Brute Force e Cracking

Você já encontrou serviços abertos (SSH, FTP, HTTP). Agora vamos tentar **acessar** esses serviços.

### Passo 1: Preparar wordlists
```bash
# Primeiro, veja onde estão as wordlists
ls /usr/share/seclists/Passwords/Top1000.txt       # senhas mais comuns
ls /usr/share/seclists/Usernames/top-usernames-shortlist.txt  # usuários comuns
```

### Passo 2: Tentar brute force no SSH (Hydra)
```bash
# Se o Nmap mostrou porta 22 (SSH) aberta, tente quebrar a senha
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://192.168.1.1
# -l admin = testar com usuário "admin"
# -P = arquivo de senhas
```
**Se encontrou:** o Hydra mostra `[22][ssh] host: 192.168.1.1   login: admin   password: senha123`

### Passo 3: Se tem um hash para quebrar (John)
```bash
# Se você coletou hashes (ex: de /etc/shadow), primeiro identifique o formato
hashid '5d41402abc4b2a76b9719d911017c592'

# Depois, tente quebrar com John
john --wordlist=/usr/share/seclists/Passwords/Top1000.txt hash.txt

# Para ver o que já foi crackeado
john --show hash.txt
```

### Passo 4: Se tem GPU, usar Hashcat (mais rápido)
```bash
# Hashcat é muito mais rápido que John para hashes simples
# Exemplo para MD5:
hashcat -m 0 hash.txt /usr/share/seclists/Passwords/Top1000.txt

# Para ver resultados
hashcat -m 0 --show hash.txt
```

### Resumo da ordem — Por que essa sequência?

Exploração segue a ordem: **preparar → identificar → quebrar → usar**.

```
PASSO 1: Preparar wordlists → Ter listas de senhas prontas
├── POR QUE: Brute force só funciona com boas wordlists
├── O QUE FAZER: Instalar SecLists (maior coleção de wordlists)
├── COMANDO: sudo apt install seclists
├── ONDE FICA: /usr/share/seclists/
├── QUANDO AVANÇAR: Quando tiver wordlists instaladas
└── DICAS: Comece com Top10000.txt, depois vá para listas maiores

        ↓

PASSO 2: hydra → Brute force em serviços (SSH, FTP, HTTP)
├── POR QUE: Hydra testa senhas automaticamente em serviços
├── O QUE PROCURAR: Senha encontrada, resposta "valid password"
├── COMANDO: hydra -l admin -P passwords.txt ssh://target.com
├── QUANDO AVANÇAR: Se encontrar senha, use ela para logar
└── SE DER ERRADO: Se muito lento, reduza threads: -t 4

        ↓

PASSO 3: hashid → Identificar tipo de hash
├── POR QUE: Cada tipo de hash tem forma diferente de crackear
├── O QUE PROCURAR: Nome do hash (MD5, SHA256, NTLM, bcrypt)
├── COMANDO: hashid '5f4dcc3b5aa765d61d8327deb882cf99'
├── QUANDO AVANÇAR: Quando souber o tipo de hash
└── SE DER ERRADO: Se não identificar, tente: hash-identifier

        ↓

PASSO 4: john → Crackear hashes (aceita vários formatos)
├── POR QUE: John é o mais compatível com diferentes formatos
├── O QUE PROCURAR: Hash crackeado (aparece ao lado do hash)
├── COMANDO: john --wordlist=/usr/share/seclists/Passwords/Top10000.txt hash.txt
├── QUANDO AVANÇAR: Se john não crackear, tente hashcat
└── SE DER ERRADO: Se não reconhecer o formato, use: --format=raw-md5

        ↓

PASSO 5: hashcat → Crackear com GPU (mais rápido)
├── POR QUE: GPU é 100x mais rápida que CPU para hashes
├── O QUE PROCURAR: Hash crackeado no output
├── COMANDO: hashcat -m 0 hash.txt wordlist.txt (-m 0 = MD5)
├── QUANDO PARAR: Quando crackear ou esgotar wordlist
└── SE DER ERRADO: Se não tiver GPU, use john (CPU)

IMPORTANTE: Só crackee hashes que você tem autorização!

---

**Dica:** Para HTTP POST form (login de site): hydra -l admin -P passwords.txt http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"
```

---

## Hydra

Força bruta de login em praticamente qualquer serviço (SSH, FTP, HTTP, SMB, RDP, etc).

### Instalação
```bash
sudo apt install -y hydra
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-l` | Usuário único |
| `-L` | Lista de usuários |
| `-p` | Senha única |
| `-P` | Lista de senhas |
| `-t` | Threads (padrão 16) |
| `-f` | Parar no primeiro sucesso |
| `-F` | Parar quando achar em qualquer host |
| `-v` | Verbose (mostrar tentativas) |
| `-V` | Verbose com login/senha em cada linha |
| `-d` | Debug |
| `-s` | Porta (quando não é padrão) |
| `-o` | Output |
| `-M` | Lista de hosts |

### Exemplos práticos

```bash
# SSH brute force (usuário único)
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://192.168.1.1

# SSH brute force (lista de usuários)
hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P passwords.txt ssh://192.168.1.1

# FTP brute force
hydra -l admin -P passwords.txt ftp://192.168.1.1

# HTTP POST form (login form)
# Primeiro, inspecione o form no navegador para descobrir os campos
hydra -l admin -P passwords.txt 192.168.1.1 http-post-form \
  "/login:user=^USER^&pass=^PASS^:F=incorrect"
# /login = caminho do form
# user=^USER^&pass=^PASS^ = campos (substituídos pelo hydra)
# F=incorrect = string que indica falha

# HTTP GET form
hydra -l admin -P passwords.txt 192.168.1.1 http-get-form \
  "/admin/login:username=^USER^&password=^PASS^:F=Invalid credentials"

# SMB brute force
hydra -l administrator -P passwords.txt smb://192.168.1.1

# RDP brute force
hydra -l admin -P passwords.txt rdp://192.168.1.1

# MySQL brute force
hydra -l root -P passwords.txt mysql://192.168.1.1

# Com porta específica
hydra -l admin -P passwords.txt -s 8080 ssh://192.168.1.1

# Múltiplos hosts
hydra -l admin -P passwords.txt -M targets.txt ssh

# Parar no primeiro hit
hydra -l admin -P passwords.txt -f ssh://192.168.1.1

# Com verbose para acompanhar
hydra -l admin -P passwords.txt -V ssh://192.168.1.1

# Menos threads (mais lento, menos detecção)
hydra -l admin -P passwords.txt -t 4 ssh://192.168.1.1

# Output para arquivo
hydra -l admin -P passwords.txt -o hydra_results.txt ssh://192.168.1.1
```

### Dicas
```bash
# Descobrir o nome do form para HTTP POST
# Abra o form no navegador, inspecione o elemento, veja os nomes dos campos

# Se o form redireciona em sucesso/falha, usar F= para falha ou S= para sucesso
hydra -l admin -P passwords.txt target.com http-post-form \
  "/login:user=^USER^&pass=^PASS^:S=Welcome"
# S= = string que indica SUCESSO
```

---

## John the Ripper (john)

Cracking de hashes. Suporta centenas de formatos de hash.

### Instalação
```bash
sudo apt install -y john
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `--wordlist=` | Wordlist para brute force |
| `--rules` | Aplicar regras de mutação |
| `--format=` | Forçar formato do hash |
| `--list=formats` | Listar formatos suportados |
| `--incremental` | Modo incremental (brute force puro) |
| `--show` | Mostrar hashes já crackeados |
| `--single` | Modo single (usa info do /etc/passwd) |

### Exemplos práticos

```bash
# Crack automático (john tenta adivinhar o formato)
john hash.txt

# Com wordlist
john --wordlist=/usr/share/seclists/Passwords/Top1000.txt hash.txt

# Com regras (mutações da wordlist)
john --wordlist=wordlist.txt --rules hash.txt

# Forçar formato
john --format=raw-md5 hash.txt
john --format=raw-sha256 hash.txt
john --format=bcrypt hash.txt

# Listar formatos suportados
john --list=formats

# Modo incremental (brute force puro, lento)
john --incremental hash.txt

# Modo single
john --single hash.txt

# Mostrar resultados
john --show hash.txt

# Cracking de /etc/shadow
unshadow /etc/passwd /etc/shadow > hashes.txt
john hashes.txt
```

### Crackear vários hashes de uma vez
```bash
# Colocar vários hashes no arquivo (um por linha)
cat > hashes.txt << EOF
5d41402abc4b2a76b9719d911017c592
e99a18c428cb38d5f260853678922e03
098f6bcd4621d373cade4e832627b4f6
EOF

john --wordlist=/usr/share/seclists/Passwords/Top1000.txt hashes.txt
```

### Formatos mais comuns

| Formato | Exemplo |
|:---|:---|
| raw-md5 | `5d41402abc4b2a76b9719d911017c592` |
| raw-sha1 | `aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d` |
| raw-sha256 | `2cf24dba5fb0a30e26e83b2ac5b9e29e...` |
| bcrypt | `$2a$10$...` |
| NTLM | `aad3b435b51404eeaad3b435b51404ee` |
| descrypt | `rEK1ecacw.7.c` |

---

## Hashcat

Cracking de hashes com GPU. Muito mais rápido que John para hashes simples.

### Instalação
```bash
sudo apt install -y hashcat
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-m` | Modo/tipo do hash |
| `-a` | Modo de ataque |
| `-o` | Output |
| `--show` | Mostrar hashes crackeados |
| `-r` | Regra de mutação |
| `-j` / `-k` | Regra para input/output |

### Modos de hash mais usados

| Modo (-m) | Tipo |
|:---|:---|
| `0` | MD5 |
| `100` | SHA1 |
| `1400` | SHA-256 |
| `1000` | NTLM |
| `3200` | bcrypt |
| `1800` | sha512crypt |
| `7400` | sha256crypt |
| `5500` | NetNTLMv2 |
| `13100` | Kerberos TGS-REP |
| `16800` | WPA-PMKID-PBKDF2 |

### Modos de ataque

| Modo (-a) | Descrição |
|:---|:---|
| `0` | Straight (wordlist puro) |
| `3` | Brute force (máscara) |
| `6` | Wordlist + máscara |
| `7` | Máscara + wordlist |

### Exemplos práticos

```bash
# MD5 — wordlist simples
hashcat -m 0 hash.txt /usr/share/seclists/Passwords/Top1000.txt

# SHA-256
hashcat -m 1400 hash.txt wordlist.txt

# NTLM (Windows)
hashcat -m 1000 hash.txt wordlist.txt

# bcrypt (lento, mais Secure)
hashcat -m 3200 hash.txt wordlist.txt

# Brute force com máscara
# ?l = lowercase, ?u = uppercase, ?d = digit, ?s = special
hashcat -m 0 hash.txt -a 3 ?l?l?l?l?l?l    # 6 minúsculas
hashcat -m 0 hash.txt -a 3 ?d?d?d?d?d?d    # 6 dígitos
hashcat -m 0 hash.txt -a 3 ?u?l?l?l?d?d    # 1 maiúscula + 4 minúsculas + 2 dígitos

# Wordlist + regra
hashcat -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule

# Múltiplas wordlists
hashcat -m 0 hash.txt wordlist1.txt wordlist2.txt

# Output
hashcat -m 0 hash.txt wordlist.txt -o cracked.txt

# Mostrar resultados
hashcat -m 0 --show cracked.txt

# Listar modos de hash
hashcat --list | head -30

# Benchmark (testar performance)
hashcat -b
```

### Regras de hashcat
```bash
# Regra padrão: aplica mutações (maiúscula, números, símbolos)
hashcat -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule

# Regra agressiva
hashcat -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/d3ad0ne.rule

# Criar regra customizada no arquivo .rule
# : = Characters
# l = lowercase all
# u = uppercase first
# c = capitalize
# t = toggle case
# $X = append character X
# ^X = prepend character X
```

---

## Fluxo típico de Cracking

```
1. Coletar hashes (shadow, banco de dados, captura de rede)
        ↓
2. Identificar formato (john --list=formats ou hashid)
        ↓
3. Tentar John primeiro (mais formatos suportados)
        ↓
4. Se não crackear → Hashcat (GPU, mais rápido)
        ↓
5. Se wordlist falhar → regras → brute force
        ↓
6. Se ainda não → verificar se hash é fraco ou precisa de outro approach
```

### Combinando John + Hashcat
```bash
# Converter formato do John para Hashcat
john --format=raw-md5 --list=formats
# Se o formato for "Raw-MD5", Hashcat usa -m 0

# Converter de John para Hashcat (john2hashcat)
# Não existe conversor oficial, mas o formato raw geralmente é compatível
```

### Ferramenta auxiliar: hashid
```bash
# Identificar tipo de hash
sudo apt install -y hashid
hashid '5d41402abc4b2a76b9719d911017c592'
hashid -f 'hash_to_crack.txt'
```

---

## Lab Prático

### Exercício 1: Brute Force com Hydra
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/hydra
- **O que vai praticar:** Força bruta em SSH, FTP e HTTP forms com Hydra, uso de wordlists e ajuste de threads
- **Tempo estimado:** 45 minutos

### Exercício 2: Cracking de Hashes com John
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/johntheripper0
- **O que vai praticar:** Identificação de formatos, cracking com wordlists, regras de mutação e brute force puro
- **Tempo estimado:** 40 minutos

### Exercício 3: Hashcat na Prática
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/hashcat
- **O que vai praticar:** Cracking com GPU, máscaras, regras e diferentes formatos de hash (MD5, NTLM, bcrypt)
- **Tempo estimado:** 50 minutos

### Exercício 4: Brute Force - Credentials
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/starting-point
- **O que vai praticar:** Enumeração de credenciais, brute force em serviços web e exploração de login forms
- **Tempo estimado:** 90 minutos

### Dica de Estudo
> Comece sempre com wordlists pequenas (Top1000) antes de usar listas grandes. Identifique o formato do hash antes de crackear. Documente cada tentativa e os resultados encontrados. Use Hydra com `-t 4` para evitar bloqueios.
