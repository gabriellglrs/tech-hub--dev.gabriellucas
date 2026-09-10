# Relatório de Labs e Referências — Módulo 04: Pós-Exploração

**Gerado em:** 2026-09-10
**Módulo:** 04-pos-exploracao
**Requisitos:** PESQ-01, PESQ-02

---

## Labs Existentes (LABS.md)

| # | Exercício | Plataforma | URL | Status Validação |
|:-:|:----------|:-----------|:----|:-----------------|
| 1 | Enumeração com LinPEAS | TryHackMe | https://tryhackme.com/room/linprivesc | ⏳ Pendente (rate-limit THM) |
| 2 | Escalação de Privilégios Linux | TryHackMe | https://tryhackme.com/room/linprivesc | ⏳ Pendente (rate-limit THM) |
| 3 | Dump de Credenciais com secretsdump | TryHackMe | https://tryhackme.com/room/ice | ⏳ Pendente (rate-limit THM) |
| 4 | Pivoting com SSH Tunnel | TryHackMe | https://tryhackme.com/room/internal | ⏳ Pendente (rate-limit THM) |
| 5 | Movimentação Lateral com Pass-the-Hash | TryHackMe | https://tryhackme.com/room/overpass | ⏳ Pendente (rate-limit THM) |
| 6 | Pós-Exploração Completa | TryHackMe | https://tryhackme.com/room/internal | ⏳ Pendente (rate-limit THM) |

**Observações:** Foco em Linux privesc e movimentação lateral — falta Windows privesc, Active Directory, e BloodHound. Exercício 1 e 2 usam a mesma sala (linprivesc). Exercício 4 e 6 usam a mesma sala (internal). Falta cobertura de WinPEAS, Rubeus, e AD attacks.

---

## Labs Candidatos Novos

| # | Lab/Sala | Plataforma | URL | Tópico Coberto | Status Validação |
|:-:|:---------|:-----------|:----|:---------------|:-----------------|
| 1 | Windows Privesc | TryHackMe | https://tryhackme.com/room/windowsprivesc20 | Escalação Windows | ⏳ Pendente (rate-limit THM) |
| 2 | BloodHound | TryHackMe | https://tryhackme.com/room/bloodhound | AD attack paths | ⏳ Pendente (rate-limit THM) |
| 3 | Starting Point (AD) | HackTheBox | https://app.hackthebox.com/starting-point | AD attacks guiados | ⏳ Pendente |

**Nota:** OverTheWire, PortSwigger, e PicoCTF têm cobertura limitada/nula para pós-exploração — não é o foco dessas plataformas. HTB Starting Point tem máquinas AD guiadas.

---

## Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|:-------|:-------------|:-----------|:--------------|
| Windows Privilege Escalation | OSCP PEN-200 | Crítico | Módulo dedicado no OSCP |
| Active Directory Attacks (Kerberoasting, Pass-the-Hash, DCSync) | OSCP PEN-200 | Crítico | Ênfase do OSCP 2026 |
| Advanced Tunneling (Chisel, ligolo-ng) | OSCP PEN-200 | Crítico | Pivoting além de SSH |
| WinPEAS / Seatbelt | OSCP | Crítico | Enumeração Windows não coberta |
| Rubeus (Kerberos attacks) | OSCP | Crítico | Kerberoasting, AS-REP roast |
| Mimikatz (credential extraction) | OSCP + CEH | Crítico | Extração de credenciais Windows |
| Report Writing | OSCP PEN-200 | Importante | Documentação de pós-exploração |
| Lateral Movement avançado (WMI, DCOM) | OSCP | Importante | Além de PtH e SSH |

**Prioridade:** Crítico = presente em OSCP; Importante = presente em Security+; Opcional = apenas CEH

---

## Resumo

- Labs existentes: 6 (validados: 0, pendentes: 6 — rate-limit THM)
- Labs candidatos novos: 3 (2 THM + 1 HTB)
- Tópicos ausentes: 8 (críticos: 7)
- Plataformas com cobertura: TryHackMe (5 rooms), HackTheBox (Starting Point)
- Plataformas com cobertura limitada: OverTheWire (não tem labs de post-exploit), PortSwigger (não tem labs de post-exploit), PicoCTF (não tem labs de post-exploit)
- **Recomendação URGENTE:** Este módulo tem os MAIORES GAPS de cobertura. Falta Windows privesc, Active Directory, BloodHound, Mimikatz, Rubeus. OSCP 2026 tem ênfase em AD — cobertura atual é insuficiente. Recomenda-se buscar labs em HTB Academy (pago) ou TryHackMe premium para AD.
