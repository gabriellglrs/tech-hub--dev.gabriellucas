# 🔒 Proxy e Anonimato

> Trafegar na rede de forma anônima ou contornar restrições usando proxies.

---

## 🚀 Passo a Passo — Como usar Proxy e Anonimato

Você quer **esconder seu IP** ou contornar bloqueios. Vamos configurar o Tor + Proxychains passo a passo.

### Passo 1: Instalar Tor
```bash
# O Tor é uma rede que esconde seu IP
sudo apt install -y tor
sudo systemctl start tor
sudo systemctl status tor   # veja se está rodando (deve mostrar "active")
```

### Passo 2: Instalar Proxychains
```bash
# O Proxychains força qualquer app a usar o Tor
sudo apt install -y proxychains4
```

### Passo 3: Configurar Proxychains
```bash
# Edite o arquivo de configuração
sudo nano /etc/proxychains4.conf

# Vá até o final do arquivo e mude para:
# dynamic_chain
# ...
# socks5 127.0.0.1 9050

# Salve e saia (Ctrl+X, Y, Enter)
```

### Passo 4: Testar se está funcionando
```bash
# Veja seu IP normal:
curl ifconfig.me

# Agora veja seu IP pelo Tor:
proxychains4 curl ifconfig.me
# Deve mostrar um IP diferente!
```

### Passo 5: Usar com ferramentas
```bash
# Nmap via Tor:
proxychains4 nmap -sV -Pn -T2 target.com

# Navegador via Tor:
proxychains4 firefox

# Qualquer ferramenta:
proxychains4 seu_comando
```

### Resumo da ordem:
```
1. sudo apt install tor          → instalar Tor
2. sudo systemctl start tor      → iniciar Tor
3. sudo apt install proxychains4 → instalar Proxychains
4. sudo nano /etc/proxychains4.conf → configurar para usar Tor
5. proxychains4 curl ifconfig.me    → testar se funciona
6. proxychains4 nmap ...            → usar com ferramentas
```

---

## Proxychains4

Force qualquer aplicação a usar proxy (SOCKS4/5, HTTP). Útil para anonimato e bypass.

### Instalação
```bash
sudo apt install -y proxychains4
```

### Configuração

O arquivo de configuração fica em `/etc/proxychains4.conf` (ou `~/.proxychains/proxychains.conf`).

```bash
# Editar configuração
sudo nano /etc/proxychains4.conf
```

### Tipos de Proxy

```bash
# No final do arquivo, escolha UM tipo:

# Proxy dinâmico (mais flexível)
dynamic_chain
proxy_list
socks5 127.0.0.1 9050

# Proxy estrito ( todos devem funcionar)
strict_chain
proxy_list
socks5 127.0.0.1 9050

# Proxy randômico
random_chain
proxy_list
socks5 192.168.1.1:1080
socks5 10.0.0.1:1080
http 172.16.0.1:8080
```

### Configurações importantes

```bash
# Velocidade (timeout em milissegundos)
proxy_timeout 10000

# Não resolver DNS via proxy (recomendado para anonimato)
proxy_dns

# Tipos de proxy suportados:
# socks4  IP PORTA
# socks5  IP PORTA [USER PASS]
# http    IP PORTA [USER PASS]
```

### Exemplos práticos

```bash
# === BÁSICO ===

# Nmap via proxychains
proxychains4 nmap -sV -Pn 192.168.1.1

# Curl via proxychains
proxychains4 curl http://target.com

# SSH via proxychains
proxychains4 ssh user@target.com

# === TOR ===

# Instalar Tor:
sudo apt install -y tor
sudo systemctl start tor
# Tor roda na porta 9050 por padrão

# Configurar proxychains para Tor:
# dynamic_chain
# ...
# socks5 127.0.0.1 9050

# Verificar IP via Tor:
proxychains4 curl ifconfig.me

# Nmap via Tor:
proxychains4 nmap -sV -Pn -T2 target.com

# === MÚLTIPLOS PROXIES ===

# Configuração com múltiplos proxies:
# random_chain
# proxy_list
# socks5 192.168.1.1:1080
# socks5 10.0.0.1:1080
# http 172.16.0.1:8080

# === COM USUÁRIO/SENHA ===

# socks5 192.168.1.1 1080 usuario senha
# http 10.0.0.1 8080 usuario senha
```

### Proxychains + Ferramentas Cyberseg

```bash
# Nmap (combinar com -Pn para ignorar ping bloqueado)
proxychains4 nmap -sV -Pn -T2 target.com

# Gobuster
proxychains4 gobuster dir -u http://target.com -w wordlist.txt -t 10

# Hydra
proxychains4 hydra -l admin -P passwords.txt ssh://target.com

# Nikto
proxychains4 nikto -h http://target.com

# Subfinder
proxychains4 subfinder -d target.com
```

### Tor vs Proxychains vs VPN

| Feature | Tor | Proxychains | VPN |
|:---|:---|:---|:---|
| Anonimato | Alto (múltiplos hops) | Depende do proxy | Baixo |
| Velocidade | Lento | Médio | Rápido |
| Criptografia | Sim | Não (a menos que SOCKS5+SSL) | Sim |
| Uso | Navegação anônima | Forçar apps a usar proxy | Tunelamento completo |
| Configuração | Automático | Manual | Automático |
| Bypass de geo-block | Sim | Sim | Sim |

### Dicas importantes

```bash
# 1. Sempre usar proxy_dns para não vazar consultas DNS
# 2. Para Tor, usar -T2 no Nmap (muito lento com -T4)
# 3. Nem todas as ferramentas funcionam bem com proxychains
# 4. Verificar se o proxy está funcionando:
proxychains4 curl ifconfig.me

# 5. Para HTTPS,确保 que o proxy suporta CONNECT
# 6. Proxychains não funciona bem com ferramentas que usam raw sockets
```

---

## Tor (complemento)

Embora não esteja no install.sh, Tor é essencial para anonimato.

### Instalação
```bash
sudo apt install -y tor
sudo systemctl enable tor
sudo systemctl start tor
```

### Configuração básica
```bash
# Tor roda na porta 9050 por padrão
# Configurar proxychains para usar:
# socks5 127.0.0.1 9050

# Verificar se Tor está rodando
sudo systemctl status tor

# Reiniciar Tor
sudo systemctl restart tor
```

### Uso básico
```bash
# Navegar via Tor (usando proxychains)
proxychains4 firefox

# Ou configurar o navegador para usar SOCKS5 127.0.0.1 9050
```

---

## Responder

Poisoning de LLMNR/NBT-NS/MDNS. Captura hashes NTLM em redes Windows.

### Instalação
```bash
sudo git clone --depth=1 https://github.com/lgandx/Responder.git /opt/Responder
sudo ln -sf /opt/Responder/Responder.py /usr/local/bin/responder
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-I` | Interface de rede |
| `-w` | WPAD (Web Proxy Auto-Discovery) |
| `-d` | DHCP (LLMNR/DHCP) |
| `-v` | Verbose |

### Exemplos práticos

```bash
# Iniciar Responder na interface
sudo responder -I eth0

# Com WPAD
sudo responder -I eth0 -w

# Verbose
sudo responder -I eth0 -v

# Depois de capturar hash, crackear com john/hashcat
# O hash fica em /opt/Responder/logs/
cat /opt/Responder/logs/SMB*.txt | grep ":::" > hashes.txt
john --wordlist=/usr/share/seclists/Passwords/Top10000.txt hashes.txt
```

### Como funciona
1. Responder envia respostas falsas para consultas LLMNR/NBT-NS
2. Máquinas Windows enviam hashes NTLM para o Responder
3. Você captura os hashes e crackea com john/hashcat

### ⚠️ Aviso legal
Use apenas em redes autorizadas. Poisoning é uma técnica de ataque.

---

## Bettercap

Framework de MITM e monitoramento de rede. Substitui o ettercap, mais moderno.

### Instalação
```bash
sudo apt install -y bettercap
```

### Uso básico

```bash
# Iniciar bettercap (interface interativa)
sudo bettercap -iface eth0

# Dentro do bettercap:
help                        # ver comandos disponíveis
net.probe                   # descobrir hosts na rede
net.sniff                    # iniciar sniff
net.sniff on                # ligar sniff
net.sniff off               # desligar sniff
arp.spoof on                # iniciar ARP spoofing
arp.spoof off               # parar ARP spoofing
set net.sniff.verbose true  # verbose no sniff
```

### Comandos úteis

```bash
# Descobrir hosts
net.probe on

# Listar hosts descobertos
net.show

# ARP Spoofing (MITM)
set arp.spoof.targets 192.168.1.100
arp.spoof on

# Sniff HTTP
net.sniff on

# Sniff SSL/TLS (precisa de cert)
tls.proxy on

# DNS Spoofing
set dns.spoof.domains example.com
set dns.spoof.address 192.168.1.100
dns.spoof on

# Sessão
session.save        # salvar sessão
session.load        # carregar sessão
```

### Recursos principais
- **ARP Spoofing** — MITM em rede local
- **DNS Spoofing** — redirecionar DNS
- **SSL Strip** — downgrade de HTTPS
- **Packet Sniffing** — capturar tráfego
- **Network Discovery** — descobrir hosts
- **Bluetooth/Antena** — monitoramento BLE

### ⚠️ Aviso legal
Use apenas em redes autorizadas. Bettercap é uma ferramenta de ataque.

---

## mitmproxy

Proxy interativo para análise e manipulação de tráfego HTTPS.

### Instalação
```bash
sudo apt install -y mitmproxy
```

### Três ferramentas

| Comando | Descrição |
|:---|:---|
| `mitmproxy` | Interface TUI (terminal) |
| `mitmweb` | Interface web |
| `mitmdump` | Modo batch (sem interface) |

### Exemplos práticos

```bash
# Iniciar proxy (interface TUI)
mitmproxy

# Iniciar proxy (interface web)
mitmweb

# Iniciar proxy em porta específica
mitmproxy -p 8080

# Salvar tráfego em arquivo
mitmdump -w traffic.flow

# Ler tráfego salvo
mitmdump -r traffic.flow

# Filtrar apenas requests HTTP
mitmdump -nr traffic.flow --filter "~m GET"

# Script customizado
mitmdump -s script.py

# Modo headless (para scripts)
mitmdump -s script.py -p 8080
```

### Como usar como proxy

```bash
# 1. Iniciar mitmproxy
mitmproxy -p 8080

# 2. Configurar o navegador para usar proxy:
#    Proxy: 127.0.0.1:8080

# 3. Acessar http://mitm.it para instalar certificado

# 4. Interceptar e manipular tráfego
```

### Scripts (addons)

```python
# script.py - exemplo de script
from mitmproxy import http

def response(flow: http.HTTPFlow):
    if "example.com" in flow.request.pretty_url:
        flow.response.content = b"Hacked!"
```

### mitmproxy vs Burp Suite

| Feature | mitmproxy | Burp Suite |
|:---|:---|:---|
| Gratuito | ✅ Total | ✅ Community / Pago |
| Interface | TUI/Web | GUI |
| Scripts Python | ✅ | ✅ (Java) |
| Scanner | ❌ | ✅ |
| Intruder | ❌ | ✅ |
| Projeto | Open source | Comercial |

### ⚠️ Aviso legal
Use apenas em redes autorizadas e seus próprios dispositivos.

---

## Lab Prático

### Exercício 1: Tor e Proxychains
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/torproxy
- **O que vai praticar:** Configuração do Tor, uso do Proxychains para anonimato e bypass de restrições
- **Tempo estimado:** 30 minutos

### Exercício 2: Bettercap - ARP Spoofing
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/bettercap
- **O que vai praticar:** MITM com Bettercap, ARP spoofing, sniffing de tráfego e DNS spoofing
- **Tempo estimado:** 45 minutos

### Exercício 3: Responder - LLMNR Poisoning
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/responder
- **O que vai praticar:** Poisoning de LLMNR/NBT-NS, captura de hashes NTLM e cracking com John
- **Tempo estimado:** 40 minutos

### Exercício 4: Anonimato e Proxy
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/starting-point
- **O que vai praticar:** Uso de proxy chains, evasão de detecção e manutenção de anonimato em scans
- **Tempo estimado:** 60 minutos

### Dica de Estudo
> Configure Tor + Proxychains e verifique seu IP antes e depois. Pratique rodar ferramentas como Nmap e Gobuster via proxychains. Anote as diferenças de performance e detectabilidade entre scan direto e via Tor.
