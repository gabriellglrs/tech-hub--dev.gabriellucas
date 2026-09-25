# Manual Completo de Teste Web — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo do teste web.

**Objetivo final:** Encontrar, validar e reportar vulnerabilidades em aplicações web — de forma autorizada e documentada.
**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima. Este manual se alimenta do Módulo 01 (Reconhecimento) e alimenta o Módulo 03 (Exploração).
**Tempo estimado completo:** 6 a 10 horas (dependendo do escopo)

---

## Índice dos Arquivos

| # | Arquivo | Conteúdo |
|---|---------|----------|
| 00 | [00-header.md](00-header.md) | Cabeçalho e índice do manual |
| 01 | [01-conhecimentos-minimos.md](01-conhecimentos-minimos.md) | Conhecimentos mínimos (Linux, Redes, Web, Módulo 01) |
| 02 | [02-antes-de-comecar.md](02-antes-de-comecar.md) | Conceitos, preparação, ferramentas, árvore de pastas |
| 03 | [03-setup-ferramentas.md](03-setup-ferramentas.md) | Setup — VPN, Burp, proxy, CA cert, escopo, CLI |
| 04 | [04-checklist-setup.md](04-checklist-setup.md) | Script de pré-requisitos para testar tudo antes de começar |
| 05 | [05-wordlists.md](05-wordlists.md) | Guia de wordlists — qual usar para cada cenário |
| 06 | [06-opsec.md](06-opsec.md) | OPSEC, ética, escopo e quando parar |
| 07 | [07-fase1-alimentacao.md](07-fase1-alimentacao.md) | **Fase 1** — Alimentação (importar dados do Módulo 01) |
| 08 | [08-fase2-descoberta.md](08-fase2-descoberta.md) | **Fase 2** — Descoberta e superfície de ataque (Burp, ffuf, API) |
| 09 | [09-fase3-injecao.md](09-fase3-injecao.md) | **Fase 3** — Injeção (SQLi, NoSQLi, SSTI, Command Injection) |
| 10 | [10-fase4-cliente-auth.md](10-fase4-cliente-auth.md) | **Fase 4** — Cliente e Auth (XSS, CSRF, JWT, OAuth, bypass) |
| 11 | [11-fase5-especializados.md](11-fase5-especializados.md) | **Fase 5** — Especializados (SSRF, XXE, Upload, Lógica de negócio) |
| 12 | [12-fase6-validacao.md](12-fase6-validacao.md) | **Fase 6** — Validação e Nuclei (confirmar cada finding) |
| 13 | [13-fase7-relatorio.md](13-fase7-relatorio.md) | **Fase 7** — Relatório (documentar tudo) |
| 14 | [14-visao-geral.md](14-visao-geral.md) | Visão geral da estrutura final e conexão com o Módulo 03 |
| 15 | [15-automacao.md](15-automacao.md) | Script de automação — varreduras em lote |
| 16 | [16-alvos-pratica.md](16-alvos-pratica.md) | Alvos para praticar (PortSwigger, Juice Shop, DVWA) |
| 17 | [17-validacao-manual.md](17-validacao-manual.md) | Guia de validação manual — como confirmar cada achado |
| 18 | [18-troubleshooting.md](18-troubleshooting.md) | Apêndice A — Troubleshooting |
| 19 | [19-referencia-rapida.md](19-referencia-rapida.md) | Apêndice B — Referência rápida de payloads |
| 20 | [20-nao-funcionou.md](20-nao-funcionou.md) | Apêndice C — O que fazer se nada funcionar |

---

## Fluxo das 7 Fases

```
MÓDULO 01 (Reconhecimento)  ← VOCÊ JÁ FEZ ISSO
    ↓ escopo, endpoints, params, dirs, fingerprint, WAF, segredos
    ↓
FASE 1: Alimentação
    ↓ 08-alimentacao/ importa tudo do recon
    ↓
FASE 2: Descoberta e Superfície de Ataque
    ↓ Burp spider → ffuf → métodos HTTP → API docs → parametros.txt
    ↓
FASE 3: Injeção ────────── FASE 4: Cliente e Auth ────────── FASE 5: Especializados
    ↓ SQLi/NoSQLi/SSTI/CMDi   ↓ XSS/CSRF/JWT/OAuth/bypass     ↓ SSRF/XXE/Upload/Race/IDOR
    └──────────────────────────┴────────────────────────────────┘
                                     ↓
FASE 6: Validação e Nuclei
    ↓ Nuclei → re-testar TUDO → evidências → CVSS → falsos positivos fora
    ↓
FASE 7: Relatório
    ↓ Resumo executivo → tabela → detalhamento → recomendações → anexos
    ↓
MÓDULO 03 (Exploração)  ← logins-formularios.txt, hashes, vetores validados
```

---

## Pré-requisito inegociável

> **Antes de rodar QUALQUER comando deste manual, você precisa ter completado:**
> 1. **Módulo 01 — Reconhecimento:** `~/recon/targets/<alvo>/` com pelo menos `02-enum/vivos-filtrados.txt`, `04-discovery/` e `03-fingerprint/`
> 2. **Autorização de teste** por escrito com escopo definido (ver [06-opsec.md](06-opsec.md))
>
> Sem esses dados, a Fase 1 deste manual não tem o que importar. Volte e complete o Módulo 01.

---

## Convenções

- **🎯 Alvo:** URL base (ex: `https://evilcorp.com`)
- **📡 Proxy:** Burp Suite Proxy intercept (porta 8080)
- **🔒 Escopo:** Burp Target → Scope + `08-alimentacao/escopo-web.txt`
- **📁 Estrutura:** tudo em `~/recon/targets/<alvo>/` — web usa pastas `08` a `14`
- **📝 Output:** cada fase salva na sua pasta (`09-descoberta/`, `10-injecao/`, ...)

---

**Próximo passo:** [00 — Header](00-header.md)
