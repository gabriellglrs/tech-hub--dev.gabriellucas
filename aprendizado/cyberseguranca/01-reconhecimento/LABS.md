# Labs de Reconhecimento

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Nmap, Subfinder, httpx, Nuclei, Recon-ng, sherlock, exiftool, whatweb, gobuster, ffuf, amass, wafw00f, nikto, wpscan, proxychains4, ncat |
| Linux básico | ⭐ | Comandos de terminal |
| Redes básicas | ⭐ | IP, portas, DNS |
| Go (golang) | ⭐ | Para instalar waybackurls, katana, subzy |

---

## Labs por Plataforma

### TryHackMe (10 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Whois & DNS | Whois, dig, nslookup, DNS enum | ⭐ | https://tryhackme.com/room/dnsindns |
| 2 | OSINT | Coleta de informações, Google dorking | ⭐⭐ | https://tryhackme.com/room/ohsint |
| 3 | Nmap (Room 1) | Scan de portas, detecção de serviços | ⭐ | https://tryhackme.com/room/nmap01 |
| 4 | Nmap (Room 2) | Scan agressivo, scripts NSE | ⭐⭐ | https://tryhackme.com/room/nmap |
| 5 | Recon Final | Reconhecimento completo de alvo | ⭐⭐⭐ | https://tryhackme.com/room/gh0st |
| 6 | Passive Recon | OSINT passivo, Shodan, theHarvester | ⭐ | https://tryhackme.com/room/passiverecon |
| 7 | Active Recon | Nmap, DNS enum, web crawling | ⭐⭐ | https://tryhackme.com/room/activerecon |
| 8 | Shodan | Busca de dispositivos, vulnerabilidades | ⭐⭐ | https://tryhackme.com/room/shodan |
| 9 | Google Dorking | Operadores avançados, enumeração | ⭐ | https://tryhackme.com/room/googledorking |
| 10 | OSINT Framework | Maltego, Recon-ng, automação | ⭐⭐ | https://tryhackme.com/room/osintframework |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### PortSwigger (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | API Testing Labs | Enumeração de APIs, testes de segurança | ⭐⭐ | https://portswigger.net/web-security/api-testing |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 12 | Starting Point | Reconhecimento inicial de máquinas | ⭐⭐ | https://app.hackthebox.com/starting-point |

### Prática Local (10 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 13 | Pipeline completo | Subfinder → httpx → Nuclei em domínio real | ⭐⭐ | `subfinder -d target.com -silent \| httpx -mc 200 -silent \| nuclei -severity critical,high` |
| 14 | Google Dorks | Encontrar arquivos expostos com dorks | ⭐ | `site:target.com filetype:pdf` + `site:target.com inurl:admin` |
| 15 | Recon-ng | Pipeline automatizado com Recon-ng | ⭐⭐ | `recon-ng` → workspaces create → modules load → run |
| 16 | Certificate Transparency | Descobrir subdomínios via crt.sh | ⭐⭐ | `curl -s "https://crt.sh/?q=evilcorp.com&output=json" \| jq -r '.[].name_value' \| sort -u` |
| 17 | Subdomain Takeover | Verificar subdomínios com CNAME órfão | ⭐⭐⭐ | `subzy run --targets subdomains.txt` |
| 18 | Cloud Storage | Enumerar buckets S3 públicos | ⭐⭐⭐ | `aws s3 ls s3://target-bucket --no-sign-request 2>/dev/null` |
| 19 | Wayback URLs | Extrair endpoints históricos | ⭐⭐ | `echo "evilcorp.com" \| waybackurls \| grep "="` |
| 20 | Sherlock OSINT | Buscar usuário em 400+ redes sociais | ⭐⭐ | `sherlock "target_username" --print-found --csv` |
| 21 | JavaScript Analysis | Extrair endpoints de arquivos JS | ⭐⭐⭐ | `katana -u https://target.com -jc -d 3 \| grep "\.js$" \| xargs -I {} python3 linkfinder.py -i {} -o cli` |
| 22 | CORS Testing | Testar CORS misconfiguration | ⭐⭐⭐ | `curl -s -I -H "Origin: https://evil.com" https://target.com/ \| grep -i "access-control"` |
| 23 | WhatWeb Fingerprinting | Identificar tecnologias de um site | ⭐ | `whatweb -a 3 -v http://testphp.vulnweb.com` |
| 24 | Gobuster Discovery | Encontrar diretórios ocultos | ⭐⭐ | `gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -t 50 -x php,html,txt` |
| 25 | ffuf Vhost Discovery | Descobrir virtual hosts internos | ⭐⭐⭐ | `ffuf -u http://target.com -H "Host: FUZZ.target.com" -w /usr/share/wordlists/dirb/common.txt -fs 4242` |
| 26 | Amass Deep Enum | Enumeração DNS profunda com brute force | ⭐⭐⭐ | `amass enum -v -src -ip -brute -d target.com` |
| 27 | Wafw00f Detection | Detectar WAF protegendo o alvo | ⭐ | `wafw00f -v http://target.com` |
| 28 | Nikto Web Scan | Scan de vulnerabilidades web | ⭐⭐ | `nikto -h http://target.com` |
| 29 | WPScan WordPress | Enumerar plugins e vulnerabilidades WP | ⭐⭐ | `wpscan --url http://target.com -e vp --plugins-detection mixed` |
| 30 | Netcat Banner Grab | Pegar banner de serviços | ⭐ | `ncat -v target.com 22` + `ncat -v target.com 25` |
| 31 | ProxyChains Anonimato | Scan anônimo via Tor | ⭐⭐⭐ | `proxychains4 curl -s https://api.ipify.org` + `proxychains4 nmap -sT -Pn target.com` |
| 32 | Relatório Completo | Documentar todo o recon em Markdown | ⭐⭐ | Criar `relatorio.md` seguindo o template do arquivo 19 |

---

## Exercícios Investigativos

> Estes exercícios não são "copie e cole comandos". São cenários que exigem raciocínio, análise e tomada de decisão.

### Exercício Investigativo 1: O IP Sem DNS

**Cenário:** Você está fazendo reconhecimento da "Target Corp" (ASN AS12345). Ao escanear o range 203.0.113.0/24, encontrou o IP 203.0.113.50 com as seguintes portas abertas:

```
22/tcp   open  ssh         OpenSSH 8.9p1
80/tcp   open  http        nginx 1.18.0
443/tcp  open  https       nginx 1.18.0
3306/tcp open  mysql       MySQL 8.0.28
```

Mas esse IP **não tem registro DNS** (não aparece em `dig +short 50.113.0.203.in-addr.arpa`).

**Pergunta:** O que você pode concluir? Quais seriam seus próximos passos?

**Raciocínio esperado:**
1. **Ativo "invisível":** IP sem DNS = servidor que não está no DNS público
2. **MySQL exposto:** Porta 3306 aberta externamente = risco crítico
3. **Próximo passo:** Verificar se o MySQL aceita conexão externa
4. **Se sim:** Documentar como critical finding
5. **Se não:** Investigar por que a porta está aberta (firewall? proxy?)

### Exercício Investigativo 2: O CNAME Órfão

**Cenário:** Você encontrou o subdomínio `legacy.targetcorp.com`. Ao consultar DNS:

```
$ dig legacy.targetcorp.com CNAME +short
app.herokuapp.com.

$ dig app.herokuapp.com A +short
54.237.128.99
```

Mas ao acessar `https://legacy.targetcorp.com`, retorna erro 404.

**Pergunta:** O que isso significa? Qual o risco?

**Raciocínio esperado:**
1. **CNAME para Heroku:** O subdomínio aponta para um serviço externo
2. **404:** O aplicativo não existe mais no Heroku
3. **Risco:** Subdomain takeover - alguém pode criar um app no Heroku e assumir o subdomínio
4. **Próximo passo:** Verificar se o Heroku aceita claim do domínio
5. **Se sim:** Critical finding (subdomain takeover)

### Exercício Investigativo 3: O WAF Misterioso

**Cenário:** Você está escaneando `api.targetcorp.com`. O Wafw00f retorna:

```
[+] The site api.targetcorp.com is behind Cloudflare (Cloudflare Inc.)
```

Mas ao fazer `curl -s -I https://api.targetcorp.com`, você vê:

```
Server: nginx/1.18.0
X-Powered-By: Express
```

**Pergunta:** Por que o Wafw00f detectou Cloudflare mas o header mostra nginx? O que isso significa?

**Raciocínio esperado:**
1. **Cloudflare é reverse proxy:** Tráfego passa pelo Cloudflare antes de chegar ao servidor
2. **nginx é o servidor real:** Por trás do Cloudflare, roda nginx
3. **Express:** Aplicação Node.js
4. **Implicação:** O IP real do servidor está escondido pelo Cloudflare
5. **Próximo passo:** Encontrar o IP real (DNS history, email headers, etc.)

### Exercício Investigativo 4: A API Interna

**Cenário:** Ao escanear subdomínios, você encontrou `internal-api.targetcorp.com`. Retorna 404 para `/`, mas `/api/health` retorna 200 com:

```json
{"status": "ok", "version": "2.1.0", "database": "connected"}
```

**Pergunta:** O que você faria? Por quê?

**Raciocínio esperado:**
1. **API interna exposta:** Não deveria ser acessível externamente
2. **Versão exposta:** 2.1.0 pode ter CVEs conhecidos
3. **Status do banco:** Informação sensível (pode indicar tipo de DB)
4. **Próximo passo:** Enumerar mais endpoints, verificar autenticação
5. **Se sem auth:** Critical finding

### Exercício Investigativo 5: Correlação Completa

**Cenário:** Você completou o reconhecimento de `targetcorp.com` e encontrou:

**Fase 1 (Passiva):**
- ASN: AS12345 (Target Corp)
- Ranges: 203.0.113.0/24, 198.51.100.0/22
- Subdomínios: api, mail, vpn, dev, staging
- GitHub: repositório `targetcorp/api-gateway` com `config/production.yml`

**Fase 2 (Ativa):**
- api.targetcorp.com: 203.0.113.10 (443/tcp open)
- mail.targetcorp.com: 203.0.113.20 (25, 110, 143, 993, 995 open)
- vpn.targetcorp.com: 203.0.113.50 (1194/tcp open)
- dev.targetcorp.com: 203.0.113.30 (80/tcp open)
- staging.targetcorp.com: 203.0.113.40 (80/tcp open)

**Fase 3 (GitHub):**
- `config/production.yml` contém: `mongodb://admin:senha123@db.targetcorp.com:27017/prod`

**Pergunta:** Monte a superfície de ataque completa. Qual a ordem de prioridade?

**Raciocínio esperado:**
```
SUPERFÍCIE DE ATAQUE:

1. db.targetcorp.com (27017) → MongoDB exposto com credencial do GitHub
   PRIORIDADE: CRÍTICA

2. dev/staging (203.0.113.30/40) → Podem ter versões não-patcheadas
   PRIORIDADE: ALTA

3. api.targetcorp.com (443) → API pública, pode ter vulnerabilidades
   PRIORIDADE: ALTA

4. vpn.targetcorp.com (1194) → OpenVPN, pode ter configuração fraca
   PRIORIDADE: MÉDIA

5. mail.targetcorp.com (25, 993) → Email, pode ter configuração SMTP
   PRIORIDADE: MÉDIA
```

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 10 | Nmap, DNS, OSINT, Shodan, Google Dorking, recon completo |
| PortSwigger | 1 | API testing |
| HackTheBox | 1 | Starting point recon |
| Local | 20 | Pipeline completo, Google Dorks, Recon-ng, CT, Takeover, Cloud, Wayback, Sherlock, JS, CORS, WhatWeb, Gobuster, ffuf, Amass, Wafw00f, Nikto, WPScan, Netcat, ProxyChains, Relatório |
| Investigativos | 5 | Raciocínio, análise, correlação, tomada de decisão |
| **Total** | **37** | |
