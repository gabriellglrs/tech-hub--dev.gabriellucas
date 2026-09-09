# 📡 Reconhecimento e Enumeração

> Primeira fase de qualquer pentest: mapear o alvo sem ser detectado.

---

## 🚀 Passo a Passo — Como fazer Reconhecimento

Antes de qualquer coisa, você precisa **descobrir o que existe** no alvo. Vamos seguir uma ordem lógica:

### Passo 1: Descobrir informações do domínio (Whois)
```bash
# Primeiro, veja quem é o dono do domínio e quais servidores DNS ele usa
whois example.com
```
**O que procurar:** Name Servers, bloco de IPs, data de criação, registrar.

### Passo 2: Descobrir registros DNS (dig)
```bash
# Agora veja os registros DNS — isso te diz onde o site aponta
dig example.com A          # IP do site
dig example.com MX         # servidores de email
dig example.com NS         # name servers
dig example.com TXT        # registros de verificação (SPF, DKIM)

# Para ver só os resultados (sem enrolação):
dig +short example.com
```

### Passo 3: Descobrir se o IP está no ar (ping)
```bash
# Teste se o servidor responde
ping -c 4 example.com
```

### Passo 4: Descobrir portas abertas (Nmap)
```bash
# Agora escaneie o IP que você descobriu nos passos anteriores
# Primeiro, um scan básico para ver portas e serviços:
nmap -sV -sC 192.168.1.1

# Se não souber o IP, use o domínio:
nmap -sV -sC example.com
```
**O que procure:** Portas abertas (22=SSH, 80=HTTP, 443=HTTPS, 445=SMB, etc) e versões dos serviços.

### Passo 5: Scan agressivo (Nmap)
```bash
# Se quiser mais detalhes (versão exata, scripts, OS):
nmap -A -p- -T4 192.168.1.1
# -A = tudo (OS, versão, scripts, traceroute)
# -p- = todas as portas (1 a 65535)
# -T4 = mais rápido
```

### Passo 6: Se for uma rede inteira (Masscan)
```bash
# Se o alvo for uma rede (ex: 192.168.1.0/24), use Masscan para varrer rápido
masscan 192.168.1.0/24 -p 80,443,22 --rate=5000

# Depois, use Nmap para investigar os hosts que encontrou
nmap -sV -sC 192.168.1.10  # substitua pelo IP encontrado
```

### Resumo da ordem — Por que essa sequência?

O reconhecimento segue uma ordem lógica: **do mais amplo para o mais específico**. Cada passo depende do anterior.

```
PASSO 1: whois → Descobrir quem é o dono do domínio
├── POR QUE: Antes de atacar, você precisa saber quem é o alvo
├── O QUE PROCURAR: Name servers, bloco de IPs, registrar, data de criação
├── QUANDO AVANÇAR: Quando souber os name servers e bloco de IP
└── SE DER ERRADO: Se não retornar nada, o domínio pode ser novo ou usar privacy protection

        ↓

PASSO 2: dig → Descobrir registros DNS (onde o site aponta)
├── POR QUE: Precisa saber o IP real do servidor antes de escanear
├── O QUE PROCURAR: Registro A (IP), MX (email), NS (name servers)
├── COMANDO: dig +short example.com (só o IP, sem enrolação)
├── QUANDO AVANÇAR: Quando tiver o IP do servidor
└── SE DER ERRADO: Se não resolver, teste com dig @8.8.8.8 example.com (DNS público)

        ↓

PASSO 3: theharvester → Coletar emails e subdomínios
├── POR QUE: Emails servem para phishing, subdomínios revelam serviços ocultos
├── O QUE PROCURAR: Emails @empresa.com, subdomínios (api., admin., vpn.)
├── COMANDO: theHarvester -d example.com -b all
├── QUANDO AVANÇAR: Quando tiver lista de subdomínios e emails
└── SE DER ERRADO: Tente fontes específicas: -b google, -b linkedin

        ↓

PASSO 4: ping → Confirmar que o servidor está no ar
├── POR QUE: Não adianta escanear um servidor offline
├── O QUE PROCURAR: Tempo de resposta (latência), pacotes perdidos
├── COMANDO: ping -c 4 example.com
├── QUANDO AVANÇAR: Quando receber respostas (mesmo que 1 de 4)
└── SE DER ERRADO: Se bloquear ping, use nmap com -Pn (ignora ping)

        ↓

PASSO 5: nmap básico → Descobrir portas abertas e serviços
├── POR QUE: Portas abertas = possíveis pontos de entrada
├── O QUE PROCURAR: Portas 22(SSH), 80(HTTP), 443(HTTPS), 445(SMB), 3389(RDP)
├── COMANDO: nmap -sV -sC IP (detecta versão + scripts padrão)
├── QUANDO AVANÇAR: Quando souber quais portas estão abertas
└── SE DER ERRADO: Se muito lento, use -T4 (mais rápido) ou -Pn (ignora ping)

        ↓

PASSO 6: nmap -A → Detalhes completos (versão exata, OS, scripts)
├── POR QUE: Versão do serviço = vulnerabilidades conhecidas
├── O QUE PROCURAR: Versão exata (Apache 2.4.49 = vulnerável!), OS detectado, scripts revelaram info
├── COMANDO: nmap -A -p- -T4 IP (-A = tudo, -p- = todas as portas)
├── QUANDO AVANÇAR: Quando tiver versões de todos os serviços
└── SE DER ERRADO: Se -p- demorar muito, escaneie só portas comuns: -p 21,22,25,53,80,443,445,3389
```

**Dica:** Salve os resultados em arquivo: `nmap -sV -sC IP -oN recon.txt` para consultar depois.

---

## Nmap

Scanner de portas mais usado no mundo. Essencial para descobrir portas abertas, serviços e versões rodando no alvo.

### Instalação
```bash
sudo apt install -y nmap
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-sV` | Detecta versão do serviço |
| `-sC` | Roda scripts padrão do Nmap |
| `-sS` | TCP SYN scan (stealth) — o mais comum |
| `-sT` | TCP connect scan (usa 3-way handshake completo) |
| `-sU` | UDP scan (mais lento, mas importante) |
| `-p-` | Scanneia todas as 65535 portas |
| `-p 80,443` | Scanneia portas específicas |
| `-T4` | Timing agressivo (mais rápido) |
| `-T2` | Timing paranoido (mais lento, menos detecção) |
| `-A` | Scan agressivo (OS, versão, scripts, traceroute) |
| `-Pn` | Trata todos os hosts como online (ignora ping) |
| `-oX` | Output em XML |
| `-oG` | Output em grepable |

### Exemplos práticos

```bash
# Scan básico — descobre portas abertas e serviços
nmap -sV -sC 192.168.1.1

# Scan agressivo — tudo que o Nmap sabe
nmap -A -p- -T4 192.168.1.1

# Scan stealth rápido (SYN)
nmap -sS -T4 -Pn 192.168.1.1

# Scan UDP (serviços como SNMP, DNS, DHCP)
nmap -sU --top-ports 100 -T4 192.168.1.1

# Scan de uma rede inteira
nmap -sn 192.168.1.0/24              # quais hosts estão vivos
nmap -sV -p 22,80,443 192.168.1.0/24 # quais serviços nessas portas

# Enumeração web
nmap --script=http-enum,http-headers,http-title -p 80,443 192.168.1.1

# Enumeração SMB
nmap --script=smb-enum-shares,smb-enum-users -p 445 192.168.1.1

# Enumeração DNS
nmap --script=dns-brute example.com

# Output para relatório
nmap -sV -oX scan_result.xml 192.168.1.1
```

### Dicas avançadas
```bash
# Evitar detecção — scan lento e fragmentado
nmap -sS -T1 -f --mtu 24 -D RND:10 192.168.1.1

# Scan só com scripts específicos
nmap --script=http-sql-injection -p 80 192.168.1.1

# Atualizar banco de scripts
sudo nmap --script-updatedb
```

---

## Masscan

Scanner de portas mais rápido que Nmap. Ideal para varreduras em larga escala (milhares de IPs).

### Instalação
```bash
sudo apt install -y masscan
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-p` | Portas (ex: `-p 80,443` ou `-p 0-65535`) |
| `--rate` | Pacotes por segundo |
| `-oG` | Output grepable |
| `-oJ` | Output JSON |
| `--banners` | Tenta pegar banner do serviço |

### Exemplos práticos

```bash
# Scan rápido de todas as portas em uma rede
masscan 192.168.1.0/24 -p 0-65535 --rate=10000

# Scan de portas web
masscan 192.168.1.0/24 -p 80,443,8080,8443 --rate=5000

# Scan com banner grab
masscan 192.168.1.0/24 -p 22,80,443 --banners --rate=1000

# Output para arquivo
masscan 192.168.1.0/24 -p 1-10000 -oG masscan_results.txt --rate=5000

# Comparar com Nmap (Masscan para escanear, Nmap para investigar)
masscan 192.168.1.0/24 -p 80 --rate=10000 -oL masscan.txt
# Depois passar os resultados para Nmap
nmap -sV -p $(grep "80/open" masscan.txt | awk '{print $4}' | tr '\n' ',' | sed 's/,$//') 192.168.1.0/24
```

### Dica
> Masscan é rápido mas menos preciso. Use para descobrir portas abertas em larga escala e depois use Nmap para investigar cada porta encontrada.

---

## Whois

Consulta informações de registro de domínio e IP.

### Instalação
```bash
sudo apt install -y whois
```

### Exemplos práticos

```bash
# Informações de domínio
whois example.com

# Informações de IP
whois 200.100.50.25

# Procurar por palavra-chave no output
whois example.com | grep -i "name server\|registrar\|creation"
```

### O que procurar no output
- **Name Servers** — servidores DNS do domínio
- **Registrar** — quem registrou o domínio
- **Creation/Expiry Date** — quando foi criado/expira
- **Registrant** — dono do domínio (às vezes mascarado por privacy)
- **CIDR/Ranged** — bloco de IPs associado

---

## DNS Utils (dig, nslookup, host)

Ferramentas para consultar e enumeração de registros DNS.

### Instalação
```bash
sudo apt install -y dnsutils
```

### dig (mais detalhado)

```bash
# Consulta básica
dig example.com

# Tipo específico de registro
dig example.com A          # endereço IPv4
dig example.com AAAA       # endereço IPv6
dig example.com MX         # servidores de email
dig example.com NS         # name servers
dig example.com TXT        # registros TXT (SPF, DKIM, etc)
dig example.com SOA        # authority
dig example.com CNAME      # alias

# Output limpo
dig +short example.com
dig +noall +answer example.com

# Consultar servidor DNS específico
dig @8.8.8.8 example.com

# Zona de transferência (se habilitada — vulnerabilidade!)
dig axfr example.com @ns1.example.com

# Brute force de subdomínios
for sub in mail www ftp vpn api dev staging test; do
  result=$(dig +short $sub.example.com)
  [ -n "$result" ] && echo "$sub.example.com -> $result"
done
```

### nslookup (mais simples)

```bash
nslookup example.com
nslookup -type=MX example.com
nslookup example.com 8.8.8.8
```

### host (mais compacto)

```bash
host example.com
host -t MX example.com
host example.com 8.8.8.8
```

---

## Ping / IPUtils

### Instalação
```bash
sudo apt install -y iputils-ping
```

### Exemplos práticos

```bash
# Ping básico
ping -c 4 192.168.1.1

# Ping com tamanho específico (testar MTU)
ping -s 1400 -M do 192.168.1.1

# Ping rápido (sem resolver DNS)
ping -c 4 -n 192.168.1.1

# Ping flood (requer root, útil para stress test)
sudo ping -f -c 1000 192.168.1.1

# Ping com intervalo específico
ping -c 10 -i 0.2 192.168.1.1   # 10 pacotes, 200ms entre cada
```

---

## TheHarvester

Coleta emails, subdomínios, hosts e IPs de fontes públicas (Google, Bing, DNS, etc).

### Instalação
```bash
sudo pip3 install theHarvester
# ou
sudo apt install -y theharvester
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-d` | Domínio alvo |
| `-b` | Fonte de dados (google, bing, dnsdumpster, etc) |
| `-l` | Limite de resultados |
| `-f` | Output em arquivo HTML |
| `-S` | Usar Shodan |

### Exemplos práticos

```bash
# Coletar emails e subdomínios de várias fontes
theHarvester -d example.com -b all

# Só do Google
theHarvester -d example.com -b google

# Com limite de resultados
theHarvester -d example.com -b all -l 200

# Salvar em HTML
theHarvester -d example.com -b all -f report.html

# Usando Shodan (precisa de API key)
theHarvester -d example.com -b all -S
```

### Fontes disponíveis
```
google, bing, bingapi, yahoo, duckduckgo, crtsh, dnsdumpster,
hackertarget, otx, securityTrails, shodan, subdomainfinderc99,
threatminer, urlscan, virustotal, zoomeye
```

---

## DNSRecon

Enumeração DNS mais profunda que dig. Faz zone transfer, brute force, e muito mais.

### Instalação
```bash
sudo apt install -y dnsrecon
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-d` | Domínio alvo |
| `-n` | Servidor DNS específico |
| `-t` | Tipo (std, zt, brt, srv, tld, goo) |
| `-w` | Wordlist para brute force |
| `-j` | Output JSON |
| `--threads` | Threads para brute force |

### Exemplos práticos

```bash
# Scan padrão (tudo)
dnsrecon -d example.com

# Zona de transferência
dnsrecon -d example.com -n ns1.example.com -t zt

# Brute force de subdomínios
dnsrecon -d example.com -t brt -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# Enumeração SRV
dnsrecon -d example.com -t srv

# Google enumeration
dnsrecon -d example.com -t goo

# Output JSON
dnsrecon -d example.com -j output.json

# Range de IPs
dnsrecon -r 192.168.1.0/24
```

### dnsrecon vs dig

| Feature | dig | dnsrecon |
|:---|:---|:---|
| Consultas simples | ✅ Melhor | ✅ |
| Zone transfer | Manual | Automático |
| Brute force | Manual (loop) | ✅ Built-in |
| SRV records | Manual | ✅ |
| Google enum | ❌ | ✅ |
| Output JSON | ❌ | ✅ |

---

## Fluxo típico de Reconhecimento

```
1. Whois do domínio → descobrir name servers, bloco de IPs
        ↓
2. DNS enum → dig/dnsrecon para todos os registros
        ↓
3. TheHarvester → coletar emails, subdomínios de fontes públicas
        ↓
4. Ping sweep / Masscan → descobrir hosts vivos na rede
        ↓
5. Nmap nas portas comuns → descobrir serviços
        ↓
6. Nmap com scripts → enumeração detalhada de cada serviço
        ↓
7. Passar para fase de Web App Testing ou Exploração
```

---

## Lab Prático

### Exercício 1: Reconhecimento Completo com Nmap
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/nmap01
- **O que vai praticar:** Scan de portas, detecção de serviços, scripts NSE e enumeração básica com Nmap
- **Tempo estimado:** 45 minutos

### Exercício 2: DNS e Enumeração com Dig/Whois
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dnsindemand
- **O que vai praticar:** Consultas DNS, zone transfer, enumeração de registros e coleta de informações com Whois
- **Tempo estimado:** 30 minutos

### Exercício 3: Nmap Live Host Discovery
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/nmap02
- **O que vai praticar:** Ping sweep, TCP/UDP scans, traceroute e evasão de firewalls
- **Tempo estimado:** 40 minutos

### Exercício 4: Nmap Scanning
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/furthernmap
- **O que vai praticar:** Scan agressivo (-A), scan em redes, output em diferentes formatos
- **Tempo estimado:** 45 minutos

### Dica de Estudo
> Comece sempre pelos rooms básicos de Nmap no TryHackMe. Pratique os comandos em um alvo autorizado (como as máquinas do THM) e documente seus findings em um relatório simples. Repita o fluxo completo (Whois → Dig → Nmap) até que se torne automático.
