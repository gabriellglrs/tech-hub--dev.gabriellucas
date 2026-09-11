## FASE 2 — Enumeração Ativa

**Tempo estimado:** 45-90 minutos
**Objetivo:** Confirmar quais subdomínios e serviços REALMENTE existem e estão respondendo. Agora você TOCA no alvo.
**Por quê:** Nem todo subdomínio encontrado na Fase 1 está ativo. Precisamos descobrir quais estão vivos para não gastar tempo escaneando alvos mortos.

---

### Passo 2.1 — Validar Subdomínios

**O que você vai fazer:** Verificar quais dos subdomínios encontrados na Fase 1 realmente respondem a requests HTTP.

**Passo 2.1.1 — Descobrir quais resolvem DNS**

```bash
# Primeiro, instalar dnsx se não tiver
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest

# Resolver todos os subdomínios
cat 01-intel/subdominios-todos.txt | dnsx -silent -a > 02-enum/resolvidos.txt
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com [104.21.33.16]
api.evilcorp.com [104.21.33.17]
dev.evilcorp.com [192.168.1.10]
mail.evilcorp.com [192.168.1.50]
staging.evilcorp.com [192.168.1.20]
www.evilcorp.com [104.21.33.15]
```

**O que procurar:** Lista de subdomínios que têm IP associado. Subdomínios sem IP podem não existir mais.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | DNS privado ou sem resolução | Use `dig` manualmente em cada um: `dig +short admin.evilcorp.com` |
| Muito lento | Muitos subdomínios | Adicione resolvers: `dnsx -r resolvers.txt` |
| `command not found` | Não instalado | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` |

**Passo 2.1.2 — Verificar quais estão HTTP vivos**

```bash
cat 02-enum/resolvidos.txt | httpx -silent -status-code -title > 02-enum/vivos.txt
```

**✅ Output esperado (exemplo real):**
```
http://admin.evilcorp.com [403] [Admin Panel - EvilCorp]
http://api.evilcorp.com [200] [EvilCorp API v2]
http://dev.evilcorp.com [200] [Development Server]
http://mail.evilcorp.com [200] [Roundcube Webmail]
http://staging.evilcorp.com [200] [EvilCorp Staging]
http://www.evilcorp.com [200] [EvilCorp - Leading the Future]
```

**O que procurar:**
- **Status 200:** Site acessível (bom alvo) — `api.evilcorp.com`, `dev.evilcorp.com`
- **Status 301/302:** Redirecionamento (pode ser interessante)
- **Status 403:** Acesso negado (pode ter conteúdo oculto) — `admin.evilcorp.com`
- **Status 404:** Não encontrado (pode ser erro de configuração)

**Salvar apenas os que têm status 200 ou 301/302:**
```bash
cat 02-enum/vivos.txt | grep -E "\[200\]|\[301\]|\[302\]" > 02-enum/vivos-filtrados.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Subdomínios bloqueando requests | Teste manualmente: `curl -I http://subdominio.com` |
| `command not found` | httpx não instalado | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| Muitos timeouts | Servidores lentos | Use `httpx -timeout 10 -silent` |

**Passo 2.1.3 — Brute Force DNS (se poucos resultados)**

Se encontrou menos de 10 subdomínios vivos, tente brute force:

```bash
gobuster dns -d evilcorp.com -w /usr/share/wordlists/dirb/common.txt -t 50 -o 02-enum/bruteforce-dns.txt
```

**✅ Output esperado (exemplo real):**
```
===============================================================
Gobuster v3.x
===============================================================
[+] Url: evilcorp.com
[+] Threads: 50
[+] Wordlist: /usr/share/wordlists/dirb/common.txt
===============================================================
Starting gobuster in DNS enumeration mode
===============================================================
ftp.evilcorp.com [Found: 192.168.1.30]
internal.evilcorp.com [Found: 192.168.1.40]
mail.evilcorp.com [Found: 192.168.1.50]
owa.evilcorp.com [Found: 192.168.1.60]
vpn.evilcorp.com [Found: 192.168.1.70]
===============================================================
Finished
===============================================================
```

---

### Passo 2.2 — Scan de Portas e Serviços

**O que você vai fazer:** Descobrir quais portas estão abertas nos IPs do alvo e quais serviços estão rodando nelas.

**IMPORTANTE:** Antes de escanear, salve a lista de IPs para não esquecer:
```bash
# Extrair IPs dos subdomínios vivos
cat 02-enum/vivos.txt | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u > 02-enum/ips.txt
```

**✅ Output de `02-enum/ips.txt` (exemplo):**
```
104.21.33.15
104.21.33.16
104.21.33.17
192.168.1.10
192.168.1.20
192.168.1.50
```

**Passo 2.2.1 — Scan TCP rápido (descobrir ports abertos)**

```bash
nmap -sT -Pn -p- --min-rate 5000 -T4 -iL 02-enum/ips.txt -oN 02-enum/nmap-ports.txt
```

**Explicação das flags:**
- `-sT`: TCP connect scan (funciona sem root)
- `-Pn`: Não fazer ping antes (muitos servidores bloqueiam ping)
- `-p-`: Todas as 65535 portas
- `--min-rate 5000`: Enviar no mínimo 5000 pacotes por segundo (mais rápido)
- `-T4`: Timing agressivo (mais rápido, mas mais ruidoso)
- `-iL`: Ler targets de arquivo
- `-oN`: Salvar output em formato legível

**✅ Output esperado (exemplo real para 1 IP):**
```
Nmap scan report for 104.21.33.15
Host is up (0.023s latency).

PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
443/tcp   open  https
3306/tcp  open  mysql
8080/tcp  open  http-proxy
8443/tcp  open  https-alt

Nmap scan report for 192.168.1.50
Host is up (0.018s latency).

PORT      STATE SERVICE
25/tcp    open  smtp
110/tcp   open  pop3
143/tcp   open  imap
993/tcp   open  imaps
995/tcp   open  pop3s
```

**O que procurar:**
- **22/tcp (SSH):** Acesso remoto — verificar versão (frequentemente vulnerable)
- **80/443 (HTTP/HTTPS):** Web — verificar aplicações web
- **3306 (MySQL):** Banco de dados — pode estar exposto à internet (GRAVE)
- **8080/8443 (alt HTTP):** Outras aplicações web (staging, admin)
- **25/110/143 (email):** Servidor de email — pode ter vulnerabilidades
- **3389 (RDP):** Acesso remoto Windows — ALVO PRIMÁRIO
- **6379 (Redis):** Redis exposto — frequentemente sem autenticação

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muito lento (>30min) | Scan de 65k portas | Use portas comuns: `-p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443` |
| IP banido | IDS bloqueando | Diminua `--min-rate` para 1000 ou use `-T3` |
| Sem root | Precisa root para SYN scan | Use `-sT` (já está no comando) |
| Output vazio | IP inacessível | Verifique se o IP está correto: `ping -c 1 104.21.33.15` |

**Passo 2.2.2 — Service detection (versões dos serviços)**

```bash
# Descobrir quais ports estão abertos
grep "open" 02-enum/nmap-ports.txt | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' > /tmp/ports.txt

# Escanear versões nos ports abertos
nmap -sV -sC -p $(cat /tmp/ports.txt) -iL 02-enum/ips.txt -oN 02-enum/nmap-services.txt
```

**✅ Output esperado (exemplo real):**
```
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.6 (Ubuntu Linux; protocol 2.0)
|_ssh-hostkey: 2048 SHA256:abc123... (RSA)
| ssh2-enum-algos: 
|   kex_algorithms: curve25519-sha256
80/tcp    open  http    Apache/2.4.41 (Ubuntu)
|_http-title: EvilCorp - Leading the Future
|_http-server-header: Apache/2.4.41 (Ubuntu)
443/tcp   open  ssl/http Apache/2.4.41 (Ubuntu)
|_ssl-date: TLS randomness does not represent time
3306/tcp  open  mysql   MySQL 5.7.42-0ubuntu0.18.04.1
| mysql-info: Protocol: 10, Version: 5.7.42
8080/tcp  open  http    Apache Tomcat 9.0.82
|_http-title: Apache Tomcat/9.0.82
```

**O que procurar:**
- **Versão exata:** `Apache/2.4.41`, `OpenSSH/8.9p1`, `MySQL/5.7.42` → usar searchsploit depois
- **Versões antigas:** `Apache/2.4.29` (2017) → provavelmente tem CVEs conhecidas
- **Serviços inesperados:** `MySQL 5.7` exposto à internet = configuração incorreta perigosa
- **Apache Tomcat** → verificar CVEs de Tomcat

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Não detecta versões | Serviço escondendo banner | Adicione `--version-all` |
| Muitos ports altos | Serviços em portas altas | Aumente range: `-p-` |
| Muito lento | Muitos ports | Execute só nos ports que já descobriu |

**Passo 2.2.3 — UDP top ports**

```bash
nmap -sU --top-ports 20 -iL 02-enum/ips.txt -oN 02-enum/nmap-udp.txt
```

**✅ Output esperado (exemplo real):**
```
PORT      STATE SERVICE
53/udp    open  domain
123/udp   open  ntp
161/udp   open  snmp
162/udp   open  snmptrap
500/udp   open  isakmp
1900/udp  open  upnp
4500/udp  open  nat-t-ike
```

**O que procurar:**
- **53 (DNS):** DNS pode ter zone transfer habilitado
- **161 (SNMP):** SNMP exposto = informações do sistema
- **123 (NTP):** NTP pode ser usado para amplificação de ataque

---

### Passo 2.3 — Banner Grabbing

**O que você vai fazer:** Conectar manualmente a cada port aberto e pegar a "banner" — texto que identifica o serviço e versão.

**Passo 2.3.1 — Banner de serviços TCP**

```bash
# Para cada port aberto, conectar e pegar a banner
for port in 21 22 25 80 443; do
    echo "=== Port $port ===" >> 02-enum/banners.txt
    echo "" | ncat -w 3 evilcorp.com $port 2>&1 >> 02-enum/banners.txt
done
```

**✅ Output esperado (exemplo real):**
```
=== Port 21 ===
220 (vsFTPd 3.0.5)

=== Port 22 ===
SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6

=== Port 25 ===
220 mail.evilcorp.com ESMTP Postfix (Ubuntu)

=== Port 80 ===
HTTP/1.1 200 OK
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3

=== Port 443 ===
HTTP/1.1 200 OK
Server: Apache/2.4.41 (Ubuntu)
Strict-Transport-Security: max-age=31536000
```

**O que procurar:**
- `SSH-2.0-OpenSSH_8.9p1` → Versão do SSH
- `220 mail.evilcorp.com ESMTP Postfix` → Servidor de email
- `220 (vsFTPd 3.0.5)` → Versão do FTP
- `X-Powered-By: PHP/7.4.3` → Linguagem e versão

**Passo 2.3.2 — Headers HTTP**

```bash
curl -I http://evilcorp.com > 02-enum/headers.txt
```

**✅ Output esperado (exemplo real):**
```
HTTP/1.1 200 OK
Date: Thu, 10 Sep 2026 14:30:00 GMT
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
Referrer-Policy: strict-origin-when-cross-origin
Connection: close
Content-Type: text/html; charset=UTF-8
```

**O que procurar:**
- `Server: Apache/2.4.41` → Versão do servidor web
- `X-Powered-By: PHP/7.4.3` → Linguagem e versão
- `X-Frame-Options` → Se tem proteção contra clickjacking ✅
- `Strict-Transport-Security` → Se força HTTPS ✅
- `Content-Security-Policy` → Se tem CSP ✅
- **Ausência de headers de segurança** = má configuração

**Passo 2.3.3 — TLS/SSL info**

```bash
nmap --script ssl-cert -p 443 evilcorp.com > 02-enum/ssl-info.txt
```

**✅ Output esperado (exemplo real):**
```
PORT    STATE SERVICE
443/tcp open  https

ssl-cert: Subject: commonName=evilcorp.com
          Issuer: commonName=R3/organizationName=Let's Encrypt
          Public Key: RSA 2048
          Not Before: 2024-06-01T00:00:00Z
          Not After:  2024-08-30T23:59:59Z
          Subject Alternative Name: DNS:evilcorp.com, DNS:*.evilcorp.com, DNS:admin.evilcorp.com
```

**O que procurar:**
- **Issuer:** `Let's Encrypt` (gratuito, mais confiável)
- **SANs:** `*.evilcorp.com` (wildcard) + `admin.evilcorp.com` (revela subdomínio)
- **Validade:** Se o certificado expirou ou está próximo de expirar

---

### Checklist da Fase 2

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Subdomínios DNS | `02-enum/resolvidos.txt` | [ ] |
| 2 | Subdomínios HTTP vivos | `02-enum/vivos-filtrados.txt` | [ ] |
| 3 | Ports TCP abertos | `02-enum/nmap-ports.txt` | [ ] |
| 4 | Serviços e versões | `02-enum/nmap-services.txt` | [ ] |
| 5 | UDP ports | `02-enum/nmap-udp.txt` | [ ] |
| 6 | Banners | `02-enum/banners.txt` | [ ] |
| 7 | Headers HTTP | `02-enum/headers.txt` | [ ] |
| 8 | SSL/TLS info | `02-enum/ssl-info.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 2:

```
02-enum/
├── subdominios-todos.txt    ← cópia da Fase 1 (para referência)
├── resolvidos.txt           ← subdomínios que resolvem DNS
├── vivos.txt                ← subdomínios que respondem HTTP (com status)
├── vivos-filtrados.txt      ← apenas os vivos com status 200/301/302
├── ips.txt                  ← lista de IPs extraídos dos subdomínios vivos
├── nmap-ports.txt           ← scan de portas TCP (TODAS as 65535)
├── nmap-services.txt        ← versões dos serviços nos ports abertos
├── nmap-udp.txt             ← scan de ports UDP
├── banners.txt              ← banners dos serviços (SSH, FTP, SMTP, HTTP)
├── headers.txt              ← headers HTTP do domínio principal
└── ssl-info.txt             ← informações do certificado SSL
```

### ✅ Sinal de sucesso:
- Você tem pelo menos **3 subdomínios vivos** em `vivos-filtrados.txt`
- Você sabe **quais ports estão abertos** em cada IP
- Você sabe **a versão de cada serviço** (Apache, SSH, MySQL, etc)
- Você tem **as versões anotadas** — vai precisar disso na Fase 3

### ❌ Se falhou:
- Pode ser que o alvo esteja muito protegido. Tente: `nmap -sV -sC evilcorp.com`
- Se 0 subdomínios vivos: o alvo pode ser só um domínio sem subdomínios (normal para empresas pequenas)
- O mínimo para avançar: ter `nmap-ports.txt` com pelo menos 1 port aberta

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 2 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `vivos-filtrados.txt` | Fase 3, 4 | Fingerprinting e discovery em quem está vivo |
| `nmap-services.txt` | Fase 3, 5 | Saber versões para buscar CVEs |
| `ips.txt` | Fase 5 | Scan de vulnerabilidades nos IPs |
| `banners.txt` | Fase 6 | Validar versões de serviço |
| `headers.txt` | Fase 3, 6 | Detectar WAF e validar headers |

**Se completou tudo → Avance para Fase 3**

---
