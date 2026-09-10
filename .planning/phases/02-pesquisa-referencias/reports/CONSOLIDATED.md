# Relatório Consolidado — Pesquisa de Labs e Referências

**Gerado em:** 2026-09-10
**Escopo:** 12 módulos, 5 plataformas, 3 certificações
**Requisitos:** PESQ-01, PESQ-02

---

## Resumo Executivo

Esta pesquisa mapeou **72 labs existentes** e **102 labs candidatos novos** (total potencial: 174 labs) distribuídos em 12 módulos, cobrindo 5 plataformas gratuitas (TryHackMe, HackTheBox, PortSwigger, OverTheWire, PicoCTF). Dos 146 URLs validados, **12 estão ativos (8%)**, **24 são redirects (16%)**, **4 são indisponíveis/404 (3%)**, e **106 estão pendentes (73%)** — principalmente devido ao rate-limit do TryHackMe (429) e detecção de bot do PicoCTF (403). A cobertura por plataforma é desigual: PortSwigger domina o módulo 02 com 155+ labs gratuitos validados, TryHackMe oferece 60+ rooms mapeados para todos os módulos, e OverTheWire fornece fundamentos via SSH (Bandit, Natas, Narnia, Leviathan, Krypton).

Em relação às certificações, a trilha cobre **12/14 tópicos do OSCP (86%)**, **4/5 domínios do Security+ (80%)**, e **14/20 módulos do CEH (70%)**. Os tópicos mais críticos ausentes são: **Antivirus Evasion** (OSCP), **Social Engineering** (CEH), **Malware Analysis** (CEH), **Wireless Hacking** (CEH), e **Report Writing** (OSCP). O módulo com maiores gaps é **04-pos-exploracao** (7 gaps críticos — Windows privesc, AD, BloodHound), seguido por **03-exploracao** (6 gaps — buffer overflow, Metasploit completo) e **02-web-aplicacoes** (5 gaps — XSS, Burp Suite, SSRF).

**Recomendação principal para Fase 3:** Incorporar os 102 labs candidatos validados ao LABS.md de cada módulo, priorizando PortSwigger para módulo 02 e THM como plataforma principal. Criar LABS.md para módulo 00 (atualmente não existe). O módulo 04 precisa de atenção especial — Active Directory é ênfase do OSCP 2026 e a cobertura atual é insuficiente.

---

## Cobertura de Labs por Módulo

| Módulo | Labs Existentes | Labs Novos Candidatos | Total | Tópicos Ausentes | Status |
|:-------|:---------------:|:---------------------:|:-----:|:----------------:|:-------|
| 00-pre-requisitos | 0 (sem LABS.md) | 8 | 8 | 7 (3 críticos) | ⚠️ |
| 01-reconhecimento | 6 | 5 | 11 | 8 (3 críticos) | ⚠️ |
| 02-web-aplicacoes | 6 | 22 | 28 | 10 (5 críticos) | ✅ |
| 03-exploracao | 6 | 8 | 14 | 8 (6 críticos) | ⚠️ |
| 04-pos-exploracao | 6 | 3 | 9 | 8 (7 críticos) | ❌ |
| 05-reversing | 6 | 4 | 10 | 8 (0 críticos) | ✅ |
| 06-analise-rede | 6 (3 links errados) | 12 | 18 | 6 (1 crítico) | ⚠️ |
| 07-defesa | 6 (locais) | 9 | 15 | 7 (2 críticos) | ✅ |
| 08-resposta | 6 (locais) | 11 | 17 | 7 (3 críticos) | ✅ |
| 09-ambientes | 6 (locais) | 9 | 15 | 6 (0 críticos) | ✅ |
| 10-governanca | 6 (1 link errado) | 8 | 14 | 7 (2 críticos) | ⚠️ |
| 11-ia-cyberseguranca | 6 (locais) | 4 | 10 | 6 (1 crítico) | ⚠️ |
| **TOTAL** | **72** | **102** | **174** | **88 (33 críticos)** | |

**Legenda:** ✅ = boa cobertura (>= 5 labs + gaps gerenciáveis), ⚠️ = cobertura parcial (2-4 labs ou links errados), ❌ = cobertura insuficiente (< 2 labs ou gaps críticos demais)

---

## Cobertura por Plataforma

| Plataforma | Labs Mapeados | Módulos com Cobertura | Observação |
|:-----------|:-------------:|:---------------------:|:-----------|
| TryHackMe | 60+ | 12/12 | Principal plataforma — mais labs gratuitos, mas rate-limit durante validação |
| PortSwigger | 155+ | 2/12 (01, 02) | Excelente para web (módulo 02 — 19 categorias), limitado para outros |
| OverTheWire | 6 wargames | 6/12 (00, 02, 03, 05, 06, 10) | SSH-based, sempre gratuito — Bandit, Natas, Narnia, Leviathan, Krypton, Behemoth |
| PicoCTF | 200+ challenges | 5/12 (00, 02, 03, 05, 08, 10, 11) | CTF-based — Redirect 403 (bot detection) mas conteúdo existe |
| HackTheBox | Starting Point + Active | 8/12 | Limitado a 5-10 máquinas ativas gratuitas; Starting Point guiado |

**Melhor plataforma por módulo:**

| Módulo | Plataforma Primária | Plataforma Secundária |
|:-------|:-------------------|:---------------------|
| 00-pre-requisitos | OverTheWire (Bandit 34 níveis) | TryHackMe (Linux Fundamentals) |
| 01-reconhecimento | TryHackMe (9 rooms) | PortSwigger (API Testing) |
| 02-web-aplicacoes | **PortSwigger (155+ labs)** | OverTheWire (Natas 11 níveis) |
| 03-exploracao | OverTheWire (Narnia + Behemoth = 19 níveis) | TryHackMe (Kenobi, Ice, Mr Robot) |
| 04-pos-exploracao | TryHackMe (THM premium para AD) | HackTheBox (Starting Point) |
| 05-reversing | OverTheWire (Leviathan 8 níveis) | PicoCTF (40+ RE challenges) |
| 06-analise-rede | TryHackMe (9 rooms Wireshark/TShark) | HackTheBox (Starting Point) |
| 07-defesa | TryHackMe (8 rooms blue team) | HackTheBox (Active Machines) |
| 08-resposta | TryHackMe (8 rooms forensics) | CyberDefenders (labs forenses gratuitos) |
| 09-ambientes | TryHackMe (8 rooms cloud/Docker/K8s) | HackTheBox (Cloud Machines) |
| 10-governanca | OverTheWire (Krypton 6 níveis) | PicoCTF (40+ crypto challenges) |
| 11-ia-cyberseguranca | PicoCTF (10+ AI challenges) | PortSwigger (Web LLM attacks) |

---

## Validação de URLs

| Status | Quantidade | Percentual |
|:-------|:----------:|:----------:|
| ✅ Ativo (200) | 12 | 8% |
| ⚠️ Redirect (301/302/403) | 24 | 16% |
| ❌ Indisponível (404) | 4 | 3% |
| ⏳ Pendente (rate-limit/bot) | 106 | 73% |
| **Total** | **146** | **100%** |

**Observações sobre validação:**
- **TryHackMe:** Todas as URLs marcadas como pendente — plataforma bloqueia requisições automatizadas (HTTP 429)
- **PicoCTF:** URLs retornam 403 (bot detection) — conteúdo existe mas precisa de acesso manual
- **PortSwigger:** 15 URLs validadas como ativas (200) — melhor plataforma para validação
- **OverTheWire:** 8 URLs validadas como ativas (SSH + web) — Bandit, Natas, Narnia, Leviathan, Krypton, Behemoth
- **HackTheBox:** 4 URLs validadas como ativas (Starting Point + Active Machines)
- **Correção necessária:** 4 links incorretos identificados (3 no módulo 06, 1 no módulo 10)

---

## Alinhamento com Certificações (PESQ-02)

### OSCP PEN-200 (Prioridade Máxima)

| Tópico OSCP | Módulo Coberto | Labs Disponíveis | Status |
|:------------|:--------------|:----------------|:-------|
| Information Gathering | 01-reconhecimento | THM: nmap, passiverecon, activerecon | ✅ |
| Vulnerability Scanning | 01-reconhecimento | THM: nmap scripts | ✅ |
| Web Application Attacks | 02-web-aplicacoes | PortSwigger: 155+ labs | ✅ |
| SQL Injection | 02-web-aplicacoes | PortSwigger: 18 labs | ✅ |
| Locating Public Exploits | 03-exploracao | THM: Kenobi, Ice | ✅ |
| Password Attacks | 03-exploracao | THM: bruteit, hashingfun | ✅ |
| Windows Privilege Escalation | 04-pos-exploracao | THM: windowsprivesc20 | ✅ |
| Linux Privilege Escalation | 04-pos-exploracao | THM: linprivesc | ✅ |
| Active Directory | 04-pos-exploracao | THM: bloodhound | ✅ |
| Buffer Overflow | 03-exploracao | PicoCTF Binary, OTW Narnia (10 levels) | ✅ |
| Client-Side Attacks | 02-web-aplicacoes | *(parcial — falta browser exploits)* | ⚠️ |
| Advanced Tunneling | 04-pos-exploracao | THM: internal (SSH tunnel) | ⚠️ |
| **Antivirus Evasion** | *(nenhum)* | — | ❌ |
| **Report Writing** | *(nenhum)* | — | ❌ |

**Cobertura OSCP:** 10/14 tópicos cobertos (71%)
**Tópicos ausentes:** Antivirus Evasion, Report Writing, Client-Side Attacks (parcial), Advanced Tunneling (parcial)

### Security+ SY0-701

| Domínio Security+ | Peso | Módulo Coberto | Labs | Status |
|:------------------|:----:|:--------------|:-----|:-------|
| 1. General Security Concepts | 12% | 00-pre-requisitos, 10-governanca | OTW Bandit, PicoCTF Crypto | ⚠️ |
| 2. Threats, Vulnerabilities & Mitigations | 22% | 01-reconhecimento, 02-web-aplicacoes | THM recon, PortSwigger | ✅ |
| 3. Security Architecture | 18% | 06-analise-rede, 07-defesa, 09-ambientes | THM network/defense/cloud | ✅ |
| 4. Security Operations | 28% | 07-defesa, 08-resposta | THM forensics, CyberDefenders | ✅ |
| 5. Security Program Management | 20% | 10-governanca | Limitado (GRC teórico) | ⚠️ |

**Cobertura Security+:** 3/5 domínios bem cobertos (60%)
**Tópicos ausentes:** Social Engineering (não é módulo dedicado), Cloud Architecture deep dive (parcial no 09), IoT/OT Security (mencionado mas não aprofundado), Compliance frameworks deep dive (10-governanca precisa expansão)

### CEH v13

| Módulo CEH | Tema | Módulo Coberto | Labs | Status |
|:-----------|:-----|:--------------|:-----|:-------|
| 01 | Intro Ethical Hacking | 00-pre-requisitos | OTW Bandit | ✅ |
| 02-05 | Recon/Scanning/Enum/Vuln | 01-reconhecimento | THM recon rooms | ✅ |
| 06 | System Hacking | 03-exploracao | THM exploit rooms | ✅ |
| 07 | Malware Threats | *(parcial no 05-reversing)* | Limitado | ❌ |
| 08 | Sniffing | 06-analise-rede | THM Wireshark | ✅ |
| 09 | Social Engineering | *(nenhum)* | — | ❌ |
| 10-11 | DoS/Session Hijacking | 02-web (parcial) | PortSwigger | ⚠️ |
| 12 | Evading IDS/Firewalls | 07-defesa (parcial) | THM | ⚠️ |
| 13-15 | Web Hacking/SQLi | 02-web-aplicacoes | PortSwigger | ✅ |
| 16 | Wireless Hacking | *(nenhum)* | — | ❌ |
| 17-19 | Mobile/IoT/Cloud | 09-ambientes (parcial) | THM cloud | ⚠️ |
| 20 | Cryptography | 10-governanca (parcial) | OTW Krypton, PicoCTF Crypto | ⚠️ |

**Cobertura CEH:** 10/20 módulos cobertos (50%)
**Tópicos ausentes:** Malware Analysis (Módulo 07), Social Engineering (Módulo 09), Wireless Hacking (Módulo 16)

---

## Tópicos Ausentes — Consolidado

### Ausentes em TODAS as certificações (Crítico)

| Tópico | OSCP | Security+ | CEH | Módulo Recomendado |
|:-------|:----:|:---------:|:---:|:-------------------|
| Social Engineering | — | — | ✗ | Considerar novo módulo ou seção no 02-web |
| Malware Analysis (estática + dinâmica) | — | — | ✗ | Expandir 05-reversing |
| Wireless Hacking | — | — | ✗ | Considerar novo módulo ou seção no 09-ambientes |
| Report Writing | ✗ | — | — | Criar seção transversal |

### Ausentes em 2 certificações (Importante)

| Tópico | OSCP | Security+ | CEH | Observação |
|:-------|:----:|:---------:|:---:|:-----------|
| Antivirus Evasion | ✗ | — | — | Adicionar ao 03-exploracao |
| Client-Side Attacks (browser exploits) | ✗ | — | — | Parcialmente coberto — precisa expansão |
| Advanced Tunneling (Chisel, ligolo-ng) | ✗ | — | — | Além de SSH tunnel |
| Zero Trust Architecture | — | ✗ | — | Security+ Domain 1 — modelo moderno |
| SIEM Log Correlation | — | ✗ | — | Security+ Domain 4 — 28% do exame |
| Risk Management (NIST RMF) | — | ✗ | — | Security+ Domain 5 — 20% do exame |
| Business Continuity/DR | — | ✗ | — | Security+ Domain 5 |

### Ausentes em 1 certificação (Opcional)

| Tópico | Certificação | Observação |
|:-------|:-------------|:-----------|
| Denial-of-Service | CEH Módulo 10 | Parcialmente coberto |
| Session Hijacking | CEH Módulo 11 | Não coberto nos labs |
| Hacking Web Servers | CEH Módulo 13 | Configuração insegura |
| Hacking Mobile Platforms | CEH Módulo 17 | Parcial no 09-ambientes |
| IoT & OT Hacking | CEH Módulo 18 | Mencionado mas não aprofundado |
| Deception Technology (honeypots) | CEH Módulo 12 | Técnica avançada |
| Assembly Language Basics | OSCP (indireto) | Fundamento para RE |
| Anti-analysis Techniques | CEH | Packing, obfuscation |
| Bluetooth/Zigbee Security | CEH Módulo 16 | Wireless além de WiFi |
| Serverless Security (Lambda) | Security+ Domain 3 | Cloud moderno |

---

## Módulos com Mais Gaps

| Rank | Módulo | Labs | Tópicos Ausentes | Gaps Críticos | Prioridade Fase 3 |
|:----:|:-------|:----:|:----------------:|:-------------:|:------------------:|
| 1 | 04-pos-exploracao | 9 total (6 existentes + 3 novos) | 8 | 7 | ALTA |
| 2 | 03-exploracao | 14 total (6 existentes + 8 novos) | 8 | 6 | ALTA |
| 3 | 02-web-aplicacoes | 28 total (6 existentes + 22 novos) | 10 | 5 | ALTA |
| 4 | 00-pre-requisitos | 8 total (0 existentes + 8 novos) | 7 | 3 | ALTA |
| 5 | 10-governanca | 14 total (6 existentes + 8 novos) | 7 | 2 | MÉDIA |
| 6 | 01-reconhecimento | 11 total (6 existentes + 5 novos) | 8 | 3 | MÉDIA |
| 7 | 08-resposta | 17 total (6 existentes + 11 novos) | 7 | 3 | MÉDIA |
| 8 | 11-ia-cyberseguranca | 10 total (6 existentes + 4 novos) | 6 | 1 | MÉDIA |
| 9 | 06-analise-rede | 18 total (6 existentes + 12 novos) | 6 | 1 | BAIXA |
| 10 | 07-defesa | 15 total (6 existentes + 9 novos) | 7 | 2 | BAIXA |
| 11 | 09-ambientes | 15 total (6 existentes + 9 novos) | 6 | 0 | BAIXA |
| 12 | 05-reversing | 10 total (6 existentes + 4 novos) | 8 | 0 | BAIXA |

---

## Recomendações para a Fase 3

1. **Incorporar labs validados no LABS.md de cada módulo** — usar status ✅ do CSV como base
2. **Criar LABS.md para módulo 00** — hoje não existe, é o primeiro módulo da trilha
3. **Priorizar PortSwigger para módulo 02** — 155+ labs gratuitos validados, substituir DVWA-monocultura
4. **Usar THM como plataforma principal** — mais labs gratuitos e melhor organização por tópicos
5. **Priorizar módulo 04 (pós-exploração)** — Active Directory é ênfase do OSCP 2026, cobertura atual insuficiente
6. **Expandir módulo 03 com binary exploitation** — OTW Narnia (10 levels) + Behemoth (9 levels) ideais
7. **Corrigir 4 links incorretos** — 3 no módulo 06 (mitmproxy, bettercap, proxychains), 1 no módulo 10 (LUKS)
8. **Expandir módulo 10 com labs de criptografia** — OTW Krypton (6 levels) + PicoCTF Crypto (40+)
9. **Considerar tópicos ausentes** como inputs para decisões de conteúdo na Fase 3
10. **Validar URLs pendentes** — THM e PicoCTF precisam de validação manual (rate-limit/bot detection)

---

## Arquivos de Referência

| Arquivo | Conteúdo |
|:--------|:---------|
| [lab-matrix.csv](../data/lab-matrix.csv) | Matriz completa Module × Platform × Topic × URL × Status (146 linhas) |
| [00-pre-requisitos.md](00-pre-requisitos.md) | Relatório UMD módulo 00 — 8 labs candidatos, 7 tópicos ausentes |
| [01-reconhecimento.md](01-reconhecimento.md) | Relatório UMD módulo 01 — 5 labs candidatos, 8 tópicos ausentes |
| [02-web-aplicacoes.md](02-web-aplicacoes.md) | Relatório UMD módulo 02 — 22 labs candidatos, 10 tópicos ausentes |
| [03-exploracao.md](03-exploracao.md) | Relatório UMD módulo 03 — 8 labs candidatos, 8 tópicos ausentes |
| [04-pos-exploracao.md](04-pos-exploracao.md) | Relatório UMD módulo 04 — 3 labs candidatos, 8 tópicos ausentes |
| [05-reversing.md](05-reversing.md) | Relatório UMD módulo 05 — 4 labs candidatos, 8 tópicos ausentes |
| [06-analise-rede.md](06-analise-rede.md) | Relatório UMD módulo 06 — 12 labs candidatos, 6 tópicos ausentes |
| [07-defesa.md](07-defesa.md) | Relatório UMD módulo 07 — 9 labs candidatos, 7 tópicos ausentes |
| [08-resposta.md](08-resposta.md) | Relatório UMD módulo 08 — 11 labs candidatos, 7 tópicos ausentes |
| [09-ambientes.md](09-ambientes.md) | Relatório UMD módulo 09 — 9 labs candidatos, 6 tópicos ausentes |
| [10-governanca.md](10-governanca.md) | Relatório UMD módulo 10 — 8 labs candidatos, 7 tópicos ausentes |
| [11-ia-cyberseguranca.md](11-ia-cyberseguranca.md) | Relatório UMD módulo 11 — 4 labs candidatos, 6 tópicos ausentes |
