## 📊 Visão Geral: Toda a Estrutura Final

Ao final das 7 fases, sua estrutura completa deve parecer:

```
~/recon/targets/evilcorp/
├── 01-intel/
│   ├── whois.txt
│   ├── dns-records.txt
│   ├── reverse-dns.txt
│   ├── subdominios-todos.txt
│   ├── subfinder.txt
│   ├── amass.txt
│   ├── crtsh.txt
│   ├── theharvester.txt
│   ├── google-dorks.txt
│   ├── wayback.txt
│   ├── gau.txt
│   ├── todas-urls.txt
│   └── shodan.json
├── 02-enum/
│   ├── resolvidos.txt
│   ├── vivos.txt
│   ├── vivos-filtrados.txt
│   ├── ips.txt
│   ├── nmap-ports.txt
│   ├── nmap-services.txt
│   ├── nmap-udp.txt
│   ├── banners.txt
│   ├── headers.txt
│   └── ssl-info.txt
├── 03-fingerprint/
│   ├── whatweb-principal.txt
│   ├── whatweb-todos.txt
│   ├── httpx-tech.txt
│   ├── waf-principal.txt
│   └── waf-todos.json
├── 04-discovery/
│   ├── gobuster-basico.txt
│   ├── ffuf-extensoes.json
│   ├── ffuf-recursive.json
│   ├── vhosts.json
│   ├── urls-com-parametros.txt
│   ├── parametros.json
│   ├── js-files.txt
│   ├── js-endpoints.txt
│   └── js-secrets.txt
├── 05-vulns/
│   ├── nikto.html
│   ├── nuclei.txt
│   ├── nmap-vuln.txt
│   ├── wpscan.txt
│   ├── s3-test.txt
│   ├── subzy.txt
│   ├── cnames.txt
│   └── searchsploit-results.txt
├── 06-validacao/
│   ├── validacao.md
│   └── resumo-severidade.md
└── 07-relatorio/
    └── relatorio-recon.md
```

**Total de arquivos esperados:** ~35-40 arquivos organizados por fase.

---

## 🔗 O que você precisa ter para avançar para os Próximos Módulos

Cada módulo do curso depende de dados específicos que você coletou aqui. Veja o que precisa estar **confirmado e documentado** antes de avançar:

### Para o Módulo 02 — Web & Aplicações

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **URLs ativas com status HTTP** | Fase 2 | `02-enum/vivos-filtrados.txt` | [ ] |
| **Versões de servidores web** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |
| **CMS detectado (WordPress, etc)** | Fase 3 | `03-fingerprint/whatweb-principal.txt` | [ ] |
| **WAF detectado** | Fase 3 | `03-fingerprint/waf-principal.txt` | [ ] |
| **Diretórios encontrados** | Fase 4 | `04-discovery/gobuster-basico.txt` | [ ] |
| **URLs com parâmetros** | Fase 4 | `04-discovery/urls-com-parametros.txt` | [ ] |
| **Endpoints de API** | Fase 4 | `04-discovery/js-endpoints.txt` | [ ] |

**Para quê:** O Módulo 02 vai usar esses dados para testar SQLi, XSS, SSRF, CSRF nos endpoints que você encontrou.

### Para o Módulo 03 — Exploração

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Versões de serviços com CVE** | Fase 3, 5 | `05-vulns/nmap-vuln.txt` | [ ] |
| **Plugins WordPress vulneráveis** | Fase 5 | `05-vulns/wpscan.txt` | [ ] |
| **Portas abertas e serviços** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |
| **Credenciais encontradas** | Fase 4 | `04-discovery/js-secrets.txt` | [ ] |
| **Vulnerabilidades confirmadas** | Fase 6 | `06-validacao/resumo-severidade.md` | [ ] |

**Para quê:** O Módulo 03 vai usar esses dados para explotar as vulnerabilidades que você encontrou (Metasploit, Hydra, etc).

### Para o Módulo 04 — Pós-exploração

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Subdomínios internos** | Fase 2, 4 | `02-enum/vivos-filtrados.txt` | [ ] |
| **IPs internos** | Fase 2 | `02-enum/ips.txt` | [ ] |
| **Serviços de rede (SSH, SMB, WinRM)** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |

**Para quê:** O Módulo 04 vai usar esses dados para pivotar na rede interna, escalar privilégios, e manter acesso.

### Para o Módulo 06 — Análise de Rede

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **IPs alvo** | Fase 2 | `02-enum/ips.txt` | [ ] |
| **Portas e protocolos** | Fase 2 | `02-enum/nmap-ports.txt` | [ ] |
| **Serviços UDP** | Fase 2 | `02-enum/nmap-udp.txt` | [ ] |

**Para quê:** O Módulo 06 vai usar essos dados para capturar e analisar tráfego de rede (Wireshark, tcpdump).

### Resumo: O que NÃO pode faltar

```
MINÍMO PARA AVANÇAR:
├── 02-enum/vivos-filtrados.txt    ← saber quais URLs testar
├── 02-enum/nmap-services.txt      ← saber versões para buscar CVEs
├── 03-fingerprint/whatweb-principal.txt ← saber se é WordPress
├── 04-discovery/gobuster-basico.txt    ← saber quais diretórios existem
├── 06-validacao/resumo-severidade.md   ← saber quais vulns confirmar
└── 07-relatorio/relatorio-recon.md     ← documentar tudo
```

**Se tem esses 6 arquivos → PODE avançar para qualquer módulo.**

---

## 🔗 Conexão com os Próximos Módulos

Aqui está como o reconhecimento que você fez se conecta com CADA módulo do curso:

```
MÓDULO 01 (você está aqui)
    ↓ Você descobriu: URLs, portas, versões, vulnerabilidades
    ↓
MÓDULO 02 — Web & Aplicações
    ↓ Usa: URLs com parâmetros, diretórios, CMS detectado
    ↓ Testa: SQLi, XSS, SSRF, CSRF, autenticação
    ↓
MÓDULO 03 — Exploração
    ↓ Usa: portas abertas, versões com CVE, credenciais
    ↓ Usa: Metasploit, Hydra, Hashcat para explotar
    ↓
MÓDULO 04 — Pós-exploração
    ↓ Usa: IPs internos, subdomínios, serviços de rede
    ↓ Usa: LinPEAS, BloodHound, Mimikatz
    ↓
MÓDULO 05 — Reversing
    ↓ Usa: binários encontrados nos diretórios
    ↓ Usa: Ghidra, GDB, YARA
    ↓
MÓDULO 06 — Análise de Rede
    ↓ Usa: IPs e portas descobertos
    ↓ Usa: Wireshark, tcpdump, Bettercap
    ↓
MÓDULO 07 — Defesa
    ↓ Usa: vulnerabilidades encontradas para criar regras
    ↓ Usa: Wazuh, Suricata, Sigma
    ↓
MÓDULO 08 — Resposta a Incidentes
    ↓ Usa: logs e evidências coletadas
    ↓ Usa: Volatility, Autopsy, Sleuth Kit
    ↓
MÓDULO 09 — Ambientes
    ↓ Usa: Docker para criar labs de prática
    ↓ Reproduz: os ataques que você planejou
    ↓
MÓDULO 10 — Governança
    ↓ Usa: relatório que você escreveu
    ↓ Compara: com frameworks (NIST, MITRE, OWASP)
    ↓
MÓDULO 11 — IA
    ↓ Usa: ferramentas de IA para automatizar recon
    ↓ Melhora: os scans que você fez manualmente
```

---

## Fim do Reconhecimento

**Quando terminar a Fase 7, você terá:**
- Mapeado toda a superfície de ataque do alvo
- Identificado vulnerabilidades conhecidas
- Documentado tudo em um relatório profissional
- Sido capaz de justificar cada achado com evidências

**Próximo módulo:** [02 - Web & Aplicações](../02-web-aplicacoes/README.md)

---
