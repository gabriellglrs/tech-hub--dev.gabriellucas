# Relatório de Labs e Referências — Módulo 01: Reconhecimento

**Gerado em:** 2026-09-10
**Módulo:** 01-reconhecimento
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| 1 | Whois e DNS Lookup | TryHackMe | https://tryhackme.com/room/dnsindns | ⏳ Pendente (rate-limit THM) |
| 2 | Enumeração de Subdomínios | TryHackMe | https://tryhackme.com/room/ohsint | ⏳ Pendente (rate-limit THM) |
| 3 | Scan de Portas com Nmap | TryHackMe | https://tryhackme.com/room/nmap01 | ⏳ Pendente (rate-limit THM) |
| 4 | OSINT com theHarvester | TryHackMe | https://tryhackme.com/room/ohsint | ⏳ Pendente (rate-limit THM) |
| 5 | Scan com Nmap Scripts | TryHackMe | https://tryhackme.com/room/nmap | ⏳ Pendente (rate-limit THM) |
| 6 | Reconhecimento Completo | TryHackMe | https://tryhackme.com/room/gh0st | ⏳ Pendente (rate-limit THM) |

**Observações:** Todos os 6 exercícios existentes usam exclusivamente TryHackMe. Não há cobertura de PortSwigger, OverTheWire, PicoCTF ou HTB. Exercício 2 e 4 apontam para a mesma sala (ohsint) — pode ser intencional (OSINT + subdomínios) mas merece revisão.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | Passive Recon | TryHackMe | https://tryhackme.com/room/passiverecon | Reconhecimento passivo | ⏳ Pendente (rate-limit THM) |
| 2 | Active Recon | TryHackMe | https://tryhackme.com/room/activerecon | Reconhecimento ativo | ⏳ Pendente (rate-limit THM) |
| 3 | Shodan | TryHackMe | https://tryhackme.com/room/shodan | Busca em dispositivos IoT | ⏳ Pendente (rate-limit THM) |
| 4 | API Testing Labs | PortSwigger | https://portswigger.net/web-security/api-testing | Teste de APIs (5 labs) | ✅ Ativo |
| 5 | Starting Point Machines | HackTheBox | https://app.hackthebox.com/starting-point | Enumeração em máquinas guiadas | ⏳ Pendente |

**Nota:** OverTheWire e PicoCTF têm cobertura limitada para reconhecimento — não é o foco dessas plataformas. PortSwigger API Testing é relevante para módulos web mas cobre reconhecimento de APIs.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| Vulnerability Scanning (Nessus, NSE avançado) | OSCP PEN-200 | Crítico | Módulo dedicado no OSCP |
| Footprinting & Reconnaissance | CEH v13 Módulo 02 | Importante | Base para CEH |
| Scanning Networks | CEH v13 Módulo 03 | Importante | Nmap avançado, sweep scanning |
| Enumeration (SMB, SNMP, LDAP) | CEH v13 Módulo 04 | Importante | Enumeração além de portas |
| Vulnerability Analysis | CEH v13 Módulo 05 | Importante | Análise de vulnerabilidades |
| Threats e tipos de ataque | Security+ SY0-701 Domínio 2 | Crítico | 22% do exame |
| OSINT avançado (Maltego, Recon-ng) | OSCP + CEH | Importante | Ferramentas não cobertas nos labs |
| Subdomain enumeration automatizada | OSCP | Crítico | Subfinder, Amass não têm lab dedicado |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 6 (validados: 0, pendentes: 6 — rate-limit THM)
- Labs candidatos novos: 5 (3 THM + 1 PortSwigger + 1 HTB)
- Tópicos ausentes: 8 (críticos: 3)
- Plataformas com cobertura: TryHackMe (forte — 9 rooms), PortSwigger (API Testing)
- Plataformas com cobertura limitada: OverTheWire (não tem labs de recon), PicoCTF (não tem labs de recon), HackTheBox (Starting Point genérico)
- **Recomendação:** Adicionar labs de PortSwigger para web API recon e Expandir cobertura de enumeração (SMB, SNMP) via THM ou HTB.
