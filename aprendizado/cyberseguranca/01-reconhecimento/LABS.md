# Labs de Reconhecimento

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Nmap, Subfinder, httpx, Nuclei, Recon-ng, sherlock, exiftool |
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

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 10 | Nmap, DNS, OSINT, Shodan, Google Dorking, recon completo |
| PortSwigger | 1 | API testing |
| HackTheBox | 1 | Starting point recon |
| Local | 10 | Pipeline completo, Google Dorks, Recon-ng, CT, Takeover, Cloud, Wayback, Sherlock, JS, CORS |
| **Total** | **22** | |
