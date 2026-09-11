## Apêndice B — Referência Rápida

### Qual ferramenta usar?

| Cenário | Primária | Alternativa |
|---------|----------|-------------|
| Subdomínios passivos | Subfinder | Amass -passive |
| Subdomínios profundos | Amass -brute | Gobuster dns |
| Validar subdomínios | httpx | curl -I |
| Scan de portas | Nmap -sT | Masscan |
| Tecnologias | WhatWeb | httpx -tech-detect |
| WAF | Wafw00f | Headers manuais |
| Diretórios | Gobuster dir | ffuf |
| Fuzzing complexo | ffuf | Gobuster |
| Vulns web | Nikto + Nuclei | Nmap NSE |
| WordPress | WPScan | WhatWeb |
| Cloud | aws CLI | cloud_enum |
| Takeover | Subzy | Nuclei takeover |
| Banner | Ncat | curl -I |
| Anonimato | ProxyChains | VPN |

### Fluxo visual

```
PREPARAÇÃO
    ↓
FASE 1: Inteligência Passiva (não toca no alvo)
    ↓ WHOIS, DNS, Subfinder, Amass, crt.sh, theHarvest, Google Dorks, Wayback
    ↓
FASE 2: Enumeração Ativa (tocando no alvo)
    ↓ Validar subs (httpx) → Nmap ports → Service detection → Banner grab
    ↓
FASE 3: Fingerprinting
    ↓ WhatWeb, Wafw00f, httpx -tech-detect, searchsploit CVEs
    ↓
FASE 4: Discovery de Conteúdo
    ↓ Gobuster → ffuf → vhosts → params → JS analysis
    ↓
FASE 5: Scan de Vulnerabilidades
    ↓ Nikto, Nuclei, Nmap NSE, WPScan, Cloud, Takeover
    ↓
FASE 6: Validação
    ↓ Confirmar achados → Eliminar falsos positivos → Organizar
    ↓
FASE 7: Relatório
    ↓ Resumo → Escopo → Metodologia → Descobertas → Recomendações
    ↓
FIM ✓
```
