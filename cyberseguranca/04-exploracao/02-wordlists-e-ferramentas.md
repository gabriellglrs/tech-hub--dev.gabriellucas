# 📦 Wordlists

> Wordlists são essenciais para brute force, fuzzing e enumeração. SecLists é a coleção mais completa.

---

## 🚀 Passo a Passo — Como usar Wordlists

Wordlist = lista de palavras. Serve para brute force (adivinhar senhas), fuzzing (descobrir diretórios) e enumeração. Vamos aprender qual usar para cada situação.

### Passo 1: Ver onde estão as wordlists
```bash
# O SecLists foi instalado em:
ls /usr/share/seclists/

# Veja as pastas principais:
ls /usr/share/seclists/Discovery/Web-Content/   # para diretórios web
ls /usr/share/seclists/Discovery/DNS/           # para subdomínios
ls /usr/share/seclists/Passwords/               # para senhas
ls /usr/share/seclists/Usernames/               # para usuários
```

### Passo 2: Qual wordlist usar para cada tarefa

| Tarefa | Wordlist | Comando |
|:---|:---|:---|
| Descobrir diretórios web | `common.txt` | `gobuster dir -u http://target -w /usr/share/seclists/Discovery/Web-Content/common.txt` |
| Brute force de senhas | `Top1000.txt` | `hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://target` |
| Brute force de subdomínios | `subdomains-top1million-5000.txt` | `gobuster dns -d target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt` |
| Brute force de usuários | `top-usernames-shortlist.txt` | `hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P passwords.txt ssh://target` |

### Passo 3: Começar sempre pela lista menor
```bash
# Comece com a lista PEQUENA (mais rápido):
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Se não encontrou nada, use a lista MAIOR (mais lento, mais completo):
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 100
```

### Resumo da ordem:
```
1. ls /usr/share/seclists/     → ver onde está tudo
2. common.txt                  → começar sempre pela lista menor
3. directory-list-2.3-medium   → se não achou, usar a maior
4. Top1000.txt                 → para brute force de senhas
5. rockyou.txt                 → último recurso (muito grande)
```

---

## SecLists

Após instalar com `--sec`, o SecLists fica em `/usr/share/seclists/`.

### Instalação separada
```bash
sudo apt install -y seclists
```

### Estrutura do diretório

```
/usr/share/seclists/
├── Discovery/
│   ├── Web-Content/        # Diretórios e arquivos web
│   ├── DNS/                # Subdomínios
│   └── Infrastructure/     # IPs, portas
├── Passwords/              # Senhas
├── Usernames/              # Usuários
├── Fuzzing/                # Payloads para fuzzing
└── Leaked-Databases/       # Dados vazados
```

---

## 🌐 Web Content (Discovery/Web-Content)

Para brute force de diretórios e arquivos.

### Principais wordlists

| Wordlist | Descrição | Tamanho |
|:---|:---|:---|
| `common.txt` | Diretórios e arquivos comuns | ~4.600 |
| `big.txt` | Lista maior | ~20.000 |
| `directory-list-2.3-medium.txt` | Brute force de diretórios | ~220.000 |
| `directory-list-2.3-small.txt` | Versão menor | ~87.000 |
| `raft-large-directories.txt` | Raft - directories | ~62.000 |
| `raft-large-files.txt` | Raft - files | ~62.000 |
| `raft-small-directories.txt` | Raft small | ~12.000 |
| `raft-small-files.txt` | Raft small files | ~12.000 |
| `burp-parameter-names.txt` | Parâmetros HTTP | ~2.600 |
| `php.fuzz.txt` | Arquivos PHP | ~5.000 |
| `extensions_common.txt` | Extensões de arquivo | ~50 |

### Como usar

```bash
# Com Gobuster
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Com FFUF
ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Usar lista maior (mais lento, mais completo)
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 100
```

### Quando usar cada uma

| Cenário | Wordlist recomendada |
|:---|:---|
| Scan rápido | `common.txt` |
| Scan completo | `directory-list-2.3-medium.txt` |
| Fuzzing de parâmetros | `burp-parameter-names.txt` |
| Arquivos PHP | `php.fuzz.txt` |
| Raft (muito completo) | `raft-large-directories.txt` |

---

## 🌍 DNS (Discovery/DNS)

Para brute force de subdomínios.

### Principais wordlists

| Wordlist | Descrição | Tamanho |
|:---|:---|:---|
| `subdomains-top1million-5000.txt` | Top 5K subdomínios | ~5.000 |
| `subdomains-top1million-20000.txt` | Top 20K | ~20.000 |
| `subdomains-top1million-110000.txt` | Top 110K | ~110.000 |
| `dehydrated.txt` | Para DNS challenge | ~3.400 |
| `common-prefixes.txt` | Prefixos comuns | ~1.500 |

### Como usar

```bash
# Com Gobuster
gobuster dns -d target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t 50

# Com Subfinder + wordlist
subfinder -d target.com -all -o subfinder.txt
gobuster dns -d target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -o gobuster.txt

# Unir resultados
cat subfinder.txt gobuster.txt | sort -u > all_subdomains.txt
```

---

## 🔑 Passwords

Para brute force de senhas.

### Principais wordlists

| Wordlist | Descrição | Tamanho |
|:---|:---|:---|
| `Top1000.txt` | Top 1000 senhas | ~1.000 |
| `Top10000.txt` | Top 10K senhas | ~10.000 |
| `Top100000.txt` | Top 100K | ~100.000 |
| `rockyou.txt` | Lista clássica | ~14.000.000 |
| `Leaked-Databases/` | Dados vazados reais | Variável |
| `Default-Credentials/` | Credenciais padrão | Variável |

### Como usar

```bash
# Com Hydra
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://target.com

# Com John
john --wordlist=/usr/share/seclists/Passwords/Top10000.txt hash.txt

# Com Hashcat
hashcat -m 0 hash.txt /usr/share/seclists/Passwords/rockyou.txt
```

### Dicas
```bash
# Começar com listas pequenas (Top1000)
# Se não funcionar, usar listas maiores
# rockyou.txt é muito grande — usar com cuidado

# Para alvos brasileiros, procurar wordlists com senhas em português
# Ou criar wordlists customizadas com crunch:
sudo apt install -y crunch
crunch 8 8 -t @@@@2023 -o wordlist.txt
# Gera senhas como: aaaa2023, bbbb2023, etc.
```

---

## 👤 Usernames

Para brute force de usuários.

### Principais wordlists

| Wordlist | Descrição | Tamanho |
|:---|:---|:---|
| `top-usernames-shortlist.txt` | Top usuários | ~30 |
| `names.txt` | Nomes completos | ~60.000 |
| ` usernames.txt` | usuários comuns | ~1.000 |
| `roots.txt` | Variações de root | ~100 |

### Como usar

```bash
# Com Hydra
hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P passwords.txt ssh://target.com
```

---

## 🔨 Fuzzing

Payloads para fuzzing de vulnerabilidades.

### Principais wordlists

| Wordlist | Descrição |
|:---|:---|
| `special-chars.txt` | Caracteres especiais |
| `LFI/LFI_gracefulsecurity_linux.txt` | Linux LFI |
| `LFI/LFI_gracefulsecurity_windows.txt` | Windows LFI |
| `SQLi/` | SQL Injection payloads |
| `XSS/` | Cross-Site Scripting payloads |
| `Traversal/` | Directory traversal |

### Como usar

```bash
# LFI testing
ffuf -u http://target.com/page?file=FUZZ -w /usr/share/seclists/Fuzzing/LFI/LFI_gracefulsecurity_linux.txt

# SQL Injection
ffuf -u http://target.com/page?id=FUZZ -w /usr/share/seclists/Fuzzing/SQLi/Generic-SQLi.txt
```

---

## Lab Prático

### Exercício 1: Wordlists e SecLists
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/seclists
- **O que vai praticar:** Navegação pelo SecLists, seleção de wordlists para diferentes tarefas e uso com ferramentas
- **Tempo estimado:** 30 minutos

### Exercício 2: Brute Force com Wordlists
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/bruteforce
- **O que vai praticar:** Brute force de diretórios, subdomínios e senhas usando wordlists apropriadas
- **Tempo estimado:** 45 minutos

### Exercício 3: Crunch e CeWL
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/crunch
- **O que vai praticar:** Geração de wordlists customizadas com Crunch e CeWL baseadas em contexto
- **Tempo estimado:** 30 minutos

### Exercício 4: Default Credentials
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/starting-point
- **O que vai praticar:** Uso de wordlists de credenciais padrão, enumeração de usuários e exploração de credenciais default
- **Tempo estimado:** 60 minutos

### Resumo da ordem — Por que essa sequência?

Wordlists seguem a ordem: **identificar → escolher menor → escalar se necessário**.

```
PASSO 1: Identificar o tipo de tarefa → Qual wordlist usar
├── POR QUE: Cada tarefa (diretórios, subdomínios, senhas) tem lista ideal
├── O QUE FAZER: Mapear a tarefa antes de escolher wordlist
├── REFERÊNCIA: Tabela no início do arquivo (Tarefa → Wordlist → Comando)
├── QUANDO AVANÇAR: Quando souber qual lista usar
└── DICAS: Para web use Discovery/, para DNS use Discovery/DNS/, para senhas use Passwords/

        ↓

PASSO 2: Começar sempre pela lista menor → Rápido e eficiente
├── POR QUE: Listas pequenas são rápidas e já cobrem 80% dos casos
├── O QUE FAZER: Usar common.txt (web) ou Top1000.txt (senhas)
├── COMANDO: gobuster dir -u http://target -w /usr/share/seclists/Discovery/Web-Content/common.txt
├── QUANDO AVANÇAR: Se não encontrar nada, usar lista maior
└── ERROS COMUNS: Pular direto para lista grande é desperdício de tempo

        ↓

PASSO 3: Escalar para lista maior → Se a menor não funcionou
├── POR QUE: Listas maiores cobrem mais opções, mas são lentas
├── O QUE FAZER: Usar directory-list-2.3-medium.txt ou rockyou.txt
├── COMANDO: gobuster dir -u http://target -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 100
├── QUANDO AVANÇAR: Quando encontrar resultados ou esgotar opções
└── DICAS: Ajuste threads (-t) para equilibrar velocidade e estabilidade

        ↓

PASSO 4: Wordlists customizadas → Para cenários específicos
├── POR QUE: Nem sempre listas genéricas funcionam (ex: senhas em português)
├── O QUE FAZER: Usar Crunch para gerar padrões ou CeWL para sites
├── COMANDO: crunch 8 8 -t @@@@2023 -o wordlist.txt
├── QUANDO AVANÇAR: Quando listas prontas falharem
└── DICAS: CeWL gera wordlists a partir de sites do alvo

        ↓

PASSO 5: Integrar com ferramentas → Usar wordlists no ataque
├── POR QUE: Wordlist sozinha não faz nada, precisa de ferramenta
├── O QUE FAZER: Usar com Gobuster, Hydra, FFUF, John, Hashcat
├── REFERÊNCIA: Tabela de integração no início do arquivo
├── QUANDO PARAR: Quando encontrar o que procura
└── ÉTICA: Use apenas em alvos autorizados

IMPORTANTE: A wordlist certa na ferramenta certa = resultado rápido!

---

## 📋 Resumo: qual wordlist usar

| Tarefa | Wordlist |
|:---|:---|
| Scan rápido de diretórios | `Discovery/Web-Content/common.txt` |
| Scan completo de diretórios | `Discovery/Web-Content/directory-list-2.3-medium.txt` |
| Brute force de subdomínios | `Discovery/DNS/subdomains-top1million-5000.txt` |
| Brute force de senhas rápido | `Passwords/Top1000.txt` |
| Brute force de senhas completo | `Passwords/rockyou.txt` |
| Brute force de usuários | `Usernames/top-usernames-shortlist.txt` |
| Fuzzing de parâmetros | `Discovery/Web-Content/burp-parameter-names.txt` |
| Fuzzing de vulnerabilidades | `Fuzzing/` |
| Default credentials | `Passwords/Default-Credentials/` |

---

## Criando wordlists customizadas

```bash
# Crunch — gerar wordlists por padrão
sudo apt install -y crunch

# Gerar senhas de 8 caracteres (a-z, 0-9)
crunch 8 8 abcdefghijklmnopqrstuvwxyz0123456789

# Gerar com padrão
crunch 8 8 -t @@@@2023 -o wordlist.txt
# @ = minúscula, , = maiúscula, % = número, ^ = símbolo

# CeWL — gerar wordlist a partir de um site
sudo apt install -y cewl
cewl http://target.com -w wordlist.txt -d 3 -m 5
# -d = profundidade
# -m = tamanho mínimo da palavra

# Mantis — gerar wordlists baseadas em contexto
# https://github.com/rapid7/Recourse
```
