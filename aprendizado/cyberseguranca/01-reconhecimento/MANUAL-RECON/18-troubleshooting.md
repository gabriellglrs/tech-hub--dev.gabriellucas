## Apêndice A — Troubleshooting

### Ferramenta não encontrada

| Ferramenta | Comando para instalar |
|------------|----------------------|
| subfinder | `sudo apt install subfinder` |
| httpx | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| nuclei | `sudo apt install nuclei` |
| katana | `go install github.com/projectdiscovery/katana/cmd/katana@latest` |
| dnsx | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` |
| ffuf | `sudo apt install ffuf` |
| gobuster | `sudo apt install gobuster` |
| amass | `sudo apt install amass` |
| wafw00f | `sudo apt install wafw00f` |
| nikto | `sudo apt install nikto` |
| wpscan | `sudo apt install wpscan` |
| ncat | `sudo apt install ncat` |
| proxychains4 | `sudo apt install proxychains4` |
| seclists | `sudo apt install seclists` |

### Scan muito lento

| Causa | Solução |
|-------|---------|
| Nmap -p- em IP grande | Use `-p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443` |
| Gobuster com wordlist grande | Use `common.txt` (4600) em vez de `directory-list-2.3-medium.txt` (220k) |
| Amass enum completo | Use `-passive` para enumeração passiva |
| UDP scan | Limitze a `--top-ports 20` |

### Scan bloqueado

| Causa | Solução |
|-------|---------|
| WAF bloqueando | Reduza threads, adicione delay, use ProxyChains |
| IP banido | Espere 30 min ou mude de IP (VPN/Tor) |
| Rate limiting | Diminua `--min-rate` no Nmap, `-t` no Gobuster |

### Output vazio

| Ferramenta | Possível causa | Solução |
|------------|---------------|---------|
| subfinder | Domínio muito novo/privado | Use `-all` ou tente Amass |
| amass | Internet bloqueando APIs | Verifique conectividade |
| httpx | Subdomínios não respondem HTTP | Teste com `curl -I` manualmente |
| wafw00f | WAF não na database | Use `wafw00f -a` para testar todos |
| nuclei | Templates desatualizados | Rode `nuclei -update-templates` |

---
