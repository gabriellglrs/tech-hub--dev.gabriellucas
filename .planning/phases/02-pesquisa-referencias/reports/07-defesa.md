## Módulo 07: Defesa e Hardening

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Auditoria com Lynis | Local (Kali) | N/A ( ferramenta local) | ✅ Válido (sem URL) |
| 2 | Configurar UFW (Firewall) | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 3 | Regras Avançadas com iptables | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 4 | IDS com Suricata | Local (Kali) | N/A (ferramenta local) | ✅ Válido (sem URL) |
| 5 | SIEM com Wazuh | Local (Kali) | https://documentation.wazuh.com/ | ✅ Ativo |
| 6 | Hardening Completo (Final) | Local (Kali) | https://tryhackme.com/room/linuxfundamentalspart1 | ⚠️ Link genérico (linux fundamentals não é hardening) |

**Resumo existente:** 6 exercícios, maioria labs locais (sem URL de plataforma). Ferramentas: Lynis, UFW, iptables, Suricata, Wazuh, fail2ban. **Forte em:** ferramentas reais. **Fraqueza:** poucos labs em plataformas interativas.

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | Wazuh | TryHackMe | https://tryhackme.com/room/wazuhct | Wazuh SIEM hands-on | ⏳ Pendente (rate-limit) |
| 2 | Intrusion Detection (IDS) | TryHackMe | https://tryhackme.com/room/idsevasion | IDS evasion, Suricata, Wazuh | ⏳ Pendente (rate-limit) |
| 3 | Monday Monitor | TryHackMe | https://tryhackme.com/room/mondaymonitor | Wazuh SIEM forensics com Atomic Red Team | ⏳ Pendente (rate-limit) |
| 4 | Linux Fundamentals | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart1 | Fundamentos Linux para hardening | ⏳ Pendente (rate-limit) |
| 5 | Firewalls | TryHackMe | https://tryhackme.com/room/firewalls | Conceitos de firewall | ⏳ Pendente (rate-limit) |
| 6 | Linux Fundamentals Part 2 | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart2 | Serviços, permissões | ⏳ Pendente (rate-limit) |
| 7 | Linux Fundamentals Part 3 | TryHackMe | https://tryhackme.com/room/linuxfundamentalspart3 | Administração avançada | ⏳ Pendente (rate-limit) |
| 8 | SOC Level 1 | TryHackMe | https://tryhackme.com/room/soclevel1 | SOC operations, monitoramento | ⏳ Pendente (rate-limit) |
| 9 | Active Machines (defense) | HackTheBox | https://app.hackthebox.com/machines | Cenários defensivos | ✅ Ativo |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| Zero Trust Architecture | Security+ Domain 1 | Crítico | Modelo de segurança moderno, 12% do exame |
| SIEM log correlation | Security+ Domain 4 | Crítico | 28% do exame — operations é o maior domínio |
| Vulnerability scanning (Nessus/OpenVAS) | Security+ Domain 4 | Importante | Ferramenta essencial de defesa |
| Configuration hardening benchmarks (CIS) | Security+ Domain 4 | Importante | Padrão de indústria |
| Patch management | Security+ Domain 4 | Importante | Processo crítico de defesa |
| Endpoint detection and response (EDR) | Security+ Domain 4 | Importante | Tecnologia moderna de defesa |
| Deception technology (honeypots) | CEH Module 12 | Opcional | Técnica avançada de defesa |

### Resumo

- **Labs existentes:** 6 (locais + 1 Wazuh doc)
- **Labs candidatos novos:** 9 (8 THM, 1 HTB)
- **Total potencial:** 15 labs
- **Plataforma mais forte:** TryHackMe (8 rooms de defesa/blue team)
- **Força do módulo:** Labs locais com ferramentas reais (Lynis, UFW, iptables, Suricata, Wazuh)
- **Gaps críticos:** Zero Trust, SIEM correlation, vulnerability scanning
- **Ação necessária:** Corrigir link genérico do exercício 6
