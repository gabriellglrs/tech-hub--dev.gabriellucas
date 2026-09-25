# Manual Completo de Exploração — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo da exploração.

**Objetivo final:** Transformar vulnerabilidades em ACESSO REAL (credenciais, shell, dados) — de forma autorizada e documentada.
**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima. Este manual se alimenta dos Módulos 01 e 02.
**Tempo estimado completo:** 4 a 8 horas (dependendo do escopo)

---

## Índice dos Arquivos

| # | Arquivo | Conteúdo |
|---|---------|----------|
| 00 | [00-header.md](00-header.md) | Cabeçalho e índice do manual |
| 01 | [01-conhecimentos-minimos.md](01-conhecimentos-minimos.md) | Conhecimentos mínimos (Linux, Redes, Web, Módulos 01-02) |
| 02 | [02-antes-de-comecar.md](02-antes-de-comecar.md) | Conceitos, preparação do ambiente, ferramentas necessárias |
| 03 | [03-setup-ferramentas.md](03-setup-ferramentas.md) | Setup — VPN, Hydra, John, Hashcat, Metasploit, SecLists |
| 04 | [04-checklist-setup.md](04-checklist-setup.md) | Script de pré-requisitos para testar tudo antes de começar |
| 05 | [05-wordlists.md](05-wordlists.md) | Guia de wordlists — qual usar para cada cenário |
| 06 | [06-opsec.md](06-opsec.md) | OPSEC — não deixar rastros e não travar contas |
| 07 | [07-fase1-alimentacao.md](07-fase1-alimentacao.md) | **Fase 1** — Alimentação (importar dados dos Módulos 01 e 02) |
| 08 | [08-fase2-vetores.md](08-fase2-vetores.md) | **Fase 2** — Priorização de Vetores (CVEs, serviços, logins) |
| 09 | [09-fase3-bruteforce.md](09-fase3-bruteforce.md) | **Fase 3** — Brute Force (Hydra em SSH, FTP, HTTP, SMB) |
| 10 | [10-fase4-cracking.md](10-fase4-cracking.md) | **Fase 4** — Cracking de Hashes (hashid, John, Hashcat) |
| 11 | [11-fase5-exploracao.md](11-fase5-exploracao.md) | **Fase 5** — Exploração (Searchsploit, Metasploit, payloads) |
| 12 | [12-fase6-validacao.md](12-fase6-validacao.md) | **Fase 6** — Validação e Impacto (confirmar acesso) |
| 13 | [13-fase7-relatorio.md](13-fase7-relatorio.md) | **Fase 7** — Relatório (documentar tudo) |
| 14 | [14-visao-geral.md](14-visao-geral.md) | Visão geral da estrutura final e conexão com o Módulo 04 |
| 15 | [15-automacao.md](15-automacao.md) | Script de automação — rodar tudo de uma vez |
| 16 | [16-alvos-pratica.md](16-alvos-pratica.md) | Alvos para praticar (TryHackMe, HackTheBox, OverTheWire) |
| 17 | [17-validacao-manual.md](17-validacao-manual.md) | Guia de validação manual — como confirmar cada achado |
| 18 | [18-troubleshooting.md](18-troubleshooting.md) | Apêndice A — Troubleshooting |
| 19 | [19-referencia-rapida.md](19-referencia-rapida.md) | Apêndice B — Referência rápida de ferramentas |
| 20 | [20-nao-funcionou.md](20-nao-funcionou.md) | Apêndice C — O que fazer se nada funcionar |

---

## Fluxo das 7 Fases

```
MÓDULO 01 (Recon) + MÓDULO 02 (Web)  ← VOCÊ JÁ FEZ ISSO
    ↓
FASE 1: Alimentação (importa os dados dos módulos anteriores)
    ↓ nmap-services, nmap-vuln, resumo-severidade, logins, endpoints, emails
    ↓
FASE 2: Priorização de Vetores
    ↓ searchsploit → matriz de decisão → CVE / serviço / login / hash
    ↓
FASE 3: Brute Force
    ↓ Hydra: SSH → FTP → HTTP POST form → SMB/RDP
    ↓
FASE 4: Cracking de Hashes
    ↓ hashid → John (CPU) → Hashcat (GPU) → regras → máscaras
    ↓
FASE 5: Exploração
    ↓ Searchsploit → Metasploit → payload → sessão
    ↓
FASE 6: Validação e Impacto
    ↓ Confirmar acesso → evidências → parar no escopo
    ↓
FASE 7: Relatório
    ↓ Resumo → Escopo → Metodologia → Acessos → Recomendações
```

---

## Pré-requisito inegociável

> **Antes de rodar QUALQUER comando deste manual, você precisa ter completado:**
> 1. **Módulo 01 — Reconhecimento:** `~/recon/targets/<alvo>/` com pelo menos `02-enum/nmap-services.txt`, `05-vulns/nmap-vuln.txt` e `06-validacao/resumo-severidade.md`
> 2. **Módulo 02 — Web & Aplicações:** lista de URLs de login, formulários e endpoints testados
>
> Sem esses dados, a Fase 1 deste manual não tem o que importar. Volte e complete os módulos anteriores.

---

**Próximo passo:** [00 - Header](00-header.md)
