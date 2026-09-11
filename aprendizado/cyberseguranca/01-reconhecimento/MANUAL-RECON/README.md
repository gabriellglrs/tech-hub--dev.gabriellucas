# Manual Completo de Reconhecimento — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo do reconhecimento.

**Objetivo final:** Mapear TODA a superfície de ataque de um alvo.
**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima.
**Tempo estimado completo:** 4 a 8 horas (dependendo do escopo)

---

## Índice dos Arquivos

| # | Arquivo | Conteúdo |
|---|---------|----------|
| 00 | [00-header.md](00-header.md) | Cabeçalho e índice do manual |
| 01 | [01-conhecimentos-minimos.md](01-conhecimentos-minimos.md) | Conhecimentos mínimos (Linux, Redes, Web, Segurança) |
| 02 | [02-antes-de-comecar.md](02-antes-de-comecar.md) | Conceitos, preparação do ambiente, ferramentas necessárias |
| 03 | [03-setup-rede.md](03-setup-rede.md) | Setup de rede — VPN, Tor e ProxyChains |
| 04 | [04-checklist-setup.md](04-checklist-setup.md) | Script de pré-requisitos para testar tudo antes de começar |
| 05 | [05-wordlists.md](05-wordlists.md) | Guia de wordlists — qual usar para cada cenário |
| 06 | [06-opsec.md](06-opsec.md) | OPSEC — não deixar rastros |
| 07 | [07-fase1-intel.md](07-fase1-intel.md) | **Fase 1** — Inteligência Passiva (WHOIS, DNS, subdomínios, OSINT) |
| 08 | [08-fase2-enum.md](08-fase2-enum.md) | **Fase 2** — Enumeração Ativa (validar subs, portas, serviços) |
| 09 | [09-fase3-fingerprint.md](09-fase3-fingerprint.md) | **Fase 3** — Fingerprinting (tecnologias, WAF, versões) |
| 10 | [10-fase4-discovery.md](10-fase4-discovery.md) | **Fase 4** — Discovery de Conteúdo (diretórios, endpoints, JS) |
| 11 | [11-fase5-vulns.md](11-fase5-vulns.md) | **Fase 5** — Scan de Vulnerabilidades (Nikto, Nuclei, WPScan) |
| 12 | [12-fase6-validacao.md](12-fase6-validacao.md) | **Fase 6** — Análise e Validação (confirmar achados) |
| 13 | [13-fase7-relatorio.md](13-fase7-relatorio.md) | **Fase 7** — Relatório (documentar tudo) |
| 14 | [14-visao-geral.md](14-visao-geral.md) | Visão geral da estrutura final e conexão com outros módulos |
| 15 | [15-automacao.md](15-automacao.md) | Script de automação — rodar tudo de uma vez |
| 16 | [16-alvos-pratica.md](16-alvos-pratica.md) | Alvos para praticar (TryHackMe, HackTheBox, PortSwigger, etc) |
| 17 | [17-validacao-manual.md](17-validacao-manual.md) | Guia de validação manual — como confirmar cada achado |
| 18 | [18-troubleshooting.md](18-troubleshooting.md) | Apêndice A — Troubleshooting |
| 19 | [19-referencia-rapida.md](19-referencia-rapida.md) | Apêndice B — Referência rápida de ferramentas |
| 20 | [20-nao-funcionou.md](20-nao-funcionou.md) | Apêndice C — O que fazer se nada funcionar |

---

## Fluxo das 7 Fases

```
FASE 1: Inteligência Passiva (não toca no alvo)
    ↓ WHOIS, DNS, Subfinder, Amass, crt.sh, theHarvester, Wayback
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
```

---

**Próximo módulo:** [02 - Web & Aplicações](../02-web-aplicacoes/README.md)
