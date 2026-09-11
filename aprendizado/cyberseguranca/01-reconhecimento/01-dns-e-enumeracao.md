# 📡 Reconhecimento e Enumeração

> Primeira fase de qualquer pentest: mapear o alvo sem ser detectado.

## 📚 O que é Reconhecimento e Enumeração?

**Reconhecimento** é a fase de coletar informações sobre o alvo **sem ser detectado**. É como espiar a casa antes de entrar — você precisa saber quantas portas tem, onde ficam as janelas, quem mora lá, qual o melhor horário.

**Enumeração** é ir além: descobrir **detalhes específicos** que podem ser usados para exploração — versões de serviços, usuários, subdomínios, tecnologias.

### Por que isso é importante?

- **90% das falhas** são descobertas na fase de reconhecimento
- Sem saber o que existe, você não sabe **onde atacar**
- Um bom reconhecimento **economiza horas** de exploração cega
- Erros aqui revelam que você está atacando (pode ser bloqueado)

### Como funciona na prática?

```
Fase 1: Passiva (sem contato direto)
├── Whois → Dono do domínio
├── Google Dork → Informações indexadas
├── Shodan/Censys → Serviços expostos
└── theHarvester → Emails e subdomínios

Fase 2: Ativa (contato direto com o alvo)
├── Nmap → Portas e serviços
├── DNS enum → Subdomínios
├── Web crawl → Páginas e diretórios
└── Banner grab → Versões exatas
```

### O que você vai descobrir?

| Tipo de informação | O que revela | Como usar |
|:---|:---|:---|
| IP do servidor | Onde o alvo está hospedado | Escanear com Nmap |
| Versão do Apache | Apache 2.4.49 = vulnerável | Pesquisar CVEs |
| Email @empresa | Usuários reais | Phishing, brute force |
| Subdomínios | APIs, painéis internos | Acesso alternativo |
| Tecnologias | WordPress, Laravel | Ataques específicos |

### Diferença entre Reconhecimento e Enumeração

| Reconhecimento | Enumeração |
|:---|:---|
| Coleta ampla de dados | Detalhes específicos |
| Feito de longe (passivo) | Contato com o alvo |
| Ex: "empresa.com usa Nginx" | Ex: "Nginx 1.18.0, PHP 8.1" |
| Base do ataque | Pontos de entrada específicos |

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

### 🎯 Quando usar o Nmap
Sempre. É a primeira ferramenta que você roda contra qualquer alvo. Você vai precisar dele quando:
- Precisar saber **quais serviços estão rodando** em um servidor
- Precisar descobrir **versões de serviços** (para pesquisar CVEs)
- Precisar mapear **uma rede inteira** (ex: 192.168.1.0/24)
- Precisar identificar o **sistema operacional** do alvo

### 🛠️ Como o Nmap te ajuda
O Nmap é como um raio-x do servidor. Ele te diz:
- **Portas abertas** = serviços ativos (cada porta é uma porta de entrada potencial)
- **Versões** = Apache 2.4.49 (vulnerável!) vs Apache 2.4.51 (corrigido)
- **Scripts** = verifica vulnerabilidades automaticamente com `--script vuln`
- **SO** = Linux, Windows, versão específica

### ➡️ Depois de rodar o Nmap — Próximos passos
1. **Anote as portas abertas** → Vai usar isso no Módulo 3 (Exploração)
2. **Pesquise CVEs** → Google: "Apache 2.4.49 CVE" → encontra falhas conhecidas
3. **Teste serviços específicos** → SSH (Hydra), HTTP (Nikto/ffuf), SMB (enum4linux)
4. **Escaneie todas as portas** → `nmap -p- -T4 alvo` para não perder nada
5. **Salve o output** → `nmap -oN scan.txt alvo` para referência futura

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

### 🎯 Quando usar o Masscan
Quando você precisa escanear **muitos IPs rapidamente** (redes inteiras, /24, /16). O Nmap é mais preciso, mas o Masscan é 10x mais rápido. Use quando:
- Precisar mapear **uma rede inteira** (ex: 192.168.1.0/24)
- Tiver **milhares de IPs** para escanear
- Precisar descobrir **hosts vivos** antes de usar o Nmap
- Estiver em **CTF** ou competição com tempo limitado

### 🛠️ Como o Masscan te ajuda
- **Velocidade** → Varre 65535 portas em segundos (Nmap leva minutos)
- **Escala** → Funciona em redes /16 (65.536 IPs) sem travar
- **Output** → Resultados em formato grepable para processar depois

### ➡️ Depois de rodar o Masscan — Próximos passos
1. **Passe os IPs para o Nmap** → `nmap -sV -p 80,443 IP_ENCONTRADO`
2. **Investigue cada serviço** → Para cada porta aberta, rode scripts específicos
3. **Salve o output** → `masscan -oG results.txt` para referência futura

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

### 🎯 Quando usar o Whois
Sempre no início do reconhecimento. Use quando:
- Precisar saber **quem é o dono** de um domínio
- Precisar descobrir **name servers** (servidores DNS)
- Precisar do **bloco de IPs** associado ao domínio
- Quiser saber **quando o domínio foi criado** (domínio novo = menos testado)

### 🛠️ Como o Whois te ajuda
- **Name Servers** → Revela onde o domínio está hospedado (pode ter falhas)
- **Bloco de IPs** → Escaneie a rede inteira com Nmap
- **Registrar** → Às vezes revela dados do dono (se não usar privacy)
- **Datas** → Domínio novo pode ter menos segurança

### ➡️ Depois de rodar o Whois — Próximos passos
1. **Anote os name servers** → Use com `dig @ns1.example.com`
2. **Escaneie o bloco de IPs** → `nmap -sn 200.100.50.0/24`
3. **Pesquise o registrar** → Google: "registrar X vulnerabilidade"

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

### 🎯 Quando usar dig/nslookup/host
Depois de rodar o Whois. Use quando:
- Precisar descobrir o **IP real** do servidor
- Precisar verificar **registros DNS** (A, MX, NS, TXT)
- Precisar testar **zone transfer** (vulnerabilidade!)
- Precisar fazer **brute force de subdomínios**

### 🛠️ Como dig te ajuda
- **Registro A** → IP do servidor (para escanear com Nmap)
- **Registro MX** → Servidores de email (pode ter vulnerabilidades)
- **Registro TXT** → Chaves SPF, DKIM (configuração de email)
- **Zone transfer** → Se funcionar, revela TODOS os subdomínios!

### ➡️ Depois de rodar dig — Próximos passos
1. **IP encontrado?** → Escaneie com `nmap -sV -sC IP`
2. **Zone transfer funcionou?** → Anote todos os subdomínios para brute force
3. **Email server encontrado?** → Teste phishable users com theHarvester
4. **Salve o output** → `dig example.com > dns_results.txt`

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

### 🎯 Quando usar o Ping
Para confirmar que o servidor **está no ar** antes de escanear. Use quando:
- Precisar saber se o alvo **responde** a requisições
- Precisar medir **latência** (tempo de resposta)
- Precisar testar **conectividade** básica

### 🛠️ Como o Ping te ajuda
- **Servidor no ar** → Não adianta escanear um servidor offline
- **Latência** → Servidor muito lento pode indicar sobrecarga ou bloqueio
- **TTL** → Pode revelar o SO (TTL 64 = Linux, TTL 128 = Windows)

### ➡️ Depois de rodar o Ping — Próximos passos
1. **Servidor respondeu?** → Escaneie com `nmap -sV -sC IP`
2. **Servidor NÃO respondeu?** → Use `nmap -Pn IP` (ignora ping)
3. **TTL revelou o SO?** → Use isso para escolher ferramentas adequadas

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

### 🎯 Quando usar o TheHarvester
Na fase **passiva** do reconhecimento (sem tocar no alvo). Use quando:
- Precisar de **emails** para phishing ou brute force
- Precisar de **subdomínios** extras (além do que o Whois mostrou)
- Precisar de **IPs** associados ao domínio
- Estiver fazendo **OSINT** (inteligência de fontes abertas)

### 🛠️ Como o TheHarvester te ajuda
- **Emails** → `admin@empresa.com`, `joao@empresa.com` (usuários reais!)
- **Subdomínios** → `api.empresa.com`, `vpn.empresa.com` (pontos de entrada)
- **IPs** → Onde o domínio está hospedado
- **Fontes** → Google, Bing, DNS, Shodan, LinkedIn (múltiplas perspectivas)

### ➡️ Depois de rodar o TheHarvester — Próximos passos
1. **Emails encontrados?** → Use para brute force com Hydra (Módulo 3)
2. **Subdomínios encontrados?** → Escaneie cada um com `nmap -sV -sC IP`
3. **IPs encontrados?** → Escaneie com Nmap para descobrir serviços
4. **Salve o output** → `theHarvester -d empresa.com -b all -f report.html`

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

### 🎯 Quando usar o DNSRecon
Quando o `dig` não é suficiente. Use quando:
- Precisar testar **zone transfer** automaticamente
- Precisar fazer **brute force de subdomínios** com wordlist
- Precisar descobrir **registros SRV** (serviços Active Directory)
- Quiser um **output JSON** para processar depois

### 🛠️ Como o DNSRecon te ajuda
- **Zone transfer** → Se funcionar, revela TODOS os subdomínios de uma vez
- **Brute force** → Testa milhares de subdomínios com wordlist
- **SRV records** → Descobre serviços AD (_ldap._tcp.empresa.com)
- **Google enum** → Descobre subdomínios via Google

### ➡️ Depois de rodar o DNSRecon — Próximos passos
1. **Zone transfer funcionou?** → Anote todos os subdomínios e escaneie
2. **Subdomínios encontrados via brute force?** → Use `httpx` para verificar quais estão ativos
3. **Registros SRV encontrados?** → Pode indicar Active Directory (Módulo 4)
4. **Salve o output** → `dnsrecon -d empresa.com -j output.json`

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

## 🧠 Exercícios de Raciocínio

### Exercício 1: Análise de Whois

**Cenário:** Você fez `whois example.com` e recebeu:

```
Domain Name: EXAMPLE.COM
Registrar: GoDaddy.com, LLC
Updated Date: 2025-01-15
Creation Date: 2010-03-20
Registry Expiry Date: 2026-03-20
Name Server: NS1.GODADDY.COM
Name Server: NS2.GODADDY.COM
Registrant Organization: Example Corp
Registrant State/Province: California
```

**Pergunta:** O que você pode concluir? Quais seriam seus próximos passos?

**Raciocínio esperado:**
1. **Empresa real:** Example Corp está em California → pode ter operação nos EUA
2. **Domínio antigo:** Criado em 2010 → empresa estabelecida
3. **Expira em 2026:** Pode ser renovado ou abandonado
4. **GoDaddy:** Registrar popular → pode ter painel de gerenciamento exposto
5. **Próximo passo:** Verificar subdomínios, DNS records, portas abertas

### Exercício 2: Zone Transfer

**Cenário:** Você executou `dig axfr example.com @ns1.example.com` e a zona de transferência funcionou. O output mostrou:

```
example.com.    3600    IN    SOA    ns1.example.com. admin.example.com. 2026091101 3600 900 604800 86400
example.com.    3600    IN    NS     ns1.example.com.
example.com.    3600    IN    NS     ns2.example.com.
example.com.    3600    IN    A      203.0.113.10
mail.example.com. 3600  IN    A      203.0.113.20
dev.example.com. 3600   IN    A      203.0.113.30
staging.example.com. 3600 IN A      203.0.113.40
vpn.example.com. 3600   IN    A      203.0.113.50
```

**Pergunta:** O que você pode concluir? Qual a prioridade de escaneamento?

**Raciocínio esperado:**
1. **Vulnerabilidade:** Zone transfer exposta → qualquer pessoa pode ver todos os subdomínios
2. **Ativos encontrados:** 6 subdomínios com IPs diferentes
3. **Prioridade:** VPN (203.0.113.50) → porta de entrada para rede interna
4. **Depois:** dev/staging → podem ter versões não-patcheadas
5. **Email:** mail.example.com → pode ser phishing target
6. **Próximo passo:** Nmap em todos os IPs, priorizando VPN

### Exercício 3: DNS Inconsistente

**Cenário:** Você consultou DNS e encontrou:

```
$ dig api.example.com +short
10.0.0.50

$ dig api.example.com @8.8.8.8 +short
203.0.113.100
```

**Pergunta:** Por que os IPs são diferentes? O que isso significa?

**Raciocínio esperado:**
1. **DNS split:** A empresa usa DNS diferente para rede interna vs externa
2. **10.0.0.50:** IP interno (RFC 1918) → acessível apenas na rede da empresa
3. **203.0.113.100:** IP externo → acessível pela internet
4. **Risco:** O IP externo pode ser mais protegido, mas o interno pode ter menos segurança
5. **Próximo passo:** Escanear o IP externo, verificar se há acesso ao interno

### Exercício 4: Decisão de Ferramenta

**Cenário:** Você precisa descobrir subdomínios de `target.com`. Pode usar:
- `dig` (manual, lento)
- `dnsrecon` (automático, com brute force)
- `subfinder` (passivo, rápido)

**Pergunta:** Qual você escolheria? Por quê?

**Raciocínio esperado:**
1. **Primeiro:** subfinder (passivo, rápido, não toca no alvo)
2. **Depois:** dnsrecon com brute force (ativo, mais completo)
3. **Por quê:** Comece passivo, depois vá para ativo
4. **Regra:** Passivo primeiro → menos rastro → mais seguro

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
