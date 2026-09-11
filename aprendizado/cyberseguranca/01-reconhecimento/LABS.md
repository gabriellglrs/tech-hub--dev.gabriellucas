# Labs de Reconhecimento

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Nmap, Subfinder, httpx, Nuclei |
| Linux básico | ⭐ | Comandos de terminal |
| Redes básicas | ⭐ | IP, portas, DNS |

---

## Labs por Plataforma

### TryHackMe (8 labs)

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

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### PortSwigger (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 9 | API Testing Labs | Enumeração de APIs, testes de segurança | ⭐⭐ | https://portswigger.net/web-security/api-testing |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 10 | Starting Point | Reconhecimento inicial de máquinas | ⭐⭐ | https://app.hackthebox.com/starting-point |

### Prática Local (1 lab)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 11 | Pipeline completo | Subfinder → httpx → Nuclei em domínio real | ⭐⭐ | `subfinder -d target.com -silent \| httpx -mc 200 -silent \| nuclei -severity critical,high` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 8 | Nmap, DNS, OSINT, Shodan, recon completo |
| PortSwigger | 1 | API testing |
| HackTheBox | 1 | Starting point recon |
| Local | 1 | Pipeline completo |
| **Total** | **11** | |
