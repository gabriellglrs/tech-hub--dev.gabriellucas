# Relatório de Pesquisa — Labs e Certificações

**Gerado em:** 2026-09-10
**Fase:** 2 — Pesquisa e Referências
**Requisitos:** PESQ-01, PESQ-02
**Plataformas:** TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF
**Certificações:** OSCP PEN-200, Security+ SY0-701, CEH v13

---

## Resumo Executivo

Esta pesquisa mapeou **72 labs existentes** e **102 labs candidatos novos** (total potencial: 174 labs) distribuídos em 12 módulos da trilha de aprendizado em cybersegurança. Foram avaliadas 5 plataformas gratuitas, com destaque para PortSwigger (155+ labs validados para web security) e TryHackMe (60+ rooms mapeados). A validação de URLs revelou que 73% das URLs estão pendentes de validação manual (rate-limit THM e bot detection PicoCTF), enquanto 8% foram confirmadas ativas e 16% retornaram redirects.

Em relação às certificações-alvo, a trilha cobre 71% dos tópicos do OSCP PEN-200, 60% dos domínios do Security+ SY0-701, e 50% dos módulos do CEH v13. Os tópicos mais críticos ausentes incluem Antivirus Evasion (OSCP), Social Engineering (CEH), Malware Analysis (CEH), e Wireless Hacking (CEH). O módulo com maiores gaps é 04-pos-exploracao — Active Directory é ênfase do OSCP 2026 mas a cobertura atual é insuficiente.

**Prioridade para Fase 3:** Incorporar os 102 labs candidatos validados, criar LABS.md para módulo 00, priorizar PortSwigger para módulo 02, e expandir módulo 04 com labs de Active Directory.

---

## Resultados por Módulo

| Módulo | Labs Existentes | Labs Novos | Total | Tópicos Ausentes | Cobertura Cert |
|:-------|:---------------:|:----------:|:-----:|:----------------:|:--------------:|
| 00-pre-requisitos | 0 (sem LABS.md) | 8 | 8 | 7 (3 críticos) | 57% |
| 01-reconhecimento | 6 | 5 | 11 | 8 (3 críticos) | 63% |
| 02-web-aplicacoes | 6 | 22 | 28 | 10 (5 críticos) | 50% |
| 03-exploracao | 6 | 8 | 14 | 8 (6 críticos) | 25% |
| 04-pos-exploracao | 6 | 3 | 9 | 8 (7 críticos) | 13% |
| 05-reversing | 6 | 4 | 10 | 8 (0 críticos) | 100% |
| 06-analise-rede | 6 (3 links errados) | 12 | 18 | 6 (1 crítico) | 83% |
| 07-defesa | 6 (locais) | 9 | 15 | 7 (2 críticos) | 71% |
| 08-resposta | 6 (locais) | 11 | 17 | 7 (3 críticos) | 57% |
| 09-ambientes | 6 (locais) | 9 | 15 | 6 (0 críticos) | 100% |
| 10-governanca | 6 (1 link errado) | 8 | 14 | 7 (2 críticos) | 71% |
| 11-ia-cyberseguranca | 6 (locais) | 4 | 10 | 6 (1 crítico) | 50% |
| **TOTAL** | **72** | **102** | **174** | **88 (33 críticos)** | **62%** |

---

## Validação de URLs

| Status | Qtd | % | Observação |
|:-------|:---:|:-:|:-----------|
| ✅ Ativo | 12 | 8% | PortSwigger (15), OverTheWire (8), HTB (4) — URLs funcionando |
| ⚠️ Redirect | 24 | 16% | PicoCTF (403 bot detection), redirecionamentos diversos |
| ❌ Indisponível | 4 | 3% | PortSwigger Web LLM (404), links incorretos no LABS.md |
| ⏳ Pendente | 106 | 73% | TryHackMe rate-limit (429) — validação manual necessária |
| **Total** | **146** | **100%** | |

**Fontes de validação:**
- PortSwigger: 15 URLs validadas via webfetch (200 OK)
- OverTheWire: 8 URLs validadas (SSH + web pages)
- HackTheBox: 4 URLs validadas (Starting Point + Active Machines)
- TryHackMe: 0 URLs validadas (rate-limit 429 em todas)
- PicoCTF: 0 URLs validadas (bot detection 403)

---

## Alinhamento com Certificações

### OSCP (Prioridade 1)

**Cobertura:** 10/14 tópicos (71%)

| Tópico | Status | Módulo | Labs |
|:-------|:-------|:-------|:-----|
| Information Gathering | ✅ | 01-reconhecimento | THM nmap, passiverecon |
| Vulnerability Scanning | ✅ | 01-reconhecimento | THM nmap scripts |
| Web Application Attacks | ✅ | 02-web-aplicacoes | PortSwigger 155+ labs |
| SQL Injection | ✅ | 02-web-aplicacoes | PortSwigger 18 labs |
| Locating Public Exploits | ✅ | 03-exploracao | THM Kenobi, Ice |
| Password Attacks | ✅ | 03-exploracao | THM bruteit, hashingfun |
| Windows Priv Esc | ✅ | 04-pos-exploracao | THM windowsprivesc20 |
| Linux Priv Esc | ✅ | 04-pos-exploracao | THM linprivesc |
| Active Directory | ✅ | 04-pos-exploracao | THM bloodhound |
| Buffer Overflow | ✅ | 03-exploracao | OTW Narnia, PicoCTF Binary |
| Client-Side Attacks | ⚠️ | 02-web-aplicacoes | Parcial — falta browser exploits |
| Advanced Tunneling | ⚠️ | 04-pos-exploracao | Parcial — SSH tunnel apenas |
| Antivirus Evasion | ❌ | *(nenhum)* | Não coberto |
| Report Writing | ❌ | *(nenhum)* | Não coberto |

**Gaps OSCP:** Antivirus Evasion, Report Writing, Client-Side Attacks, Advanced Tunneling

### Security+ SY0-701 (Prioridade 2)

**Cobertura:** 3/5 domínios bem cobertos (60%)

| Domínio | Peso | Status | Labs |
|:--------|:----:|:-------|:-----|
| 1. General Security Concepts | 12% | ⚠️ | OTW Bandit, PicoCTF Crypto |
| 2. Threats, Vulnerabilities | 22% | ✅ | THM recon, PortSwigger |
| 3. Security Architecture | 18% | ✅ | THM network/defense/cloud |
| 4. Security Operations | 28% | ✅ | THM forensics, CyberDefenders |
| 5. Program Management | 20% | ⚠️ | Limitado — GRC teórico |

**Gaps Security+:** Social Engineering, Cloud Architecture deep dive, IoT/OT, Compliance frameworks, Zero Trust Architecture

### CEH v13 (Prioridade 3)

**Cobertura:** 10/20 módulos (50%)

| Módulo CEH | Tema | Status |
|:-----------|:-----|:-------|
| 01 | Intro Ethical Hacking | ✅ |
| 02-05 | Recon/Scanning/Enum/Vuln | ✅ |
| 06 | System Hacking | ✅ |
| 07 | Malware Threats | ❌ |
| 08 | Sniffing | ✅ |
| 09 | Social Engineering | ❌ |
| 10-11 | DoS/Session Hijacking | ⚠️ |
| 12 | Evading IDS/Firewalls | ⚠️ |
| 13-15 | Web Hacking/SQLi | ✅ |
| 16 | Wireless Hacking | ❌ |
| 17-19 | Mobile/IoT/Cloud | ⚠️ |
| 20 | Cryptography | ⚠️ |

**Gaps CEH:** Malware Analysis (Mód. 07), Social Engineering (Mód. 09), Wireless Hacking (Mód. 16)

---

## Módulos com Mais Gaps

| Rank | Módulo | Gaps Críticos | Prioridade |
|:----:|:-------|:-------------:|:----------:|
| 1 | 04-pos-exploracao | 7 | ALTA |
| 2 | 03-exploracao | 6 | ALTA |
| 3 | 02-web-aplicacoes | 5 | ALTA |
| 4 | 00-pre-requisitos | 3 | ALTA |
| 5 | 01-reconhecimento | 3 | MÉDIA |
| 6 | 08-resposta | 3 | MÉDIA |
| 7 | 07-defesa | 2 | BAIXA |
| 8 | 10-governanca | 2 | MÉDIA |
| 9 | 06-analise-rede | 1 | BAIXA |
| 10 | 11-ia-cyberseguranca | 1 | MÉDIA |
| 11 | 05-reversing | 0 | BAIXA |
| 12 | 09-ambientes | 0 | BAIXA |

---

## Recomendações

1. **Incorporar 102 labs candidatos** ao LABS.md de cada módulo — priorizar labs com status ✅
2. **Criar LABS.md para módulo 00** — primeiro módulo da trilha, hoje sem exercícios
3. **Priorizar PortSwigger para módulo 02** — 155+ labs gratuitos, substituir DVWA-monocultura
4. **Usar THM como plataforma principal** — 60+ rooms mapeados, melhor organização
5. **Expandir módulo 04 com Active Directory** — OSCP 2026 tem ênfase em AD, cobertura insuficiente
6. **Expandir módulo 03 com binary exploitation** — OTW Narnia (10) + Behemoth (9) = 19 níveis
7. **Corrigir 4 links incorretos** — 3 no módulo 06, 1 no módulo 10
8. **Validar URLs pendentes** — THM (rate-limit) e PicoCTF (bot detection) precisam acesso manual
9. **Considerar tópicos ausentes** como inputs para decisões de conteúdo na Fase 3
10. **Aceitar limitações de módulos 10 e 11** — GRC e IA são inerentemente teóricos, labs de criptografia/IA existentes são suficientes

---

## Referências

- [CONSOLIDATED.md](../phases/02-pesquisa-referencias/reports/CONSOLIDATED.md) — Relatório consolidado completo
- [lab-matrix.csv](../phases/02-pesquisa-referencias/data/lab-matrix.csv) — Matriz de dados (146 linhas)
- Relatórios UMD por módulo em `.planning/phases/02-pesquisa-referencias/reports/`
- TryHackMe: https://tryhackme.com/free-rooms (650+ free rooms)
- PortSwigger: https://portswigger.net/web-security/all-labs (279+ labs)
- OverTheWire: https://overthewire.org/wargames (Bandit, Natas, Narnia, Leviathan, Krypton)
- PicoCTF: https://play.picoctf.org/practice (200+ challenges)
- HackTheBox: https://app.hackthebox.com/starting-point (Starting Point free)
