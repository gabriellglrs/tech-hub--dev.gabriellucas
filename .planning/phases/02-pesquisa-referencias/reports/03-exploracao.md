# Relatório de Labs e Referências — Módulo 03: Exploração

**Gerado em:** 2026-09-10
**Módulo:** 03-exploracao
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| 1 | Brute Force SSH com Hydra | TryHackMe | https://tryhackme.com/room/bruteit | ⏳ Pendente (rate-limit THM) |
| 2 | Brute Force HTTP Login | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |
| 3 | Identificar e Quebrar Hashes | TryHackMe | https://tryhackme.com/room/hashingfun | ⏳ Pendente (rate-limit THM) |
| 4 | Cracking com Wordlists Customizadas | TryHackMe | https://tryhackme.com/room/bruteit | ⏳ Pendente (rate-limit THM) |
| 5 | Brute Force com Metasploit | TryHackMe | https://tryhackme.com/room/metasploitintro | ⏳ Pendente (rate-limit THM) |
| 6 | Pentest de Autenticação | TryHackMe | https://tryhackme.com/room/dvwa | ⏳ Pendente (rate-limit THM) |

**Observações:** Foco excessivo em brute force e cracking — não cobre exploração de vulnerabilidades, buffer overflow, ou busca de exploits. Exercício 2 e 6 usam DVWA novamente. Falta Metasploit hands-on (apenas brute force auxiliary), SearchSploit, e exploração de serviços.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | Kenobi | TryHackMe | https://tryhackme.com/room/kenobi | Exploração de serviços Samba | ⏳ Pendente (rate-limit THM) |
| 2 | Ice | TryHackMe | https://tryhackme.com/room/ice | Metasploit + exploração | ⏳ Pendente (rate-limit THM) |
| 3 | Mr Robot | TryHackMe | https://tryhackme.com/room/mrrobot | CTF completo com exploração | ⏳ Pendente (rate-limit THM) |
| 4 | Buffer Overflow Prep | TryHackMe | https://tryhackme.com/room/bufferoverflowprep | Buffer overflow hands-on | ⏳ Pendente (rate-limit THM) |
| 5 | Narnia (10 levels) | OverTheWire | ssh://narnia.labs.overthewire.org:2226 | Binary exploitation (x86) | ✅ Ativo |
| 6 | Behemoth (9 levels) | OverTheWire | ssh://behemoth.labs.overthewire.org:2221 | Binary exploitation avançado | ✅ Ativo |
| 7 | Binary Exploitation (30+) | PicoCTF | https://play.picoctf.org/practice | Buffer overflow, format strings | ⏳ Pendente |
| 8 | Starting Point (Exploit) | HackTheBox | https://app.hackthebox.com/starting-point | Exploração guiada | ⏳ Pendente |

**Nota:** OverTheWire Narnia + Behemoth são ideais para binary exploitation — 19 níveis progressivos com código-fonte. PicoCTF Binary Exploitation complementa com CTF challenges.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| Locating Public Exploits (SearchSploit, Exploit-DB) | OSCP PEN-200 | Crítico | Módulo dedicado no OSCP |
| Fixing Exploits (buffer overflow basics) | OSCP PEN-200 | Crítico | Essencial para OSCP |
| Antivirus Evasion | OSCP PEN-200 | Crítico | Não coberto em nenhum lab |
| Buffer Overflow completo | OSCP + CEH | Crítico | Labs existentes não cobrem BO |
| System Hacking | CEH v13 Módulo 06 | Importante | Base para exploração |
| Metasploit completo (payloads, sessions, post) | OSCP | Crítico | Apenas brute force auxiliary nos labs |
| Nmap NSE para vulnerabilidades | OSCP | Crítico | Não coberto nos labs de exploração |
| Password Attacks avançado (rainbow tables, GPU cracking) | OSCP | Importante | Labs cobrem básico mas falta avançado |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 6 (validados: 0, pendentes: 6 — rate-limit THM)
- Labs candidatos novos: 8 (4 THM + 2 OTW + 1 PicoCTF + 1 HTB)
- Tópicos ausentes: 8 (críticos: 6)
- Plataformas com cobertura: TryHackMe (7 rooms), OverTheWire (Narnia + Behemoth = 19 níveis)
- Plataformas com cobertura limitada: PicoCTF (CTF-based), PortSwigger (não tem labs de exploit), HackTheBox (Starting Point)
- **Recomendação URGENTE:** Adicionar labs de buffer overflow (OverTheWire Narnia), Metasploit completo (THM Kenobi/Ice), e SearchSploit/Exploit-DB. O módulo atual foca apenas em brute force — precisa de cobertura de exploração de vulnerabilidades reais.
